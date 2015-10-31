//
//  ItemDetailViewController.swift
//  GraduateList
//
//  Created by Jasmine Cha on 10/25/15.
//  Copyright © 2015 Jasmine Cha. All rights reserved.
//

import UIKit
import EventKitUI
import MobileCoreServices

class ItemDetailViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var taskName: UITextField!
    var newTask = Task()
    @IBOutlet weak var startDate: UIDatePicker!
    @IBOutlet weak var endDate: UIDatePicker!
    var newMedia: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        taskName.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard.add
        textField.resignFirstResponder()
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doneCapture(segue:UIStoryboardSegue) {
        // currently does the same thing as cancel hehe
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "doneSegue" {
            if((taskName.text != "")){
                addEvent()
                newTask.name = taskName.text!
            }
        }
    }

    func createEvent(eventStore: EKEventStore, title: String, startDate: NSDate, endDate: NSDate) {
        let event = EKEvent(eventStore: eventStore)
        
        event.title = title
        event.startDate = startDate
        event.endDate = endDate
        
        event.calendar = eventStore.defaultCalendarForNewEvents
        do {
            try eventStore.saveEvent(event, span: .ThisEvent)
            
            let formatter = NSDateFormatter()
            formatter.dateFormat = "MM-dd-yyyy hh:mm"
            let stringDate: String = formatter.stringFromDate(event.startDate)
            let endStringDate: String = formatter.stringFromDate(event.endDate)
            
            newTask.startDateTime = stringDate
            newTask.endDateTime = endStringDate
            
        } catch {
            print("Bad things happened")
        }
    }
    
    func addEvent() {
        let eventStore = EKEventStore()
        
        //let startDate = NSDate()
        
        //let endDate = startDate.dateByAddingTimeInterval(60 * 60) // One hour
        
        if (EKEventStore.authorizationStatusForEntityType(.Event) != EKAuthorizationStatus.Authorized) {
            eventStore.requestAccessToEntityType(.Event, completion: {
                granted, error in
                self.createEvent(eventStore, title: (self.taskName?.text)!, startDate: self.startDate.date, endDate: self.endDate.date)
            })
        } else {
            createEvent(eventStore, title: (self.taskName?.text)!, startDate: self.startDate.date, endDate: self.endDate.date)
        }
    }
    @IBAction func useCamera(sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.Camera) {
                
                let imagePicker = UIImagePickerController()
                
                imagePicker.delegate = self
                imagePicker.sourceType =
                    UIImagePickerControllerSourceType.Camera
                imagePicker.mediaTypes = [kUTTypeImage as NSString as String]
                imagePicker.allowsEditing = false
                
                self.presentViewController(imagePicker, animated: true,
                    completion: nil)
                newMedia = true
        }
    }
    
    
    func imagePickerController(didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        let strKit = kUTTypeImage as String
        
        if mediaType == strKit {
            let image = info[UIImagePickerControllerOriginalImage]
                as! UIImage
            
            if (newMedia == true) {
                UIImageWriteToSavedPhotosAlbum(image, self,
                    "image:didFinishSavingWithError:contextInfo:", nil)
            } else if mediaType == strKit {
                // Code to support video here
            }
            
        }
    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo:UnsafePointer<Void>) {
        
        if error != nil {
            let alert = UIAlertController(title: "Save Failed",
                message: "Failed to save image",
                preferredStyle: UIAlertControllerStyle.Alert)
            
            let cancelAction = UIAlertAction(title: "OK",
                style: .Cancel, handler: nil)
            
            alert.addAction(cancelAction)
            self.presentViewController(alert, animated: true,
                completion: nil)
        }
    }
}

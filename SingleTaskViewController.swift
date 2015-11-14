//
//  SingleTaskViewController.swift
//  GraduateList
//
//  Created by Jasmine Cha on 11/1/15.
//  Copyright © 2015 Jasmine Cha. All rights reserved.
//

import UIKit
import EventKitUI

class SingleTaskViewController: UIViewController {

    @IBOutlet weak var taskTitle: UILabel!
    @IBOutlet weak var descrip: UILabel!
    @IBOutlet weak var dateTime: UILabel!
    @IBOutlet weak var completed: UILabel!
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var buttonComplete: UIButton!


    //To pass back to BucketListViewController, see "prepareForSegue
    var taskToPass = Task()
    var indexToPass = 0
    
    @IBAction func onPressComplete(sender: UIButton) {
        alertComplete("Complete", message: "Mark as complete?")
    }
    
    @IBAction func doneEdit(segue: UIStoryboardSegue){
        if(segue.identifier == "doneEdit"){
            if let src = segue.sourceViewController as? EditListViewController{
                taskToPass.name = src.taskToPass.name
                taskToPass.descrip = src.taskToPass.descrip
            }
        }
        print("printing", taskToPass.name)
    }
    
    @IBAction func cancel(segue: UIStoryboardSegue){
    
    }
    
    func alertComplete(title: String, message: String){
        
        let refreshAlert = UIAlertController(title: "Mark as complete?", message: "Are you sure you want to mark this complete?", preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
            print("Handle Cancel")
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action: UIAlertAction!) in
            self.taskToPass.updateCompleted("Completed")
            self.completed.text = self.taskToPass.completed
            self.taskToPass.changed = true
            self.performSegueWithIdentifier("doneEach", sender: nil)
        }))
        presentViewController(refreshAlert, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func deleteAlert(sender: UIButton) {
        alert("Delete", message: "Are you sure you want to delete?")
    }
    
    func alert(title: String, message: String) {
        
        let refreshAlert = UIAlertController(title: "Delete?", message: "Are you sure you want to delete?", preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
            print("Handle Cancel")
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Delete", style: .Default, handler: { (action: UIAlertAction!) in
            self.removeEvent()
            self.performSegueWithIdentifier("doneDel", sender: nil)
        }))
        
        presentViewController(refreshAlert, animated: true, completion: nil)
    }
    
    // Responds to button to remove event. This checks that we have permission first, before removing the
    // event
    @IBAction func removeEvent() {
        let eventStore = EKEventStore()
        
        if (EKEventStore.authorizationStatusForEntityType(.Event) != EKAuthorizationStatus.Authorized) {
            eventStore.requestAccessToEntityType(.Event, completion: { (granted, error) -> Void in
                self.deleteEvent(eventStore, eventIdentifier: self.taskToPass.eventId)
            })
        } else {
            deleteEvent(eventStore, eventIdentifier: taskToPass.eventId)
        }
    }
    
    func deleteEvent(eventStore: EKEventStore, eventIdentifier: String) {
        let eventToRemove = eventStore.eventWithIdentifier(eventIdentifier)
        if (eventToRemove != nil) {
            do {
                try eventStore.removeEvent(eventToRemove!, span: .ThisEvent)
            } catch {
                print("Bad things happened")
            }
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "doneEach" {
            if let dest = segue.sourceViewController as? BucketListViewController{
                dest.passedIndex = indexToPass
                dest.passedTask = taskToPass
            }
        }
        if segue.identifier == "editSegue" {
            if let dest = segue.destinationViewController as? EditListViewController{
                dest.taskToPass = taskToPass
                dest.indexToPass = indexToPass
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        taskTitle.font = UIFont(name: (taskTitle.font?.fontName)!, size: 20)
        taskTitle.text = taskToPass.name
        descrip.text = taskToPass.descrip
        completed.text = taskToPass.completed
        dateTime.text = taskToPass.startDateTime
        
        let path = taskToPass.img
        print(path, "this is path")
        if (path != ""){
            let imageis: UIImage = UIImage(contentsOfFile: path)!
            photoImage.image = imageis
        }

        location.text = NSString(format: "Lat: %.2f" + " Lon: %.2f" , taskToPass.lat, taskToPass.lon) as String
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    }
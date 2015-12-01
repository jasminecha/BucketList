//
//  EditListViewController.swift
//  GraduateList
//
//  Created by Jasmine Cha on 11/8/15.
//  Copyright © 2015 Jasmine Cha. All rights reserved.
//

import UIKit
import MobileCoreServices

class EditListViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var taskToPass = Task()
    var indexToPass = 0
    var oldTask = ""
    var oldDescrip = ""
    
    var temp = ""
    
    @IBOutlet weak var taskName: UITextField!
    @IBOutlet weak var taskDescri: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskName.delegate = self
        taskDescri.delegate = self
        temp = taskToPass.img + "temp"
        
        oldTask = taskToPass.name
        
        oldDescrip = taskToPass.descrip
        
        taskName.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        taskDescri.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        
        taskName.text = taskToPass.name
        if(taskToPass.descrip == ""){
            taskDescri.placeholder = "No description provided."
        }
        else{
            taskDescri.text = taskToPass.descrip
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "cancelEdit"){
            taskToPass.name = oldTask
            taskToPass.descrip = oldDescrip
            taskToPass.changed = false
        }
        else if(segue.identifier == "doneEdit" && taskToPass.name != oldTask || taskToPass.descrip != oldDescrip || taskToPass.img != temp){
            taskToPass.changed = true
            taskToPass.img = temp
        }
    }
    
    func textFieldDidChange(textField: UITextField){
        if(textField == taskName){
            taskToPass.name = taskName.text!
        }
        else if (textField == taskDescri){
            taskToPass.descrip = taskDescri.text!
        }
        else{
            print("error")
        }
    }
    
    func textFieldShouldReturn(userText: UITextField) -> Bool {
        userText.resignFirstResponder()
        return true
    }
    
    @IBAction func changeImg(sender: UIButton) {
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
        }
    }
    
    func displayAlertWithTitle(title: String, message: String){
        let controller = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        controller.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        
        presentViewController(controller, animated: true, completion: nil)
        
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let image = info[UIImagePickerControllerOriginalImage]
            as! UIImage
        
        let fileManager = NSFileManager.defaultManager()
        
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let filePathToWrite = temp
        
        // let imageData: NSData = UIImagePNGRepresentation(selectedImage)!
        let jpgImageData = UIImageJPEGRepresentation(image, 1.0)
        
        fileManager.createFileAtPath(filePathToWrite, contents: jpgImageData, attributes: nil)
        
        // Check file saved successfully
        let getImagePath = (paths as NSString).stringByAppendingPathComponent("User_Profile_Image.jpg")
        if(fileManager.fileExistsAtPath(getImagePath)){
            print("WOHOO")
        }
        else{
            print("nah")
        }
        
        picker.dismissViewControllerAnimated(true, completion: nil)
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
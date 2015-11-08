//
//  EditListViewController.swift
//  GraduateList
//
//  Created by Jasmine Cha on 11/8/15.
//  Copyright © 2015 Jasmine Cha. All rights reserved.
//

import UIKit

class EditListViewController: UIViewController, UITextFieldDelegate {
    
    var taskToPass = Task()
    var indexToPass = 0
    
    @IBOutlet weak var taskName: UITextField!
    @IBOutlet weak var taskDescri: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskName.delegate = self
        taskDescri.delegate = self
        
        taskName.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        taskDescri.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        
        taskName.text = taskToPass.name
        if(taskToPass.descrip == ""){
            taskDescri.text = "No description provided."
        }
        else{
            taskDescri.text = taskToPass.descrip
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
}

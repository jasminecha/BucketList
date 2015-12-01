//
//  LoginViewController.swift
//  GraduateList
//
//  Created by David Stolz on 11/22/15.
//  Copyright © 2015 Jasmine Cha. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Storyboard Items
    @IBOutlet weak var usernameInput: UITextField!

    // MARK: Items Needed for Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameInput.delegate = self
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Segue Info
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "usernameAdd" {
            let src = segue.destinationViewController as! UINavigationController
            let listItems = src.topViewController as! BucketListViewController
            var val = usernameInput.text!.stringByReplacingOccurrencesOfString(" ", withString: "")
            if(val == ""){
                val = "Default user"
            }
            listItems.user = val
        }
    }
}
//
//  SignupViewController.swift
//  GraduateList
//
//  Created by Jasmine Cha on 12/1/15.
//  Copyright © 2015 Jasmine Cha. All rights reserved.
//
//  Tutorial from http://www.appcoda.com/login-signup-parse-swift/

import UIKit
import Parse

class SignupViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Storyboard Items
    @IBOutlet weak var usernameInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var emailInput: UITextField!
    
    // MARK: Items Needed for Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameInput.delegate = self
        passwordInput.delegate = self
        emailInput.delegate = self
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Alert
    func alert(title: String, message: String){
        let controller = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        controller.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(controller, animated: true, completion: nil)
        
    }
    
    // MARK: Signup
    @IBAction func signUpButton(sender: AnyObject) {
        let username = self.usernameInput.text!.capitalizedString
        let password = self.passwordInput.text
        var email = self.emailInput.text
        //var emailRegex:NSRegularExpression
        let emailPattern = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        //try! emailRegex = NSRegularExpression(pattern: emailPattern, options: NSRegularExpressionOptions.CaseInsensitive)

        email = email!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailPattern)
        let passes = emailTest.evaluateWithObject(email)
        // Validate the text fields
        if username.characters.count < 5 {
            alert("Invalid", message: "Username must be greater than 5 characters")
        } else if(username.containsString(" ")){
            alert("Invalid", message: "Username cannot contains spaces")
        } else if password!.characters.count < 8 {
            alert("Invalid", message: "Password must be greater than 8 characters")
            
        } else if email!.characters.count == 0 || !passes  {
            alert("Invalid", message: "Please enter a valid email address")
        } else {
            // Run a spinner to show a task in progress
            let spinner: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0, 0, 150, 150)) as UIActivityIndicatorView
            spinner.startAnimating()
            
            let newUser = PFUser()
            
            newUser.username = username
            newUser.password = password
            newUser.email = email
            
            // Sign up the user asynchronously
            newUser.signUpInBackgroundWithBlock({ (succeed, error) -> Void in
                
                // Stop the spinner
                spinner.stopAnimating()
                if ((error) != nil) {
                    self.alert("Error", message: "\(error)")
                    
                } else {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Login")
                        self.presentViewController(viewController, animated: true, completion: nil)
                    })
                }
            })
        }
    }
    

}
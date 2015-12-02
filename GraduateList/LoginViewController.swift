//
//  LoginViewController.swift
//  GraduateList
//
//  Created by David Stolz on 12/1/15.
//  Copyright © 2015 Jasmine Cha. All rights reserved.
//
//  Tutorial from http://www.appcoda.com/login-signup-parse-swift/

import UIKit
import Parse

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Storyboard Items
    @IBOutlet weak var loginUser: UITextField!
    @IBOutlet weak var loginPass: UITextField!
    
    // MARK: Items Needed for Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        loginUser.delegate = self
        loginPass.delegate = self
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func alert(title: String, message: String){
        let controller = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        controller.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(controller, animated: true, completion: nil)
        
    }
    
    // MARK: Segue
    @IBAction func cancel(segue:UIStoryboardSegue) {
        
    }
    
    // MARK: Login
    @IBAction func loginButton(sender: AnyObject) {
        let username = self.loginUser.text
        let password = self.loginPass.text
        
        // Validate the text fields
        let spinner: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0, 0, 150, 150)) as UIActivityIndicatorView
        spinner.startAnimating()
            
        // Send a request to login
        var trimmedLog = username!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        trimmedLog = trimmedLog.capitalizedString
            
        PFUser.logInWithUsernameInBackground(trimmedLog, password: password!, block: { (user, error) -> Void in
                
            // Stop the spinner
            spinner.stopAnimating()
                
            if ((user) != nil) {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("NavController")
                    self.presentViewController(viewController, animated: true, completion: nil)
                })
                    
            } else {
                self.alert("Error", message: "\(error)")
            }
        })
    }
}
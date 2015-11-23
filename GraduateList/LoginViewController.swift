//
//  LoginViewController.swift
//  GraduateList
//
//  Created by David Stolz on 11/22/15.
//  Copyright © 2015 Jasmine Cha. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameInput: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameInput.delegate = self

        // Do any additional setup after loading the view.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "usernameAdd" {
            let src = segue.destinationViewController as! UINavigationController
            let listItems = src.topViewController as! BucketListViewController
            var val = usernameInput.text!.stringByReplacingOccurrencesOfString(" ", withString: "")
            if(val == ""){
                val = "Default user"
            }
            listItems.user = val
//            sendAddUser(val)
        }
    }
    
//    func sendAddUser(val: String){
//        let request = NSMutableURLRequest(URL: NSURL(string: "http://pacific-inlet-7989.herokuapp.com/adduser")!)
//        let session = NSURLSession.sharedSession()
//        request.HTTPMethod = "POST"
//        
//        let params = ["name": val] as Dictionary<String, String>
//        
//        request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(params, options: [])
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.addValue("application/json", forHTTPHeaderField: "Accept")
//        //
//        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
//            print("Response: \(response)")
//            let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
//            print("Body: \(strData)")
//        })
//        task.resume()
//    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard.add
        textField.resignFirstResponder()
        return true
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
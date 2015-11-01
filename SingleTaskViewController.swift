//
//  SingleTaskViewController.swift
//  GraduateList
//
//  Created by Jasmine Cha on 11/1/15.
//  Copyright © 2015 Jasmine Cha. All rights reserved.
//

import UIKit

class SingleTaskViewController: UIViewController {

    @IBOutlet weak var taskTitle: UILabel!
    @IBOutlet weak var descrip: UILabel!
    @IBOutlet weak var dateTime: UILabel!
    @IBOutlet weak var completed: UILabel!
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var location: UILabel!

    var taskToPass = Task()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        taskTitle.font = UIFont(name: (taskTitle.font?.fontName)!, size: 30)
        taskTitle.text = taskToPass.name
        descrip.text = taskToPass.descrip
        dateTime.text = taskToPass.startDateTime
        photoImage.image = taskToPass.img
        
        location.text = NSString(format: "Lat: %.2f" + " Lon: %.2f" , taskToPass.lat, taskToPass.lon) as String
        
        if(taskToPass.completed){
            completed.text = "Completed"
        }
        else{
            completed.text = "Not yet completed"
        }
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

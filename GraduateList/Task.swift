//
//  Task.swift
//  GraduateList
//
//  Created by Stolz, David (dps7ud) on 10/31/15.
//  Copyright © 2015 Jasmine Cha. All rights reserved.
//  Tutorial - http://www.raywenderlich.com/114234/learn-to-code-ios-apps-with-swift-tutorial-3-arrays-objects-and-classes

import UIKit

class Task: NSObject {
    
    var name = ""
    var descrip = ""
    var completed = false
    //   var img = UIImage
    var tags = []
    var startDateTime = ""
    var endDateTime = ""
    var lat = 0.0
    var lon = 0.0
    var img: UIImage!
    
    func updateName(newName: String){
        name = newName
    }
    
    func updateCompleted(val: Bool){
        completed = val
    }
    
    func toString() -> String {
        let s = (completed ? "True" : "False")
        return "name: " + self.name + " completed: " + s
    }
    
    //Equitable. Basically an operator override?
    func equals(task: Task) -> Bool{
        var b = true
        b = b && self.name == task.name
        b = b && self.descrip == task.descrip
        b = b && self.startDateTime == task.startDateTime
        b = b && self.endDateTime == task.endDateTime
        b = b && self.completed == task.completed
        b = b && self.lat == task.lat
        b = b && self.lon == task.lon
        return b
    }
}
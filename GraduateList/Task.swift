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
    
}
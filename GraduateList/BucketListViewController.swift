//
//  BucketListViewController.swift
//  GraduateList
//
//  Created by Jasmine Cha on 10/25/15.
//  Copyright © 2015 Jasmine Cha. All rights reserved.
//  Tutorial from - https://github.com/ioscreator/ioscreator/tree/master/IOS8SwiftAddRowsTableViewTutorial
//

import UIKit

class BucketListViewController: UITableViewController {

    let path = NSTemporaryDirectory() + "savedTask.txt"
    
    var tasks = [Task]()
    var newTask = Task()
    
    let arrayValues:NSMutableArray = []
    var added = false
    
    @IBAction func cancel(segue:UIStoryboardSegue) {
        
    }
    
    func loadValues(){
        let readArray:NSArray? = NSArray(contentsOfFile: path)
        if let array = readArray{
            for item in array{
                let currentTask = Task()
                currentTask.name = String(item[0])
                currentTask.descrip = String(item[1])
                currentTask.completed = item[2] as! Bool
                currentTask.startDateTime = String(item[3])
                currentTask.endDateTime = String(item[4])
                currentTask.lat = item[5] as! Double
                currentTask.lon = item[6] as! Double
                tasks.append(currentTask)
            }
        }
        else{
            print("Couldn't")
        }
    }
    
    
    @IBAction func doneEach(segue:UIStoryboardSegue){
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toEachSegue" {
            if let dest = segue.destinationViewController as? SingleTaskViewController{
                if let index = tableView.indexPathForSelectedRow?.row{
                    dest.taskToPass = tasks[index]
                }
            }
        }
    }
    
    @IBAction func done(segue:UIStoryboardSegue) {
        let detailVC = segue.sourceViewController as! ItemDetailViewController
        newTask = detailVC.newTask
        
//        loadValues()
        if(!added){
            for element in tasks {
//                let arrVal = NSMutableArray()
                arrayValues.addObject([element.name, element.descrip, element.completed, element.startDateTime, element.endDateTime, element.lat, element.lon])
            }
        }

        if(newTask.name != ""){
            tasks.append(newTask)
            self.tableView.reloadData()
            
            arrayValues.addObject([newTask.name, newTask.descrip, newTask.completed, newTask.startDateTime, newTask.endDateTime, newTask.lat, newTask.lon]) // check why img is nil
            
            print("This is the destPath")
            print(path)
            
            if arrayValues.writeToFile(path, atomically: true){
                print("writing passed!")
            }
            else{
                print("Didn't pass writing")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadValues()
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return tasks.count
    }
    
    
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("carCell", forIndexPath: indexPath)
        // Configure the cell...
        cell.textLabel!.text = tasks[indexPath.row].name
        
        return cell
    }
    
}
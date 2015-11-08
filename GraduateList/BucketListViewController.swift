//
//  BucketListViewController.swift
//  GraduateList
//
//  Created by Jasmine Cha on 10/25/15.
//  Copyright © 2015 Jasmine Cha. All rights reserved.
//  Tutorial from - https://github.com/ioscreator/ioscreator/tree/master/IOS8SwiftAddRowsTableViewTutorial
//  Tutorial from - https://github.com/deege/deegeu-swift-eventkit/tree/master/CalendarTest

import UIKit

class BucketListViewController: UITableViewController {

    let path = NSTemporaryDirectory() + "storage2.txt"
    
    var passedIndex:Int = 0
    
    var tasks = [Task]()
    var newTask = Task()
    //Necessary?
    var passedTask:Task = Task()

    var arrayValues:NSMutableArray = []
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
                currentTask.completed = String(item[2])
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
        
        if(!added){
            for element in tasks {
                //                let arrVal = NSMutableArray()
                arrayValues.addObject([element.name, element.descrip, element.completed, element.startDateTime, element.endDateTime, element.lat, element.lon])
            }
            added = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toEachSegue" {
            if let dest = segue.destinationViewController as? SingleTaskViewController{
                if let index = tableView.indexPathForSelectedRow?.row{
                    dest.taskToPass = tasks[index]
                    dest.indexToPass = index
                }
            }
        }
    }
    
    @IBAction func doneEach(segue: UIStoryboardSegue){
        if let src = segue.sourceViewController as? SingleTaskViewController{
            passedTask = src.taskToPass
            passedIndex = src.indexToPass           

//            let taskChanged = tasks[passedIndex].equals(passedTask)
            if src.changed {
                tasks.removeAtIndex(passedIndex)
                arrayValues.removeObjectAtIndex(passedIndex)
                addAndWrite(passedTask)
                src.changed = false
            }
        }
        print("after",passedTask.name)
    }

    func addAndWrite(task: Task){
        if(!added){
            for element in tasks {
                //                let arrVal = NSMutableArray()
                arrayValues.addObject([element.name, element.descrip, element.completed, element.startDateTime, element.endDateTime, element.lat, element.lon])
            }
            added = true
        }
        
        if(task.name != ""){
            tasks.append(task)
            self.tableView.reloadData()
            
            arrayValues.addObject([task.name, task.descrip, task.completed, task.startDateTime, task.endDateTime, task.lat, task.lon]) // check why img is nil
            
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
    
    @IBAction func doneDel(segue: UIStoryboardSegue){
        if let src = segue.sourceViewController as? SingleTaskViewController{
            let curIndex = src.indexToPass
        
            tasks.removeAtIndex(curIndex)
            arrayValues.removeObjectAtIndex(curIndex)
            self.tableView.reloadData()
        
            let text = ""
            do{
                try text.writeToFile(path, atomically: true, encoding: NSUTF8StringEncoding)
            } catch {
                print("error")
            }
        
            if arrayValues.writeToFile(path, atomically: true){
                print("writing passed!")
            }
            else{
                print("Didn't pass writing")
            }
        }
        //add write
    }
    
    @IBAction func done(segue:UIStoryboardSegue) {
        if segue.sourceViewController is ItemDetailViewController{
            let detailVC = segue.sourceViewController as! ItemDetailViewController
            newTask = detailVC.newTask
            addAndWrite(newTask)
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
        //TODO: fix^
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
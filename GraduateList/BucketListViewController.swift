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

    var tasks = [Task]()
    var newTask = Task()
    let arrayValues:NSMutableArray = []
    
    @IBAction func cancel(segue:UIStoryboardSegue) {
        
    }
    
    @IBAction func done(segue:UIStoryboardSegue) {
        let detailVC = segue.sourceViewController as! ItemDetailViewController
        newTask = detailVC.newTask
        
        if(newTask.name != ""){
            tasks.append(newTask)
            self.tableView.reloadData()
            
            let destPath = NSTemporaryDirectory() + "saved.txt"
            arrayValues.addObject([newTask.name, newTask.completed, newTask.startDateTime, newTask.endDateTime, newTask.lat, newTask.lon])
            
            if arrayValues.writeToFile(destPath, atomically: true){
                print("writing passed!")
            }
            else{
                print("Didn't pass writing")
            }
        
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tasks = []
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
        
        let path = NSTemporaryDirectory() + "saved.txt"
        let readArray:NSArray? = NSArray(contentsOfFile: path)
        if let array = readArray{
            for item in array{
                cell.textLabel!.text = String(item[0])
            }
        }
        else{
            print("Couldn't")
        }
        print(tasks[indexPath.row])
        
        return cell
    }
    
}
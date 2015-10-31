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
    var newTaskName = Task()
    
    @IBAction func cancel(segue:UIStoryboardSegue) {
        
    }
    
    @IBAction func done(segue:UIStoryboardSegue) {
        let detailVC = segue.sourceViewController as! ItemDetailViewController
        newTaskName = detailVC.newTask
        
        if(newTaskName.name != ""){
            tasks.append(newTaskName)
            self.tableView.reloadData()
            
            print(newTaskName.name)
            print(newTaskName.startDateTime)
            print(newTaskName.endDateTime)
            print(newTaskName.completed)
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
        
        cell.textLabel!.text = tasks[indexPath.row].name
        
        return cell
    }
    
}
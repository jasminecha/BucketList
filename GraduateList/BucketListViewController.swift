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

    var tasks = [String]()
    var newTask: String = ""
    
    @IBAction func cancel(segue:UIStoryboardSegue) {
        
    }
    
    @IBAction func done(segue:UIStoryboardSegue) {
        let detailVC = segue.sourceViewController as! ItemDetailViewController
        newTask = detailVC.name
        
        if(newTask != ""){
            tasks.append(newTask)
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tasks = ["Default task"]
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
        
        cell.textLabel!.text = tasks[indexPath.row]
        
        return cell
    }
    
}
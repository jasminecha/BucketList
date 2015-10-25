//
//  ItemDetailViewController.swift
//  GraduateList
//
//  Created by Jasmine Cha on 10/25/15.
//  Copyright © 2015 Jasmine Cha. All rights reserved.
//

import UIKit
import EventKitUI

class ItemDetailViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var taskName: UITextField!
    var name: String = ""
    @IBOutlet weak var startDate: UIDatePicker!
    @IBOutlet weak var endDate: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        taskName.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard.add
        textField.resignFirstResponder()
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        addEvent()
        if segue.identifier == "doneSegue" {
            name = taskName.text!
        }
    }

    func createEvent(eventStore: EKEventStore, title: String, startDate: NSDate, endDate: NSDate) {
        let event = EKEvent(eventStore: eventStore)
        
        event.title = title
        event.startDate = startDate
        event.endDate = endDate
        event.calendar = eventStore.defaultCalendarForNewEvents
        do {
            try eventStore.saveEvent(event, span: .ThisEvent)
        } catch {
            print("Bad things happened")
        }
    }
    
    func addEvent() {
        let eventStore = EKEventStore()
        
        //let startDate = NSDate()
        
        //let endDate = startDate.dateByAddingTimeInterval(60 * 60) // One hour
        
        if (EKEventStore.authorizationStatusForEntityType(.Event) != EKAuthorizationStatus.Authorized) {
            eventStore.requestAccessToEntityType(.Event, completion: {
                granted, error in
                self.createEvent(eventStore, title: (self.taskName?.text)!, startDate: self.startDate.date, endDate: self.endDate.date)
            })
        } else {
            createEvent(eventStore, title: (self.taskName?.text)!, startDate: self.startDate.date, endDate: self.endDate.date)
        }
    }
}

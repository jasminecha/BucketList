//
//  ItemDetailViewController.swift
//  GraduateList
//
//  Created by Jasmine Cha on 10/25/15.
//  Copyright © 2015 Jasmine Cha. All rights reserved.
//  Tutorial - https://github.com/marksherriff/iOS-GPSExample

import UIKit
import CoreLocation
import EventKitUI
import MobileCoreServices

class ItemDetailViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {
    
    // MARK: Storyboard Items
    @IBOutlet weak var taskName: UITextField!
    @IBOutlet weak var startDate: UIDatePicker!
    @IBOutlet weak var endDate: UIDatePicker!
    @IBOutlet weak var taskDescrip: UITextField!
    
    // MARK: Fields
    var newMedia: Bool?
    var newTask = Task()
    var count: Int?
    var user = ""
    var dateCheck = false
    var locationManager: CLLocationManager?
    
    // MARK: Items Needed for Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        taskName.delegate = self
        taskDescrip.delegate = self
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
    
    // MARK: Alerts
    func alertDidntWork(title: String, message: String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Okay", style: .Default, handler: { (action: UIAlertAction!) in
            print("Data")
        }))
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func displayAlertWithTitle(title: String, message: String){
        let controller = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        controller.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        
        presentViewController(controller, animated: true, completion: nil)
        
    }
    
    // MARK: Segue Info
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        var name = taskName.text
        name = name!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        var desc = taskDescrip.text
        desc = desc!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        if identifier == "doneSegue" {
            if(name == ""){
                alertDidntWork("Insufficient Data", message: "No Task Name Given")
                return false
            } else if desc == ""{
                alertDidntWork("Insufficient Data", message: "No Descripton Given")
                return false
            }
            
            if((taskName.text != "")){
                addEvent()
                
                if !dateCheck{
                    alertDidntWork("End Date is before Start Date", message: "")
                    return false
                }
                
                newTask.name = taskName.text!
                newTask.descrip = taskDescrip.text!
                newTask.user = user
                
                sendAddTask(newTask.name)
                
                return true
            }
        }
        return true
    }
    
    @IBAction func doneCapture(segue:UIStoryboardSegue) {
        
    }
    
    // MARK: Web Services
    func sendAddTask(val: String){
        let request = NSMutableURLRequest(URL: NSURL(string: "http://pacific-inlet-7989.herokuapp.com/addtask")!)
        let session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        let params = ["task": val, "name": user] as Dictionary<String, String>
        
        request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(params, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        //
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            print("Response: \(response)")
            let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("Body: \(strData)")
        })
        task.resume()
    }
    
    // MARK: Location
        func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count == 0{
            //handle error here
            return
        }
        
        let newLocation = locations[0]
        
        newTask.lat = newLocation.coordinate.latitude
        newTask.lon = newLocation.coordinate.longitude
        
    }
    
    func locationManager(manager: CLLocationManager,
        didFailWithError error: NSError){
            print("Location manager failed with error = \(error)")
    }
    
    func locationManager(manager: CLLocationManager,
        didChangeAuthorizationStatus status: CLAuthorizationStatus){
            
            print("The authorization status of location services is changed to: ", terminator: "")
            
            switch CLLocationManager.authorizationStatus(){
            case .AuthorizedAlways:
                print("Authorized")
            case .AuthorizedWhenInUse:
                print("Authorized when in use")
            case .Denied:
                print("Denied")
            case .NotDetermined:
                print("Not determined")
            case .Restricted:
                print("Restricted")
            }
    }
    
    // MARK: Event Things
    func createEvent(eventStore: EKEventStore, title: String, startDate: NSDate, endDate: NSDate) {
        
        if(dateCheck){
        
            let event = EKEvent(eventStore: eventStore)
            
            event.title = title
            event.startDate = startDate
            event.endDate = endDate
        
            event.calendar = eventStore.defaultCalendarForNewEvents
            do {
                try eventStore.saveEvent(event, span: .ThisEvent)
                newTask.eventId = event.eventIdentifier

                let formatter = NSDateFormatter()
                formatter.dateFormat = "MM-dd-yyyy hh:mm"
                let stringDate: String = formatter.stringFromDate(event.startDate)
                let endStringDate: String = formatter.stringFromDate(event.endDate)
            
                newTask.startDateTime = stringDate
                newTask.endDateTime = endStringDate

            } catch {
                print("Bad things happened")
            }
        }
    }
    
    func addEvent() {
        
        let eventStore = EKEventStore()
        
        if self.endDate.date.compare(self.startDate.date) == NSComparisonResult.OrderedDescending || self.endDate.date.compare(self.startDate.date) != NSComparisonResult.OrderedAscending {
            self.dateCheck = true
        }

        
        if (EKEventStore.authorizationStatusForEntityType(.Event) != EKAuthorizationStatus.Authorized) {
            eventStore.requestAccessToEntityType(.Event, completion: {
                granted, error in

                self.createEvent(eventStore, title: (self.taskName?.text)!, startDate: self.startDate.date, endDate: self.endDate.date)
                
            })
        } else {
            createEvent(eventStore, title: (self.taskName?.text)!, startDate: self.startDate.date, endDate: self.endDate.date)
        }
    }
    
    // MARK: Images and Camera
    @IBAction func useCamera(sender: UIButton) {
        getGPS()

        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.Camera) {
                
                let imagePicker = UIImagePickerController()
                
                imagePicker.delegate = self
                imagePicker.sourceType =
                    UIImagePickerControllerSourceType.Camera
                imagePicker.mediaTypes = [kUTTypeImage as NSString as String]
                imagePicker.allowsEditing = false
                
                self.presentViewController(imagePicker, animated: true,
                    completion: nil)
                newMedia = true
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let image = info[UIImagePickerControllerOriginalImage]
            as! UIImage
        
        let fileManager = NSFileManager.defaultManager()
        
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let filePathToWrite = "\(paths)/User_Profile_Image.jpg" + String(count)
        newTask.img = filePathToWrite
        print(newTask.img)
        
        // let imageData: NSData = UIImagePNGRepresentation(selectedImage)!
        let jpgImageData = UIImageJPEGRepresentation(image, 1.0)
        
        fileManager.createFileAtPath(filePathToWrite, contents: jpgImageData, attributes: nil)
        
        // Check file saved successfully
        let getImagePath = (paths as NSString).stringByAppendingPathComponent("User_Profile_Image.jpg")
        if(fileManager.fileExistsAtPath(getImagePath)){
            print("WOHOO")
        }
        
        if (newMedia == true) {
            UIImageWriteToSavedPhotosAlbum(image, self,
                "image:didFinishSavingWithError:contextInfo:", nil)
        }
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
        
    func image(image: UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo:UnsafePointer<Void>) {
        if error != nil {
            let alert = UIAlertController(title: "Save Failed",
                message: "Failed to save image",
                preferredStyle: UIAlertControllerStyle.Alert)
            
            let cancelAction = UIAlertAction(title: "OK",
                style: .Cancel, handler: nil)
            
            alert.addAction(cancelAction)
            self.presentViewController(alert, animated: true,
                completion: nil)
        }
    }

    
    //MARK: Location
    func createLocationManager(startImmediately startImmediately: Bool){
        locationManager = CLLocationManager()
        if let manager = locationManager{
            print("Successfully created the location manager")
            manager.delegate = self
            if startImmediately{
                manager.startUpdatingLocation()
            }
        }
    }
    
    func getGPS(){
        if CLLocationManager.locationServicesEnabled(){
            
            /* Do we have authorization to access location services? */
            switch CLLocationManager.authorizationStatus(){
            case .AuthorizedAlways:
                /* Yes, always */
                createLocationManager(startImmediately: true)
            case .AuthorizedWhenInUse:
                /* Yes, only when our app is in use */
                createLocationManager(startImmediately: true)
                print("authorized when in use")
            case .Denied:
                /* No */
                displayAlertWithTitle("Not Determined",
                    message: "Location services are not allowed for this app")
            case .NotDetermined:
                /* We don't know yet, we have to ask */
                createLocationManager(startImmediately: false)
                if let manager = self.locationManager{
                    manager.requestWhenInUseAuthorization()
                }
            case .Restricted:
                /* Restrictions have been applied, we have no access
                to location services */
                displayAlertWithTitle("Restricted",
                    message: "Location services are not allowed for this app")
            }
        }
    }
}
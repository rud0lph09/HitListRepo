//
//  ViewController.swift
//  hitList
//
//  Created by Rodolfo Castillo on 11/03/15.
//  Copyright (c) 2015 Rodolfo Castillo. All rights reserved.
//

import UIKit
import CoreData
//Necessary if you want to use this to store in the device

class ViewController: UIViewController, UITableViewDataSource{
    //We also are remarking that the view controller is de UITableViewDataSource
    

    @IBOutlet weak var tableView: UITableView!
    
    //var names = [String]()
    //We change de constructor to the one of [NSManagedObject]() so we create an Object from coreData
    var people = [NSManagedObject]()

    @IBAction func remove(sender: AnyObject) {
        //Add the alert
        var alert = UIAlertController(title: "New name",
            message: "Add a new name",
            preferredStyle: .Alert)
        //This will tell us what to do to save the name
        /*let saveAction = UIAlertAction(title: "Save",
        style: .Default) { (action: UIAlertAction!) -> Void in
        
        let textField = alert.textFields![0] as UITextField
        self.names.append(textField.text)
        self.tableView.reloadData()
        }*/
        let removeAction = UIAlertAction(title: "Remove Last Entry",
            style: .Default) { (action: UIAlertAction!) -> Void in
                
                //let textField = alert.textFields![0] as UITextField
                self.removePerson()//note how we are now calling another method
                self.tableView.reloadData()
        }
        
        //In case we want to cancel!
        let cancelAction = UIAlertAction(title: "Cancel",
            style: .Default) { (action: UIAlertAction!) -> Void in
        }
        
        //Adding the text field to the alert
        //alert.addTextFieldWithConfigurationHandler {
            //(textField: UITextField!) -> Void in
        //}
        
        //we call the methods
        alert.addAction(removeAction)
        alert.addAction(cancelAction)
        
        //we call the alert to screen. ACTCION TIME!
        presentViewController(alert,
            animated: true,
            completion: nil)
    }
    
    @IBAction func add(sender: AnyObject) {
        //Add the alert
        var alert = UIAlertController(title: "New name",
            message: "Add a new name",
            preferredStyle: .Alert)
        //This will tell us what to do to save the name
        /*let saveAction = UIAlertAction(title: "Save",
            style: .Default) { (action: UIAlertAction!) -> Void in
                
                let textField = alert.textFields![0] as UITextField
                self.names.append(textField.text)
                self.tableView.reloadData()
        }*/
        let saveAction = UIAlertAction(title: "Save",
            style: .Default) { (action: UIAlertAction!) -> Void in
                
                let textField = alert.textFields![0] as UITextField
                self.saveName(textField.text)//note how we are now calling another method
                self.tableView.reloadData()
        }
        
        //In case we want to cancel!
        let cancelAction = UIAlertAction(title: "Cancel",
            style: .Default) { (action: UIAlertAction!) -> Void in
        }
        
        //Adding the text field to the alert
        alert.addTextFieldWithConfigurationHandler {
            (textField: UITextField!) -> Void in
        }
        
        //we call the methods
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        //we call the alert to screen. ACTCION TIME!
        presentViewController(alert,
            animated: true,
            completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "\"The List\""//Add a title
        tableView.registerClass(UITableViewCell.self,
            forCellReuseIdentifier: "Cell")//register as class
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //To make it stop complaining we will add the following methods
    /*
    func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
            return names.count
    }
    
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath
        indexPath: NSIndexPath) -> UITableViewCell {
            
            let cell =
            tableView.dequeueReusableCellWithIdentifier("Cell")
                as UITableViewCell
            
            cell.textLabel!.text = names[indexPath.row]
            
            return cell
    }
    */
    
    //We also replaced the methods with this modificacions
    func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
            return people.count//we are now storing in corData and pulling the number of "persons" to display the cells
    }
    
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath
        indexPath: NSIndexPath) -> UITableViewCell {
            
            let cell =
            tableView.dequeueReusableCellWithIdentifier("Cell")
                as UITableViewCell
            
            let person = people[indexPath.row]
            cell.textLabel!.text = person.valueForKey("name") as String?
            //Checkout how we are asking for the attribute we declared in our data model
            
            return cell
    }
    
    //Remember that method we swaped for saveAction?
    func saveName(name: String) {
        //1
        let appDelegate =
        UIApplication.sharedApplication().delegate as AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        //we are saying that we want that model we created!
        
        //2
        let entity =  NSEntityDescription.entityForName("Person",
            inManagedObjectContext:
            managedContext)
        
        let person = NSManagedObject(entity: entity!,
            insertIntoManagedObjectContext:managedContext)
        
        //3
        person.setValue(name, forKey: "name")
        //we search for the key value in our model
        
        //4
        var error: NSError?
        if !managedContext.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        }
        //In case an error occurrs
        //5
        people.append(person)
        //we add the person!
    }
    
    func removePerson(){
        //1
        let appDelegate =
        UIApplication.sharedApplication().delegate as AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        //we are saying that we want that model we created!
        
        //2
        let entity =  NSEntityDescription.entityForName("Person",
            inManagedObjectContext:
            managedContext)
        
        let person = NSManagedObject(entity: entity!,
            insertIntoManagedObjectContext:managedContext)
        
        //3
        //person.setValue(name, forKey: "name")
        //we search for the key value in our model
        
        //4
        var error: NSError?
        if people.count == 0 {
            println("There is nothing to errase \(error), \(error?.userInfo)")
        }
        //In case an error occurrs
        //5
        people.removeLast()
        //we add the person!

    }
    
    //Excellent! We have the data but we still have to fetch it!
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //1
        let appDelegate =
        UIApplication.sharedApplication().delegate as AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        //2
        let fetchRequest = NSFetchRequest(entityName:"Person")
        
        //3
        var error: NSError?
        
        let fetchedResults =
        managedContext.executeFetchRequest(fetchRequest,
            error: &error) as [NSManagedObject]?
        
        if let results = fetchedResults {
            people = results
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
    }


}


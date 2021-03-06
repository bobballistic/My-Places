//
//  TableViewController.swift
//  MyPlaces
//
//  Created by Bob on 05/11/2014.
//  Copyright (c) 2014 BallisticSoft. All rights reserved.
//

import UIKit

var activePlace:Int = 0
var places = [Dictionary<String,String>]()


class TableViewController: UITableViewController {
    
    @IBOutlet var taskTable:UITableView!
    // MARK: - MoveToSegue
    @IBAction func addLocation(sender: AnyObject) {
        
        self.performSegueWithIdentifier("addLocation", sender: UIBarButtonItem.self)
        places.append(["name":"Taj Mahal", "latitude":"27.175115", "longitude":"78.042144"])

        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = 70
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "map"))
    
        /*
        if places.count == 1 {
             //We remove the empty cell at the begining of the table, not shure why it's showing ?!?!
             //UPDATE syntax was off, var places = [Dictionary<String,String>()] should be var places = [Dictionary<String,String>]()


          places.removeAtIndex(0)
        }
        */
        if places.count == 0 {
        
        places.append(["name":"Taj Mahal", "latitude":"27.175115", "longitude":"78.042144"])
            
            // MARK: - DisplayingNSUSerToTable? Populating the table when the view loads
            //
            
            if var storedPlaces: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("name") {  //We are checking if the app was used before (if there is anything in the NSUserdefaults)
                
                places = []     // emptying the myToDo array (In case there are items in)
                
                for var i = 0; i<storedPlaces?.count; ++i {               // Looping trough all the items in the array
                    var stringStored = storedPlaces as [Dictionary<String, String>]    // Create new var stringStored (type string) from the storedToDoItems (object)
                    places.append(stringStored[i] as Dictionary)           // Adding items at index [i] to array
                    
                }
                
                
            }
           
        }

        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // --------------- checking if user wants to add a new locatio, if so set the var active place to -1? ----------
        if segue.identifier == "addLocation" {
            activePlace = -1
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        // ---------------- Keep the navigation bar controler after second back but hit
        self.navigationController?.navigationBarHidden = true

    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Moving to segue with identifier, and getting rid of navigation bar in map ?>
        // What to do when row selected
        activePlace = indexPath.row
        
        self.performSegueWithIdentifier("findPlace", sender: indexPath)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return places.count
    }

    
    // MARK: - Populating the table

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        // Configure the cell...
        // MARK: - Custom Cells
        if (indexPath.row % 2 == 0) {
            cell.backgroundColor = UIColor.clearColor()
        } else {
        cell.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.7)
        cell.textLabel.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.0)
        cell.detailTextLabel?.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.0)
        }
        cell.textLabel.textColor = UIColor.whiteColor()
        // MARK:  SOLUTIUON TO FILL TABLE WITH "UNKNOWN" IF PLACE IS " "
   
        if places[indexPath.row]["name"] == " " {
            
            places[indexPath.row]["name"] = "Unknown"
    
        }
        cell.textLabel.text = places[indexPath.row]["name"]
            return cell
       
    }
    // MARK: - SwipeToDelete
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            ///tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
           
            places.removeAtIndex(indexPath.row)
            let fixedPlaces = places
            NSUserDefaults.standardUserDefaults().setObject(fixedPlaces, forKey: "name")
            NSUserDefaults.standardUserDefaults().synchronize()
            taskTable.reloadData()
            //taskTable.reloadData() // refresh the table data
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }




}

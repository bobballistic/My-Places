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
        
        if places.count == 1 {
            // We remove the empty cell at the begining of the table, not shure why it's showing ?!?!
            // UPDATE syntax was off, var places = [Dictionary<String,String>()] should be var places = [Dictionary<String,String>]()


           places.removeAtIndex(0)
        }
        
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

        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}

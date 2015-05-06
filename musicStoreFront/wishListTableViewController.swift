//
//  wishListTableViewController.swift
//  musicStoreFront
//
//  Created by Yifan Xiao on 5/5/15.
//  Copyright (c) 2015 Yifan Xiao. All rights reserved.
//

import UIKit
import Parse
import CoreData

class wishListTableViewController: UITableViewController {

    var wishList = [PFObject]()
    
    override func viewDidLoad() {
        
         super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        let query = PFQuery(className: "WishList")
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error:NSError?) -> Void in
            
            self.wishList = objects as! [PFObject]
            self.tableView.reloadData()
        }

    }

    
    @IBAction func refresh(sender: AnyObject) {
        
    self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        return wishList.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("listCell", forIndexPath: indexPath) as! listTableViewCell
        
        let app:PFObject = self.wishList[indexPath.row] as PFObject

        println(app.objectId)
        let iconData = app["appIcon"] as! NSData
        
        if let image = UIImage(data: iconData) {
            cell.iconView.image = image
            cell.iconView.layer.cornerRadius = 15.0
            cell.iconView.clipsToBounds = true
        }

        cell.iconLabel.text = app["trackCensoredName"] as? String

        return cell
    }


    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    

    
    //Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            let query = PFQuery(className: "WishList")
            
            let app:PFObject = self.wishList[indexPath.row] as PFObject
            
            app.deleteInBackground()
            
            self.wishList.removeAtIndex(indexPath.row)
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let app:PFObject = self.wishList[indexPath.row] as PFObject
        
        let urlString:NSString = app.valueForKey("trackViewUrl") as! NSString
        
        let url = NSURL(string: urlString as String)
        UIApplication.sharedApplication().openURL(url!)
    }


}

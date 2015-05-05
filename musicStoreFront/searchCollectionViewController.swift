//
//  searchCollectionViewController.swift
//  musicStoreFront
//
//  Created by Yifan Xiao on 5/4/15.
//  Copyright (c) 2015 Yifan Xiao. All rights reserved.
//

import UIKit
import CoreData

let reuseIdentifier = "Cell"

class searchCollectionViewController: UICollectionViewController {
    
    
    var results = [NSManagedObject]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func backButtonPressed(sender: UIBarButtonItem) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        let vc:UINavigationController = segue.destinationViewController as! UINavigationController
        let detailController:detailViewController = vc.topViewController as! detailViewController
        
        let path:NSIndexPath = self.collectionView!.indexPathForCell(sender as! UICollectionViewCell)!
        let object = self.results[path.row]
        
        detailController.appObject = object
        
    }


    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return self.results.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("searchCell", forIndexPath: indexPath) as! searchCell
    
        let object = self.results[indexPath.row]
        
        let appName = object.valueForKey("trackCensoredName") as? String
        
        let picData = object.valueForKey("appIcon") as! NSData
        
        cell.cellTitle.text = appName
        
        if let image = UIImage(data: picData) {
            cell.cellIcon.image = image
            cell.cellIcon.layer.cornerRadius = 15.0
            cell.cellIcon.clipsToBounds = true
        }
    
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let side = (self.view!.frame.width - 100)/2.0
        
        return CGSizeMake(side, side*1.1)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(10, 40, 10, 40)
    }


}

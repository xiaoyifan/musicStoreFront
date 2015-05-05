//
//  ViewController.swift
//  musicStoreFront
//
//  Created by Yifan Xiao on 5/4/15.
//  Copyright (c) 2015 Yifan Xiao. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var results = [NSManagedObject]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        var appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        
        var request = NSFetchRequest(entityName: "App")
        request.returnsObjectsAsFaults = false;
        
        var errorFet:NSError?
        
        let fetchResults = context.executeFetchRequest(request, error: &errorFet) as? [NSManagedObject]
        
        if let res = fetchResults {
            self.results = res
        }
        
//        println(self.results[0].valueForKey("appIcon"))
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
            return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return self.results.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("appCell", forIndexPath: indexPath) as! appCell
        
            let object = self.results[indexPath.row]
        
            let appName = object.valueForKey("trackCensoredName") as? String
        
            let picData = object.valueForKey("appIcon") as! NSData
        
            cell.cellTitle.text = appName
        
        if let image = UIImage(data: picData) {
            cell.cellIcon.image = image
            cell.cellIcon.layer.cornerRadius = 15.0
            cell.cellIcon.clipsToBounds = true
//            println(image)
//            println(cell.cellIcon.image?.size)
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

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        let vc:UINavigationController = segue.destinationViewController as! UINavigationController
        let detailController:detailViewController = vc.topViewController as! detailViewController
        
        let path:NSIndexPath = self.collectionView!.indexPathForCell(sender as! UICollectionViewCell)!
        let object = self.results[path.row]
        
        detailController.appObject = object
        
    }

}


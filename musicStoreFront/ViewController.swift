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
        
        var results:Array = context.executeFetchRequest(request, error: &errorFet)!
        
        println(errorFet)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
            return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return 20
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("appCell", forIndexPath: indexPath) as! UICollectionViewCell
            var image : UIImage = UIImage(named:"sad")!
            let bgImage = UIImageView(image: image)
            bgImage.frame = CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height)
            cell.addSubview(bgImage)
    
            return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            let side = (self.view!.frame.width - 100)/2.0
    
            return CGSizeMake(side, side)
        }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            return UIEdgeInsetsMake(10, 40, 10, 40)
        }


}


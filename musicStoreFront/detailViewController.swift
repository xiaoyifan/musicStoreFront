//
//  detailViewController.swift
//  musicStoreFront
//
//  Created by Yifan Xiao on 5/5/15.
//  Copyright (c) 2015 Yifan Xiao. All rights reserved.
//

import UIKit
import CoreData

class detailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {

    
    @IBOutlet weak var photoTableView: UITableView!
    
    @IBOutlet weak var appIcon: UIImageView!
    
    @IBOutlet weak var appTitle: UILabel!
    
    @IBOutlet weak var appDescription: UITextView!
    
    
    var appObject:NSManagedObject?
    var photos = [PhotoRecord]()
    let pendingOperations = PendingOperations()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.photoTableView.delegate = self;
        self.photoTableView.dataSource = self;
        // Do any additional setup after loading the view.
        
        let iconData = appObject!.valueForKey("appIcon") as! NSData
        
        if let image = UIImage(data: iconData) {
            self.appIcon.image = image
            self.appIcon.layer.cornerRadius = 15.0
            self.appIcon.clipsToBounds = true
        }
        
        self.appTitle.text = appObject!.valueForKey("trackCensoredName") as? String
        self.appDescription.text = appObject!.valueForKey("objDescription") as! String
        
        fetchPhotoDetails()
        
    }
    
    
    
    @IBAction func wishListTapped(sender: UIBarButtonItem) {
        
        
    }
    
    
    func fetchPhotoDetails() {
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        let screenshotUrls:NSArray = appObject!.valueForKey("screenshotUrls") as! NSArray
        
                for value in screenshotUrls{
                    let name = value as! String
                    let url = NSURL(string:value as? String ?? "")
                    println(url)
                    if url != nil {
                        let photoRecord = PhotoRecord(name:name, url:url!)
                        self.photos.append(photoRecord)
                    }
                }
        
                self.photoTableView.reloadData()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // #pragma mark - Table view data source
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        println(photos.count)
        return photos.count
    }
    

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("photoCell", forIndexPath: indexPath) as! screenshotsTableViewCell
        
        //1
        if cell.accessoryView == nil {
            let indicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
            cell.accessoryView = indicator
        }
        let indicator = cell.accessoryView as! UIActivityIndicatorView
        
        //2
        let photoDetails = photos[indexPath.row]
        
        //3
        
        cell.myImageView?.image = photoDetails.image
        
        //4
        switch (photoDetails.state){
        case .Failed:
            indicator.stopAnimating()
//            cell.textLabel?.text = "Failed to load"
        case .New:
            indicator.startAnimating()
            if (!tableView.dragging && !tableView.decelerating) {
                println("it's new")
                self.startOperationsForPhotoRecord(photoDetails, indexPath: indexPath)
            }
            
        case .Downloaded:
            indicator.stopAnimating()
        }
        
        return cell
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        //1
        
        suspendAllOperations()
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // 2
        if !decelerate {
            loadImagesForOnscreenCells()
            resumeAllOperations()
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        // 3
        loadImagesForOnscreenCells()
        resumeAllOperations()
    }
    
    func suspendAllOperations () {
        pendingOperations.downloadQueue.suspended = true
    }
    
    func resumeAllOperations () {
        pendingOperations.downloadQueue.suspended = false
    }
    
    func loadImagesForOnscreenCells () {
        //1
        if let pathsArray = self.photoTableView.indexPathsForVisibleRows() {
            //2
            var allPendingOperations = Set(pendingOperations.downloadsInProgress.keys.array)
            
            //3
            var toBeCancelled = allPendingOperations
            let visiblePaths = Set(pathsArray as! [NSIndexPath])
            toBeCancelled.subtractInPlace(visiblePaths)
            
            //4
            var toBeStarted = visiblePaths
            toBeStarted.subtractInPlace(allPendingOperations)
            
            // 5
            for indexPath in toBeCancelled {
                if let pendingDownload = pendingOperations.downloadsInProgress[indexPath] {
                    pendingDownload.cancel()
                }
                pendingOperations.downloadsInProgress.removeValueForKey(indexPath)
               
            }
            
            // 6
            for indexPath in toBeStarted {
                let indexPath = indexPath as NSIndexPath
                let recordToProcess = self.photos[indexPath.row]
                startOperationsForPhotoRecord(recordToProcess, indexPath: indexPath)
            }
        }
    }
    
    func startOperationsForPhotoRecord(photoDetails: PhotoRecord, indexPath: NSIndexPath){
        switch (photoDetails.state) {
        case .New:
            startDownloadForRecord(photoDetails, indexPath: indexPath)
        default:
            NSLog("do nothing")
        }
    }
    
    func startDownloadForRecord(photoDetails: PhotoRecord, indexPath: NSIndexPath){
        //1
        if let downloadOperation = pendingOperations.downloadsInProgress[indexPath] {
            return
        }
        
        //2
        let downloader = ImageDownloader(photoRecord: photoDetails)
        //3
        downloader.completionBlock = {
            if downloader.cancelled {
                return
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.pendingOperations.downloadsInProgress.removeValueForKey(indexPath)
                self.photoTableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            })
        }
        //4
        pendingOperations.downloadsInProgress[indexPath] = downloader
        //5
        pendingOperations.downloadQueue.addOperation(downloader)
    }
    


}

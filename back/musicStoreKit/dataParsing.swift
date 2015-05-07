//
//  dataParsing.swift
//  musicStore
//
//  Created by Yifan Xiao on 4/21/15.
//  Copyright (c) 2015 Yifan Xiao. All rights reserved.
//

import UIKit
import CoreData
import Parse

public class dataParsing {
    
    public static let sharedInstance = dataParsing()
    
    public init(){
        println("parsing singleton is being initialized")
    }
    
    public func parse(data: NSString!) -> NSArray {
        
        var objects:NSMutableArray!
        
        let dataJson = (data as NSString).dataUsingEncoding(NSUTF8StringEncoding)
        
        var dictionary: NSDictionary = NSJSONSerialization.JSONObjectWithData(dataJson!, options: NSJSONReadingOptions.AllowFragments, error: nil) as! NSDictionary
        
        var links:NSArray = dictionary["results"] as! NSArray
        
        if objects == nil{
            objects = NSMutableArray()
        }
        objects.removeAllObjects()
        
        for dic in links{
            
            //println(dic)
            var app:appItem! = appItem()
            app.screenshotUrls = dic["screenshotUrls"] as! NSArray
            app.artworkUrl60 = dic["artworkUrl60"] as! NSString
            app.ipadScreenshotUrls = dic["ipadScreenshotUrls"] as! NSArray
            app.features = dic["features"] as! NSArray
            app.supportedDevices = dic["supportedDevices"] as! NSArray
            app.trackCensoredName = dic["trackCensoredName"] as! NSString
            app.languageCodesISO2A = dic["languageCodesISO2A"] as! NSArray
            app.contentAdvisoryRating = dic["contentAdvisoryRating"] as! NSString
            
            if dic["averageUserRating"] != nil{
                 println(dic["averageUserRating"])
                app.averageUserRating = dic["averageUserRating"] as? Double
            }
            else{
                app.averageUserRating = 0.0
            }
            
            app.trackViewUrl = dic["trackViewUrl"] as! NSString
            app.currency = dic["currency"] as! NSString
            app.price = dic["price"] as! Double
            app.version = dic["version"] as! NSString
            app.objDescription = dic["description"] as! NSString
            app.minimumOsVersion = dic["minimumOsVersion"] as! NSString
            app.trackId = dic["trackId"] as! NSNumber
            
            objects.addObject(app)
            
        }
        let array = objects as NSArray
     
       return array
    }
    
   
}

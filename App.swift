//
//  App.swift
//  musicStoreFront
//
//  Created by Yifan Xiao on 5/4/15.
//  Copyright (c) 2015 Yifan Xiao. All rights reserved.
//

import Foundation
import CoreData

class App: NSManagedObject {

    @NSManaged var appIcon: NSData
    @NSManaged var artworkUrl60: String
    @NSManaged var averageUserRating: NSNumber
    @NSManaged var contentAdvisoryRating: String
    @NSManaged var currency: String
    @NSManaged var features: AnyObject
    @NSManaged var ipadScreenshotUrls: AnyObject
    @NSManaged var keywords: String
    @NSManaged var languageCodesISO2A: AnyObject
    @NSManaged var minimumOsVersion: String
    @NSManaged var objDescription: String
    @NSManaged var price: NSNumber
    @NSManaged var screenshotUrls: AnyObject
    @NSManaged var supportedDevices: AnyObject
    @NSManaged var trackCensoredName: String
    @NSManaged var trackViewUrl: String
    @NSManaged var version: String

}

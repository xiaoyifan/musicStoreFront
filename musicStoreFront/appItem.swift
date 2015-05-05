//
//  appItem.swift
//  musicStore
//
//  Created by Yifan Xiao on 4/21/15.
//  Copyright (c) 2015 Yifan Xiao. All rights reserved.
//
import Foundation

public class appItem {
    
    public var appIcon:NSData?
    public var artworkUrl60:NSString?
    public var averageUserRating: Double?
    public var contentAdvisoryRating:NSString?
    public var screenshotUrls:NSArray?
    public var ipadScreenshotUrls:NSArray?
    public var features:NSArray?
    public var supportedDevices:NSArray?
    public var trackCensoredName:NSString?
    public var languageCodesISO2A:NSArray?
    public var trackViewUrl:NSString?
    public var currency:NSString?
    public var price:Double?
    public var version:NSString?
    public var objDescription:NSString?
    public var minimumOsVersion:NSString?
    public var keywords:NSString?
    
    public init() { }
}

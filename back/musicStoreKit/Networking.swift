//
//  Networking.swift
//  musicStore
//
//  Created by Yifan Xiao on 4/21/15.
//  Copyright (c) 2015 Yifan Xiao. All rights reserved.
//

import UIKit

public class Networking {
    
    public static let sharedInstance = Networking()
    
    // MARK: - Initilization
    public init() {
        println("Singleton is being initialized");
    }
    
    // MARK: - Request
    /**
    Creates a request for the specified method, URL string, parameters, and parameter encoding.
    
    :param: method The HTTP method.
    :param: URLString The URL string.
    :param: parameters The parameters. `nil` by default.
    :param: encoding The parameter encoding. `.URL` by default.
    
    :returns: The created request.
    */
  public func get(request: NSURLRequest!, callback: (String, String?) -> Void) {
        
        var session = NSURLSession.sharedSession()
        var task = session.dataTaskWithRequest(request){
            (data, response, error) -> Void in
            if error != nil {
                callback("", error.localizedDescription)
            } else {
                var result = NSString(data: data, encoding: NSASCIIStringEncoding)!
                callback(result as String, nil)
            }
        }
        task.resume()
    }
    
    public func getData(request: NSURLRequest!, callback: (NSData?, String?) -> Void) {
        
        var session = NSURLSession.sharedSession()
        var task = session.dataTaskWithRequest(request){
            (data, response, error) -> Void in
            if error != nil {
                callback(nil, error.localizedDescription)
            } else {
                
                callback(data, nil)
            }
        }
        task.resume()
    }
}
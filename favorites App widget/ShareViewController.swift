//
//  ShareViewController.swift
//  FavoriteExtension
//
//  Created by T. Andrew Binkowski on 4/21/15.
//  Copyright (c) 2015 The University of Chicago. All rights reserved.
//

import UIKit
import Social
import MobileCoreServices
import Parse

class ShareViewController: SLComposeServiceViewController {
    
    var imageToShare: UIImage?
    var urlToShare: String?
    var textToShare: String?
    
    override func presentationAnimationDidFinish() {
        
//        Parse.enableLocalDatastore()
        
        // Initialize Parse.
        Parse.setApplicationId("6Xl1i1oRMRYb8mwRSA4COu3dRBelJz0iHUM36msm",
            clientKey: "aKuIG9No5cU9bPG2NqZ7OVW04ogsKSbGMR7EiMk8")
        
        let items = extensionContext?.inputItems
        var itemProvider: NSItemProvider?
        
        // Exit early if there are no items
        if items == nil && items!.isEmpty != false { return }
        let item = items![0] as! NSExtensionItem
        println("Attachment items: \(items)")
        
        // Loop through all the attachment items and store their values in properties
        // Note: The App Store makes three attachements available: image, plain-text, and url
        if let attachments = item.attachments {
            
            for attachment in attachments {
                itemProvider = attachment as? NSItemProvider
                
                // Get text
                //let urlType = kUTTypePlainText as NSString  as String
                if itemProvider?.hasItemConformingToTypeIdentifier("public.plain-text") == true {
                    itemProvider?.loadItemForTypeIdentifier("public.plain-text", options: nil) { (item, error) -> Void in
                        if error == nil {
                            if let text = item as? String {
                                self.textToShare = text
                            }
                        }
                    }
                }
                
                // Get URL
                //let urlType = kUTTypeURL as NSString  as String
                if itemProvider?.hasItemConformingToTypeIdentifier("public.url") == true {
                    itemProvider?.loadItemForTypeIdentifier("public.url", options: nil) { (item, error) -> Void in
                        if error == nil {
                            if let url = item as? NSURL {
                                self.urlToShare = url.absoluteString!
                            }
                        }
                    }
                    
                }
                
                // Get image
                // let imageType = kUTTypeImage as NSString as String
                if itemProvider?.hasItemConformingToTypeIdentifier("public.image") == true {
                    itemProvider?.loadItemForTypeIdentifier("public.image", options: nil) { (item, error) -> Void in
                        if error == nil {
                            println("Item: \(item)")
                            if let image = item as? UIImage {
                                self.imageToShare = image
                            }
                        }
                    }
                }
                
            }
        }
        
    }
    
    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }
    override func didSelectPost() {
        
        let imageData: NSData? = UIImagePNGRepresentation(imageToShare!)
        
        
//        let sharedItem: NSDictionary = [ "date": NSDate(),
//            "contentText": textToShare!,
//            "imageData": imageData!,
//            "url": urlToShare!
//        ]
//        println(sharedItem)
        
        var musicApp = PFObject(className: "WishList")
        
        musicApp["appIcon"] = imageData
        musicApp["trackCensoredName"] = textToShare
        musicApp["trackViewUrl"] = urlToShare
        
        musicApp.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (!success) {
                println(error?.description)
            }
            
        }
        
        // Inform the host that we're done, so it un-blocks its UI.
        // Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
        self.extensionContext!.completeRequestReturningItems([], completionHandler: nil)
    }
    
    override func configurationItems() -> [AnyObject]! {
        // To add configuration options via table cells at the bottom of the sheet,
        // return an array of SLComposeSheetConfigurationItem here.
        return []
    }
}

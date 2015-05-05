//
//  seachViewController.swift
//  musicStoreFront
//
//  Created by Yifan Xiao on 5/4/15.
//  Copyright (c) 2015 Yifan Xiao. All rights reserved.
//

import UIKit
import CoreData

class seachViewController: UIViewController {

    
    var results = [NSManagedObject]()
    
    @IBOutlet weak var searchTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    @IBAction func submitButtonPressed(sender: UIButton) {
        
//        NSSet* wordsInString = [NSSet setWithArray:[myString componentsSeparatedByString:@" "]];
//        NSPredicate* pred = [NSPredicate predicateWithFormat:@"SELF.text IN %@", wordsInString];
        
        let textField:NSString = self.searchTextField.text
        let keyArray = textField.componentsSeparatedByString(" ")
        
        let set = NSSet(array: keyArray)
        
        let searchPredicate: NSPredicate = NSPredicate(format: "keywords contains %@",textField)
        
        var appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        
        var request = NSFetchRequest(entityName: "App")
        request.returnsObjectsAsFaults = false;
        request.predicate = searchPredicate
        
        var errorFet:NSError?
        
        let searchResults = context.executeFetchRequest(request, error: &errorFet) as? [NSManagedObject]
        
        if let res = searchResults {
            self.results = res
        }
        
        println(self.results.count)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let controller:UINavigationController = storyboard.instantiateViewControllerWithIdentifier("searchNavigationVC") as! UINavigationController
        
        let vc:searchCollectionViewController = controller.topViewController as! searchCollectionViewController
        vc.results = self.results
        vc.title = "results for: \(textField)"
        self.presentViewController(controller, animated: true, completion: nil)
        
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

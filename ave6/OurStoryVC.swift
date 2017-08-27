//
//  OurStoryVC.swift
//  ave6
//
//  Created by Alex Beattie on 8/26/17.
//  Copyright © 2017 Artisan Branding. All rights reserved.
//

import UIKit
import Parse

class OurStoryVC: UIViewController, UIScrollViewDelegate {

    var propObj = PFObject(className: "ourStory")
    var myArray:[PFObject] = []

    @IBOutlet weak var containerScrollView: UIScrollView!
    @IBOutlet weak var descriptionTxt: UITextView!
    @IBOutlet weak var image:UIImageView!

    @IBOutlet weak var theNameLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDetails()
        
        
    }

    func getDetails() {
//        if let theName = propObj["about"] as? String {
//            self.descriptionTxt.text = theName
//            print(theName)
//        }
//        let query = PFQuery(className: "ourStory")
//        query.findObjectsInBackground { (objects, error) -> Void in
//            if error == nil {
//                if let objects = objects {
//                    for object in objects  {
//                        self.myArray.append(object)
//                        print(objects)
//                    }
//                    //                    self.ourStoryTableView.reloadData()
//                }
//            }
//        }
        
        
        let query = PFQuery(className: "ourStory")
        query.getFirstObjectInBackground { (objects, error) -> Void in
            if error == nil {
                if let objects = objects {
                        print(objects)
                    }
                    //                    self.ourStoryTableView.reloadData()
               
            }
        }
        
        
        
        
        
        if propObj["theTitle"] != nil { theNameLbl.text = "\(propObj["theTitle"]!)"
        } else { theNameLbl.text = "N/A" }
        if propObj["about"] != nil { theNameLbl.text = "\(propObj["about"]!)"
        } else { descriptionTxt.text = "N/A" }
        
//        descriptionTxt.text = propObj["about"] as? String
//        theNameLbl.text = propObj["theTitle"] as? String
        DispatchQueue.main.async(execute: { () -> Void in
            
            let imageFile = self.propObj[PROP_IMAGE] as? PFFile
            imageFile?.getDataInBackground { (imageData, error) -> Void in
                if error == nil {
                    if let imageData = imageData {
                        self.image.image = UIImage(data: imageData)
                    }
                    //cell.activityIndicator.stopAnimating()
                }
            }
        })

    }
   

}

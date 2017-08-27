//
//  OurStory.swift
//  ave6
//
//  Created by Alex Beattie on 8/27/17.
//  Copyright © 2017 Artisan Branding. All rights reserved.
//

import UIKit
import Parse

class OurStory: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate{

    @IBOutlet weak var tableView:UITableView!
//    var headerView: UIView!
    
    var propObj = PFObject(className: "ourStory")
    var bioStuff:[PFObject] = []
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        //        tableView.estimatedRowHeight = 140
        //
        queryForTable()
        tableView.reloadData()
        
    }
    

    
   
    func queryForTable() {
        let query = PFQuery(className: "ourStory")
        query.findObjectsInBackground { (objects, error) -> Void in
            if error == nil {
                if let objects = objects {
                    for object in objects  {
                        self.bioStuff.append(object)
                        //                        print(objects)
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    
    //    get image
    //    let leftIconView = UIImageView()
    //    leftIconView.contentMode = .scaleAspectFill
    //
    //    if let thumbImage = self.propObj["imageFile"] as? PFFile {
    //        thumbImage.getDataInBackground() { (imageData, error) -> Void in
    //            if error == nil {
    //                if let imageData = imageData {
    //                    leftIconView.image = UIImage(data:imageData)
    //                }
    //            }
    //        }
    //    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bioStuff.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Our Story", for: indexPath) as? OurStoryCell else {  return UITableViewCell() }
        
        var propObj = PFObject(className: "ourStory")
        propObj = bioStuff[indexPath.row]
        
        
        cell.bioDescLbl?.text = propObj["about"] as? String
        if let eachName = propObj["theTitle"] as? String {
            cell.theName?.text = eachName
            
        }
        
        return cell
    }
    
}


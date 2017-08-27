//
//  OurStoryVC.swift
//  ave6
//
//  Created by Alex Beattie on 8/26/17.
//  Copyright © 2017 Artisan Branding. All rights reserved.
//

import UIKit
import Parse

class OurStoryVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var propObj = PFObject(className: "ourStory")

    var myArray: [PFObject] = []
    
    @IBOutlet weak var ourStoryTableView: UITableView!
    
    
    
    func queryForTable() {
        let query = PFQuery(className: "ourStory")
        //        query.cachePolicy = .networkElseCache
        query.findObjectsInBackground { (objects, error) -> Void in
            if error == nil {
                if let objects = objects {
                    for object in objects  {
                        self.myArray.append(object)
                        
                        print(objects)
                    }
                    self.ourStoryTableView.reloadData()
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       
        ourStoryTableView.rowHeight = UITableViewAutomaticDimension
        ourStoryTableView.rowHeight = 250
        ourStoryTableView.delegate = self
        ourStoryTableView.dataSource = self
        queryForTable()

    }


    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OurStory", for: indexPath) as? OurStoryCell else { return UITableViewCell() }

   
        
        var ourStoryClass = PFObject(className: "ourStory")
        ourStoryClass = myArray[indexPath.row]
        
        if let theName = ourStoryClass["aboutText"] as? String {
            cell.aboutTxtLbl.text = theName
        }
        
        if let thePrice = ourStoryClass["aboutDetailTxt"] as? String {
            cell.aboutDetailLbl.text = thePrice
        }
     
        return cell
    }
}



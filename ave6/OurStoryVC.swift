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


    @IBOutlet weak var ourStoryTableView: UITableView!
    var propObj = PFObject(className: "ourStory")
    var myArray:[PFObject] = []
    
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
       
        
        ourStoryTableView.estimatedRowHeight = 85.0
        ourStoryTableView.rowHeight = UITableViewAutomaticDimension
        
        ourStoryTableView.delegate = self
        ourStoryTableView.dataSource = self
        queryForTable()

    }


    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OurStory", for: indexPath) as? OurStoryCell else { return UITableViewCell() }

   
        DispatchQueue.main.async {
            var ourStoryClass = PFObject(className: "ourStory")
            ourStoryClass = self.myArray[indexPath.row]
            
//            if let theName = ourStoryClass["aboutText"] as? String {
//                cell.aboutTxtLbl.text = theName
//            }
            cell.aboutDetailLbl.text = ourStoryClass["about"] as? String
            
//
//            if let thePrice =  {
//            }
        }
     
        
        return cell
    }
}

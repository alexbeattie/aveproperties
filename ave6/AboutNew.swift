//
//  AboutNew.swift
//  ave6
//
//  Created by Alex Beattie on 8/22/17.
//  Copyright © 2017 Artisan Branding. All rights reserved.
//

import UIKit
import Parse

class AboutNew: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {

    
    
    @IBOutlet weak var tableView:UITableView!
    private let kTableHeaderHeight: CGFloat = 300.0
    var headerView: UIView!
    
    var propObj = PFObject(className: "Bio")
    var bioStuff:[PFObject] = []
    override func viewDidLoad() {
        
      
        super.viewDidLoad()
        
        headerView = tableView.tableHeaderView
        tableView.tableHeaderView = nil
        tableView.addSubview(headerView)
        
        tableView.contentInset = UIEdgeInsets(top: kTableHeaderHeight, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -kTableHeaderHeight)
        updateHeaderView()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
//        tableView.estimatedRowHeight = 140
//
        queryForTable()
        tableView.reloadData()
        
    }

    func updateHeaderView() {
        
        var headerRect = CGRect(x: 0, y: -kTableHeaderHeight, width: tableView.bounds.width, height: kTableHeaderHeight)
        if tableView.contentOffset.y < -kTableHeaderHeight {
            headerRect.origin.y = tableView.contentOffset.y
            headerRect.size.height = -tableView.contentOffset.y
        }
        headerView.frame = headerRect
        
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateHeaderView()
    }
    func queryForTable() {
    let query = PFQuery(className: "Bio")
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
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "About Description", for: indexPath) as? AboutCell else {  return UITableViewCell() }
        
        var propObj = PFObject(className: "Bio")
        propObj = bioStuff[indexPath.row]
        
       
        cell.bioDescLbl?.text = propObj["bio"] as? String
        if let eachName = propObj["name"] as? String {
            cell.theName?.text = eachName
            
        }

        return cell
    }

}

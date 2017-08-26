//
//  ListingsTVC.swift
//  ave6
//
//  Created by Alex Beattie on 8/25/17.
//  Copyright © 2017 Artisan Branding. All rights reserved.
//

import UIKit
import Parse

class ListingsTVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    
    @IBOutlet var listingTableView: UITableView!
    
    var propObj = PFObject(className: "allListings")
    var myArray:[PFObject] = []

    
    func queryForTable() {
        let query = PFQuery(className: "allListings")
        query.order(byDescending: "price")
        query.cachePolicy = .networkElseCache
        query.findObjectsInBackground { (objects, error) -> Void in
            if error == nil {
                if let objects = objects {
                    for object in objects  {
                        self.myArray.append(object)
                        //                        print(objects)
                    }
                    self.listingTableView.reloadData()
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listingTableView.delegate = self
        listingTableView.dataSource = self
        
        queryForTable()
    }

  

    // MARK: - Table view data source

 
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return myArray.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "listingCell", for: indexPath) as? ListingsCell else { return UITableViewCell() }
        
        
        var listingClass = PFObject(className: "allListings")
        listingClass = myArray[indexPath.row]
       
        if let theName = listingClass["name"] as? String {
            cell.nameLbl.text = theName
        }
        
        if let thePrice = listingClass["cost"] as? String {
            cell.priceLbl.text = thePrice
        }

        DispatchQueue.main.async(execute: { () -> Void in

            let imageFile = listingClass[PROP_IMAGE] as? PFFile
            imageFile?.getDataInBackground { (imageData, error) -> Void in
                if error == nil {
                    if let imageData = imageData {
                        cell.listingImage.image = UIImage(data: imageData)
                    }
                    //cell.activityIndicator.stopAnimating()
                }
            }

        })

        return cell
    }
 

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        var listingClass = PFObject(className: "allListings")
        listingClass = myArray[indexPath.row]

        let pdVC =  storyboard!.instantiateViewController(withIdentifier: "PropertyDetails") as! NewDetailViewController
        pdVC.propObj = listingClass
        navigationController?.pushViewController(pdVC, animated: true)

        
    }

 
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 

}

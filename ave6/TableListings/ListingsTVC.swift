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
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
   
//    func startActivityIndicator() {
//
////        activityIndicator.center = self.view.center
//        activityIndicator.hidesWhenStopped = true
//        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
////        view.addSubview(activityIndicator)
//        activityIndicator.startAnimating()
//    }
    func stopActivityIndicator() {
        activityIndicator.stopAnimating()
    }
   
    
    func queryForTable() {
        let query = PFQuery(className: "allListings")
        query.order(byDescending: "price")
//        query.cachePolicy = .networkElseCache
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
        listingTableView.rowHeight = UITableViewAutomaticDimension
        listingTableView.rowHeight = 300
        listingTableView.backgroundColor = #colorLiteral(red: 0.3647058824, green: 0.3647058824, blue: 0.3647058824, alpha: 1)

        listingTableView.separatorColor = UIColor.clear

        queryForTable()
        
        
    }

  

    // MARK: - Table view data source

 
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return myArray.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "listingCell", for: indexPath) as? ListingsCell else { return UITableViewCell() }
        stopActivityIndicator()
        cell.listingImage.image = nil
        cell.backgroundColor = #colorLiteral(red: 0.2392156863, green: 0.7607843137, blue: 0.8196078431, alpha: 1)
        cell.layer.borderWidth = 2.0
        cell.layer.borderColor = #colorLiteral(red: 0.5137254902, green: 0.8470588235, blue: 0.8117647059, alpha: 1)

        var listingClass = PFObject(className: "allListings")
        listingClass = myArray[indexPath.row]
       
        if let theName = listingClass["name"] as? String {
            cell.nameLbl.text = theName
        }
        
        if let thePrice = listingClass["cost"] as? String {
            cell.priceLbl.text = thePrice
        }

        activityIndicator.startAnimating()

        
//        DispatchQueue.main.async(execute: { () -> Void in

            let imageFile = listingClass[PROP_IMAGE] as? PFFile
        imageFile?.getDataInBackground { (imageData, error) -> Void in
                if error == nil {
                    if let imageData = imageData {
//                        self.activityIndicator.stopAnimating()
//                        self.activityIndicator.removeFromSuperview()
                        cell.listingImage.image = UIImage(data: imageData)
                    }

                    
                }
            }

//        })
//        cell.backgroundColor = UIColor.white
//        cell.layer.borderColor = UIColor.black.cgColor
//        cell.layer.borderWidth = 1
//        cell.layer.cornerRadius = 8
//        cell.clipsToBounds = true

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

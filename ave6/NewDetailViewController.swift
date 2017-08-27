//
//  NewDetailViewController.swift
//  ave6
//
//  Created by Alex Beattie on 7/23/17.
//  Copyright © 2017 Artisan Branding. All rights reserved.
//

import UIKit
import Parse
import MapKit
import AVKit
import AVFoundation
import MessageUI
import SafariServices

class NewDetailViewController: UIViewController, MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate {
    @IBOutlet weak var playBtn: UIButton!

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var propName: UILabel!
    @IBOutlet weak var propPrice: UILabel!
    @IBOutlet var propImage: UIImageView!
    @IBOutlet weak var propDesc: UITextView!
    @IBOutlet var mapView: MKMapView!
 
    @IBOutlet weak var expandMapView: NSLayoutConstraint!
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    var propObj = PFObject(className: "allListings")
    var listingClass = PFObject(className: "allListings")
    var addressItems = PFGeoPoint()

    var annotation:MKAnnotation!
    var pointAnnotation:MKPointAnnotation!
    var pinView:MKPinAnnotationView!
    var region: MKCoordinateRegion!
    var mapType: MKMapType!

    var movieList:[PFObject] = []
    var player:AVPlayer!
    var playerLayer:AVPlayerLayer!
    
    @IBOutlet weak var expandCollapse: UIButton!
    @IBOutlet weak var mapHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var tableViewHeighConstraint: NSLayoutConstraint!
    
    
    @IBAction func expandMap(_ sender: Any) {
        
//        let expandCollapse = UIButton(type: .custom)
//        expandCollapse.setImage(UIImage(named:"icons8-expand"), for: .normal)
        
        
        if (mapHeightConstraint.constant == 210) {
        mapHeightConstraint.constant = 600
        tableViewHeighConstraint.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
//            self.expandCollapse.setImage(UIImage(named:"collapse"), for: .selected)

        }
        } else {
            mapHeightConstraint.constant = 210
            tableViewHeighConstraint.constant = 300
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()

            }
          
        
        }
        
        
        
    }
    
    
    
    
//    @IBAction func animateDwon(_ sender: Any) {
//        expandMapView.constant = 0
//        UIView.animate(withDuration: 0.3) {
//            self.view.layoutIfNeeded()
//        }
//    }
    
    @IBAction func playBtn(_ sender: Any) {

        print("button tapped")
                        playVideo()
    }
    func startActivityIndicator() {
        
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    func stopActivityIndicator() {
        activityIndicator.stopAnimating()
    }
    func playVideo() {
   
        startActivityIndicator()
        var videoUrl:String? = self.propObj["movieFile"] as? String
        let query = PFQuery(className: "allListings")
        query.findObjectsInBackground { (object, error) in
            if (error == nil && object != nil) {
                if let video = self.propObj["moviefile"] as? String {
                     let videoFile = video
                     videoUrl = videoFile
                }
            }
            self.setupVideoPlayerWithURL(url: NSURL(string: videoUrl!)!)
        }
    }
 
    func setupVideoPlayerWithURL(url:NSURL) {
        let player = AVPlayer(url: url as URL)
        let playerController = AVPlayerViewController()
        
        playerController.player = player
        present(playerController, animated: true) {
            player.play()
            self.stopActivityIndicator()
        }
    }

    @IBAction func share(_ sender: Any) {

        let textToShare = propObj["name"]! as! String
        guard let site = NSURL(string: propObj["url"]! as! String) else { return }
        let objectsToShare = [textToShare, site] as [Any]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = sender as? UIView
        activityVC.popoverPresentationController?.barButtonItem = (sender as! UIBarButtonItem)
        self.present(activityVC, animated: true, completion: nil)
        
    }
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let origImage = UIImage(named: "icons8-expand")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        expandCollapse.setImage(tintedImage, for: .normal)
        expandCollapse.tintColor = #colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1)
        
      

    

        tableView.delegate = self
        tableView.dataSource = self
        
        if mapView.annotations.count != 0 {
            annotation = mapView.annotations[0]
            mapView.removeAnnotation(annotation)
            
        }
        self.mapView.delegate = self
        
        let addressItems = PFGeoPoint(latitude: (propObj["addressItems"] as AnyObject).latitude, longitude: (propObj["addressItems"] as AnyObject).longitude)
        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake((propObj["addressItems"] as AnyObject).latitude, (propObj["addressItems"] as AnyObject).longitude)
        mapView.region = MKCoordinateRegionMakeWithDistance(
            CLLocationCoordinate2DMake(addressItems.latitude, addressItems.longitude), 27500, 27500);
        
        mapView.setRegion(mapView.region, animated: true)
        
      
        if let theLocation = propObj["addressItems"] as? PFGeoPoint {
            CLLocationCoordinate2DMake(addressItems.latitude, addressItems.longitude)
            print(theLocation.latitude, theLocation.longitude)
        }
        let newAnnotation = MKPointAnnotation()
        newAnnotation.coordinate = location
        newAnnotation.title = propObj["name"] as? String
        newAnnotation.subtitle = propObj["cost"] as? String
        mapView.addAnnotation(newAnnotation)
        mapView.selectAnnotation(newAnnotation, animated: true)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        


    }
 
    override func viewWillAppear(_ animated: Bool) {
        print("Im in View Will Appear")
        super.viewWillAppear(animated)
        self.title = propObj["name"] as? String
        
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        stopActivityIndicator()
        self.navigationController?.setToolbarHidden(false, animated: true)
        self.navigationController?.toolbar.isTranslucent = true

     
        
//        calcBtn.addTarget(self, action: #selector(MainVC.calculate), for: .touchUpInside)


    }
    
  
    // start tableview
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DescriptionCell", for: indexPath) as? DescriptionCell else { return UITableViewCell() }
        
        if let theName = propObj["name"] {
            cell.propName.text = theName as? String
        }
        
        if let theCost = propObj["cost"] as? String {
            cell.propCost.text = theCost
        }
        
        if let theDesc = propObj["listingDescription"] {
            cell.propDesc.text = theDesc as? String
        }

        
        return cell
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let annoView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "Default")
        annoView.pinTintColor = #colorLiteral(red: 0.5137254902, green: 0.8470588235, blue: 0.8117647059, alpha: 1)
        annoView.animatesDrop = true
        annoView.canShowCallout = true
        let swiftColor = #colorLiteral(red: 0.5137254902, green: 0.8470588235, blue: 0.8117647059, alpha: 1)
        annoView.centerOffset = CGPoint(x: 100, y: 400)
        annoView.pinTintColor = swiftColor
        
        // Add a RIGHT CALLOUT Accessory
        let rightButton = UIButton(type: UIButtonType.detailDisclosure)
        rightButton.frame = CGRect(x:0, y:0, width:32, height:32)
        rightButton.layer.cornerRadius = rightButton.bounds.size.width/2
        rightButton.clipsToBounds = true
        rightButton.tintColor = #colorLiteral(red: 0.5137254902, green: 0.8470588235, blue: 0.8117647059, alpha: 1)
        
        annoView.rightCalloutAccessoryView = rightButton
        
        
        let leftIconView = UIImageView()
        leftIconView.contentMode = .scaleAspectFill
        if let thumbImage = propObj["imageFile"] as? PFFile {
            thumbImage.getDataInBackground() { (imageData, error) -> Void in
                if error == nil {
                    if let imageData = imageData {
                        leftIconView.image = UIImage(data:imageData)


                    }
                }
            }
        }
        let newBounds = CGRect(x:0.0, y:0.0, width:54.0, height:54.0)
        leftIconView.bounds = newBounds
        annoView.leftCalloutAccessoryView = leftIconView
        
        
        return annoView
        
    }
    
    func goOutToGetMap() {
        let addressItems = PFGeoPoint(latitude: (self.propObj["addressItems"] as AnyObject).latitude, longitude: (self.propObj["addressItems"] as AnyObject).longitude)
        if let theLocation = self.propObj["addressItems"] as? PFGeoPoint {
            CLLocationCoordinate2DMake(addressItems.latitude, addressItems.longitude)
            print(theLocation)
        }
        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake((self.propObj["addressItems"] as AnyObject).latitude, (self.propObj["addressItems"] as AnyObject).longitude)
        
        let placemark = MKPlacemark(coordinate: location, addressDictionary: nil)
        
        let item = MKMapItem(placemark: placemark)
        item.name = self.propObj["name"] as? String
        item.openInMaps (launchOptions: [MKLaunchOptionsMapTypeKey: 2,
                                           MKLaunchOptionsMapCenterKey:NSValue(mkCoordinate: placemark.coordinate),
                                           MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving])
        
        
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        
            let alertController = UIAlertController(title: nil, message: "Driving directions", preferredStyle: .actionSheet)
            let OKAction = UIAlertAction(title: "Get Directions", style: .default) { (action) in
                self.goOutToGetMap()
            }
            alertController.addAction(OKAction)
        
            present(alertController, animated: true) {
                
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                
            }
            alertController.addAction(cancelAction)
        }
    

    @IBAction func mailButt(sender: AnyObject) {
        //        let listingClass = PFObject(className: "Recipe")
        _ = sender as! UIBarButtonItem
        
        let mailComposer = MFMailComposeViewController()

        
        
        mailComposer.mailComposeDelegate = self
        mailComposer.setToRecipients(["artisanb@me.com"])
        mailComposer.setSubject("[iPhone App Contact] Interested in \(title!)")
        mailComposer.setMessageBody("Hello,<br>I saw <strong>\(propObj["name"]!)</strong> and would like some more information about this property<br>Thanks,<br>Regards", isHTML: true)
        
        if MFMailComposeViewController.canSendMail() {
            present(mailComposer, animated: true, completion: nil)
        } else {
            
            let alertController = UIAlertController(title: "Li Read Group", message: "Your device cannot send emails. Please configure an email address into Settings -> Mail, Contacts, Calendars.", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
   
        }
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    

    @IBAction func gotToAllMap(_ sender: Any) {
        performSegue(withIdentifier: "toAllListingsMapVC", sender: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        startActivityIndicator()
    }
    
 
    
    
    
    // Goto weblink
    @IBOutlet weak var goToLinkNow: UIButton!
    @IBOutlet weak var webLinkBtn: UIBarButtonItem!
    @IBAction func goToWebLink(_ sender: UIBarButtonItem) {
        if let videoURL = propObj["url"] as? String {
            if let newVideoUrl = URL(string: videoURL) {

                let safariVC = SFSafariViewController(url: newVideoUrl)
                present(safariVC, animated: true, completion: nil)
            }
        }
    }
    

    
    

    

}

//
//  ListingsCell.swift
//  ave6
//
//  Created by Alex Beattie on 8/25/17.
//  Copyright © 2017 Artisan Branding. All rights reserved.
//

import UIKit
import Parse

class ListingsCell: UITableViewCell {

    @IBOutlet var nameLbl:UILabel!
    @IBOutlet var priceLbl:UILabel!
    

    
    @IBOutlet weak var listingImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

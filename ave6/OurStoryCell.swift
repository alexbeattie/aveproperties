//
//  OurStoryCell.swift
//  ave6
//
//  Created by Alex Beattie on 8/26/17.
//  Copyright © 2017 Artisan Branding. All rights reserved.
//

import UIKit

class OurStoryCell: UITableViewCell {

    @IBOutlet weak var aboutTxtLbl: UILabel!
    @IBOutlet weak var aboutDetailLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

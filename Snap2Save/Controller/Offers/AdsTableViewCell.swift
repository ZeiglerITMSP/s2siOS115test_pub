//
//  AdsTableViewCell.swift
//  Snap2Save
//
//  Created by Appit on 4/17/17.
//  Copyright © 2017 Appit. All rights reserved.
//

import UIKit

class AdsTableViewCell: UITableViewCell {

    
    @IBOutlet weak var adImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

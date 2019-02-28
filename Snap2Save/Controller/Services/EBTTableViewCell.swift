//
//  EBTTableViewCell.swift
//  Snap2Save
//
//  Created by Malathi on 14/04/17.
//  Copyright © 2017 Appit. All rights reserved.
//

import UIKit

class EBTTableViewCell: UITableViewCell {

    @IBOutlet var ebtLabel: UILabel!
    
    @IBOutlet var ebtActivityIndicator: UIActivityIndicatorView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        isHidden = true;
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

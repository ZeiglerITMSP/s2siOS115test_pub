//
//  DefaultMessageTableViewCell.swift
//  Snap2Save
//
//  Created by Malathi on 02/03/17.
//  Copyright © 2017 Appit. All rights reserved.
//

import UIKit

class DefaultMessageTableViewCell: UITableViewCell {

    @IBOutlet var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

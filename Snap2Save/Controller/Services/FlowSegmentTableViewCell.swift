//
//  FlowSegmentTableViewCell.swift
//  Snap2Save
//
//  Created by Malathi on 14/04/17.
//  Copyright © 2017 Appit. All rights reserved.
//

import UIKit

class FlowSegmentTableViewCell: UITableViewCell {

    @IBOutlet var flowSegmentControl: UISegmentedControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

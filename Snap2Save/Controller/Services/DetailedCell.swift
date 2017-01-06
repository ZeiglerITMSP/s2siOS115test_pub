//
//  DetailedCell.swift
//  Snap2Save
//
//  Created by Appit on 1/2/17.
//  Copyright © 2017 Appit. All rights reserved.
//

import UIKit

class DetailedCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var detailLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.separatorInset = UIEdgeInsets(top: 0, left: 10000, bottom: 0, right: 0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

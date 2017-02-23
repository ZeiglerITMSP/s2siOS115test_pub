//
//  RecentActivityHeader.swift
//  Snap2Save
//
//  Created by Appit on 2/22/17.
//  Copyright © 2017 Appit. All rights reserved.
//

import UIKit


protocol RecentActivityHeaderDelegate {
    
    func handleFilter()
}

class RecentActivityHeader: UITableViewCell {

    // Properties
    var delegate:RecentActivityHeaderDelegate?
    
    // Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var filterButton: UIButton!
    // Actions
    @IBAction func filterButtonAction(_ sender: UIButton) {
        
        delegate?.handleFilter()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

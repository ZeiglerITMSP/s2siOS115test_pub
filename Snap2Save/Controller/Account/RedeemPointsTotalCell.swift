//
//  RedeemPointsTotalCell.swift
//  Snap2Save
//
//  Created by Appit on 2/22/17.
//  Copyright © 2017 Appit. All rights reserved.
//

import UIKit

protocol RedeemPointsTotalDelegate {
    
    func handleRedeemPoints()
}

class RedeemPointsTotalCell: UITableViewCell {
    
    // Properties
    var delegate:RedeemPointsTotalDelegate?
    
    // Outlets
    @IBOutlet var currentPointTotalTitleLabel: UILabel!
    @IBOutlet var lifetimePointsEarnedTitleLabel: UILabel!
    @IBOutlet var lifetimePointsEarnedTitleValue: UILabel!
    @IBOutlet var currentPointTotalTitleValue: UILabel!
    @IBOutlet var redeemPointsButton: UIButton!
    
    // Actions
    @IBAction func redeemPointsButtonAction(_ sender: UIButton) {
        
        self.delegate?.handleRedeemPoints()
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

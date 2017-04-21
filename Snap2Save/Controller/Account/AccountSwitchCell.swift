//
//  AccountSwitchCell.swift
//  Snap2Save
//
//  Created by Appit on 4/20/17.
//  Copyright © 2017 Appit. All rights reserved.
//

import UIKit

protocol AccountSwitchCellDelegate {
    func didSwithStateChanged(isOn: Bool)
}

class AccountSwitchCell: UITableViewCell {

    // Properties
    var delegate: AccountSwitchCellDelegate?
    
    // Outlets
    @IBOutlet weak var myTitleLabel: UILabel!
    @IBOutlet weak var mySwitch: UISwitch!
    
    // Actions
    @IBAction func switchAction(_ sender: UISwitch) {
        delegate?.didSwithStateChanged(isOn: sender.isOn)
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

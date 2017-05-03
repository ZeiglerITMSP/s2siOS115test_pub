//
//  LoadMoreActivityTVC.swift
//  Snap2Save
//
//  Created by Appit on 5/1/17.
//  Copyright © 2017 Appit. All rights reserved.
//

import UIKit

class LoadMoreActivityTVC: UITableViewCell {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func startAnimiatingActivit() {
        
        activityIndicator.startAnimating()
    }

}

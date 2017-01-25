//
//  EBTChangeEmailTVC.swift
//  Snap2Save
//
//  Created by Appit on 1/25/17.
//  Copyright © 2017 Appit. All rights reserved.
//

import UIKit

class EBTChangeEmailTVC: UITableViewController {

    fileprivate enum ActionType {

    }
    
    // Properties
    let ebtWebView: EBTWebView = EBTWebView.shared
    fileprivate var actionType: ActionType?
    
    var pageTitle = "ebt.emailChange".localized()
    
    // Outlets
    @IBOutlet weak var currentEmailField: AIPlaceHolderTextField!
    @IBOutlet weak var emailField: AIPlaceHolderTextField!
    @IBOutlet weak var confirmEmailField: AIPlaceHolderTextField!
    @IBOutlet weak var changeEmailButton: UIButton!
    @IBOutlet weak var changeEmailActivityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var errorTitleLabel: UILabel!
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    // Actions
    @IBAction func changeEmailAction(_ sender: UIButton) {
        
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
   

}

//
//  EBTConfirmationTVC.swift
//  Snap2Save
//
//  Created by Appit on 12/22/16.
//  Copyright © 2016 Appit. All rights reserved.
//

import UIKit

class EBTConfirmationTVC: UITableViewController {

    
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var validationCodeField: AIPlaceHolderTextField!
    
    // Actions
    
    @IBAction func validateAction(_ sender: UIButton) {
        
        performSegue(withIdentifier: "EBTSecurityQuestionTVC", sender: nil)
    }
    
    
    @IBAction func resendAction(_ sender: Any) {
    }
    
    @IBAction func changeEmailAction(_ sender: UIButton) {
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateBackButtonText()
        
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

//
//  EBTSecurityQuestionTVC.swift
//  Snap2Save
//
//  Created by Appit on 12/22/16.
//  Copyright © 2016 Appit. All rights reserved.
//

import UIKit

class EBTSecurityQuestionTVC: UITableViewController {

    // Ouetles
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var securityQuestionField: AIPlaceHolderTextField!
    
    @IBOutlet weak var securityAnswerField: AIPlaceHolderTextField!
    
    // Actions
    
    @IBAction func confirmAction(_ sender: UIButton) {
        
       // performSegue(withIdentifier: "EBTDateOfBirthTVC", sender: nil)
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        
        
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
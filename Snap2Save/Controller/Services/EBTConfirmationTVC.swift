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

        // Back Action
        self.navigationItem.addBackButton(withTarge: self, action: #selector(backAction))
        
        // Automatic height
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func backAction() {
        
        showAlert(title: "Are you sure ?", message: "The process will be cancelled.", action: #selector(cancelProcess))
    }
    
    func cancelProcess() {
        
        // Define identifier
        let notificationName = Notification.Name("POPTOLOGIN")
        // Post notification
        NotificationCenter.default.post(name: notificationName, object: nil)
    }

    

}

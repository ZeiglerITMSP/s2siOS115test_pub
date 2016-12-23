//
//  EBTSelectPinTVC.swift
//  Snap2Save
//
//  Created by Appit on 12/22/16.
//  Copyright © 2016 Appit. All rights reserved.
//

import UIKit

class EBTSelectPinTVC: UITableViewController {

    
    // Outlets
    
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var pinField: AIPlaceHolderTextField!
    
    
    @IBOutlet weak var confirmPinField: AIPlaceHolderTextField!
    
    @IBAction func nextAction(_ sender: UIButton) {
        
        performSegue(withIdentifier: "EBTUserInformationTVC", sender: nil)
    }
    
    @IBAction func useCurrentPinAction(_ sender: UIButton) {
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Back Action
        self.navigationItem.addBackButton(withTarge: self, action: #selector(backAction))
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func backAction() {
        
        showAlert(title: "Are you sure ?", message: "The registration process will be cancelled.", action: #selector(cancelProcess))
    }
    
    func cancelProcess() {
        
        // Define identifier
        let notificationName = Notification.Name("POPTOLOGIN")
        // Post notification
        NotificationCenter.default.post(name: notificationName, object: nil)
    }

    

}

//
//  EBTDateOfBirthTVC.swift
//  Snap2Save
//
//  Created by Appit on 12/22/16.
//  Copyright © 2016 Appit. All rights reserved.
//

import UIKit

class EBTDateOfBirthTVC: UITableViewController {

    
    // Outles
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var dobField: AIPlaceHolderTextField!
    
    @IBOutlet weak var socialSecurityNumberField: AIPlaceHolderTextField!
    
    
    @IBAction func nextAction(_ sender: UIButton) {
        
        performSegue(withIdentifier: "EBTSelectPinTVC", sender: nil)
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateBackButtonText()
        
        self.dobField.contentTextField.textFieldType = .DatePickerTextField
        self.dobField.contentTextField.dateFormatString = "mm/dd/yyyy"
        
        self.dobField.contentTextField.updateUIAsPerTextFieldType()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   
}




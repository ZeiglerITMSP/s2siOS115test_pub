//
//  EBTUserInformationTVC.swift
//  Snap2Save
//
//  Created by Appit on 12/22/16.
//  Copyright © 2016 Appit. All rights reserved.
//

import UIKit

class EBTUserInformationTVC: UITableViewController {

    // Outlets
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var userIdField: AIPlaceHolderTextField!
    
    
    @IBOutlet weak var passwordField: AIPlaceHolderTextField!
    
    @IBOutlet weak var ConfirmPasswordField: AIPlaceHolderTextField!
    
    @IBOutlet weak var emailAddressField: AIPlaceHolderTextField!
    
    @IBOutlet weak var confirmEmailField: AIPlaceHolderTextField!
    
    @IBOutlet weak var phoneNumberField: AIPlaceHolderTextField!
    
    
    @IBOutlet weak var questionOneField: AIPlaceHolderTextField!

    @IBOutlet weak var answerOneField: AIPlaceHolderTextField!
    
    
    @IBOutlet weak var questionTwoField: AIPlaceHolderTextField!
    
    @IBOutlet weak var answerTwoField: AIPlaceHolderTextField!
    
    @IBOutlet weak var questionThreeField: AIPlaceHolderTextField!
    
    @IBOutlet weak var answerThreeField: AIPlaceHolderTextField!
    
    // Actions
    
    @IBAction func nextAction(_ sender: UIButton) {
        
        performSegue(withIdentifier: "EBTConfirmationTVC", sender: nil)
    }
    @IBAction func cancelAction(_ sender: UIButton) {
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        updateBackButtonText()
        
        
        questionOneField.contentTextField.setRightGap(width: 10, placeHolderImage: UIImage(named:"ic_downarrow_input")!)
        questionOneField.contentTextField.textFieldType = .TextPickerTextField
        questionOneField.contentTextField.pickerViewArray = ["Curabitur blandit tempus porttitor.", "Aenean eu leo quam. Pellentesque ornare sem lacinia quam venenatis vestibulum.", "Etiam porta sem malesuada magna mollis euismod."]
        questionOneField.contentTextField.updateUIAsPerTextFieldType()
        
        
        questionTwoField.contentTextField.setRightGap(width: 10, placeHolderImage: UIImage(named:"ic_downarrow_input")!)
        questionTwoField.contentTextField.textFieldType = .TextPickerTextField
        questionTwoField.contentTextField.pickerViewArray = ["Curabitur blandit tempus porttitor.", "Aenean eu leo quam. Pellentesque ornare sem lacinia quam venenatis vestibulum.", "Etiam porta sem malesuada magna mollis euismod."]
        questionTwoField.contentTextField.updateUIAsPerTextFieldType()
        
        
        questionThreeField.contentTextField.setRightGap(width: 10, placeHolderImage: UIImage(named:"ic_downarrow_input")!)
        questionThreeField.contentTextField.textFieldType = .TextPickerTextField
        questionThreeField.contentTextField.pickerViewArray = ["Curabitur blandit tempus porttitor.", "Aenean eu leo quam. Pellentesque ornare sem lacinia quam venenatis vestibulum.", "Etiam porta sem malesuada magna mollis euismod."]
        questionThreeField.contentTextField.updateUIAsPerTextFieldType()
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}

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

        // Back Action
        self.navigationItem.addBackButton(withTarge: self, action: #selector(backAction))
        
        // info Button..
        userIdField.delegate = self
        passwordField.delegate = self
        userIdField.tag = 100
        passwordField.tag = 101
        
        
        // fill questions
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
        
        // Automatic height
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44
        
        
        
        
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

extension EBTUserInformationTVC: AIPlaceHolderTextFieldDelegate {
    
    
    func didTapOnInfoButton(textfield: AIPlaceHolderTextField) {
    
        if textfield.tag == 100 {
            // User ID
            showMyAlert(title: "User ID Rules:", message: "* Minimum of 6 and maximum of 15 long \n* Alphanumeric \n* Must include at least 1 number \n* Case insensitive * No special characters like @#$%^&*() \n* No spaces")
            
        } else if textfield.tag == 101 {
            // Password
            
            showMyAlert(title: "Password Rules:", message: "* Minimum of 8 and maximum of 10 long \n* Alphanumeric \n* Numeric Character (0-9): One character must be a number \n* Lower Case Character (a-z): One character must be lower case \n* Upper Case Character (A-Z): One character must be UPPER case \n* Case sensitive\n* No special characters like @#$%&()\n* No spaces\n* Cannot be same as any of last 6 passwords you have used\n* Maximum of 2 consecutive identical characters")
            
        }
        
    }
    
    
    func showMyAlert(title:String, message:String) {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.left
        
        let messageText = NSMutableAttributedString(
            string: message,
            attributes: [
                NSParagraphStyleAttributeName: paragraphStyle,
                NSFontAttributeName : UIFont.preferredFont(forTextStyle: UIFontTextStyle.body),
                NSForegroundColorAttributeName : UIColor.gray
            ]
        )
        
        let alertController = UIAlertController(title: title, message: "", preferredStyle: .alert)
        alertController.setValue(messageText, forKey: "attributedMessage")
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        DispatchQueue.main.async {
            
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    
}

//
//  LoginVC.swift
//  Snap2Save
//
//  Created by Appit on 12/19/16.
//  Copyright © 2016 Appit. All rights reserved.
//

import UIKit



class LoginVC: UIViewController {

    
    
    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var phoneNumberTextField: AITextField!
    
    
    @IBOutlet weak var emilPlaceholderLabel: UILabel!
    @IBOutlet weak var emailTextField: AITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        phoneNumberTextField.placeHolderLabel = placeholderLabel
        phoneNumberTextField.textFieldType = AITextField.AITextFieldType.PhoneNumberTextField
        phoneNumberTextField.createUnderline(withColor: .gray, padding: 0, height: 1)
     
        emailTextField.placeHolderLabel = emilPlaceholderLabel
        emailTextField.textFieldType = AITextField.AITextFieldType.EmailTextField
        emailTextField.createUnderline(withColor: .gray, padding: 0, height: 1)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

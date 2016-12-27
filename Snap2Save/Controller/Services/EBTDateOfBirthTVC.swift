//
//  EBTDateOfBirthTVC.swift
//  Snap2Save
//
//  Created by Appit on 12/22/16.
//  Copyright © 2016 Appit. All rights reserved.
//

import UIKit

class EBTDateOfBirthTVC: UITableViewController {

    // Properties
    let ebtWebView: EBTWebView = EBTWebView.shared
    
    
    // Outles
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dobField: AIPlaceHolderTextField!
    @IBOutlet weak var socialSecurityNumberField: AIPlaceHolderTextField!
    @IBOutlet weak var errorTitleLabel: UILabel!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var nextActivityIndicator: UIActivityIndicatorView!
    
    // Actions
    @IBAction func nextAction(_ sender: UIButton) {
        
        autoFill(dob: dobField.contentTextField.text!)
        
//        performSegue(withIdentifier: "EBTSelectPinTVC", sender: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Back Action
        self.navigationItem.addBackButton(withTarge: self, action: #selector(backAction))
        
        // Automatic height
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44
        
        // dob
        self.dobField.contentTextField.textFieldType = .DatePickerTextField
        self.dobField.contentTextField.dateFormatString = "mm/dd/yyyy"
        self.dobField.contentTextField.updateUIAsPerTextFieldType()
        
        ebtWebView.responder = self
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ebtWebView.responder = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        ebtWebView.responder = nil
        
        super.viewDidDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Table view
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 1 {
            if (errorMessageLabel.text == nil || errorMessageLabel.text == "") {
                return 0
            }
        }
        
        return UITableViewAutomaticDimension
    }

    
    // MARK: -
    func backAction() {

        showAlert(title: "Are you sure ?", message: "The registration process will be cancelled.", action: #selector(cancelProcess))
    }
    
    func cancelProcess() {
        
        // Define identifier
        let notificationName = Notification.Name("POPTOLOGIN")
        // Post notification
        NotificationCenter.default.post(name: notificationName, object: nil)
    }
    
    // MARK: - Web View
    
    
    // check status
    func validateSubmitAction() {
        
        let jsPageTitle = "$('.PageHeader').text();"
        ebtWebView.webView.evaluateJavaScript(jsPageTitle) { (result, error) in
            if error != nil {
                print(error ?? "error nil")
            } else {
                print(result!)
                let stringResult = result as! String
                let pageTitle = stringResult.trimmingCharacters(in: .whitespacesAndNewlines)
                print(pageTitle)
                
                if pageTitle == "We don’t recognize the computer you’re using." {
                    
                    //self.performSegue(withIdentifier: "EBTAuthenticationTVC", sender: nil)
                } else {
                    
                }
                
            }
        }
        
    }
    
    
    
    
    func autoFill(dob:String) {
        
        let jsDOB = "void($('#txtSecurityKeyQuestionAnswer').val('\(dob)'));"
        let jsForm = "void($('form')[1].submit());"
        
        let javaScript = jsDOB + jsForm
        
        ebtWebView.webView.evaluateJavaScript(javaScript) { (result, error) in
            if error != nil {
                print(error ?? "error nil")
                
            } else {
                print(result ?? "result nil")
                self.validateDOBError()
            }
        }
    }
    
    func validateDOBError() {
        
        let dobErrorCode = "$('.errorInvalidField').text();"
        
        ebtWebView.webView.evaluateJavaScript(dobErrorCode) { (result, error) in
            if error != nil {
                
                print(error ?? "error nil")
                
            } else {
                print(result ?? "result nil")
                let stringResult = result as! String
                let trimmed = stringResult.trimmingCharacters(in: .whitespacesAndNewlines)
                print(trimmed)
                if trimmed.characters.count > 0 {
                    // got error
                    
                    
                } else {
                    // success
                    self.performSegue(withIdentifier: "EBTSelectPinTVC", sender: nil)
                }
            }
        }
    }
    
    

}


extension EBTDateOfBirthTVC: EBTWebViewDelegate {
    
    func didFinishLoadingWebView() {
        
        validateDOBError()
    }
    
}



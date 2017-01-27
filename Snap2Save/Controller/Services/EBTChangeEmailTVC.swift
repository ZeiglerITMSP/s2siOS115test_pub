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
        case changeEmail
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
        self.view.endEditing(true)
        
        self.changeEmailButton.isEnabled = false
        self.changeEmailActivityIndicator.startAnimating()
        
        actionType = ActionType.changeEmail
        
        validatePage()

        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        currentEmailField.isUserInteractionEnabled = false
        emailField.contentTextField.keyboardType = .emailAddress
        confirmEmailField.contentTextField.keyboardType = .emailAddress
        emailField.contentTextField.returnKeyType = .next
        confirmEmailField.contentTextField.returnKeyType = .done
        
        emailField.contentTextField.aiDelegate = self
        confirmEmailField.contentTextField.aiDelegate = self
        
        emailField.contentTextField.updateUIAsPerTextFieldType()
        confirmEmailField.contentTextField.updateUIAsPerTextFieldType()
        
        // Back Action
        self.navigationItem.addBackButton(withTarge: self, action: #selector(backAction))
        
        // Automatic height
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44
        
        errorMessageLabel.text = nil
        ebtWebView.responder = self
        
        AppHelper.setRoundCornersToView(borderColor: APP_ORANGE_COLOR, view: changeEmailButton, radius: 2.0, width: 1.0)
        
        addTapGesture()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadContent()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        ebtWebView.responder = self
        
        let webView = ebtWebView.webView!
        self.view.addSubview(webView)
        
        self.view.sendSubview(toBack: webView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - To Hide Keyboard
    
    func addTapGesture() {
        
        // Tap Gesuture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnTableView(recognizer:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    func tapOnTableView(recognizer: UITapGestureRecognizer) {
        
        self.view.endEditing(true)
    }
    
    func reloadContent() {
        
        DispatchQueue.main.async {
            
            self.titleLabel.text = "ebt.changeEmail.titleLabel".localized()
            self.messageLabel.text = "ebt.changeEmail.messageLabel".localized()
            
            self.title = "ebt.title.register".localized()
            
            self.pageTitle = "ebt.emailChange".localized()
            self.currentEmailField.placeholderText = "CURRENT E-MAIL ADDRESS".localized()
            self.emailField.placeholderText = "E-MAIL ADDRESS".localized()
            self.confirmEmailField.placeholderText = "CONFIRM E-MAIL ADDRESS".localized()
            
            self.errorTitleLabel.text = ""
            
            self.changeEmailButton.setTitle("CHANGE EMAIL".localized(), for: .normal)
            
            self.tableView.reloadData()
        }
        
    }
    


    // MARK: - Table view
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 2 {
            if (errorMessageLabel.text == nil || errorMessageLabel.text == "") {
                return 0
            }
        }
        
        return UITableViewAutomaticDimension
    }
    
    // MARK: -
    
    func backAction() {
        
        showAlert(title: "Are you sure ?".localized(), message: "The process will be cancelled.".localized(), action: #selector(cancelProcess))
    }
    
    func cancelProcess() {
        
        // Define identifier
        let notificationName = Notification.Name("POPTOLOGIN")
        // Post notification
        NotificationCenter.default.post(name: notificationName, object: nil)
    }
    
    func moveToNextController(identifier:String) {
        
        EBTUser.shared.email = emailField.contentTextField.text!
        
        let vc = UIStoryboard(name: "Home", bundle: Bundle.main).instantiateViewController(withIdentifier: identifier)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
   

}

extension EBTChangeEmailTVC {
    // MARK: Scrapping
    
    func validatePage() {
        
        ebtWebView.getPageHeading(completion: { result in
            
            if let pageTitle = result {
                // isCurrentPage
                if pageTitle == self.pageTitle {
                    // current page
                    if self.actionType == ActionType.changeEmail {
                        self.actionType = nil
                        self.autoFill()
                    } else {
                        self.checkForErrorMessage()
                    }
                } else {
                    self.validateNextPage()
                }
            } else {
                
            }
            
        })
        
    }
    
    func getCurrentEmailAddress() {
        
//        let dobErrorCode = "$('.prelogonInstrText:eq(4)').text().trim();"
//        
//        ebtWebView.webView.evaluateJavaScript(dobErrorCode) { (result, error) in
//            if error != nil {
//                
//                print(error ?? "error nil")
//                
//            } else {
//                print(result ?? "result nil")
//                let stringResult = result as! String
//                let trimmed = stringResult.trimmingCharacters(in: .whitespacesAndNewlines)
//                print(trimmed)
//                if trimmed.characters.count > 0 {
//                    
//                    let components = trimmed.components(separatedBy: "* ")
//                    
//                    var list = [String]()
//                    for comp in components {
//                        
//                        let trimmedNew = comp.trimmingCharacters(in: .whitespacesAndNewlines)
//                        if trimmedNew.characters.count > 0 {
//                            
//                            let final = "* " + trimmedNew
//                            list.append(final)
//                        }
//                        
//                    }
//                    
//                    self.passwordRules = list.joined(separator: "\n")
//                    
//                } else {
//                    
//                }
//            }
//        }
    }

    
    func autoFill() {
        
        let emailAddress = emailField.contentTextField.text!
        let confirmEmail = confirmEmailField.contentTextField.text!
        
        let jsEmailAddress = "$('#newEMailTextField').val('\(emailAddress)');"
        let jsCofirmEmail = "$('#validateEMailTextField').val('\(confirmEmail)');"
        
        let jsSubmit = "void($('#changeEmailBtn').click());"
        
        let javaScript =  jsEmailAddress + jsCofirmEmail + jsSubmit
        
        ebtWebView.webView.evaluateJavaScript(javaScript) { (result, error) in
            self.checkForErrorMessage()
        }
    }
    
    
    func checkForErrorMessage() {
        
        ebtWebView.getErrorMessage(completion: { result in
            
            if let errorMessage = result {
                if errorMessage.characters.count > 0 {
                    // error message
                    
                    // update view
                    if self.ebtWebView.isPageLoading == false {
                        self.changeEmailButton.isEnabled = true
                        self.changeEmailActivityIndicator.stopAnimating()
                    }
                    self.errorMessageLabel.text = errorMessage
                    self.tableView.reloadData()
                    
                } else {
                    
                }
            } else {
                
            }
        })
    }
    
    func validateNextPage() {
        
        ebtWebView.getPageHeading(completion: { result in
            
            if let pageTitle = result {
                
                if let nextVCIdentifier = EBTConstants.getEBTViewControllerName(forPageTitle: pageTitle) {
                    self.moveToNextController(identifier: nextVCIdentifier)
                } else {
                    // unknown page
                    print("UNKNOWN PAGE")
                }
                
            } else {
                // is page not loaded
                print("PAGE NOT LOADED YET..")
            }
        })
    }
    
    
    
}



extension EBTChangeEmailTVC: AITextFieldProtocol {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == emailField.contentTextField {
            confirmEmailField.contentTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
}


extension EBTChangeEmailTVC: EBTWebViewDelegate {
    
    func didFinishLoadingWebView() {
        
        validatePage()
    }
    
}

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
        
        if validateInputs() == false {
            return
        }
        
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
        
        // text style
        currentEmailField.placeholderLabel.textColor = UIColor.black
        currentEmailField.placeholderLabel.font = UIFont.boldSystemFont(ofSize: 12.0)
        
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
        getCurrentEmailAddress()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        ebtWebView.responder = self
        
        let webView = ebtWebView.webView!
        self.view.addSubview(webView)
        self.view.sendSubview(toBack: webView)
        webView.isHidden = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: -
    
    func validateInputs() -> Bool {
        
        // userId
        if AppHelper.isEmpty(string: currentEmailField.contentTextField.text) {
            self.showAlert(title: "", message: "alert.emptyField.currentEmail".localized())
        } else if AppHelper.isEmpty(string: emailField.contentTextField.text) {
            self.showAlert(title: "", message: "alert.emptyField.email".localized())
        } else if AppHelper.isEmpty(string: confirmEmailField.contentTextField.text) {
            self.showAlert(title: "", message: "alert.emptyField.confirmEmail".localized())
        } else {
            return true
        }
        return false
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
            self.errorMessageLabel.text = ""
            
            self.changeEmailButton.setTitle("CHANGE EMAIL".localized(), for: .normal)
            
            self.tableView.reloadData()
        }
        
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
        
        showAlert(title: "ebt.processTerminate.title".localized(), message: "ebt.processTerminate.alert".localized(), action: #selector(cancelProcess))
    }
    
    func cancelProcess() {
        
        // Define identifier
        let notificationName = Notification.Name("POPTOLOGIN")
        // Post notification
        NotificationCenter.default.post(name: notificationName, object: nil)
    }
    
    func exitProcessIfPossible() {
        
        if self.ebtWebView.isPageLoading == false {
            self.showForceQuitAlert()
        }
    }
    
    func showForceQuitAlert() {
        
        self.showAlert(title: "", message: "ebt.alert.timeout.message".localized(), action: #selector(self.cancelProcess), showCancel: false)
        EBTUser.shared.isForceQuit = true
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
                self.exitProcessIfPossible()
            }
        })
    }
    
    func getCurrentEmailAddress() {
        
        let javaScript = "getCurrentEmailAddress();"
        
        ebtWebView.webView.evaluateJavaScript(javaScript) { (result, error) in
            
            if let resultString = result as? String {
                let resultTrimmed = resultString.trimmingCharacters(in: .whitespacesAndNewlines)
                if resultTrimmed.characters.count > 0 {
                    // status message
                    self.currentEmailField.contentTextField.text = resultTrimmed
//                    self.tableView.reloadData()
                } else {
                    // no status message
//                    self.checkForErrorMessage()
                }
            } else {
                //print(error ?? "")
            }
        }
    }
    
    func autoFill() {
        
        let emailAddress = emailField.contentTextField.text!
        let confirmEmail = confirmEmailField.contentTextField.text!
        
//        let jsEmailAddress = "$('#newEMailTextField').val('\(emailAddress)');"
//        let jsCofirmEmail = "$('#validateEMailTextField').val('\(confirmEmail)');"
//        
//        let jsSubmit = "void($('#changeEmailBtn').click());"
//        
//        let javaScript =  jsEmailAddress + jsCofirmEmail + jsSubmit
        
        let javaScript = "autoFillChangeEmail('\(emailAddress)', '\(confirmEmail)');"
        
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
                    //print("UNKNOWN PAGE")
                    self.exitProcessIfPossible()
                }
                
            } else {
                // is page not loaded
                //print("PAGE NOT LOADED YET..")
                self.exitProcessIfPossible()
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
    
    func aiTextField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        return AppHelper.isValid(input: string)
    }

    
    func didFinishLoadingWebView() {
        
        validatePage()
    }
    
    func didFail() {
        showForceQuitAlert()
    }
    
    func didFailProvisionalNavigation() {
        showForceQuitAlert()
    }
    
}

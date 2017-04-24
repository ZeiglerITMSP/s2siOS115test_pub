//
//  EBTConfirmationTVC.swift
//  Snap2Save
//
//  Created by Appit on 12/22/16.
//  Copyright © 2016 Appit. All rights reserved.
//

import UIKit

class EBTConfirmationTVC: UITableViewController {

    
    fileprivate enum ActionType {
        
        case validate
        case resend
        case changeEmail
    }
    
    // Properties
    let ebtWebView: EBTWebView = EBTWebView.shared
    fileprivate var actionType: ActionType?
    
    var pageTitle = "ebt.confirmation".localized()
    
    var isSuccessMessage = false
    
    // Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var errorTitleLabel: UILabel!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var validationCodeField: AIPlaceHolderTextField!
    @IBOutlet weak var validateActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var resendActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var changeEmailActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var validateButton: UIButton!
    @IBOutlet weak var resendButton: UIButton!
    @IBOutlet weak var changeEmailButton: UIButton!
    @IBOutlet weak var confirmationMessageLabel: UILabel!
    
    
    // Actions
    
    @IBAction func validateAction(_ sender: UIButton) {
        self.view.endEditing(true)
        
        if validateInputs() == false {
            return
        }
        
        self.validateButton.isEnabled = false
        self.validateActivityIndicator.startAnimating()
        
        actionType = ActionType.validate
        
        validatePage()
    }
    
    
    @IBAction func resendAction(_ sender: Any) {
        self.view.endEditing(true)
        
        self.resendButton.isEnabled = false
        self.resendActivityIndicator.startAnimating()
        
        actionType = ActionType.resend
        
        validatePage()
    }
       
    @IBAction func changeEmailAction(_ sender: UIButton) {
        self.view.endEditing(true)
        
        self.changeEmailButton.isEnabled = false
        self.changeEmailActivityIndicator.startAnimating()
        
        actionType = ActionType.changeEmail
        
        validatePage()
    }
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()

        validationCodeField.contentTextField.returnKeyType = .done
        validationCodeField.contentTextField.aiDelegate = self
        validationCodeField.contentTextField.updateUIAsPerTextFieldType()
        
        // Back Action
        self.navigationItem.addBackButton(withTarge: self, action: #selector(backAction))
        
        // Automatic height
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44
        
        errorMessageLabel.text = nil
        ebtWebView.responder = self
        
        AppHelper.setRoundCornersToView(borderColor: APP_ORANGE_COLOR, view: validateButton, radius: 2.0, width: 1.0)
        AppHelper.setRoundCornersToView(borderColor: nil, view: resendButton, radius: 2.0, width: 1.0)
        AppHelper.setRoundCornersToView(borderColor: nil, view: changeEmailButton, radius: 2.0, width: 1.0)
        
        addTapGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadContent()
        validatePage()
        getConfirmationMessage()
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
        if AppHelper.isEmpty(string: validationCodeField.contentTextField.text) {
            self.showAlert(title: "", message: "alert.emptyField.validationCode".localized())
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
            
            self.titleLabel.text = "ebt.confirmation.titleLabel".localized()
            self.messageLabel.text = "ebt.confirmation.messageLabel".localized()
            
//            self.confirmationMessageLabel.text = "ebt.confirmationMessage".localizedFormat(EBTUser.shared.email!)
            self.title = "ebt.title.register".localized()
            self.pageTitle = "ebt.confirmation".localized()
            self.validationCodeField.placeholderText = "ENTER EMAIL VALIDATION CODE".localized()
            self.errorTitleLabel.text = ""
            self.errorMessageLabel.text = ""
            
            self.validateButton.setTitle("VALIDATE".localized(), for: .normal)
            self.resendButton.setTitle("RESEND".localized(), for: .normal)
            self.changeEmailButton.setTitle("CHANGE EMAIL".localized(), for: .normal)
            
            self.tableView.reloadData()
        }
        
    }

    func updateErrorTextColor() {
        
        if isSuccessMessage {
            self.errorMessageLabel.textColor = APP_GRREN_COLOR
        } else {
            self.errorMessageLabel.textColor = UIColor.red
        }
    }
    
    // MARK: - Table view
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 2 {
            updateErrorTextColor()
            if (errorMessageLabel.text == nil || errorMessageLabel.text == "") {
                return 0
            }
        }
        
        return UITableViewAutomaticDimension
    }
    
    
    // MARK: -

    func backAction() {
        
//        self.navigationController?.popViewController(animated: true)
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
        
        self.showAlert(title: nil, message: "ebt.alert.timeout.message".localized(), action: #selector(self.cancelProcess), showCancel: false)
    }
    
    func moveToNextController(identifier:String) {
        
        let vc = UIStoryboard(name: "Home", bundle: Bundle.main).instantiateViewController(withIdentifier: identifier)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension EBTConfirmationTVC {
    // MARK: Scrapping
    
    func validatePage() {
        
        ebtWebView.getPageHeading(completion: { result in
            
            if let pageTitle = result {
                // isCurrentPage
                if pageTitle == self.pageTitle {
                    // current page
                    if self.actionType == ActionType.validate {
                        self.actionType = nil
                        self.autoFill()
                    } else if self.actionType == ActionType.resend {
                        self.actionType = nil
                        self.resendVerificationCode()
                    } else if self.actionType == ActionType.changeEmail {
                        self.actionType = nil
                        self.changeEmail()
                    } else {
                        self.checkForSuccessMessage()
                    }
                } else {
                    self.validateNextPage()
                }
            } else {
                self.exitProcessIfPossible()
            }
            
        })
        
    }
    
    
    func autoFill() {
        
        let valdationCode = validationCodeField.contentTextField.text!
        
        actionType = ActionType.validate
        
        let jsCardNumber = "$('#txtEmailValidationCode').val('\(valdationCode)');"
        let jsSubmit = "void($('#validateEmailBtn').click());"
        
        let javaScript =  jsCardNumber + jsSubmit
        
        ebtWebView.webView.evaluateJavaScript(javaScript) { (result, error) in
            
            self.checkForErrorMessage()
        }
    }
    
    func resendVerificationCode() {
        
        let jsResendClick = "void($('#resendValidationCodeBtn').click());"
        let javaScript = jsResendClick
        
        ebtWebView.webView.evaluateJavaScript(javaScript) { (result, error) in
            
            self.checkForSuccessMessage()
            
//            if error != nil {
//                print(error ?? "error nil")
//                
//                self.resendButton.isEnabled = true
//                self.resendActivityIndicator.stopAnimating()
//                
//            } else {
//                print(result ?? "result nil")
//                self.checkForSuccessMessage()
//            }
        }
    }
    
    func getConfirmationMessage() {
        
        let javaScript = "function getEmailConfirmation() { " +
            "var names = ''; " +
            "var msgDescription = $('#emailValidationForm .prelogonInstrTextArea .prelogonInstrText');" +
            "msgDescription.each(function(i, object) { " +
                "if (i != 0) { " +
                    "names += object.innerText.trim(); " +
                "} " +
                "if (i == 1) { " +
                    "names += '. ' " +
                "} " +
            "}); " +
            "return names;" +
        "} " +
        
        "getEmailConfirmation(); "
        
        ebtWebView.webView.evaluateJavaScript(javaScript) { (result, error) in
            
            if let resultString = result as? String {
                let resultTrimmed = resultString.trimmingCharacters(in: .whitespacesAndNewlines)
                let resultRemovedExtraWhiteSpaces = resultTrimmed.condenseWhitespace()
                if resultRemovedExtraWhiteSpaces.characters.count > 0 {
                    // status message
                    self.confirmationMessageLabel.text = resultTrimmed
                    self.tableView.reloadData()
                } else {
                    
                }
            } else {
                print(error ?? "")
            }
        }
    }
    
    func changeEmail() {
        
        let jsResendClick = "void($('#changeEmailBtn').click());"
        let javaScript = jsResendClick
        
        ebtWebView.webView.evaluateJavaScript(javaScript) { (result, error) in

        }
    }

    func checkForSuccessMessage() {
        
        ebtWebView.checkForSuccessMessage(completion: { result in
            
            if let errorMessage = result {
                if errorMessage.characters.count > 0 {
                    // success message
                    
                    // update view
                    if self.ebtWebView.isPageLoading == false {
                        self.validateButton.isEnabled = true
                        self.validateActivityIndicator.stopAnimating()
                        self.resendButton.isEnabled = true
                        self.resendActivityIndicator.stopAnimating()
                        self.changeEmailButton.isEnabled = true
                        self.changeEmailActivityIndicator.stopAnimating()
                    }
                    
                    self.errorMessageLabel.text = errorMessage
                    self.isSuccessMessage = true
                    self.tableView.reloadData()
                    
                } else {
                    self.checkForErrorMessage()
                }
            } else {
                
            }
        })
    }
    
    
    
    func checkForErrorMessage() {
        
        ebtWebView.getErrorMessage(completion: { result in
            
            if let errorMessage = result {
                if errorMessage.characters.count > 0 {
                    // error message
                    
                    // update view
                    if self.ebtWebView.isPageLoading == false {
                        self.validateButton.isEnabled = true
                        self.validateActivityIndicator.stopAnimating()
                        self.resendButton.isEnabled = true
                        self.resendActivityIndicator.stopAnimating()
                        self.changeEmailButton.isEnabled = true
                        self.changeEmailActivityIndicator.stopAnimating()
                    }
                    
                    self.errorMessageLabel.text = errorMessage
                    self.isSuccessMessage = false
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
                    self.exitProcessIfPossible()
                }
                
            } else {
                // is page not loaded
                print("PAGE NOT LOADED YET..")
                self.exitProcessIfPossible()
            }
        })
    }



}


extension EBTConfirmationTVC: EBTWebViewDelegate {
    
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

extension EBTConfirmationTVC: AITextFieldProtocol {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    
    func aiTextField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        return AppHelper.isValid(input: string)
    }

}


//
//  EBTLoginSecurityQuestionTVC.swift
//  Snap2Save
//
//  Created by Appit on 1/2/17.
//  Copyright © 2017 Appit. All rights reserved.
//

import UIKit
import Localize_Swift

class EBTLoginSecurityQuestionTVC: UITableViewController {

    fileprivate enum ActionType {
        
        case securityQuestion
    }
    
    // Properties
    let ebtWebView: EBTWebView = EBTWebView.shared
    fileprivate var actionType: ActionType?
    
    var pageTitle = "ebt.securityQuestion".localized()
    
    var languageSelectionButton: UIButton!
    
    // Ouetles
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var errorTitleLabel: UILabel!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var securityQuestionTitleLabel: UILabel!
    @IBOutlet weak var securityQuestionLabel: UILabel!
    
    @IBOutlet weak var securityAnswerField: AIPlaceHolderTextField!
    
    @IBOutlet weak var confirmButton: UIButton!
    
    @IBOutlet weak var confirmActivityIndicator: UIActivityIndicatorView!
    
    
    // Actions
    
    @IBAction func confirmAction(_ sender: UIButton) {
        self.view.endEditing(true)
        
        if validateInputs() == false {
            return
        }
        
        confirmButton.isEnabled = false
        confirmActivityIndicator.startAnimating()
        
        actionType = ActionType.securityQuestion
        
        validatePage()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        errorMessageLabel.text = nil
        
        securityAnswerField.contentTextField.returnKeyType = .done
        securityAnswerField.contentTextField.aiDelegate = self
        securityAnswerField.contentTextField.updateUIAsPerTextFieldType()
        
        // Back Action
        self.navigationItem.addBackButton(withTarge: self, action: #selector(backAction))
        
        // Automatic height
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44
        
        ebtWebView.responder = self
        
        validatePage()
        
        AppHelper.setRoundCornersToView(borderColor: APP_ORANGE_COLOR, view: confirmButton, radius: 2.0, width: 1.0)
        
        addTapGesture()
        
//        // language selection
//        languageSelectionButton = LanguageUtility.createLanguageSelectionButton(withTarge: self, action: #selector(languageButtonClicked))
//        LanguageUtility.addLanguageButton(languageSelectionButton, toController: self)

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
        webView.isHidden = true
        
        // listen language change notification.
//        LanguageUtility.addOberverForLanguageChange(self, selector: #selector(reloadContent))
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        // remove language change observer
//        LanguageUtility.removeObserverForLanguageChange(self)
        super.viewDidDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func languageButtonClicked() {
//        
//        self.showLanguageSelectionAlert()
//        
//    }
    
    // MARK: -
    
    func validateInputs() -> Bool {
        
        // userId
        if AppHelper.isEmpty(string: securityAnswerField.contentTextField.text) {
            self.showAlert(title: "", message: "alert.emptyField.securityAnswer".localized())
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
    
    @objc func tapOnTableView(recognizer: UITapGestureRecognizer) {
        
        self.view.endEditing(true)
    }

    func reloadContent() {
        
        DispatchQueue.main.async {
            
            if EBTUser.shared.loggedType == "1" {
                self.title = "ebt.title.login".localized()
            } else {
                self.title = "ebt.title.register".localized()
            }
            
            self.updateBackButtonText()
            
            self.pageTitle = "ebt.securityQuestion".localized()
            self.titleLabel.text = "ebt.securityQuestion.titleLabel".localized()
            self.messageLabel.text = "ebt.securityQuestion.messageLabel".localized()
            self.securityQuestionTitleLabel.text = "SECURITY QUESTION".localized()
            self.securityAnswerField.placeholderText = "SECURITY ANSWER".localized()
            self.errorTitleLabel.text = ""
            self.errorMessageLabel.text = ""
            
            self.confirmButton.setTitle("CONFIRM".localized(), for: .normal)
            
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
    
    @objc func backAction() {
        
        showAlert(title: "ebt.processTerminate.title".localized(), message: "ebt.processTerminate.alert".localized(), action: #selector(cancelProcess))
    }
    
    @objc func cancelProcess() {
        
        // Define identifier
        let notificationName = Notification.Name("POPTOLOGIN")
        // Post notification
        NotificationCenter.default.post(name: notificationName, object: nil)
    }
    
    func showForceQuitAlert() {
        
        self.showAlert(title: "", message: "ebt.alert.timeout.message".localized(), action: #selector(self.cancelProcess), showCancel: false)
        EBTUser.shared.isForceQuit = true
    }
    
    func exitProcessIfPossible() {
        
        if self.ebtWebView.isPageLoading == false {
            self.showForceQuitAlert()
        }
    }
    
    func moveToNextController(identifier:String) {
        
        let vc = UIStoryboard(name: "Home", bundle: Bundle.main).instantiateViewController(withIdentifier: identifier)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

extension EBTLoginSecurityQuestionTVC {
    
    // MARK: Scrapping
    
    func validatePage() {
        
        ebtWebView.getPageHeading(completion: { result in
            
            if let pageTitle = result {
                // isCurrentPage
                if pageTitle == self.pageTitle {
                    // current page
                    if self.actionType == ActionType.securityQuestion {
                        self.actionType = nil
                        self.autoFill()
                    } else {
                        self.getSecurityQuestion()
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
               // print("PAGE NOT LOADED YET..")
                self.exitProcessIfPossible()
            }
            
        })
        
    }
    
    
    func getSecurityQuestion() {
        
        let js = "getSecurityQuestion();"
        
        ebtWebView.webView.evaluateJavaScript(js) { (result, error) in
            if error != nil {
                //print(error ?? "error nil")
            } else {
                //print(result ?? "result nil")
                let stringResult = result as! String
                let trimmedText = stringResult.trimmingCharacters(in: .whitespacesAndNewlines)
               // print(trimmedText)
                
                if trimmedText.characters.count > 0 {
                    
                    self.securityQuestionLabel.text = trimmedText
                    self.tableView.reloadData()
                    
                } else {
                    
                }
            }
        }
    }

    
    func autoFill() {

        let securityAnswer = self.securityAnswerField.contentTextField.text!
        let javaScript = "autoFillSecurityAnswerAndSubmit('\(securityAnswer)');"
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
                        self.confirmButton.isEnabled = true
                        self.confirmActivityIndicator.stopAnimating()
                    }
                    
                    self.errorMessageLabel.text = errorMessage
                    self.tableView.reloadData()
                    
                } else {
//                    // no error message
//                    self.errorMessageLabel.text = nil
//                    self.tableView.reloadData()
                }
            } else {
                
            }
        })
    }


}

extension EBTLoginSecurityQuestionTVC: EBTWebViewDelegate {
    
    
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


extension EBTLoginSecurityQuestionTVC: AITextFieldProtocol {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    func aiTextField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        return AppHelper.isValid(input: string)
    }

    
}

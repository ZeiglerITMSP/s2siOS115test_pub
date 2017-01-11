//
//  EBTLoginTVC.swift
//  Snap2Save
//
//  Created by Appit on 12/20/16.
//  Copyright © 2016 Appit. All rights reserved.
//

import UIKit
import PKHUD

import LocalAuthentication

class EBTLoginTVC: UITableViewController {
    
    fileprivate enum ActionType {
        
        case waitingForPageLoad
        case sumbit
    }
    
        // Properties
    let ebtWebView: EBTWebView = EBTWebView.shared
    fileprivate var actionType: ActionType?
    
    let notificationName = Notification.Name("POPTOLOGIN")
    
    var languageSelectionButton: UIButton!
    
    // Outlets
    @IBOutlet weak var userIdField: AIPlaceHolderTextField!
    @IBOutlet weak var passwordField: AIPlaceHolderTextField!
    @IBOutlet weak var errorTitleLabel: UILabel!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registrationButton: UIButton!
    @IBOutlet weak var remmeberMyUserNameLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // Action
    @IBAction func loginAction(_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        if isValid(userId: userIdField.contentTextField.text) &&
            isValid(password: passwordField.contentTextField.text) {
            
            if rememberMeButton.isSelected {
                saveUserID()
            }
            
            loginButton.isEnabled = false
            activityIndicator.startAnimating()
            validatePage()
        }
        
    }
    
    @IBAction func registrationAction(_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        performSegue(withIdentifier: "EBTCardNumberTVC", sender: nil)
    }
    
    
    @IBOutlet weak var rememberMeButton: UIButton!
    
    @IBAction func rememberMeAction(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        UserDefaults.standard.set(sender.isSelected, forKey: kRememberMeEBT)
        
        if sender.isSelected == false {
            UserDefaults.standard.removeObject(forKey: kUserIdEBT)
        }
        
    }
    
    // MARK:-
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        errorMessageLabel.text = nil
        
        updateBackButtonText()
        
        userIdField.contentTextField.textFieldType = .PhoneNumberTextField
        userIdField.contentTextField.textFieldType = .NormalTextField
        
        passwordField.contentTextField.isSecureTextEntry = true
        
        // Automatic height
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44
        
        ebtWebView.responder = self
        
        // language selection
        languageSelectionButton = LanguageUtility.createLanguageSelectionButton(withTarge: self, action: #selector(languageButtonClicked))
        LanguageUtility.addLanguageButton(languageSelectionButton, toController: self)
        
        reloadContent()
        loadLoginPage()
        
        
        self.navigationItem.addBackButton(withTarge: self, action: #selector(backAction))
        
        
        // remember userID
        let rememberUser = UserDefaults.standard.bool(forKey: kRememberMeEBT)
        rememberMeButton.isSelected = rememberUser
        
        if rememberUser {
            let userId = UserDefaults.standard.value(forKey: kUserIdEBT) as? String
            if userId != nil {
                authenticateUserWithTouchID()
            }
        }
        
        userIdField.contentTextField.aiDelegate = self
        passwordField.contentTextField.aiDelegate = self
        
        AppHelper.setRoundCornersToView(borderColor: APP_ORANGE_COLOR, view: loginButton, radius: 2.0, width: 1.0)
        AppHelper.setRoundCornersToView(borderColor: APP_GRREN_COLOR, view: registrationButton, radius: 2.0, width: 1.0)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadContent()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        ebtWebView.responder = self
        //        loadLoginPage()
        // Stop listening notification
        NotificationCenter.default.removeObserver(self, name: notificationName, object: nil)
        
        LanguageUtility.addOberverForLanguageChange(self, selector: #selector(reloadContent))
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(popToLoginVC), name: notificationName, object: nil)
        LanguageUtility.removeObserverForLanguageChange(self)
        super.viewDidDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: -
    
    func backAction() {
        
       _ = self.navigationController?.popViewController(animated: true)
    }
    
    func languageButtonClicked() {
        
        self.showLanguageSelectionAlert()
        
    }
    
    func reloadContent() {
        
        DispatchQueue.main.async {
            
            self.languageSelectionButton.setTitle("language.button.title".localized(), for: .normal)
            self.updateBackButtonText()
            self.title = "EBT".localized()
            self.userIdField.placeholderText = "USER ID".localized()
            self.passwordField.placeholderText = "PASSWORD".localized()
            
            self.remmeberMyUserNameLabel.text = "Remember my user ID".localized()
            
            self.loginButton.setTitle("LOGIN".localized(), for: .normal)
            self.registrationButton.setTitle("REGISTRATION".localized(), for: .normal)
            
        }
        
        
    }
    
    func popToLoginVC() {
        
        _ = self.navigationController?.popToViewController(self, animated: true)
        loadLoginPage()
        userIdField.contentTextField.text = ""
        passwordField.contentTextField.text = ""
        errorMessageLabel.text = ""
        loginButton.isEnabled = true
        self.tableView.reloadData()
    }
    
    // MARK: - Table view
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            if (errorMessageLabel.text == nil || errorMessageLabel.text == "") {
                return 0
            }
        }
        
        return UITableViewAutomaticDimension
    }
    
    
    // MARK: - Fields validation 
    
    func isValid(userId:String?) -> Bool {
        
        if (userId != nil) && (userId != "") {
            return true
        }
        
        return false
    }
    
    func isValid(password:String?) -> Bool {
        
        if (password != nil) && (password != "") {
            return true
        }
        
        return false
    }
    
    
    
    
    
    // MARK: - WebView
    
    // load webpage
    func loadLoginPage() {
        
        let loginUrl_en = kEBTLoginUrl
        
        let url = NSURL(string: loginUrl_en)
        let request = NSURLRequest(url: url! as URL)
        print("asdfasdf")
        ebtWebView.webView.load(request as URLRequest)
    }
    
    func validatePage() {
        
        let jsLoginValidation = "$('#button_logon').text();"
        
        let javaScript = jsLoginValidation
        
        ebtWebView.webView.evaluateJavaScript(javaScript) { (result, error) in
            
            if let result = result {
                
                let resultString = result as! String
                
                if resultString == "Logon" {
                    self.autoFill(withUserId: self.userIdField.contentTextField.text!,
                                  password: self.passwordField.contentTextField.text!)
                } else {
                    print("page not loaded..")
                    self.actionType = ActionType.waitingForPageLoad
                }
            } else {
                print(error ?? "")
                self.actionType = ActionType.waitingForPageLoad
            }
        }
    }
    
    // autofill fields
    func autoFill(withUserId userid:String, password:String) {
        
        actionType = ActionType.sumbit
        let jsUserID = "$('#userId').val('\(userid)');"
        let jspassword = "$('#password').val('\(password)');"
        let jsSubmit = "$('#submit').click();"
        
        let javaScript = jsUserID + jspassword + jsSubmit
        ebtWebView.webView.evaluateJavaScript(javaScript) { (result, error) in
            
            self.checkForErrorMessage()
        }
    }
    
    func checkForErrorMessage() {
        
        let jsErrorMessage = "$('.errorTextLogin').text();"
        
        ebtWebView.webView.evaluateJavaScript(jsErrorMessage) { (result, error) in
            if error != nil {
                print(error ?? "error nil")
            } else {
                print(result ?? "result nil")
                let stringResult = result as! String
                let trimmedErrorMessage = stringResult.trimmingCharacters(in: .whitespacesAndNewlines)
                print(trimmedErrorMessage)
                
                if trimmedErrorMessage.characters.count > 0 {
                    print("got error message")
                    
                    self.loginButton.isEnabled = true
                    self.activityIndicator.stopAnimating()
                    
                    self.errorMessageLabel.text = trimmedErrorMessage
                    self.tableView.reloadData()
                    
                } else {
                    
                    print("form is submitting..")
                }
            }
        }
    }

    
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
                    
                    self.activityIndicator.stopAnimating()
                    self.performSegue(withIdentifier: "EBTAuthenticationTVC", sender: nil)
                } else {
                    
                    
                }
                
            }
        }
        
    }
    
    // MARK: - Touch ID
    
    func authenticateUserWithTouchID() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [unowned self] success, authenticationError in
                
                DispatchQueue.main.async {
                    if success {
                        self.autofillUserID()
                    } else {
//                        let ac = UIAlertController(title: "Authentication failed", message: "Sorry!", preferredStyle: .alert)
//                        ac.addAction(UIAlertAction(title: "OK", style: .default))
//                        self.present(ac, animated: true)
                    }
                }
            }
        } else {
            let ac = UIAlertController(title: "Touch ID not available", message: "Your device is not configured for Touch ID.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    func autofillUserID() {
        
        let userId = UserDefaults.standard.value(forKey: kUserIdEBT) as? String
        userIdField.contentTextField.text = userId
    }
    
    func saveUserID() {
        
        if let userId = userIdField.contentTextField.text {
            UserDefaults.standard.set(userId, forKey: kUserIdEBT)
        }
        
    }
    
}

extension EBTLoginTVC: EBTWebViewDelegate {
    
    func didFinishLoadingWebView() {
        
        if actionType == .sumbit {
            validateSubmitAction()
        } else if actionType == .waitingForPageLoad {
            validatePage()
        }
    }
    
}

extension EBTLoginTVC: AITextFieldProtocol {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == userIdField.contentTextField {
            
            passwordField.contentTextField.becomeFirstResponder()
        } else if textField == passwordField.contentTextField {
            
            textField.resignFirstResponder()
        }
        
        return true
    }
    
}


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
        
        case autofill
        case sumbit
    }
    
        // Properties
    let ebtWebView: EBTWebView = EBTWebView.shared
    fileprivate var actionType: ActionType?
    
    let pageTitle = "ebt.logon".localized()
    
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
        
        loginButton.isEnabled = false
        activityIndicator.startAnimating()
        
        actionType = ActionType.autofill
        validatePage()
        
        if isValid(userId: userIdField.contentTextField.text) {
            
            if rememberMeButton.isSelected {
                saveUserID()
            }
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
        
        userIdField.contentTextField.autocorrectionType = UITextAutocorrectionType.no
        userIdField.contentTextField.returnKeyType = .next
        
        passwordField.contentTextField.isSecureTextEntry = true
        passwordField.contentTextField.returnKeyType = .done
        
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
        webView.sendSubview(toBack: self.view)
        
        loadLoginPage()
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
    
    // MARK: - To Hide Keyboard
    
    func addTapGesture() {
        
        // Tap Gesuture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnTableView(recognizer:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    func tapOnTableView(recognizer: UITapGestureRecognizer) {
        
        self.view.endEditing(true)
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
        activityIndicator.stopAnimating()
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
    
    
    
    
    // MARK: -
    
    func moveToNextController(identifier:String) {
        
        let vc = UIStoryboard(name: "Home", bundle: Bundle.main).instantiateViewController(withIdentifier: identifier)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

extension EBTLoginTVC {
    
    // MARK: Scrapping
    
    func loadLoginPage() {
        
        let loginUrl_en = kEBTLoginUrl
        
        let url = NSURL(string: loginUrl_en)
        let request = NSURLRequest(url: url! as URL)

        ebtWebView.webView.load(request as URLRequest)
    }
    
    func validatePage() {
        
        // isCurrentPage
        let jsLoginValidation = "$('#button_logon').text();"
        let javaScript = jsLoginValidation
        
        ebtWebView.webView.evaluateJavaScript(javaScript) { (result, error) in
            
            if let resultString = result as? String {
                
                let resultTrimmed = resultString.trimmingCharacters(in: .whitespacesAndNewlines)
                
                if resultTrimmed == self.pageTitle {
                    // current page
                    if self.actionType == ActionType.autofill {
                        self.actionType = nil
                        self.autoFill()
                    } else {
                        self.checkForErrorMessage()
                    }
                    
                } else {
                    // validate for next page
                    self.validateNextPage()
                }
                
            } else {
                print(error ?? "")
            }
                
           
        }
    }
    
    func validateNextPage() {
    
        ebtWebView.getPageHeading(completion: { result in
         
            if let pageTitle = result {
                
                if let nextVCIdentifier = EBTConstants.getLoginViewControllerName(forPageTitle: pageTitle) {
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
    
    // autofill fields
    func autoFill() {
        
        loginButton.isEnabled = false
        activityIndicator.startAnimating()
        
        let userid = self.userIdField.contentTextField.text!
        let password = self.passwordField.contentTextField.text!
        
        let jsUserID = "$('#userId').val('\(userid)');"
        let jspassword = "$('#password').val('\(password)');"
        let jsSubmit = "$('#submit').click();"
        //        let jsSubmit = "$(\"form[name='form1']\").submit();"
        
        let javaScript = jsUserID + jspassword + jsSubmit
        ebtWebView.webView.evaluateJavaScript(javaScript) { (result, error) in
            
            self.checkForErrorMessage()
        }
    }
    
    func checkForErrorMessage() {
        
        let javaScript = "$('.errorTextLogin').text();"
        
        ebtWebView.webView.evaluateJavaScript(javaScript) { (result, error) in
            
            if let resultString = result as? String {
                
                let resultTrimmed = resultString.trimmingCharacters(in: .whitespacesAndNewlines)
                
                if resultTrimmed.characters.count > 0 {
                    // error message
                    
                    // update view
                    self.loginButton.isEnabled = true
                    self.activityIndicator.stopAnimating()
                    
                    self.errorMessageLabel.text = resultTrimmed
                    self.tableView.reloadData()
                    
                } else {
                    // no error message
                }
                
            } else {
                print(error ?? "")
            }
        }
    }
    
    
}

extension EBTLoginTVC {
    
    // MARK: Touch ID
    
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
        
        validatePage()
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


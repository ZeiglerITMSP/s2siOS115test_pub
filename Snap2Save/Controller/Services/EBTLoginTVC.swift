//
//  EBTLoginTVC.swift
//  Snap2Save
//
//  Created by Appit on 12/20/16.
//  Copyright © 2016 Appit. All rights reserved.
//

import UIKit
import Localize_Swift
import LocalAuthentication

class EBTLoginTVC: UITableViewController {
    
    fileprivate enum ActionType {
        
        case loadLoginPage
        case autofill
        case registration
    }
    
    // Properties
    let ebtWebView: EBTWebView = EBTWebView.shared
    fileprivate var actionType: ActionType?
    
    var pageTitle = "ebt.logon".localized()
    
    let notificationName = Notification.Name("POPTOLOGIN")
    var languageSelectionButton: UIButton!
    
    var isTouchIdAvailable = false
    var isSuccessMessage = false
    
    var isProcessCancelled = false
    
    var tempLoginUrl = kEBTLoginUrl
    
    var isHelpVCLoaded = false
    
    // Outlets
    @IBOutlet weak var userIdField: AIPlaceHolderTextField!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var passwordField: AIPlaceHolderTextField!
    @IBOutlet weak var errorTitleLabel: UILabel!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registrationButton: UIButton!
    @IBOutlet weak var remmeberMyUserNameLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var registrationActivityIndicator: UIActivityIndicatorView!
    
    
    
    // Action
    
    @IBAction func helpButtonAction() {
        
        isHelpVCLoaded = true
        
        let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "EBTHelpVC") as! EBTHelpVC
        self.navigationController?.pushViewController(vc, animated: false)
        
    }
    
    
    @IBAction func loginAction(_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        loginButton.isEnabled = false
        activityIndicator.startAnimating()
        
        actionType = ActionType.autofill
        validatePage()
        
        // save user name
        if isValid(userId: userIdField.contentTextField.text) {
            if rememberMeButton.isSelected {
                saveUserID()
            }
        }
        
    }
    
    @IBAction func registrationAction(_ sender: UIButton) {
        self.view.endEditing(true)
        
        //registrationButton.isEnabled = false
        registrationActivityIndicator.startAnimating()
        
        actionType = ActionType.registration
        validatePage()
    }
    
    
    @IBOutlet weak var rememberMeButton: UIButton!
    
    @IBAction func rememberMeAction(_ sender: UIButton) {
        
        //sender.isSelected = !sender.isSelected
        
        if sender.isSelected == true {
            // already remember me is clicked, so deselect it
            UserDefaults.standard.removeObject(forKey: kUserIdEBT)
            sender.isSelected = false
            UserDefaults.standard.set(sender.isSelected, forKey: kRememberMeEBT)
        } else {
            // trying to enable remember me..
            authenticateUserWithTouchID(toAutofill: false)
        }
        
        UserDefaults.standard.set(sender.isSelected, forKey: kRememberMeEBT)
    }
    
    // MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        
        errorMessageLabel.text = ""
        updateBackButtonText()
        
        // configure fields
        userIdField.contentTextField.textFieldType = .NormalTextField
        userIdField.contentTextField.autocorrectionType = UITextAutocorrectionType.no
        userIdField.contentTextField.returnKeyType = .next
        userIdField.contentTextField.updateUIAsPerTextFieldType()
        
        passwordField.contentTextField.isSecureTextEntry = true
        passwordField.contentTextField.returnKeyType = .done
        passwordField.contentTextField.updateUIAsPerTextFieldType()
        
        userIdField.contentTextField.aiDelegate = self
        passwordField.contentTextField.aiDelegate = self
        // Automatic height
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44
        
        ebtWebView.responder = self
        // language selection
        languageSelectionButton = LanguageUtility.createLanguageSelectionButton(withTarge: self, action: #selector(languageButtonClicked))
        LanguageUtility.addLanguageButton(languageSelectionButton, toController: self)
        // backbutton
        self.navigationItem.addBackButton(withTarge: self, action: #selector(backAction))
        // style for buttons
        AppHelper.setRoundCornersToView(borderColor: APP_ORANGE_COLOR, view: loginButton, radius: 2.0, width: 1.0)
        AppHelper.setRoundCornersToView(borderColor: APP_GRREN_COLOR, view: registrationButton, radius: 2.0, width: 1.0)
        // tap gesture to view
        addTapGesture()
        // touch id config
        let touchIDStatus = AppHelper.isTouchIDAvailable()
        
        if touchIDStatus.status == false {
            // if touch id status is false, then also in some cases we have to show the 'remember me'
            switch touchIDStatus.LAErrorCode! {
            case LAError.touchIDNotEnrolled.rawValue:
                isTouchIdAvailable = true
            case LAError.passcodeNotSet.rawValue:
                isTouchIdAvailable = true
            default:
                isTouchIdAvailable = false
            }
        } else {
            isTouchIdAvailable = true
        }
        // loader
        AppHelper.configSwiftLoader()
        
       // self.registrationButton.isHidden = true
        
        // Add help tab
//        addHelpTab()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isHelpVCLoaded == true {
            return
        }
        
        reloadContent()
        autofillUserName()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isHelpVCLoaded == true {
            isHelpVCLoaded = false
            return
        }
        
        ebtWebView.responder = self
        
        let webView = ebtWebView.webView!
        self.view.addSubview(webView)
        self.view.sendSubview(toBack: webView)
        
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
//    func addHelpTab() {
//        
//        let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "EBTHelpVCNavigation") as! UINavigationController
//        let tabBarController = self.tabBarController as! TabViewController
//        tabBarController.viewControllers?.append(vc)
//        
//        vc.tabBarItem = UITabBarItem(title: "EBT HELP".localized(), image: UIImage(named: "tabbarOffersInactive"), selectedImage: UIImage(named: "tabbarOffersActive"))
//        
//        tabBarController.updateSelectedItemBackground()
//    }
//    
//    func removeHelpTab() {
//        
////        let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "EBTHelpVCNavigation") as! UINavigationController
//        
//        let tabBarController = self.tabBarController as! TabViewController
//        if tabBarController.viewControllers?.count == 4 {
//            tabBarController.viewControllers?.removeLast()
//            tabBarController.updateSelectedItemBackground()
//        }
//    }
    
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
        
//        removeHelpTab()
       _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    func languageButtonClicked() {
        
        self.showLanguageSelectionAlert()
        
    }
    
    func reloadContent() {
        
        DispatchQueue.main.async {
            
            self.languageSelectionButton.setTitle("language.button.title".localized(), for: .normal)
            self.updateBackButtonText()
            self.title = "ebt.title.login".localized()
            
            self.titleLabel.text = "ebt.login.titleLabel".localized()
            self.messageLabel.text = "ebt.login.messageLabel".localized()
            self.pageTitle = "ebt.logon".localized()
            self.userIdField.placeholderText = "USER ID".localized()
            self.passwordField.placeholderText = "PASSWORD".localized()
            self.remmeberMyUserNameLabel.text = "Remember My User ID".localized()
            
            self.errorTitleLabel.text = ""
            self.errorMessageLabel.text = ""
            
            self.loginButton.setTitle("LOG IN".localized(), for: .normal)
            self.registrationButton.setTitle("REGISTER".localized(), for: .normal)
            
            self.tableView.reloadData()
            
            self.validateLoginPage()
        }
    }
    
    func popToLoginVC() {
        
        isProcessCancelled = true
        loadLoginPage()
        _ = self.navigationController?.popToViewController(self, animated: true)
       
        resetFields()
    }
    
    func resetFields() {
        
        userIdField.contentTextField.text = ""
        passwordField.contentTextField.text = ""
        errorMessageLabel.text = ""
        loginButton.isEnabled = true
        activityIndicator.stopAnimating()
        //registrationButton.isEnabled = true
        registrationActivityIndicator.stopAnimating()
        self.tableView.reloadData()
        
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
        
        updateErrorTextColor()
        if indexPath.row == 1 {
            if (errorMessageLabel.text == nil || errorMessageLabel.text == "") {
                return 0
            }
        } else if indexPath.row == 4 {
            if isTouchIdAvailable == false {
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
    
    func showForceQuitAlert() {
        
        self.showAlert(title: nil, message: "ebt.alert.timeout.message".localized(), action: #selector(backAction), showCancel: false)
    }
    
    func exitProcessIfPossible() {
        
        if self.ebtWebView.isPageLoading == false {
            self.showForceQuitAlert()
        }
    }
    
    func moveToNextController(identifier:String) {
        
        EBTUser.shared.loggedType = "1" // type 1- login, 2- signup
        EBTUser.shared.userID = userIdField.contentTextField.text!
        
        let vc = UIStoryboard(name: "Home", bundle: Bundle.main).instantiateViewController(withIdentifier: identifier)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

extension EBTLoginTVC {
    
    // MARK: Scrapping
    
    func validateLoginPage() {
        
        ebtWebView.getPageHeading(completion: { result in
            
            if let pageTitle = result {
                // isCurrentPage
                if pageTitle != self.pageTitle {
                    // current page
                    self.loadLoginPage()
                } else {
                    self.checkForStatusMessage()
                }
                
            } else {
                //print(error ?? "")
            }
            
        })
    }
    
//    func validateLoginPage() {
//        
//        // isCurrentPage
//        let jsLoginValidation = "$('#button_logon').text().trim();"
//        let javaScript = jsLoginValidation
//        
//        ebtWebView.webView.evaluateJavaScript(javaScript) { (result, error) in
//            
//            if let resultString = result as? String {
//                let resultTrimmed = resultString.trimmingCharacters(in: .whitespacesAndNewlines)
//                if resultTrimmed != self.pageTitle {
//                    self.loadLoginPage()
//                } else {
//                    // if login page
//                    self.checkForStatusMessage()
//                }
//            } else {
//                print(error ?? "")
//            }
//        }
//    }
//    
    func loadLoginPage() {
        
        
        actionType = ActionType.loadLoginPage
        
        SwiftLoader.show(title: "Loading...".localized(), animated: true)
        
        var loginUrl = tempLoginUrl //kEBTLoginUrl
        if Localize.currentLanguage() == "es" {
            loginUrl = kEBTLoginUrl_es
        }
        let url = NSURL(string: loginUrl)
        let request = NSURLRequest(url: url! as URL)

        ebtWebView.webView.load(request as URLRequest)
    }
    
    
    func validatePage() {
        
        ebtWebView.getPageHeading(completion: { result in
            
            if let pageTitle = result {
                // isCurrentPage
                if pageTitle == self.pageTitle {
                    // current page
                    if self.actionType == ActionType.autofill {
                        self.actionType = nil
                        self.autoFill()
                    } else if self.actionType == ActionType.registration {
                        self.actionType = nil
                        self.registrationClick()
                    } else {
                        self.checkForStatusMessage()
                        //self.checkForErrorMessage()
                    }
                    
                } else {
                    self.validateNextPage()
                }
                
            } else {
                self.exitProcessIfPossible()
            }
            
        })
        
    }
    
    
//    func validatePage() {
//        
//        
//        // isCurrentPage
//        let jsLoginValidation = "$('#button_logon').text().trim();"
//        let javaScript = jsLoginValidation
//        
//        ebtWebView.webView.evaluateJavaScript(javaScript) { (result, error) in
//            
//            if let resultString = result as? String {
//                
//                let resultTrimmed = resultString.trimmingCharacters(in: .whitespacesAndNewlines)
//                
//                if resultTrimmed == self.pageTitle {
//                    // current page
//                    if self.actionType == ActionType.autofill {
//                        self.actionType = nil
//                        self.autoFill()
//                    } else if self.actionType == ActionType.registration {
//                        self.actionType = nil
//                        self.registrationClick()
//                    }
//                    else {
//                        self.checkForErrorMessage()
//                    }
//                    
//                } else {
//                    // validate for next page
//                    self.validateNextPage()
//                }
//                
//            } else {
//                print(error ?? "")
//            }
//                
//           
//        }
//    }
    
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
    
    func autoFill() {
        
//        loginButton.isEnabled = false
//        activityIndicator.startAnimating()
        
        let userid = self.userIdField.contentTextField.text!
        let password = self.passwordField.contentTextField.text!
        
        let jsUserID = "$('#userId').val('\(userid)');"
        let jspassword = "$('#password').val('\(password)');"
        let jsSubmit = "$('#submit').click();"
        //        let jsSubmit = "$(\"form[name='form1']\").submit();"
        
        let javaScript = jsUserID + jspassword + jsSubmit
        ebtWebView.webView.evaluateJavaScript(javaScript) { (result, error) in
            print(error ?? "")
            self.checkForErrorMessage()
        }
    }
    
    func registrationClick() {
        
        
        let jsRegistration = "javascript:void(window.location.href =$('.prelogonActRegBtns').find(\"a[title='Register for UCARD center']\").attr('href'));"
        let javaScript = jsRegistration
        ebtWebView.webView.evaluateJavaScript(javaScript) { (result, error) in
            
            self.checkForErrorMessage()
        }
    }
    
    func checkForStatusMessage() {
        
        let javaScript = "$('#infoMsg .actionMessage').text().trim();"
        
        ebtWebView.webView.evaluateJavaScript(javaScript) { (result, error) in
            
            if let resultString = result as? String {
                let resultTrimmed = resultString.trimmingCharacters(in: .whitespacesAndNewlines)
                if resultTrimmed.characters.count > 0 {
                    // status message
                    
//                    // update view
//                    if self.ebtWebView.isPageLoading == false {
//                        
////                        self.rememberMeButton.isEnabled = true
////                        self.regenerateActivityIndicator.stopAnimating()
//                    }
                    
                    self.errorMessageLabel.text = resultTrimmed
                    self.isSuccessMessage = true
                    self.tableView.reloadData()
                    
                } else {
                    // no status message
                    self.checkForErrorMessage()
                }
                
            } else {
                print(error ?? "")
            }
        }
    }
    
    
    func checkForErrorMessage() {
        
        ebtWebView.getErrorMessage(completion: { result in
            
            if let errorMessage = result {
                if errorMessage.characters.count > 0 {
                    // error message
                    
                    if self.ebtWebView.isPageLoading == false {
                        // update view
                        self.loginButton.isEnabled = true
                       // self.registrationButton.isEnabled = true
                        self.activityIndicator.stopAnimating()
                        self.registrationActivityIndicator.stopAnimating()
                    }
                    
                    self.errorMessageLabel.text = errorMessage
                    self.isSuccessMessage = false
                    self.tableView.reloadData()
                    
                } else {
                    // no error message
                    self.errorMessageLabel.text = nil
                    self.tableView.reloadData()
                }
            } else {
                
            }
        })
    }
    
    
}

extension EBTLoginTVC {
    
    // MARK: Touch ID
    
    func autofillUserName() {
        
        if isTouchIdAvailable {
            // remember userID
            let rememberUserEnabled = UserDefaults.standard.bool(forKey: kRememberMeEBT)
            rememberMeButton.isSelected = rememberUserEnabled
            
            if rememberUserEnabled {
                let userId = UserDefaults.standard.value(forKey: kUserIdEBT) as? String
                if userId != nil {
                    authenticateUserWithTouchID(toAutofill: true)
                }
            }
        }
        
    }
    
    func authenticateUserWithTouchID(toAutofill autofill: Bool) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!".localized()
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [unowned self] success, authenticationError in
                
                DispatchQueue.main.async {
                    if success {
                        if autofill {
                            self.autofillUserID()
                        } else {
                            self.rememberMeButton.isSelected = true
                            UserDefaults.standard.set(self.rememberMeButton.isSelected, forKey: kRememberMeEBT)
                        }
                        
                    } else {
                        
                        UserDefaults.standard.removeObject(forKey: kUserIdEBT)
                        self.rememberMeButton.isSelected = false
                        UserDefaults.standard.set(self.rememberMeButton.isSelected, forKey: kRememberMeEBT)
                        
                        
//                        let ac = UIAlertController(title: "Authentication failed", message: "Sorry!", preferredStyle: .alert)
//                        ac.addAction(UIAlertAction(title: "OK", style: .default))
//                        self.present(ac, animated: true)
                    }
                }
            }
        } else {
            
//            UserDefaults.standard.removeObject(forKey: kUserIdEBT)
//            self.rememberMeButton.isSelected = false
//            UserDefaults.standard.set(self.rememberMeButton.isSelected, forKey: kRememberMeEBT)
            let ac = UIAlertController(title: "Touch ID not available".localized() , message: "Your device is not configured for Touch ID.".localized(), preferredStyle: .alert)
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
        
        if actionType == ActionType.loadLoginPage {
            actionType = nil
            
            SwiftLoader.hide()
        }
        
        validatePage()
    }
    
    func didFail() {
        if actionType == ActionType.loadLoginPage {
            actionType = nil
            
            SwiftLoader.hide()
        }

        showForceQuitAlert()
    }
    
    func didFailProvisionalNavigation() {
        if actionType == ActionType.loadLoginPage {
            actionType = nil
            
            SwiftLoader.hide()
        }

        showForceQuitAlert()
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
    
    func aiTextField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // checking for only single quote, double quote - bcz script will not work.
        // not - only allowing [^A-Za-z0-9], bcz spanish characters have to be allowed, and @. for email have to be allowed.
        
        return AppHelper.isValid(input: string)
    }
    
}


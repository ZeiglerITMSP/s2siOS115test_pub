//
//  EBTLoginTVC.swift
//  Snap2Save
//
//  Created by Appit on 12/20/16.
//  Copyright © 2016 Appit. All rights reserved.
//

import UIKit
import Alamofire
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
    
    let adSpotManager = AdSpotsManager()
    var screenLanguage: String!
//    var isHelpVCLoaded = false
    
    // Outlets
    @IBOutlet weak var userIdField: AIPlaceHolderTextField!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var passwordField: AIPlaceHolderTextField!
    @IBOutlet weak var errorTitleLabel: UILabel!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registrationButton: UIButton!
    @IBOutlet weak var remmeberMyUserNameLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var registrationActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var adImageView: UIImageView!
    @IBOutlet weak var adImageViewTwo: UIImageView!
    
    
    // Action
    
    @IBAction func imageViewOneAction(_ sender: UITapGestureRecognizer) {
        
        //print("tap gesture")
    }
    
    
//    @IBAction func helpButtonAction() {
//        
////        isHelpVCLoaded = true
//        
//        let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "EBTHelpVC") as! EBTHelpVC
//        self.navigationController?.pushViewController(vc, animated: false)
//        
//    }
    
    
    @IBAction func loginAction(_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        if validateInputs() == false {
            return
        }
        
        loginButton.isEnabled = false
        activityIndicator.startAnimating()
        
        actionType = ActionType.autofill
        validatePageAndPerformAction()
        
        // save user name
        if rememberMeButton.isSelected {
            saveUserID()
        }
    }
    
    @IBAction func registrationAction(_ sender: UIButton) {
        self.view.endEditing(true)
        
        registrationButton.isEnabled = false
        registrationActivityIndicator.startAnimating()
        
        actionType = ActionType.registration
        validatePageAndPerformAction()
    }
    
    
    @IBOutlet weak var rememberMeButton: UIButton!
    
    @IBAction func rememberMeAction(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        
        updateRememberMeStatus(rememberMe: sender.isSelected)
        
//        // Initially it will be disabled
//        // On deselected, remove user id from defaults, and updatd selection status
//        // On selection, update selection status
//        
//        // On deselected, remove user id from defaults
//        if sender.isSelected == true {
//            // already remember me is clicked, so deselect it
//            UserDefaults.standard.removeObject(forKey: kUserIdEBT)
//            sender.isSelected = false
//           // UserDefaults.standard.set(sender.isSelected, forKey: kRememberMeEBT)
//        } else {
//            // trying to enable remember me..
//            self.rememberMeButton.isSelected = true
//         //   UserDefaults.standard.set(self.rememberMeButton.isSelected, forKey: kRememberMeEBT)
//            
//            
//          //  authenticateUserWithTouchID(toAutofill: false)
//        }
//        // update selection status
//        UserDefaults.standard.set(sender.isSelected, forKey: kRememberMeEBT)
    }
    
    // MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        
        errorMessageLabel.text = ""
        updateBackButtonText()
        
        // configure fields
        userIdField.contentTextField.textFieldType = .NumberTextField
        userIdField.contentTextField.autocorrectionType = UITextAutocorrectionType.no
        userIdField.contentTextField.returnKeyType = .next
        userIdField.contentTextField.updateUIAsPerTextFieldType()
        
        passwordField.contentTextField.textFieldType = .NumberTextField
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
//        addTapGesture()
        
        adSpotManager.delegate = self
        
        
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
        
       self.registrationButton.isHidden = true
        
        
        SwiftLoader.show(title: "Loading...".localized(), animated: true)
        loadAdSpots(onLanguageChange: false)
        
        screenLanguage = Localize.currentLanguage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        

        reloadContent()
        
        if screenLanguage != Localize.currentLanguage() {
            screenLanguage = Localize.currentLanguage()
            loadAdSpots(onLanguageChange: true)
        }
        
        validateLoginPage()
//        validatePageAndPerformAction()
        udateRememberMyStatus()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        if isHelpVCLoaded == true {
//            isHelpVCLoaded = false
//            return
//        }
        
        ebtWebView.responder = self
        
        let webView = ebtWebView.webView!
        
        self.view.addSubview(webView)
        self.view.sendSubview(toBack: webView)
        webView.isHidden = true
        // remove observer
        NotificationCenter.default.removeObserver(self, name: notificationName, object: nil)
        // listen language change notification.
        LanguageUtility.addOberverForLanguageChange(self, selector: #selector(languageChanged))
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(popToLoginVC), name: notificationName, object: nil)
        // remove language change observer
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
    
    // MARK: - Remember UserId
    
    func udateRememberMyStatus() {
        
        let rememberUserEnabled = UserDefaults.standard.bool(forKey: kRememberMeEBT)
        rememberMeButton.isSelected = rememberUserEnabled
        
        if rememberUserEnabled {
            autoFillUserIdField()
        }
    }
    
    func autoFillUserIdField() {
        
        let userId = UserDefaults.standard.value(forKey: kUserIdEBT) as? String
        if userId != nil {
            self.userIdField.contentTextField.text = userId
        }
    }
    
    func updateRememberMeStatus(rememberMe: Bool) {
        // remove existing userid if unchecked remember me
        if rememberMe == false {
            UserDefaults.standard.removeObject(forKey: kUserIdEBT)
        }
        // store remember me status
        UserDefaults.standard.set(rememberMe, forKey: kRememberMeEBT)
    }
    
    // MARK: -
    
    func backAction() {
        
//        removeHelpTab()
       _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    func languageButtonClicked() {
        
        self.showLanguageSelectionAlert()
        
    }
    
    func languageChanged() {
        
        loadLoginPage()
        reloadContent()
        
        loadAdSpots(onLanguageChange: true)
    }
    
    func reloadContent() {
        
        DispatchQueue.main.async {
            
            self.languageSelectionButton.setTitle("language.button.title".localized(), for: .normal)
            self.updateBackButtonText()
            self.title = "ebt.title.login".localized()
            
            self.titleLabel.text = "ebt.login.titleLabel".localized()
            self.messageLabel.text = "ebt.login.messageLabel".localized()
            self.descriptionLabel.text = "ebt.login.description".localized()
            self.pageTitle = "ebt.logon".localized()
            self.userIdField.placeholderText = "ebt.login.cardnumber".localized()
            self.passwordField.placeholderText = "ebt.login.pin".localized()
            self.remmeberMyUserNameLabel.text = "ebt.login.remember".localized()
            
            self.errorTitleLabel.text = ""
            self.errorMessageLabel.text = ""
            
            self.loginButton.setTitle("LOG IN".localized(), for: .normal)
            self.registrationButton.setTitle("REGISTER".localized(), for: .normal)
            
            self.tableView.setContentOffset(CGPoint.zero, animated: false)
            self.tableView.reloadData()
        }
    }
    
    func loadAdSpots(onLanguageChange: Bool) {
        
        if onLanguageChange {
//            SwiftLoader.show(title: "Loading...".localized(), animated: true)
            adSpotManager.downloadAdImages()
        } else {
            adSpotManager.getAdSpots(forScreen: .ebtLogin)
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
        registrationButton.isEnabled = false
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
    

    func validateInputs() -> Bool {
        
        // userId
        
        if AppHelper.isEmpty(string: userIdField.contentTextField.text) {
            self.showAlert(title: "", message: "alert.emptyField.userid".localized())
        } else if AppHelper.isEmpty(string: passwordField.contentTextField.text) {
            self.showAlert(title: "", message: "alert.emptyField.password".localized())
        } else {
            return true
        }
        return false
    }
    
    
    // MARK: -
    
    func showForceQuitAlert() {
        
        self.showAlert(title: "", message: "ebt.alert.timeout.message".localized(), action: #selector(backAction), showCancel: false)
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

// MARK: - Table view
extension EBTLoginTVC {
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        updateErrorTextColor()
        
        if indexPath.section == 0 {
            if indexPath.row == 2 {
                if (errorMessageLabel.text == nil || errorMessageLabel.text == "") {
                    return 0
                }
            }
        } else if indexPath.section == 1 {
            
            if indexPath.row == 0 {
                
                if adSpotManager.adSpots.count > 0 {
                    
                    let spot = adSpotManager.adSpots[0]
                    let type = spot["type"]
                    if let adImage = adSpotManager.adSpotImages["\(type!)"] {
                        if adImage.size.width > self.view.frame.width {
                            let height = AppHelper.getRatio(width: adImage.size.width,
                                                            height: adImage.size.height,
                                                            newWidth: self.view.frame.width)
                            
                            return height
                        }
                    }
                    
                    return UITableViewAutomaticDimension
                }
            }
            else if indexPath.row == 1 {
                
                if adSpotManager.adSpots.count == 2 {
                    
                    let spot = adSpotManager.adSpots[1]
                    let type = spot["type"]
                    if let adImage = adSpotManager.adSpotImages["\(type!)"] {
                        if adImage.size.width > self.view.frame.width {
                            let height = AppHelper.getRatio(width: adImage.size.width,
                                                            height: adImage.size.height,
                                                            newWidth: self.view.frame.width)
                            
                            return height
                        }
                    }
                    
                    return UITableViewAutomaticDimension
                }
            }
        }
        
        return UITableViewAutomaticDimension
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.view.endEditing(true)
        if indexPath.section == 1 {
            adSpotManager.showAdSpotDetails(spot: adSpotManager.adSpots[indexPath.row], inController: self)
        }
        
        tableView.deselectRow(at: indexPath, animated: false)
        
    }
    
//    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
//        
//        if indexPath.section == 1 {
//            adSpotManager.showAdSpotDetails(spot: adSpotManager.adSpots[indexPath.row], inController: self)
//        }
//
//        return true
//    }

    
}

extension EBTLoginTVC {
    
    // MARK: Scrapping
    
    func validateLoginPage() {
        
        ebtWebView.getPageHeading(completion: { result in
            if let pageTitle = result {
                // validate login page title
                if pageTitle != self.pageTitle {
                    // load login page
                    self.loadLoginPage()
                } else {
                    
                    if Localize.currentLanguage() == "es" {
                        self.validateSpanishLoginPage(completion: { (isSpanish) in
                            if isSpanish {
                                // loaded spanish page
                                self.checkForStatusMessage()
                            } else {
                                // if spanish page not loaded, then reload login page
                                self.exitProcessIfPossible()
                            }
                        })
                    } else {
                        self.checkForStatusMessage()
                    }
                }
            } else {
                
            }
        })
    }
    
    /// Used to vaidate page - if valid, perform desired action. else check for error message, or next page. exit process if invalid.
    func validatePageAndPerformAction() {
        // get page title
        ebtWebView.getPageHeading(completion: { result in
            if let pageTitle = result {
                // validate if page is login page
                if pageTitle == self.pageTitle {
                    // check if login page is loaded in current language.
                    // if current language is spanish, validate for spanish page, then perform action.
                    // if current language is english, perform page action.
                    if Localize.currentLanguage() == "es" {
                        self.validateSpanishLoginPage(completion: { (isSpanish) in
                            if isSpanish {
                                // if spanish page, perform page action
                                self.performActionOnPage()
                            } else {
                                // if not spanish page. reload login page
                                self.loadLoginPage()
                            }
                        })
                    } else {
                        self.performActionOnPage()
                    }
                } else {
                    // if not current page, check for next page
                    self.validateNextPage()
                }
            } else {
                // if no page title, then exit process
                self.exitProcessIfPossible()
            }
        })
    }
    
    func performActionOnPage() {
        
        if self.actionType == ActionType.autofill {
            // autofill
            self.actionType = nil
            self.autoFill()
        } else if self.actionType == ActionType.registration {
            // registration
            self.actionType = nil
            self.registrationClick()
        } else {
            // error message
            self.checkForStatusMessage()
        }
    }
    
    func validateSpanishLoginPage(completion: @escaping (Bool) -> ()) {
        completion(true)
//        let javaScript = "isSpanishPageLoaded();"
//        ebtWebView.webView.evaluateJavaScript(javaScript) { (result, error) in
//            if error != nil {
//                print(error ?? "error nil")
//                completion(false)
//            } else {
//                print(result ?? "result nil")
//                if let isSpanish = result as? Bool {
//
//                    if isSpanish == false {
//                        // if spanish page not loaded, then reload login page
//                        completion(false)
//                    } else {
//                        // loaded spanish page
//                        completion(true)
//                    }
//                } else {
//                    completion(false)
//                }
//
//            }
//        }
    }
    
    
//    func validateSpanishLoginPage() {
//        let javaScript = "isSpanishPageLoaded();"
//        ebtWebView.webView.evaluateJavaScript(javaScript) { (result, error) in
//
//            if error != nil {
//                print(error ?? "error nil")
//            } else {
//                print(result ?? "result nil")
//                if let stringResult = result as? String {
//
//                    let isSpanish = (stringResult as NSString).boolValue
//                    if isSpanish == false {
//                        // if spanish page not loaded, then reload login page
//                        self.loadLoginPage()
//                    } else {
//                        // loaded spanish page
//                        self.checkForStatusMessage()
//                    }
//                } else {
//
//                }
//            }
//        }
//    }
//
    
    func loadLoginPage() {
        
        actionType = ActionType.loadLoginPage
        
        SwiftLoader.show(title: "Loading...".localized(), animated: true)
        // test
        var loginUrl = tempLoginUrl //kEBTLoginUrl
        if Localize.currentLanguage() == "es" {
            loginUrl = kEBTLoginUrl_es
        }
        let url = NSURL(string: loginUrl)
        let request = NSURLRequest(url: url! as URL)
        
        ebtWebView.webView.load(request as URLRequest)
    }
    
    
    func validateNextPage() {
    
        ebtWebView.getPageHeading(completion: { result in
         
            if let pageTitle = result {
                
                if let nextVCIdentifier = EBTConstants.getEBTViewControllerName(forPageTitle: pageTitle) {
                    self.moveToNextController(identifier: nextVCIdentifier)
                } else {
                    // unknown page
                   // print("UNKNOWN PAGE")
                    self.exitProcessIfPossible()
                }
                
            } else {
                // is page not loaded
                //print("PAGE NOT LOADED YET..")
                self.exitProcessIfPossible()
            }
        })
    }
    
    func autoFill() {
        let userId = self.userIdField.contentTextField.text ?? ""
        let password = self.passwordField.contentTextField.text ?? ""
        
        let headers = [
            "Content-Type": "application/json"
        ] as HTTPHeaders
        
        let body = [
            "cardNumber": userId,
            "pinCode": password
        ] as Parameters

        request("https://dev.trush.in/ebt/ebtInfo", method: .post, parameters: body, encoding: JSONEncoding(), headers: headers).validate().responseSwiftyJSON { (response) in
            switch response.result {
            case .success:
                if let json = response.result.value {
                    guard json["status"]["code"].intValue == 200 else {
                        self.activityIndicator.stopAnimating()
                        self.registrationActivityIndicator.stopAnimating()
                        self.errorMessageLabel.text = json["status"]["message"].string ?? "The server encountered an unknown error"
                        self.isSuccessMessage = false
                        self.loginButton.isEnabled = true
                        self.tableView.reloadData()
                        return
                    }
                    EBTData.shared.transactionsArray = (json["transactions"].arrayObject as! [[String:String]])
                    EBTData.shared.accountBalancesObject = json["account_balance"].dictionaryObject as! [String:String]
                    self.moveToNextController(identifier: "EBTDashboardTVC")
                } else {
                    self.activityIndicator.stopAnimating()
                    self.registrationActivityIndicator.stopAnimating()
                    self.errorMessageLabel.text = "The server encountered an unknown error"
                    self.isSuccessMessage = false
                    self.loginButton.isEnabled = true
                    self.tableView.reloadData()
                }
            case .failure( _):
                if let json = response.result.value {
                    self.activityIndicator.stopAnimating()
                    self.registrationActivityIndicator.stopAnimating()
                    self.errorMessageLabel.text = json["status"]["message"].string ?? "The server encountered an unknown error"
                    self.isSuccessMessage = false
                    self.loginButton.isEnabled = true
                    self.tableView.reloadData()
                } else {
                    self.activityIndicator.stopAnimating()
                    self.registrationActivityIndicator.stopAnimating()
                    self.errorMessageLabel.text = "The server encountered an unknown error"
                    self.isSuccessMessage = false
                    self.loginButton.isEnabled = true
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func registrationClick() {
        
        let url = NSURL(string: kEBTSignupUrl)
        let request = NSURLRequest(url: url! as URL)
        
        ebtWebView.webView.load(request as URLRequest)
        
//        let jsRegistration = "javascript:void(window.location.href =$('.prelogonActRegBtns').find(\"a[title='Register for UCARD center']\").attr('href'));"
//        let javaScript = jsRegistration
//        ebtWebView.webView.evaluateJavaScript(javaScript) { (result, error) in
//            
//            self.checkForErrorMessage()
//        }
    }
    
    func checkForStatusMessage() {
        
        let javaScript = "checkForLoginStatusMessage();"
        
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
                //print(error ?? "")
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
                        self.registrationButton.isEnabled = false
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
        validatePageAndPerformAction()
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
        
        return AppHelper.isValid(input: string)
    }
    
}


// MARK: - Ads
extension EBTLoginTVC: AdSpotsManagerDelegate {
    
    func didFinishLoadingSpots() {
        
        SwiftLoader.hide()
        updateAdImage()
    }
    
    func didFailedLoadingSpots(description: String) {

        SwiftLoader.hide()
    }
    
    // function
    func updateAdImage() {
        if adSpotManager.adSpots.count > 0 {
            for i in 0..<adSpotManager.adSpots.count {
                if i == 0 {
                    let spot = adSpotManager.adSpots[i]
                    let type = spot["type"]
                    let image = adSpotManager.adSpotImages["\(type!)"]
                    self.adImageView.image = image
                } else {
                    let spot = adSpotManager.adSpots[i]
                    let type = spot["type"]
                    let image = adSpotManager.adSpotImages["\(type!)"]
                    self.adImageViewTwo.image = image
                }
                self.tableView.reloadData()
            }
        }
    }
    
}


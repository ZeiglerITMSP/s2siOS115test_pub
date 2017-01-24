//
//  LoginVC.swift
//  Snap2Save
//
//  Created by Appit on 12/19/16.
//  Copyright © 2016 Appit. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import  Localize_Swift
import FBSDKLoginKit
import PhoneNumberKit

class LoginVC: UIViewController,AITextFieldProtocol,UITextFieldDelegate,UIScrollViewDelegate,FacebookLoginDelegate,FacebookDataDelegate {
    
    var languageSelectionButton: UIButton!
    var user:User = User()
    var blueNavBarImg = AppHelper.imageWithColor(color: APP_GRREN_COLOR)
    let faceBookLogin : FacebookLogin  = FacebookLogin()
    var faceBookDict : [String : Any]? = nil
    
    @IBOutlet var facebookActivityIndicator: UIActivityIndicatorView!
    @IBOutlet var bgContainerView: UIView!
    @IBOutlet var bgScrollView: UIScrollView!
    @IBOutlet var FbLoginBgView: UIView!
    @IBOutlet var loginWithFacebookButton: UIButton!
    @IBOutlet var forgotPasswordButton: UIButton!
    @IBOutlet var passwordTextField: AITextField!
    @IBOutlet var passwordLabel: UILabel!
    @IBOutlet var mobileNumTextField:AITextField!
    @IBOutlet var mobileNumLabel: UILabel!
    @IBOutlet var orLabel: UILabel!
    
    @IBOutlet var loginButton: UIButton!
    
    @IBOutlet var loginActivityIndicator: UIActivityIndicatorView!
    
    @IBAction func loginButtonAction(_ sender: UIButton) {
        if !isValid() {
            return
        }
        userLogin()
    }
    
    @IBAction func forgotPasswordButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        let forgotPasswordVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ForgotPasswordVC")
        self.navigationController?.show(forgotPasswordVC, sender: self)
        
    }
    
    
    @IBAction func loginWithFacebookButtonAction(_ sender: UIButton) {
        
        facebookActivityIndicator.startAnimating()
        faceBookLogin.delegate = self
        faceBookLogin.dataSource = self
        faceBookLogin.loginWithFacebook()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Log In"
        
        AppHelper.setRoundCornersToView(borderColor:APP_ORANGE_COLOR, view:loginButton , radius:3.0, width: 1.0)
        
        AppHelper.setRoundCornersToView(borderColor: UIColor.init(red: 59.0/255.0, green: 89.0/255.0, blue: 152.0/255.0, alpha: 1.0), view:FbLoginBgView , radius:3.0, width: 1.0)
        
        let backButton = UIButton.init(type: .custom)
        backButton.frame = CGRect(x:0,y:0,width:80,height:25)
        backButton.setImage(UIImage.init(named: "ic_back"), for: .normal)
        backButton.setTitle("Back", for: .normal)
        backButton.setTitleColor(UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0), for: .normal)
        
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 17.0)
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0)
        
        let leftBarButton = UIBarButtonItem()
        leftBarButton.customView = backButton
        self.navigationItem.leftBarButtonItem = leftBarButton
        
        
        /* let languageButton = UIButton.init(type: .system)
         languageButton.frame = CGRect(x:0,y:0,width:60,height:25)
         languageButton.setTitle("ENGLISH".localized, for: .normal)
         languageButton.setTitleColor(UIColor.white, for: .normal)
         languageButton.backgroundColor = UIColor.init(red: 232.0/255.0, green: 126.0/255.0, blue: 51.0/255.0, alpha: 1.0)
         languageButton.addTarget(self, action: #selector(languageButtonClicked), for: .touchUpInside)
         languageButton.titleLabel?.font = UIFont.systemFont(ofSize: 11.0)
         AppHelper.setRoundCornersToView(borderColor: UIColor.init(red: 232.0/255.0, green: 126.0/255.0, blue: 51.0/255.0, alpha: 1.0), view:languageButton , radius:2.0, width: 1.0)
         let rightBarButton = UIBarButtonItem()
         rightBarButton.customView = languageButton
         self.navigationItem.rightBarButtonItem = rightBarButton*/
        
        mobileNumTextField.textFieldType = AITextField.AITextFieldType.PhoneNumberTextField
        mobileNumTextField.createBorder(borderColor: UIColor.white,xpos: 0)
        mobileNumTextField.setLeftGap(width: 0, placeHolderImage: UIImage.init())
        mobileNumTextField.setRightGap(width: 0, placeHolderImage: UIImage.init())
        mobileNumTextField.placeHolderLabel = mobileNumLabel
        mobileNumTextField.selectedColor = UIColor(white: 1, alpha: 1)
        mobileNumTextField.normalColor = UIColor(white: 1, alpha: 0.7)
        mobileNumTextField.updateUIAsPerTextFieldType()
        
        passwordTextField.textFieldType = AITextField.AITextFieldType.PasswordTextField
        passwordTextField.createBorder(borderColor: UIColor.white,xpos: 0)
        passwordTextField.setLeftGap(width: 0, placeHolderImage: UIImage.init())
        passwordTextField.setRightGap(width: 0, placeHolderImage: UIImage.init())
        passwordTextField.placeHolderLabel = passwordLabel
        passwordTextField.selectedColor = UIColor(white: 1, alpha: 1)
        passwordTextField.normalColor = UIColor(white: 1, alpha: 0.7)
        passwordTextField.updateUIAsPerTextFieldType()
        
        //mobileNumTextField.defaultRegion = "+1"
        mobileNumTextField.aiDelegate = self
        passwordTextField.aiDelegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(animateWithKeyboard(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(animateWithKeyboard(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        bgScrollView.delegate = self
        
        languageSelectionButton = LanguageUtility.createLanguageSelectionButton(withTarge: self, action: #selector(languageButtonClicked))
        LanguageUtility.addLanguageButton(languageSelectionButton, toController: self)
        reloadContent()
        
        // Tap Gesuture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnTableView(recognizer:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        LanguageUtility.addOberverForLanguageChange(self, selector: #selector(reloadContent))
        reloadContent()
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        LanguageUtility.removeObserverForLanguageChange(self)
        super.viewDidDisappear(animated)
    }
    
    func updateTextFieldUi() {
        
        // mobileNumTextField.updateUIAsPerTextFieldType()
        
    }
    // MARK: -
    
    func tapOnTableView(recognizer: UITapGestureRecognizer) {
        
        self.view.endEditing(true)
    }
    
    
    func languageButtonClicked() {
        
        self.showLanguageSelectionAlert()
        
    }
    
    func reloadContent() {
        DispatchQueue.main.async {
            
            self.languageSelectionButton.setTitle("language.button.title".localized(), for: .normal)
            self.loginWithFacebookButton.setTitle("Log In with Facebook".localized(), for: .normal)
            self.orLabel.text = "or".localized()
            self.updateTextFieldUi()
            self.mobileNumLabel.text = "10-DIGIT CELL PHONE NUMBER".localized()
            self.passwordLabel.text = "PASSWORD".localized()
            self.forgotPasswordButton.setTitle("Forgot Password?".localized(), for: .normal)
            self.loginButton.setTitle("LOG IN".localized(), for: .normal)
            self.title = "Log In".localized()
            self.updateBackButtonText()
            
        }
    }
    
    
    func animateWithKeyboard(notification: NSNotification) {
        
        // Based on both Apple's docs and personal experience,
        // I assume userInfo and its documented keys are available.
        // If you'd like, you can remove the forced unwrapping and add your own default values.
        
        let userInfo = notification.userInfo!
        
        let moveUp = (notification.name == NSNotification.Name.UIKeyboardWillShow) as Bool
        if moveUp
        {
            var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
            keyboardFrame = self.bgScrollView.convert(keyboardFrame, from: nil)
            
            var contentInset:UIEdgeInsets = bgScrollView.contentInset
            contentInset.bottom = keyboardFrame.size.height
            // contentInset.top = 0
            bgScrollView.contentInset = contentInset
            //print(""scrollView content inset in loop \(bgScrollView.contentInset)")
        }
        else
        {
            var contentInset:UIEdgeInsets = UIEdgeInsets.zero
            contentInset.top = 0;
            bgScrollView.contentInset = contentInset
            //print(""scrollView content inset out of loop \(bgScrollView.contentInset)")
        }
        
    }
    
    func backButtonAction(){
        
        _ = self.navigationController?.popToRootViewController(animated: true)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        // clear password field
        self.passwordTextField.text = nil
        
        reloadContent()
        self.navigationController?.navigationBar.isHidden = false;
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        // Sets shadow (line below the bar) to a blank image
        self.navigationController?.navigationBar.shadowImage = UIImage()
        // Sets the translucent background color
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear        // Set translucent. (Default value is already true, so this can be removed if desired.)
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        let lineView = UIView(frame: CGRect(x: 0, y: 44, width: SCREEN_WIDTH, height: 1))
        lineView.backgroundColor = UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.4)
        
        self.navigationController?.navigationBar.addSubview(lineView)
        // bgScrollView.contentSize = CGSize(width : 0, height:loginButton.frame.maxY+40)
        
        AppHelper.getScreenName(screenName: "Login screen")

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func keyBoardHidden(textField:UITextField) {
        
        if textField == mobileNumTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
    }
    
    
    func aiTextField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField == mobileNumTextField)
        {
            let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            let compo = newString.components(separatedBy: NSCharacterSet.decimalDigits.inverted)
            let decimalString = compo.joined(separator: "") as NSString
            let length = decimalString.length
            let hasLeadingOne = length > 0 && decimalString.character(at: 0) == (1 as unichar)
            
            if length == 0 || (length > 10 && !hasLeadingOne) || length > 11
            {
                let newLength = (textField.text! as NSString).length + (string as NSString).length - range.length as Int
                
                return (newLength > 10) ? false : true
            }
            var index = 0 as Int
            let formattedString = NSMutableString()
            
            if hasLeadingOne
            {
                formattedString.append("1 ")
                index += 1
            }
            if (length - index) > 3
            {
                let areaCode = decimalString.substring(with: NSMakeRange(index, 3))
                formattedString.appendFormat("(%@)", areaCode)
                index += 3
            }
            if length - index > 3
            {
                let prefix = decimalString.substring(with: NSMakeRange(index, 3))
                formattedString.appendFormat(" %@-", prefix)
                index += 3
            }
            
            let remainder = decimalString.substring(from: index)
            formattedString.append(remainder)
            textField.text = formattedString as String
            return false
        }
        else
        {
            return true
        }
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 0.0
        {
            self.setNavigationBarImage(image: blueNavBarImg)
        }
        else
        {
            self.setTransparentNavigationBar()
        }
    }
    func setNavigationBarImage(image:UIImage)
    {
        self.navigationController?.navigationBar.setBackgroundImage(image, for: UIBarMetrics.default)
        
    }
    func setTransparentNavigationBar()
    {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    
    func userLogin() {
        
        let reachbility:NetworkReachabilityManager = NetworkReachabilityManager()!
        let isReachable = reachbility.isReachable
        // Reachability
        if isReachable == false {
            self.showAlert(title: "", message: "Please check your internet connection".localized());
            return
        }
        
        let password = passwordTextField.text ?? ""
        let phoneNumber = AppHelper.removeSpecialCharacters(fromNumber: mobileNumTextField.text!)
        
        let mobileNumber = phoneNumber
        let device_id = UIDevice.current.identifierForVendor!.uuidString
        let currentLanguage = Localize.currentLanguage()
        let socialId = ""
        let version_name = Bundle.main.releaseVersionNumber ?? ""
        let version_code = Bundle.main.buildVersionNumber ?? ""
        
        
        let parameters : Parameters = ["username": mobileNumber,
                          "password": password,
                          "social_id": socialId,
                          "platform":"1",
                          "version_code":  version_code,
                          "version_name": version_name,
                          "device_id": device_id,
                          "push_token":"123123",
                          "language": currentLanguage
            ]
        
        //print("parameters)
        loginActivityIndicator.startAnimating()
        let url = String(format: "%@/logIn", hostUrl)
        //print("url)
        Alamofire.postRequest(URL(string:url)!, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response:DataResponse<Any>) in
            
            switch response.result {
            case .success:
                DispatchQueue.main.async {
                    self.loginActivityIndicator.stopAnimating()
                }
                
                let json = JSON(data: response.data!)
                print("json response\(json)")
                let responseDict = json.dictionaryObject
                if let code = responseDict?["code"] {
                    let code = code as! NSNumber
                    if code.intValue == 200 {
                        
                        if let userDict = responseDict?["user"] {
                            self.user = User.prepareUser(dictionary: userDict as! [String : Any])
                            self.user.auth_token = responseDict?["auth_token"] as! String
                            AppDelegate.getDelegate().user = self.user
                            
                            let userData = NSKeyedArchiver.archivedData(withRootObject: self.user)
                            UserDefaults.standard.set(userData, forKey: LOGGED_USER)
                        }
                        
                        if let info_screens = responseDict?["info_screens"]{
                            let infoScreen  = info_screens
                            UserDefaults.standard.set(infoScreen, forKey:INFO_SCREENS)
                        }
                        
                        if let auth_token = responseDict?["auth_token"] as? String {
                            UserDefaults.standard.set(auth_token, forKey: AUTH_TOKEN)
                            
                            if let userDict = responseDict?["user"] as? [String:Any] {
                                let user_id = userDict["id"]
                                UserDefaults.standard.set(user_id, forKey: USER_ID)
                                let autoLogin = userDict["auto_login"]
                                UserDefaults.standard.set(autoLogin, forKey: USER_AUTOLOGIN)
                            }
                            
                            UserDefaults.standard.synchronize()
                            self.presentHome()
                        }
                    }
                    else {
                        
                        if let responseDict = json.dictionaryObject {
                            let alertMessage = responseDict["message"] as! String
                            self.showAlert(title: "", message: alertMessage)
                        }
                    }
                }
                
                break
                
            case .failure(let error):
                
                DispatchQueue.main.async {
                    self.loginActivityIndicator.stopAnimating()
                    self.showAlert(title: "", message:error.localizedDescription);
                }
                //print("error)
                break
            }
            
            
        }
        
        
    }
    
    
    func presentHome() {
        self.performSegue(withIdentifier: "HomeStoryboard", sender: self)
    }
    
    func isValid() -> Bool {
        // let phoneNumber = mobileNumTextField.text?.replacingOccurrences(of: "-", with: "")
        let phoneNumber = AppHelper.removeSpecialCharacters(fromNumber: mobileNumTextField.text!)
        let validNum = AppHelper.validate(value: phoneNumber)
        
        if ((mobileNumTextField.text?.characters.count)! == 0 || validNum == false ) {
            showAlert(title: "", message: "Please enter a 10-digit cell phone number.".localized())
            return false
        }
        else if (passwordTextField.text?.characters.count)! < 6 {
            self.showAlert(title: "", message: "Password must be at least 6 characters in length.".localized())
            return false
        }
        return true
    }
    
    // MARK: - faceBookLogin
    
    func didFacebookLoginFail() {
        facebookActivityIndicator.stopAnimating()
    }
    
    func didFacebookLoginSuccess() {
        faceBookLogin.getBasicInformation()
    }
    
    func didReceiveUser(information: [String : Any]) {
        print("information is\(information)")
        faceBookDict = information
        self.checkFacebookUser()
    }
    
    func checkFacebookUser() {
        
        let reachbility:NetworkReachabilityManager = NetworkReachabilityManager()!
        let isReachable = reachbility.isReachable
        // Reachability
        if isReachable == false {
            self.showAlert(title: "", message: "Please check your internet connection".localized());
            return
        }
        
        let device_id = UIDevice.current.identifierForVendor!.uuidString
        let currentLanguage = Localize.currentLanguage()
        let socialId = faceBookDict?["id"] as? String ?? ""
        let version_name = Bundle.main.releaseVersionNumber ?? ""
        let version_code = Bundle.main.buildVersionNumber ?? ""

        let parameters : Parameters  = ["social_id": socialId,
                          "platform":"1",
                          "version_code": version_code,
                          "version_name": version_name,
                          "device_id": device_id,
                          "push_token":"123123",
                          "language": currentLanguage
            ]
        
        //print("parameters)
        let url = String(format: "%@/checkFbUser", hostUrl)
        //print("url)
        Alamofire.postRequest(URL(string:url)!, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response:DataResponse<Any>) in
            
            switch response.result {
            case .success:
                DispatchQueue.main.async {
                    self.facebookActivityIndicator.stopAnimating()
                }
                
                let json = JSON(data: response.data!)
                print("json response\(json)")
                let responseDict = json.dictionaryObject
                if let code = responseDict?["code"] {
                    let code = code as! NSNumber
                    if code.intValue == 200 {
                        
                        if let userDict = responseDict?["user"] {
                            self.user = User.prepareUser(dictionary: userDict as! [String : Any])
                            self.user.auth_token = responseDict?["auth_token"] as! String
                            AppDelegate.getDelegate().user = self.user
                            
                            let userData = NSKeyedArchiver.archivedData(withRootObject: self.user)
                            UserDefaults.standard.set(userData, forKey: LOGGED_USER)
                            
                            
                        }
                        if let info_screens = responseDict?["info_screens"]{
                            let infoScreen  = info_screens
                            
                            UserDefaults.standard.set(infoScreen, forKey:INFO_SCREENS)
                            
                        }
                        
                        if let auth_token = responseDict?["auth_token"] as? String {
                            UserDefaults.standard.set(auth_token, forKey: AUTH_TOKEN)
                            
                            if let userDict = responseDict?["user"] as? [String:Any] {
                                let user_id = userDict["id"]
                                UserDefaults.standard.set(user_id, forKey: USER_ID)
                                
                                let autoLogin = userDict["auto_login"]
                                UserDefaults.standard.set(autoLogin, forKey: USER_AUTOLOGIN)
                            }
                            
                            if let autoLogin = responseDict?["auto_login"] {
                                UserDefaults.standard.set(autoLogin, forKey: USER_AUTOLOGIN)
                            }
                            UserDefaults.standard.synchronize()
                            self.presentHome()
                        }
                    }
                        
                    else if code.intValue == 400 {
                        if let responseDict = json.dictionaryObject {
                            let alertMessage = responseDict["message"] as! String
                            self.showAlert(title: "", message: alertMessage)
                        }
                    }
                        
                        
                    else {
                        
                        let signUpVc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignupTVC") as! SignUpTVC
                        signUpVc.facebookDict = self.faceBookDict
                        self.navigationController?.show(signUpVc, sender: self)
                    }
                    
                }
                
                break
                
            case .failure(let error):
                
                DispatchQueue.main.async {
                    self.facebookActivityIndicator.stopAnimating()
                    self.showAlert(title: "", message:error.localizedDescription);
                }
                //print("error)
                break
            }
            
        }
    }
    
    
    
}

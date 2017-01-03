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

class LoginVC: UIViewController,AITextFieldProtocol,UITextFieldDelegate,UIScrollViewDelegate {
    
    var languageSelectionButton: UIButton!
    var user:User = User()
    var blueNavBarImg = AppHelper.imageWithColor(color: APP_GRREN_COLOR)
    
    @IBOutlet var bgContainerView: UIView!
    @IBOutlet var bgScrollView: UIScrollView!
    @IBOutlet var FbLoginBgView: UIView!
    @IBOutlet var loginWithFacebookButton: UIButton!
    @IBOutlet var forgotPasswordButton: UIButton!
    @IBOutlet var passwordTextField: AITextField!
    @IBOutlet var passwordLabel: UILabel!
    @IBOutlet var mobileNumTextField: AITextField!
    @IBOutlet var mobileNumLabel: UILabel!
    @IBOutlet var orLabel: UILabel!
    
    @IBOutlet var loginButton: UIButton!
    
    @IBOutlet var loginActivityIndicator: UIActivityIndicatorView!
    
    @IBAction func loginButtonAction(_ sender: UIButton) {
        if !isValid(){
            return
        }
        userLogin()
    }
    
    @IBAction func forgotPasswordButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        let forgotPasswordVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ForgotPasswordVC")
        self.navigationController?.show(forgotPasswordVC, sender: self)
        
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
        backButton.setTitleColor(UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.7), for: .normal)
        
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
        
        mobileNumTextField.aiDelegate = self
        passwordTextField.aiDelegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(animateWithKeyboard(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(animateWithKeyboard(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        bgScrollView.delegate = self
        
        languageSelectionButton = LanguageUtility.createLanguageSelectionButton(withTarge: self, action: #selector(languageButtonClicked))
        LanguageUtility.addLanguageButton(languageSelectionButton, toController: self)
        reloadContent()
        
        
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
    
    func languageButtonClicked() {
        
        self.showLanguageSelectionAlert()
        
    }
    
    func reloadContent() {
        DispatchQueue.main.async {
            
            self.languageSelectionButton.setTitle("language.button.title".localized(), for: .normal)
            self.loginWithFacebookButton.setTitle("Log In with Facebook".localized(), for: .normal)
            self.orLabel.text = "or".localized()
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
            print("scrollView content inset in loop \(bgScrollView.contentInset)")
        }
        else
        {
            var contentInset:UIEdgeInsets = UIEdgeInsets.zero
            contentInset.top = 0;
            bgScrollView.contentInset = contentInset
            print("scrollView content inset out of loop \(bgScrollView.contentInset)")
        }
        
    }
    
    func backButtonAction(){
        
        _ = self.navigationController?.popToRootViewController(animated: true)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
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
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        ////print("scrollViewDidScroll \(scrollView.contentOffset)")
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
        //self.navigationController?.navigationBar.backgroundColor = UIColor.clear
        
    }
    func setTransparentNavigationBar()
    {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    
    func userLogin(){
        
        let password = passwordTextField.text ?? ""
        let mobileNumber = mobileNumTextField.text ?? ""
        let device_id = UIDevice.current.identifierForVendor!.uuidString
        
        let parameters = ["username": mobileNumber,
                          "password": password,
                          "social_id":"",
                          "platform":"1",
                          "version_code": "1",
                          "version_name": "1",
                          "device_id": device_id,
                          "push_token":"123123",
                          "language":"en"
            ] as [String : Any]
        
        print(parameters)
        loginActivityIndicator.startAnimating()
        let url = String(format: "%@/logIn", hostUrl)
        print(url)
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
                            let userData = NSKeyedArchiver.archivedData(withRootObject: self.user)
                            UserDefaults.standard.set(userData, forKey: LOGGED_USER)
                        }
                        if let auth_token = responseDict?["auth_token"] as? String {
                            UserDefaults.standard.set(auth_token, forKey: AUTH_TOKEN)
                            
                            if let userDict = responseDict?["user"] as? [String:Any] {
                                let user_id = userDict["id"]
                                UserDefaults.standard.set(user_id, forKey: USER_ID)
                            }
                            
                            
                            self.presentHome()
                            
                        }
                    }
                    print("user id\(self.user.id)")
                    print("user info \(self.user.additionalInformation)")
                    
                }
                else {
                    
                    if let responseDict = json.dictionaryObject {
                        let alertMessage = responseDict["message"] as! String
                        self.showAlert(title: "", message: alertMessage)
                    }
                }
                
                break
                
            case .failure(let error):
                
                DispatchQueue.main.async {
                    self.loginActivityIndicator.stopAnimating()
                }
                print(error)
                break
            }
            
            
        }
        
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    func presentHome() {
        self.performSegue(withIdentifier: "HomeStoryboard", sender: self)
    }
    
    func isValid() -> Bool{
        let validNum = AppHelper.validate(value: mobileNumTextField.text!)
        
        if ((mobileNumTextField.text?.characters.count)! == 0 || validNum == false ){
            showAlert(title: "", message: "Please enter 10 digit Phone Number")
            return false
        }
        else if (passwordTextField.text?.characters.count)! < 6{
            self.showAlert(title: "", message: "Please enter Password")
            return false
        }
        return true
    }
    
}

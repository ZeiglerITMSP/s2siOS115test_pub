//
//  LoginVC.swift
//  Snap2Save
//
//  Created by Appit on 12/19/16.
//  Copyright © 2016 Appit. All rights reserved.
//

import UIKit



class LoginVC: UIViewController,AITextFieldProtocol,UITextFieldDelegate,UIScrollViewDelegate {
    
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
    
    
    @IBAction func loginButtonAction(_ sender: UIButton) {
        
    }
    @IBAction func forgotPasswordButtonAction(_ sender: UIButton) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Log In"
        AppHelper.setRoundCornersToView(borderColor: UIColor.init(red: 59.0/255.0, green: 89.0/255.0, blue: 152.0/255.0, alpha: 1.0), view:FbLoginBgView , radius:3.0, width: 1.0)
        loginWithFacebookButton.setTitle("Log In with Facebook".localized, for: .normal)
        orLabel.text = "or".localized
        mobileNumLabel.text = "10-DIGIT CELL PHONE NUMBER".localized
        passwordLabel.text = "PASSWORD".localized
        forgotPasswordButton.setTitle("Forgot Password?".localized, for: .normal)
        loginButton.setTitle("LOG IN".localized, for: .normal)
        
        let backButton = UIButton.init(type: .custom)
        backButton.frame = CGRect(x:0,y:0,width:80,height:25)
        backButton.setImage(UIImage.init(named: "ic_back"), for: .normal)
        backButton.setTitle("Back", for: .normal)
        backButton.setTitleColor(UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.7), for: .normal)
       
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 17.0)
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
       // ratingButton.contentEdgeInsets = UIEdgeInsets
        //UIEdgeInsetsMake(<#T##top: CGFloat##CGFloat#>, <#T##left: CGFloat##CGFloat#>, <#T##bottom: CGFloat##CGFloat#>, <#T##right: CGFloat##CGFloat#>)
        backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0)
        
        let leftBarButton = UIBarButtonItem()
        leftBarButton.customView = backButton
        self.navigationItem.leftBarButtonItem = leftBarButton
        print("loginButton\(loginButton.frame)")
        
        
        let languageButton = UIButton.init(type: .system)
        languageButton.frame = CGRect(x:0,y:0,width:60,height:25)
        languageButton.setTitle("ENGLISH".localized, for: .normal)
        languageButton.setTitleColor(UIColor.white, for: .normal)
        languageButton.backgroundColor = UIColor.init(red: 232.0/255.0, green: 126.0/255.0, blue: 51.0/255.0, alpha: 1.0)
        languageButton.addTarget(self, action: #selector(languageButtonClicked), for: .touchUpInside)
        languageButton.titleLabel?.font = UIFont.systemFont(ofSize: 11.0)
        AppHelper.setRoundCornersToView(borderColor: UIColor.init(red: 232.0/255.0, green: 126.0/255.0, blue: 51.0/255.0, alpha: 1.0), view:languageButton , radius:2.0, width: 1.0)
        let rightBarButton = UIBarButtonItem()
        rightBarButton.customView = languageButton
        self.navigationItem.rightBarButtonItem = rightBarButton

        mobileNumTextField.textFieldType = AITextField.AITextFieldType.PhoneNumberTextField
        mobileNumTextField.updateUIAsPerTextFieldType()
        mobileNumTextField.createBorder(borderColor: UIColor.white,xpos: 0)
        mobileNumTextField.setLeftGap(width: 0, placeHolderImage: UIImage.init())
        mobileNumTextField.setRightGap(width: 0, placeHolderImage: UIImage.init())
        mobileNumTextField.text_Color =  UIColor.white

        passwordTextField.textFieldType = AITextField.AITextFieldType.PasswordTextField
        passwordTextField.updateUIAsPerTextFieldType()
        passwordTextField.createBorder(borderColor: UIColor.white,xpos: 0)
        passwordTextField.setLeftGap(width: 0, placeHolderImage: UIImage.init())
        passwordTextField.setRightGap(width: 0, placeHolderImage: UIImage.init())
        passwordTextField.text_Color =  UIColor.white
        
        mobileNumTextField.delegate = self
        passwordTextField.delegate = self
        mobileNumTextField.aiDelegate = self
        passwordTextField.aiDelegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(animateWithKeyboard(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(animateWithKeyboard(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        print("loginButton\(loginButton.frame)")
        print("width \(self.view.bounds.size.width)")
        print("height \(self.view.bounds.size.height)")


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

    func languageButtonClicked(){
        
        let languageAlert = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        let englishBtn = UIAlertAction.init(title: "English".localized, style: .default, handler:{
            (action) in
            print("Selected English")
        })
        let spanishBtn = UIAlertAction.init(title: "Spanish".localized, style: .default, handler:{
            (action) in
            print("Selected Spanish")
            
        })
        let cancelBtn = UIAlertAction.init(title: "Cancel", style: .cancel, handler:{
            (action) in
            
        })
        
        languageAlert.view.tintColor = APP_GRREN_COLOR
        languageAlert .addAction(englishBtn)
        languageAlert.addAction(spanishBtn)
        languageAlert.addAction(cancelBtn)
        
        self.present(languageAlert, animated: true, completion:nil)

    }
    func backButtonAction(){
        
       _ = self.navigationController?.popViewController(animated: true)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
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
    
    func keyBoardHidden(textField:UITextField){
        if textField == mobileNumTextField {
            passwordTextField.becomeFirstResponder()
        }
       textField.resignFirstResponder()
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == mobileNumTextField {
            passwordTextField.becomeFirstResponder()
        }
        textField.resignFirstResponder()
        return true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        ////print("scrollViewDidScroll \(scrollView.contentOffset)")
        if scrollView.contentOffset.y > 0.0
        {
            //self.setNavigationBarImage(image: blueNavBarImg)
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


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

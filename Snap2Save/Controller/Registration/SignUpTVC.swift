//
//  SignUpTVC.swift
//  Snap2Save
//
//  Created by Malathi on 21/12/16.
//  Copyright © 2016 Appit. All rights reserved.
//

import UIKit
import Localize_Swift
import Alamofire
import SwiftyJSON

class SignUpTVC: UITableViewController,FacebookLoginDelegate,FacebookDataDelegate {
    
    var languageSelectionButton: UIButton!
    let faceBookLogin : FacebookLogin = FacebookLogin()
    
    var facebookDict:[String : Any]? = nil
    var user:User = User()
    var checkButtonSelected : Bool = false
    
    @IBOutlet var checkButton: UIButton!
    @IBOutlet var messageTextView: UITextView!
    
    @IBOutlet var facebookActivityIndicator: UIActivityIndicatorView!
    @IBOutlet var reEnterEmailMandatoryLabel: UILabel!
    @IBOutlet var emailManditoryLabel: UILabel!
    @IBOutlet var loginWithFBButton: UIButton!
    @IBOutlet var facebookBtnBgView: UIView!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var earn100PointsLabel: UILabel!
    
    @IBOutlet var mobileNumTextField: AITextField!
    @IBOutlet var mobileNumLabel: UILabel!
    @IBOutlet var requiredInfoLabel: UILabel!
    
    @IBOutlet var reEnterMobileNumLabel: UILabel!
    @IBOutlet var reEnterMobileNumTextField: AITextField!
    
    @IBOutlet var passwordLabel: UILabel!
    @IBOutlet var passwordTextField: AITextField!
    
    @IBOutlet var reEnterPasswordLabel: UILabel!
    @IBOutlet var reEnterPasswordTextField: AITextField!
    
    @IBOutlet var zipCodeLabel: UILabel!
    
    @IBOutlet var zipCodeTextField: AITextField!
    
    @IBOutlet var contactPreferenceLabel: UILabel!
    
    @IBOutlet var contactPreferenceSegmentControl: UISegmentedControl!
    
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var emailTextField: AITextField!
    
    
    @IBOutlet weak var termsTextView: UITextView!
    
    @IBOutlet var continueButton: UIButton!
    @IBOutlet var reEnterEmailTextField: AITextField!
    @IBOutlet var reEnterEmailLabel: UILabel!
    
    
    @IBAction func loginWithFbButtonAction(_ sender: Any) {
        facebookActivityIndicator.startAnimating()
        faceBookLogin.delegate = self
        faceBookLogin.dataSource = self
        faceBookLogin.loginWithFacebook()
        
    }
    
    @IBAction func contactPreferenceSegmentControl(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 1 {
            emailManditoryLabel.isHidden = false
            reEnterEmailMandatoryLabel.isHidden = false
        }
        else if sender.selectedSegmentIndex == 0 {
            emailManditoryLabel.isHidden = true
            reEnterEmailMandatoryLabel.isHidden = true
        }
    }
    
    @IBAction func checkButtonAction(_ sender: UIButton) {
        
        if checkButtonSelected == false {
            checkButton.setImage(UIImage.init(named: "checkOn"), for: .normal)
            checkButtonSelected = true
        }
        else
        {
            checkButton.setImage(UIImage.init(named: "checkOff"), for: .normal)
            checkButtonSelected = false
        }
        
    }
    @IBAction func continueButtonClicked(_ sender: UIButton) {
        
        if !isValidData(){
            return
        }
        
        let socialId = facebookDict?["id"] ?? ""
       // let email = facebookDict?["email"] ?? ""
        let firstName = facebookDict?["first_name"] ?? ""
        let lastName = facebookDict?["last_name"] ?? ""
        let gender = facebookDict?["gender"] ?? "";
        let phoneNumber = AppHelper.removeSpecialCharacters(fromNumber: mobileNumTextField.text!)
        
        let userDetails:[String:Any] = ["phone_number":phoneNumber,
                                        "password":passwordTextField.text ?? "",
                                        "zipcode":zipCodeTextField.text ?? "",
                                        "contact_preference":contactPreferenceSegmentControl.selectedSegmentIndex,
                                        "email":emailTextField.text ?? "",
                                        "social_id": socialId,
                                        "first_name": firstName,
                                        "last_name" : lastName,
                                        "gender" : gender
                                        ];
        
        let additionalSignUpVc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignupAdditionalFieldsTVC") as! SignupAdditionalFieldsTVC
        additionalSignUpVc.userDetailsDict = userDetails
        self.navigationController?.show(additionalSignUpVc, sender: self)
        
       
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.title = "Register"
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 60
        self.navigationController?.navigationBar.isHidden = false
        
        loadTextFields()
        
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
        
        let navBarBGImg = AppHelper.imageWithColor(color: APP_GRREN_COLOR)
        // super.setNavigationBarImage(image: navBarBGImg)
        self.navigationController?.navigationBar.setBackgroundImage(navBarBGImg, for: .default)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        languageSelectionButton = LanguageUtility.createLanguageSelectionButton(withTarge: self, action: #selector(languageButtonClicked))
        LanguageUtility.addLanguageButton(languageSelectionButton, toController: self)
        
        reloadContent()
        
        // Tap Gesuture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnTableView(recognizer:)))
        self.view.addGestureRecognizer(tapGesture)
        
        let email =  facebookDict?["email"] ?? ""
        emailTextField.text = email as? String
        
    }

    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        if contactPreferenceSegmentControl.selectedSegmentIndex == 1{
            emailManditoryLabel.isHidden = false
            reEnterEmailMandatoryLabel.isHidden = false
        }
        else if contactPreferenceSegmentControl.selectedSegmentIndex == 0{
            emailManditoryLabel.isHidden = true
            reEnterEmailMandatoryLabel.isHidden = true
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        LanguageUtility.addOberverForLanguageChange(self, selector: #selector(reloadContent))
        reloadContent()
    }
    

    override func viewDidDisappear(_ animated: Bool) {
        
//        mobileNumTextField.aiDelegate = nil
//        reEnterMobileNumTextField.aiDelegate = nil
//        passwordTextField.aiDelegate = nil
//        reEnterPasswordTextField.aiDelegate = nil
//        zipCodeTextField.aiDelegate = nil
//        emailTextField.aiDelegate = nil
//        reEnterEmailTextField.aiDelegate = nil
        
        self.view.endEditing(true)
        LanguageUtility.removeObserverForLanguageChange(self)
        
        super.viewDidDisappear(animated)
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
            self.updateBackButtonText()
            self.title = "Register".localized()
            self.earn100PointsLabel.text = "EARN 100 POINTS!".localized()
            self.updateMessageText()
           // self.messageLabel.text = "RegisterMessage".localized()
            self.loginWithFBButton.setTitle("Register with Facebook".localized(), for: .normal);
            self.requiredInfoLabel.text = "*Required information".localized()
            
            
            self.emailLabel.text = "EMAIL".localized()
            self.reEnterEmailLabel.text = "RE-ENTER EMAIL".localized()
            self.contactPreferenceSegmentControl.setTitle("Text Message".localized(), forSegmentAt: 0)
            self.contactPreferenceSegmentControl.setTitle("Email".localized(), forSegmentAt: 1)
            
            self.updateTermsText()
            
            self.continueButton.setTitle("CONTINUE".localized(), for: .normal)
            
            self.updateTextFieldsUi()
            
            self.mobileNumLabel.attributedText = "10-DIGIT CELL PHONE NUMBER".localized().makeAsRequired()
            self.reEnterMobileNumLabel.attributedText = "RE-ENTER 10-DIGIT CELL PHONE NUMBER".localized().makeAsRequired()
            self.passwordLabel.attributedText = "PASSWORD (MUST BE AT LEAST 6 CHARACTERS)".localized().makeAsRequired()
            self.reEnterPasswordLabel.attributedText = "RE-ENTER PASSWORD".localized().makeAsRequired()
            self.zipCodeLabel.attributedText = "ZIP CODE".localized().makeAsRequired()
            self.contactPreferenceLabel.attributedText = "CONTACT PREFERENCE".localized().makeAsRequired()
            
            
            self.tableView.reloadData()
        }
    }
    
    
    func updateMessageText() {
        
        let fullMessage = "RegisterMessage".localized()
        let rangeMessage = "Reward Program".localized()
        
        var link = ""
        
        if Localize.currentLanguage() == "en" {
            link = reward_program_en
        }
        else if Localize.currentLanguage() == "es" {
            link = reward_program_es
        }
        
        let attributedString = NSMutableAttributedString(string: fullMessage)
        
        let fullMessageRange = (attributedString.string as NSString).range(of: fullMessage)
        // default text style
        attributedString.addAttribute(NSForegroundColorAttributeName, value: self.messageTextView.textColor!, range: fullMessageRange)
        attributedString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 14), range: fullMessageRange)
        let titleParagraphStyle = NSMutableParagraphStyle()
        titleParagraphStyle.alignment = .left
        attributedString.addAttribute(NSParagraphStyleAttributeName, value: titleParagraphStyle, range: fullMessageRange)
        
        // linkRange
        let linkRange = (attributedString.string as NSString).range(of: rangeMessage)
        attributedString.addAttribute(NSLinkAttributeName, value: link, range: linkRange)
        
        let linkAttributes = [
            NSForegroundColorAttributeName: UIColor.white,
            NSUnderlineColorAttributeName: UIColor.white,
            NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue ] as [String : Any]
        
        // textView is a UITextView
        self.messageTextView.linkTextAttributes = linkAttributes
        self.messageTextView.attributedText = attributedString
        
        self.messageTextView.isScrollEnabled = false
        
    }

    func updateTermsText() {
        
        // Terms of Service
        let fullMessage = "TermsMessage".localized().makeAsRequired()
        //let rangeMessage = "TermsLink".localized()
        let rangeMessage = "Terms of Service"

        let rangeMessage2 = "*"
        //let range2 : NSMutableAttributedString = NSMutableAttributedString.init(string: " *")
        
       // let color : UIColor = UIColor.init(colorLiteralRed: 236.0/255.0, green: 80.0/255.0, blue: 30.0/255.0, alpha: 1.0)
        
      //  range2.addAttribute(NSForegroundColorAttributeName, value: color, range: fullMessageRange2)
        
        var link = ""
        if Localize.currentLanguage() == "en" {
            link = terms_en
        }
        else if Localize.currentLanguage() == "es" {
            link = terms_es
        }

        
        let range = (fullMessage.string as NSString).range(of: rangeMessage)
        let range1 = (fullMessage.string as NSString).range(of: rangeMessage2)


        let attributedString : NSMutableAttributedString = fullMessage as! NSMutableAttributedString
        // 148 148 153
        let fullMessageRange = (attributedString.string as NSString).range(of: fullMessage.string)
        //let fullMessageRange2 = (attributedString.string as NSString).range(of:rangeMessage2)

        let textColor = UIColor.init(red: 148.0/255.0, green: 148.0/255.0, blue: 153.0/255.0, alpha: 1.0)
        // default text style
        attributedString.addAttribute(NSForegroundColorAttributeName, value: textColor, range: range)
        
        attributedString.addAttribute(NSForegroundColorAttributeName, value: MandatoryColor, range: range1)

        attributedString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 15), range: fullMessageRange)
        let titleParagraphStyle = NSMutableParagraphStyle()
        titleParagraphStyle.alignment = .center
        
        attributedString.addAttribute(NSParagraphStyleAttributeName, value: titleParagraphStyle, range: fullMessageRange)
        
        
        // linkRange
        let linkRange = (attributedString.string as NSString).range(of: rangeMessage)
        attributedString.addAttribute(NSLinkAttributeName, value: link, range: linkRange)
        
        let linkAttributes = [
            NSForegroundColorAttributeName: UIColor.black,
            NSUnderlineColorAttributeName: UIColor.black,
            NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue ] as [String : Any]
        
       // attributedString.append(range2)
        
        // textView is a UITextView
        self.termsTextView.linkTextAttributes = linkAttributes
        self.termsTextView.attributedText = attributedString
        self.termsTextView.textAlignment = .left
        self.termsTextView.isScrollEnabled = false
        
       // self.termsTextView.contentSize = self.termsTextView.bounds.size
    }
    
    func backButtonAction(){
        
        self.view.endEditing(true)
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    func loadTextFields(){
        
        self.updateTermsText()
        
        mobileNumTextField.textFieldType = AITextField.AITextFieldType.PhoneNumberTextField
        mobileNumTextField.updateUIAsPerTextFieldType()
        mobileNumTextField.createUnderline(withColor: APP_LINE_COLOR, padding: 0, height: 1)
        mobileNumTextField.placeHolderLabel = mobileNumLabel
        //        mobileNumTextField.createBorder(borderColor: UIColor.red,xpos: 0)
        mobileNumTextField.setLeftGap(width: 0, placeHolderImage: UIImage.init())
        mobileNumTextField.setRightGap(width: 0, placeHolderImage: UIImage.init())
        mobileNumTextField.text_Color =  UIColor.black
        
        reEnterMobileNumTextField.textFieldType = AITextField.AITextFieldType.PhoneNumberTextField
        reEnterMobileNumTextField.updateUIAsPerTextFieldType()
        // reEnterMobileNumTextField.createBorder(borderColor:APP_LINE_COLOR,xpos: 0)
        reEnterMobileNumTextField.createUnderline(withColor: APP_LINE_COLOR, padding: 0, height: 1)
        reEnterMobileNumTextField.placeHolderLabel = reEnterMobileNumLabel
        reEnterMobileNumTextField.setLeftGap(width: 0, placeHolderImage: UIImage.init())
        reEnterMobileNumTextField.setRightGap(width: 0, placeHolderImage: UIImage.init())
        reEnterMobileNumTextField.text_Color =  UIColor.black
        
        passwordTextField.textFieldType = AITextField.AITextFieldType.PasswordTextField
        passwordTextField.updateUIAsPerTextFieldType()
        passwordTextField.createUnderline(withColor: APP_LINE_COLOR, padding: 0, height: 1)
        passwordTextField.placeHolderLabel = passwordLabel
        
        // passwordTextField.createBorder(borderColor: APP_LINE_COLOR,xpos: 0)
        passwordTextField.setLeftGap(width: 0, placeHolderImage: UIImage.init())
        passwordTextField.setRightGap(width: 0, placeHolderImage: UIImage.init())
        passwordTextField.text_Color =  UIColor.black
        reEnterPasswordTextField.textFieldType = AITextField.AITextFieldType.PasswordTextField
        reEnterPasswordTextField.updateUIAsPerTextFieldType()
        reEnterPasswordTextField.createUnderline(withColor: APP_LINE_COLOR, padding: 0, height: 1)
        reEnterPasswordTextField.placeHolderLabel = reEnterPasswordLabel
        
        // reEnterPasswordTextField.createBorder(borderColor: APP_LINE_COLOR,xpos: 0)
        reEnterPasswordTextField.setLeftGap(width: 0, placeHolderImage: UIImage.init())
        reEnterPasswordTextField.setRightGap(width: 0, placeHolderImage: UIImage.init())
        reEnterPasswordTextField.text_Color =  UIColor.black
        
        zipCodeTextField.textFieldType = AITextField.AITextFieldType.NumberTextField
        zipCodeTextField.updateUIAsPerTextFieldType()
        zipCodeTextField.createUnderline(withColor: APP_LINE_COLOR, padding: 0, height: 1)
        zipCodeTextField.placeHolderLabel = zipCodeLabel
        
        //zipCodeTextField.createBorder(borderColor: APP_LINE_COLOR,xpos: 0)
        zipCodeTextField.setLeftGap(width: 0, placeHolderImage: UIImage.init())
        zipCodeTextField.setRightGap(width: 0, placeHolderImage: UIImage.init())
        zipCodeTextField.text_Color =  UIColor.black
        
        emailTextField.textFieldType = AITextField.AITextFieldType.EmailTextField
        emailTextField.updateUIAsPerTextFieldType()
        emailTextField.createUnderline(withColor: APP_LINE_COLOR, padding: 0, height: 1)
        emailTextField.placeHolderLabel = emailLabel
        
        //emailTextField.createBorder(borderColor: APP_LINE_COLOR,xpos: 0)
        emailTextField.setLeftGap(width: 0, placeHolderImage: UIImage.init())
        emailTextField.setRightGap(width: 0, placeHolderImage: UIImage.init())
        emailTextField.text_Color =  UIColor.black
        
        reEnterEmailTextField.textFieldType = AITextField.AITextFieldType.EmailTextField
        reEnterEmailTextField.updateUIAsPerTextFieldType()
        reEnterEmailTextField.createUnderline(withColor: APP_LINE_COLOR, padding: 0, height: 1)
        reEnterEmailTextField.placeHolderLabel = reEnterEmailLabel
        
        // reEnterEmailTextField.createBorder(borderColor:APP_LINE_COLOR,xpos: 0)
        reEnterEmailTextField.setLeftGap(width: 0, placeHolderImage: UIImage.init())
        reEnterEmailTextField.setRightGap(width: 0, placeHolderImage: UIImage.init())
        reEnterEmailTextField.text_Color =  UIColor.black
        
        AppHelper.setRoundCornersToView(borderColor: APP_ORANGE_COLOR, view: continueButton, radius: 2.0, width: 1)
        AppHelper.setRoundCornersToView(borderColor: UIColor.init(red: 59.0/255.0, green: 89.0/255.0, blue: 152.0/255.0, alpha: 1.0), view:facebookBtnBgView , radius:3.0, width: 1.0)
        
        
      /*  mobileNumTextField.delegate = self
        reEnterMobileNumTextField.delegate = self
        passwordTextField.delegate = self
        reEnterPasswordTextField.delegate = self
        zipCodeTextField.delegate = self
        emailTextField.delegate = self
        reEnterEmailTextField.delegate = self*/
        
        mobileNumTextField.aiDelegate = self
        reEnterMobileNumTextField.aiDelegate = self
        passwordTextField.aiDelegate = self
        reEnterPasswordTextField.aiDelegate = self
        zipCodeTextField.aiDelegate = self
        emailTextField.aiDelegate = self
        reEnterEmailTextField.aiDelegate = self
 
    }
    
    func updateTextFieldsUi(){
        
        mobileNumTextField.updateUIAsPerTextFieldType()
        reEnterMobileNumTextField.updateUIAsPerTextFieldType()
        passwordTextField.updateUIAsPerTextFieldType()
        reEnterPasswordTextField.updateUIAsPerTextFieldType()
        zipCodeTextField.updateUIAsPerTextFieldType()
        emailTextField.updateUIAsPerTextFieldType()
        reEnterEmailTextField.updateUIAsPerTextFieldType()

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 14
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let socialId : String = facebookDict?["id"] as! String? ?? ""
        
        if indexPath.row == 5 {
            if  !socialId.isEmpty {
                return 0
            }
        } else if indexPath.row == 6 {
            if  !socialId.isEmpty {
                return 0
            }
    }
        
        return UITableViewAutomaticDimension
    }

    func isValidData() -> Bool{
        
        //let validMobileNum = AppHelper.validMobileNumber(mobileNumber: mobileNumTextField.text!)
        
        let phoneNumber = AppHelper.removeSpecialCharacters(fromNumber: mobileNumTextField.text!)
        let validMobileNum = AppHelper.validate(value: phoneNumber)
        let validEmail = AppHelper.isValidEmail(testStr: emailTextField.text!)
        let socialId : String = facebookDict?["id"] as! String? ?? ""
        
        if mobileNumTextField.text?.characters.count == 0 || validMobileNum == false {
            showAlert(title: "", message: "Please enter a 10-digit cell phone number.".localized())
            return false
        }
        
        if reEnterMobileNumTextField.text != mobileNumTextField.text {
            showAlert(title: "", message: "Entries must match to proceed.".localized())
            return false
        }
        
        if socialId.isEmpty == true{
        if (passwordTextField.text?.characters.count)! < 6 {
            showAlert(title: "", message: "Password must be at least 6 characters in length.".localized())
            return false
        }
        
        if reEnterPasswordTextField.text != passwordTextField.text{
            showAlert(title: "", message: "Entries must match to proceed.".localized())
            return false
        }
        }
        if (zipCodeTextField.text?.characters.count)! < 5 {
            showAlert(title: "", message: "Please enter a valid zip code.".localized())
            return false
        }
       
         if (emailTextField.text?.characters.count)! > 0 {
            if  validEmail == false {
                showAlert(title: "", message: "Please enter a valid email address.".localized())
                return false
            }
        }
            
            
        if reEnterEmailTextField.text != emailTextField.text {
            showAlert(title: "", message: "Entries must match to proceed.".localized())
            return false
        }

        if contactPreferenceSegmentControl.selectedSegmentIndex == 1 {
            if (emailTextField.text?.characters.count)! == 0 {
                    showAlert(title: "", message: "Please enter a valid email address.".localized())
                    return false
            }
        }
        
        if checkButtonSelected == false {
            showAlert(title: "", message: "You must agree to the Terms of Service.".localized())
            return false
        }
        return true
    }
    

}


extension SignUpTVC: AITextFieldProtocol {
    
    func keyBoardHidden(textField: UITextField) {
        
        let socialId : String = facebookDict?["id"] as! String? ?? ""
        if socialId.isEmpty == true {
        if textField == mobileNumTextField {
            reEnterMobileNumTextField.becomeFirstResponder()
        }
            
        else if textField == reEnterMobileNumTextField {
            passwordTextField.becomeFirstResponder()
        }
            
        else if textField == passwordTextField {
            reEnterPasswordTextField.becomeFirstResponder()
        }
        else if textField == reEnterPasswordTextField{
            zipCodeTextField.becomeFirstResponder()
        }
        else if textField == zipCodeTextField{
            emailTextField.becomeFirstResponder()
        }
        else if textField == emailTextField {
            reEnterEmailTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
            
        }
        
        else {
            
            if textField == mobileNumTextField {
                reEnterMobileNumTextField.becomeFirstResponder()
            }
                
            else if textField == reEnterMobileNumTextField {
                zipCodeTextField.becomeFirstResponder()
            }
                
            else if textField == zipCodeTextField{
                emailTextField.becomeFirstResponder()
            }
            else if textField == emailTextField {
                reEnterEmailTextField.becomeFirstResponder()
            }
            else {
                textField.resignFirstResponder()
            }
        }
    }
    
    
    func aiTextField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == mobileNumTextField || textField == reEnterMobileNumTextField {
            
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
        
        if textField == zipCodeTextField {
            let currentCharacterCount = textField.text?.characters.count ?? 0
            if (range.length + range.location > currentCharacterCount){
                return false
            }
            let newLength = currentCharacterCount + string.characters.count - range.length
            return newLength <= 5
        }
        
        return true
    }
    
    // MARK: - faceBookLogin
    
    func didFacebookLoginFail() {
        facebookActivityIndicator.stopAnimating()
    }
    
    func didFacebookLoginSuccess() {
        //print("SUCCESS")
        faceBookLogin.getBasicInformation()
    }
    
    func didReceiveUser(information: [String : Any]) {
        
       // print("information is\(information)")
        
        facebookDict = information
        let email =  facebookDict?["email"] ?? ""
        emailTextField.text = email as? String
        
        self.tableView.reloadData()
        self.checkFacebookUser()
    }
 
    func checkFacebookUser() {
        
        let reachbility:NetworkReachabilityManager = NetworkReachabilityManager()!
        let isReachable = reachbility.isReachable
        // Reachability
        if isReachable == false {
            self.showAlert(title: "", message: "The internet connection appears to be offline.".localized());
            return
        }
        
        let device_id = UIDevice.current.identifierForVendor!.uuidString
        let currentLanguage = Localize.currentLanguage()
        let socialId = facebookDict?["id"] as? String ?? ""
        let version_name = Bundle.main.releaseVersionNumber ?? ""
        let version_code = Bundle.main.buildVersionNumber ?? ""
        let email = facebookDict?["email"] as? String ?? ""
        
        let parameters : Parameters  = ["social_id": socialId,
                                        "email": email,
                                        "phone_number": "",
                          "platform":"1",
                          "version_code": version_code,
                          "version_name": version_name,
                          "device_id": device_id,
                          "push_token":"",
                          "language": currentLanguage
            ]
        
       // print(parameters)
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
                if (json.dictionary != nil) {
                    
                    let responseDict = json.dictionaryObject
                    if  let code = responseDict?["code"] {
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

//                        else {
//                                if let responseDict = json.dictionaryObject {
//                             let alertMessage = responseDict["message"] as! String
//                             self.showAlert(title: "", message: alertMessage)
//                                    
//                             }
//                        }
                    }
                }
                break
                
                
            case .failure(let error):
                
                DispatchQueue.main.async {
                    self.facebookActivityIndicator.stopAnimating()
                    self.showAlert(title: "", message:error.localizedDescription);
                }
                break
            }
            
        }
    }
    func presentHome() {
        self.performSegue(withIdentifier: "HomeStoryboard", sender: self)
    }
    

}

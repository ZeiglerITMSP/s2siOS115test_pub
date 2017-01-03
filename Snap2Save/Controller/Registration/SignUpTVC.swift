//
//  SignUpTVC.swift
//  Snap2Save
//
//  Created by Malathi on 21/12/16.
//  Copyright © 2016 Appit. All rights reserved.
//

import UIKit
import Localize_Swift

class SignUpTVC: UITableViewController,UITextFieldDelegate,AITextFieldProtocol {
    
    var languageSelectionButton: UIButton!

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
    }
    
    @IBAction func contactPreferenceSegmentControl(_ sender: UISegmentedControl) {
        
    }
    
    @IBAction func continueButtonClicked(_ sender: UIButton) {
        
        if !isValidData(){
            return
        }
        let userDetails:[String:Any] = ["phone_number":mobileNumTextField.text ?? "",
                                        "password":passwordTextField.text ?? "",
                                        "zipcode":zipCodeTextField.text ?? "",
                                        "contact_preference":contactPreferenceSegmentControl.selectedSegmentIndex,
                                        "email":emailTextField.text ?? "",
                                        "social_id":""];
        
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
        backButton.setTitleColor(UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.7), for: .normal)
        
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
    

    func languageButtonClicked() {
        
        self.showLanguageSelectionAlert()
        
    }
    
    func reloadContent() {
        
        DispatchQueue.main.async {
            self.languageSelectionButton.setTitle("language.button.title".localized(), for: .normal)
            self.updateBackButtonText()
            self.title = "Register".localized()
            self.earn100PointsLabel.text = "EARN 100 POINTS!".localized()
            self.messageLabel.text = "RegisterMessage".localized()
            self.loginWithFBButton.setTitle("Register with Facebook".localized(), for: .normal);
            self.requiredInfoLabel.text = "*Required information".localized()
            self.mobileNumLabel.text = "10-DIGIT CELL PHONE NUMBER".localized()
            self.reEnterMobileNumLabel.text = "RE-ENTER 10-DIGIT CELL PHONE NUMBER".localized()
            self.passwordLabel.text = "PASSWORD (MUST BE AT LEAST 6 CHARACTERS)".localized()
            self.reEnterPasswordLabel.text = "RE-ENTER PASSWORD".localized()
            self.zipCodeLabel.text = "ZIP CODE".localized()
            self.contactPreferenceLabel.text = "CONTACT PREFERENCE".localized()
            self.emailLabel.text = "EMAIL".localized()
            self.reEnterEmailLabel.text = "RE-ENTER EMAIL".localized()
            self.contactPreferenceSegmentControl.setTitle("Text Message".localized(), forSegmentAt: 0)
            self.contactPreferenceSegmentControl.setTitle("Email".localized(), forSegmentAt: 1)
            
            self.updateTermsText()
            
            self.continueButton.setTitle("CONTINUE".localized(), for: .normal)
            
            self.tableView.reloadData()
        }
    }

    func updateTermsText() {
        
        // Terms of Service
        let fullMessage = "TermsMessage".localized()
        let rangeMessage = "TermsLink".localized()
        let link = "https://appitventures.teamwork.com/dashboard"
        
        let attributedString = NSMutableAttributedString(string: fullMessage)
        
        let fullMessageRange = (attributedString.string as NSString).range(of: fullMessage)
        // default text style
        attributedString.addAttribute(NSForegroundColorAttributeName, value: self.termsTextView.textColor!, range: fullMessageRange)
        attributedString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 15), range: fullMessageRange)
        let titleParagraphStyle = NSMutableParagraphStyle()
        titleParagraphStyle.alignment = .center
        attributedString.addAttribute(NSParagraphStyleAttributeName, value: titleParagraphStyle, range: fullMessageRange)
        
        // linkRange
        let linkRange = (attributedString.string as NSString).range(of: rangeMessage)
        attributedString.addAttribute(NSLinkAttributeName, value: link, range: linkRange)
        
        let linkAttributes = [
            NSForegroundColorAttributeName: APP_GRREN_COLOR,
            NSUnderlineColorAttributeName: APP_GRREN_COLOR,
            NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue ] as [String : Any]
        
        // textView is a UITextView
        self.termsTextView.linkTextAttributes = linkAttributes
        self.termsTextView.attributedText = attributedString
        
    }
    
    func backButtonAction(){
        
        self.view.endEditing(true)
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    func loadTextFields(){
        
             //
        //        let contactStr = "Contact Preference *".localized
        //       // let string_to_color = "*"
        //        let contactStrRange = (contactStr as NSString).range(of: string_to_color)
        //        let contactStrAttribute = NSMutableAttributedString.init(string: contactStr)
        //        contactStrAttribute.addAttribute(NSForegroundColorAttributeName, value: APP_ORANGE_COLOR , range: contactStrRange)
        //        contactPreferenceLabel.attributedText = contactStrAttribute
        
        
//        
//        let msgStr = "Terms Of Service".localized()
//        let string              = msgStr
//        let rangeMsgStr            = (string as NSString).range(of: "Terms of Service.")
//        let attributedString    = NSMutableAttributedString(string: string)
//        
//        attributedString.addAttribute(NSLinkAttributeName, value:("https://appitventures.teamwork.com/dashboard"), range: rangeMsgStr)
//        attributedString.addAttribute(NSUnderlineStyleAttributeName, value: NSNumber(value: 1), range: rangeMsgStr)
//        attributedString.addAttribute(NSUnderlineColorAttributeName, value: APP_GRREN_COLOR, range: rangeMsgStr)
//        attributedString.addAttribute(NSForegroundColorAttributeName, value: APP_GRREN_COLOR , range: rangeMsgStr)
//        terms_serviceLabel.attributedText = attributedString
//        
        
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
        
        zipCodeTextField.textFieldType = AITextField.AITextFieldType.NormalTextField
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
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
    
    func keyBoardHidden(textField: UITextField) {
        if textField == mobileNumTextField{
            reEnterMobileNumTextField.becomeFirstResponder()
        }
        else if textField == reEnterMobileNumTextField{
            passwordTextField.becomeFirstResponder()
        }
            
        else if textField == passwordTextField{
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
    
    
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    func isValidData() -> Bool{
        let validMobileNum = AppHelper.validMobileNumber(mobileNumber: mobileNumTextField.text!)
        if mobileNumTextField.text?.characters.count == 0 || validMobileNum == false {
            showAlert(title: "", message: "Please enter 10 digit Phone Number")
            return false
        }
        else if reEnterMobileNumTextField.text != mobileNumTextField.text {
            showAlert(title: "", message: "PhoneNumbers doesn't match")
            return false
        }
           
        else if (passwordTextField.text?.characters.count)! < 6 {
            showAlert(title: "", message: "Please enter Password")
            return false
        }
        else if reEnterPasswordTextField.text != passwordTextField.text{
            showAlert(title: "", message: "Password doesn't match")
            return false
        }
        else if zipCodeTextField.text?.characters.count == 0 {
            showAlert(title: "", message: "Please enter ZipCode")
            return false
        }
        else if (emailTextField.text?.characters.count)! > 0 {
            let validEmail = AppHelper.isValidEmail(testStr: emailTextField.text!)
            if  validEmail == false{
                showAlert(title: "", message: "Enter a valid email")
                return false
            }
            
        }
        else if reEnterEmailTextField.text != emailTextField.text{
            showAlert(title: "", message: "Emails doesn't match")
            return false
        }

        return true
    }
    

}

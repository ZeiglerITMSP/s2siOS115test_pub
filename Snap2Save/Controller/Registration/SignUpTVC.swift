//
//  SignUpTVC.swift
//  Snap2Save
//
//  Created by Malathi on 21/12/16.
//  Copyright © 2016 Appit. All rights reserved.
//

import UIKit

class SignUpTVC: UITableViewController,UITextFieldDelegate,AITextFieldProtocol {
    
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
    
    @IBOutlet var terms_serviceLabel: UILabel!
    
    
    @IBOutlet var continueButton: UIButton!
    @IBOutlet var reEnterEmailTextField: AITextField!
    @IBOutlet var reEnterEmailLabel: UILabel!
    
    
    @IBAction func loginWithFbButtonAction(_ sender: Any) {
    }
    
    @IBAction func contactPreferenceSegmentControl(_ sender: UISegmentedControl) {
    }
    
    @IBAction func continueButtonClicked(_ sender: UIButton) {
        let additionalSignUpVc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignupAdditionalFieldsTVC")
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
        
        let navBarBGImg = AppHelper.imageWithColor(color: APP_GRREN_COLOR)
        // super.setNavigationBarImage(image: navBarBGImg)
        self.navigationController?.navigationBar.setBackgroundImage(navBarBGImg, for: .default)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
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
    
    func loadTextFields(){
        
        //        let main_string = "10-DIGIT CELL PHONE NUMBER *".localized
        //        let string_to_color = "*"
        //        let range = (main_string as NSString).range(of: string_to_color)
        //        let attribute = NSMutableAttributedString.init(string: main_string)
        //        attribute.addAttribute(NSForegroundColorAttributeName, value: APP_ORANGE_COLOR , range: range)
        //        mobileNumLabel.attributedText = attribute
        //
        //        let reEnterMob = "RE-ENTER 10-DIGIT CELL PHONE NUMBER *".localized
        //        //let string_to_color = "*"
        //        let mobRange = (reEnterMob as NSString).range(of: string_to_color)
        //        let reEnterMobAttr = NSMutableAttributedString.init(string: reEnterMob)
        //        reEnterMobAttr.addAttribute(NSForegroundColorAttributeName, value: APP_ORANGE_COLOR , range: mobRange)
        //        reEnterMobileNumLabel.attributedText = reEnterMobAttr
        //
        //        let passwordStr = "PASSWORD (MUST BE AT LEAST 6 CHARACTERS) *".localized
        //        //let string_to_color = "*"
        //        let passwordRange = (passwordStr as NSString).range(of: string_to_color)
        //        let  passWordRangeStrAttr = NSMutableAttributedString.init(string: passwordStr)
        //        passWordRangeStrAttr.addAttribute(NSForegroundColorAttributeName, value: APP_ORANGE_COLOR , range: passwordRange)
        //        passwordLabel.attributedText = passWordRangeStrAttr
        //
        //        let reEnterPasswdStr = "RE-ENTER PASSWORD *".localized
        //        //let string_to_color = "*"
        //        let reEnterPasswdStrRange = (reEnterPasswdStr as NSString).range(of: string_to_color)
        //        let reEnterPasswdStrAttribute = NSMutableAttributedString.init(string: reEnterPasswdStr)
        //        reEnterPasswdStrAttribute.addAttribute(NSForegroundColorAttributeName, value: APP_ORANGE_COLOR , range: reEnterPasswdStrRange)
        //        reEnterPasswordLabel.attributedText = reEnterPasswdStrAttribute
        //
        //        let zipCodeStr = "ZIP CODE *".localized
        //       // let string_to_color = "*"
        //        let zipCodeStrRange = (zipCodeStr as NSString).range(of: string_to_color)
        //        let zipCodeStrAttribute = NSMutableAttributedString.init(string: zipCodeStr)
        //        zipCodeStrAttribute.addAttribute(NSForegroundColorAttributeName, value: APP_ORANGE_COLOR , range: zipCodeStrRange)
        //        zipCodeLabel.attributedText = zipCodeStrAttribute
        //
        //        let contactStr = "Contact Preference *".localized
        //       // let string_to_color = "*"
        //        let contactStrRange = (contactStr as NSString).range(of: string_to_color)
        //        let contactStrAttribute = NSMutableAttributedString.init(string: contactStr)
        //        contactStrAttribute.addAttribute(NSForegroundColorAttributeName, value: APP_ORANGE_COLOR , range: contactStrRange)
        //        contactPreferenceLabel.attributedText = contactStrAttribute
        
        mobileNumLabel.text = "10-DIGIT CELL PHONE NUMBER".localized
        reEnterMobileNumLabel.text = "RE-ENTER 10-DIGIT CELL PHONE NUMBER".localized
        passwordLabel.text = "PASSWORD (MUST BE AT LEAST 6 CHARACTERS)".localized
        reEnterPasswordLabel.text = "RE-ENTER PASSWORD".localized
        zipCodeLabel.text = "ZIP CODE".localized
        contactPreferenceLabel.text = "Contact Preference".localized
        emailLabel.text = "EMAIL".localized
        reEnterEmailLabel.text = "RE-ENTER EMAIL".localized
        contactPreferenceSegmentControl.setTitle("Text Message".localized, forSegmentAt: 0)
        contactPreferenceSegmentControl.setTitle("Email".localized, forSegmentAt: 1)
        terms_serviceLabel.text = "Terms Of Service".localized
        continueButton.setTitle("CONTINUE".localized, for: .normal)
        
        
        
        let msgStr = "Terms Of Service".localized
        let string              = msgStr
        let rangeMsgStr            = (string as NSString).range(of: "Terms of Service")
        let attributedString    = NSMutableAttributedString(string: string)
        
        attributedString.addAttribute(NSLinkAttributeName, value:("https://appitventures.teamwork.com/dashboard"), range: rangeMsgStr)
        attributedString.addAttribute(NSUnderlineStyleAttributeName, value: NSNumber(value: 1), range: rangeMsgStr)
        attributedString.addAttribute(NSUnderlineColorAttributeName, value: APP_GRREN_COLOR, range: rangeMsgStr)
        attributedString.addAttribute(NSForegroundColorAttributeName, value: APP_GRREN_COLOR , range: rangeMsgStr)
        terms_serviceLabel.attributedText = attributedString
        
        
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
        reEnterMobileNumTextField.placeHolderLabel = reEnterPasswordLabel
        
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
        
        zipCodeTextField.textFieldType = AITextField.AITextFieldType.PhoneNumberTextField
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
        return 13
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
        }
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
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
        }
        textField.resignFirstResponder()
        return true
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
    
}

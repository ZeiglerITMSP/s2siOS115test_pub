//
//  SignupAdditionalFieldsTVC.swift
//  Snap2Save
//
//  Created by Appit on 12/19/16.
//  Copyright © 2016 Appit. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Localize_Swift

class SignupAdditionalFieldsTVC: UITableViewController ,UITextFieldDelegate,AITextFieldProtocol{
    
    var languageSelectionButton: UIButton!
    
    enum DropDownTags:Int {
        case states = 100
        case gender
        case ageGroup
        case ethnicity
    }
    
    
    var userDetailsDict:[String: Any]!
    var ageGroupArray : NSMutableArray!
    var statesArray : NSMutableArray!
    var ethnicityArray : NSMutableArray!
    var genderArray : NSMutableArray!
    var selectedStateIndex : NSInteger!
    var selectedGenderIndex : NSInteger!
    var selectedAgeGroupIndex : NSInteger!
    var SelectedEthnicityIndex : NSInteger!
    
    @IBOutlet var earn200PointsLabel: UILabel!
    
    @IBOutlet var msgLabel: UILabel!
    
    @IBOutlet var userInfoLabel: UILabel!
    
    @IBOutlet var firstNameLabel: UILabel!
    
    @IBOutlet var lastNameLabel: UILabel!
    @IBOutlet var firstNameTextField: AITextField!
    
    @IBOutlet var lastNameTextField: AITextField!
    
    @IBOutlet var addressMsgLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    
    @IBOutlet var addressLine1Label: UILabel!
    
    @IBOutlet var addressLine2TextField: AITextField!
    @IBOutlet var addressLine1TextField: AITextField!
    @IBOutlet var addressLine2Label: UILabel!
    
    @IBOutlet var genderTextField: AITextField!
    @IBOutlet var genderLabel: UILabel!
    @IBOutlet var additionalInfoLabel: UILabel!
    
    
    @IBOutlet var ageGroupTextField: AITextField!
    @IBOutlet var ageGroupLabel: UILabel!
    @IBOutlet var ethnicityLabel: UILabel!
    @IBOutlet var ethnicityTextField: AITextField!
    
    @IBOutlet var registerButton: UIButton!
    
    @IBOutlet var referralCodeTextField: AITextField!
    @IBOutlet var referralCodeLabel: UILabel!
    @IBOutlet var groupCodeTextField: AITextField!
    @IBOutlet var groupCodeLabel: UILabel!
    
    @IBOutlet var cityLabel: UILabel!
    
    @IBOutlet var zipCodeTextField: AITextField!
    @IBOutlet var zipCodeLabel: UILabel!
    @IBOutlet var stateTextField: AITextField!
    @IBOutlet var stateLabel: UILabel!
    
    @IBOutlet var cityTextField: AITextField!
    
    @IBOutlet var registerActivityIndicator: UIActivityIndicatorView!
    @IBAction func registerButtonAction(_ sender: UIButton) {
        
        userSignUp()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Register"
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 60
        self.navigationController?.navigationBar.isHidden = false
        
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
        
        loadTextFields();
        //print("userDetailsDict)
        
        languageSelectionButton = LanguageUtility.createLanguageSelectionButton(withTarge: self, action: #selector(languageButtonClicked))
        LanguageUtility.addLanguageButton(languageSelectionButton, toController: self)
        
        reloadContent()
        
        // Tap Gesuture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnTableView(recognizer:)))
        self.view.addGestureRecognizer(tapGesture)
        
        let zipcode = userDetailsDict["zipcode"] as! String
        zipCodeTextField.text = zipcode
        
        let firstname = userDetailsDict["first_name"] as! String
        firstNameTextField.text = firstname
        
        let lastName = userDetailsDict["last_name"] as! String
        lastNameTextField.text = lastName
        
    
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadContent()
        
        AppHelper.getScreenName(screenName: "SignUp screen")

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        LanguageUtility.addOberverForLanguageChange(self, selector: #selector(reloadContent))
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.view.endEditing(true)
        LanguageUtility.removeObserverForLanguageChange(self)
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
            self.earn200PointsLabel.text = "EARN 200 POINTS!".localized()
            self.msgLabel.text = "AdditionalSignUpMsg".localized()
            self.userInfoLabel.text = "USER INFORMATION".localized()
            self.firstNameLabel.text = "FIRST NAME".localized()
            self.lastNameLabel.text = "LAST NAME".localized()
            self.addressLabel.text = "ADDRESS".localized()
            self.addressMsgLabel.text = "AddressMsg".localized()
            self.addressLine1Label.text = "ADDRESS LINE 1".localized()
            self.addressLine2Label.text = "ADDRESS LINE 2".localized()
            self.cityLabel.text = "CITY".localized()
            self.additionalInfoLabel.text = "ADDITIONAL INFORMATION".localized()
            self.stateLabel.text = "STATE".localized()
            self.zipCodeLabel.text = "ZIP CODE".localized()
            self.genderLabel.text = "GENDER".localized()
            self.ethnicityLabel.text = "ETHNICITY / RACE".localized()
            self.ageGroupLabel.text = "AGE GROUP".localized()
            self.groupCodeLabel.text = "GROUP CODE (IF APPLICABLE)".localized()
            self.referralCodeLabel.text = "REFERRAL CODE (IF APPLICABLE)".localized()
            self.registerButton.setTitle("REGISTER".localized(), for: .normal)
            self.genderTextField.placeholder = "Please select".localized()
            // self.genderTextField.placeHolderLabel?.text = "Please select".localized()
            self.ageGroupTextField.placeholder = "Please select".localized()
            self.ethnicityTextField.placeholder = "Please select".localized()
            self.addressLine1TextField.placeholder = "Street address or PO box".localized()
            self.addressLine2TextField.placeholder = "Unit, Building, etc.".localized()
            
            self.genderArray = ["Male".localized(),"Female".localized()];
            self.ageGroupArray = ["21 and under".localized(),
                                  "22 to 34".localized(),
                                  "35 to 44".localized(),
                                  "45 to 54".localized(),
                                  "55 to 64".localized(),
                                  "65 and older".localized()]
            
            self.ethnicityArray = ["American Indian or Alaska Native".localized(),
                                   "Asian or Pacific Islander".localized(),
                                   "Black or African American".localized(),
                                   "Hispanic or Latino".localized(),
                                   "White/Caucasian".localized(),
                                   "Other".localized()]
            
            self.genderTextField.pickerViewArray = self.genderArray
            self.ageGroupTextField.pickerViewArray = self.ageGroupArray
            self.ethnicityTextField.pickerViewArray = self.ethnicityArray
            self.updateTextFieldsUi()
            
            if self.selectedGenderIndex != nil {
                self.genderTextField.text = self.genderArray.object(at: self.selectedGenderIndex - 1) as? String
            }
            
            if self.selectedAgeGroupIndex != nil {
                self.ageGroupTextField.text = self.ageGroupArray.object(at: self.selectedAgeGroupIndex - 1) as? String
            }
            
            if self.SelectedEthnicityIndex != nil {
                self.ethnicityTextField.text = self.ethnicityArray.object(at: self.SelectedEthnicityIndex - 1) as? String
            }
          /*  let gender = self.userDetailsDict["gender"] as! String
            if !gender.isEmpty {
                let gen = gender.capitalized
                if gen == "Female"{
                    self.selectedGenderIndex = 2
                    
                }
                else if gen == "Male" {
                    self.selectedGenderIndex = 1
                }
                
                self.genderTextField.text = self.genderArray.object(at: self.selectedGenderIndex - 1) as? String
            }*/
            self.tableView.reloadData()
            
        }
    }
    
    func backButtonAction(){
        _ = self.navigationController?.popViewController(animated: true)
        self.view.endEditing(true)
        
    }
    
    func loadTextFields(){
        
        stateTextField.tag = 100
        genderTextField.tag = 101
        ageGroupTextField.tag = 102
        ethnicityTextField.tag = 103
        
        AppHelper.setRoundCornersToView(borderColor: APP_ORANGE_COLOR, view: registerButton, radius: 2.0, width: 1.0)
        
        firstNameTextField.textFieldType = AITextField.AITextFieldType.NormalTextField
        firstNameTextField.updateUIAsPerTextFieldType()
        firstNameTextField.createUnderline(withColor: APP_LINE_COLOR, padding: 0, height: 1)
        firstNameTextField.placeHolderLabel = firstNameLabel
        firstNameTextField.setLeftGap(width: 0, placeHolderImage: UIImage.init())
        firstNameTextField.setRightGap(width: 0, placeHolderImage: UIImage.init())
        firstNameTextField.text_Color =  UIColor.black
        
        lastNameTextField.textFieldType = AITextField.AITextFieldType.NormalTextField
        lastNameTextField.updateUIAsPerTextFieldType()
        lastNameTextField.createUnderline(withColor: APP_LINE_COLOR, padding: 0, height: 1)
        lastNameTextField.placeHolderLabel = lastNameLabel
        lastNameTextField.setLeftGap(width: 0, placeHolderImage: UIImage.init())
        lastNameTextField.setRightGap(width: 0, placeHolderImage: UIImage.init())
        lastNameTextField.text_Color =  UIColor.black
        
        addressLine1TextField.textFieldType = AITextField.AITextFieldType.NormalTextField
        addressLine1TextField.updateUIAsPerTextFieldType()
        addressLine1TextField.createUnderline(withColor: APP_LINE_COLOR, padding: 0, height: 1)
        addressLine1TextField.placeHolderLabel = addressLine1Label
        addressLine1TextField.setLeftGap(width: 0, placeHolderImage: UIImage.init())
        addressLine1TextField.setRightGap(width: 0, placeHolderImage: UIImage.init())
        addressLine1TextField.text_Color =  UIColor.black
        
        addressLine2TextField.textFieldType = AITextField.AITextFieldType.NormalTextField
        addressLine2TextField.updateUIAsPerTextFieldType()
        addressLine2TextField.createUnderline(withColor: APP_LINE_COLOR, padding: 0, height: 1)
        addressLine2TextField.placeHolderLabel = addressLine2Label
        addressLine2TextField.setLeftGap(width: 0, placeHolderImage: UIImage.init())
        addressLine2TextField.setRightGap(width: 0, placeHolderImage: UIImage.init())
        addressLine2TextField.text_Color =  UIColor.black
        
        genderTextField.textFieldType = AITextField.AITextFieldType.TextPickerTextField
        genderTextField.updateUIAsPerTextFieldType()
        genderTextField.createUnderline(withColor: APP_LINE_COLOR, padding: 0, height: 1)
        genderTextField.placeHolderLabel = genderLabel
        genderTextField.setLeftGap(width: 0, placeHolderImage: UIImage.init())
        genderTextField.setRightGap(width: 10, placeHolderImage: UIImage.init(named: "ic_downarrow_input")!)
        genderTextField.text_Color =  UIColor.black
        
        ageGroupTextField.textFieldType = AITextField.AITextFieldType.TextPickerTextField
        ageGroupTextField.updateUIAsPerTextFieldType()
        ageGroupTextField.createUnderline(withColor: APP_LINE_COLOR, padding: 0, height: 1)
        ageGroupTextField.placeHolderLabel = ageGroupLabel
        ageGroupTextField.setLeftGap(width: 0, placeHolderImage: UIImage.init())
        ageGroupTextField.setRightGap(width:10, placeHolderImage: UIImage.init(named: "ic_downarrow_input")!)
        ageGroupTextField.text_Color =  UIColor.black
        
        ethnicityTextField.textFieldType = AITextField.AITextFieldType.TextPickerTextField
        ethnicityTextField.updateUIAsPerTextFieldType()
        ethnicityTextField.createUnderline(withColor: APP_LINE_COLOR, padding: 0, height: 1)
        ethnicityTextField.placeHolderLabel = ethnicityLabel
        ethnicityTextField.setLeftGap(width: 0, placeHolderImage: UIImage.init())
        ethnicityTextField.setRightGap(width: 10, placeHolderImage:  UIImage.init(named: "ic_downarrow_input")!)
        ethnicityTextField.text_Color =  UIColor.black
        
        groupCodeTextField.textFieldType = AITextField.AITextFieldType.NormalTextField
        groupCodeTextField.updateUIAsPerTextFieldType()
        groupCodeTextField.createUnderline(withColor: APP_LINE_COLOR, padding: 0, height: 1)
        groupCodeTextField.placeHolderLabel = groupCodeLabel
        groupCodeTextField.setLeftGap(width: 0, placeHolderImage: UIImage.init())
        groupCodeTextField.setRightGap(width: 0, placeHolderImage: UIImage.init())
        groupCodeTextField.text_Color =  UIColor.black
        
        referralCodeTextField.textFieldType = AITextField.AITextFieldType.NormalTextField
        referralCodeTextField.updateUIAsPerTextFieldType()
        referralCodeTextField.createUnderline(withColor: APP_LINE_COLOR, padding: 0, height: 1)
        referralCodeTextField.placeHolderLabel = referralCodeLabel
        referralCodeTextField.setLeftGap(width: 0, placeHolderImage: UIImage.init())
        referralCodeTextField.setRightGap(width: 0, placeHolderImage: UIImage.init())
        referralCodeTextField.text_Color =  UIColor.black
        
        cityTextField.textFieldType = AITextField.AITextFieldType.NormalTextField
        cityTextField.updateUIAsPerTextFieldType()
        cityTextField.createUnderline(withColor: APP_LINE_COLOR, padding: 0, height: 1)
        cityTextField.placeHolderLabel = cityLabel
        cityTextField.setLeftGap(width: 0, placeHolderImage: UIImage.init())
        cityTextField.setRightGap(width: 0, placeHolderImage: UIImage.init())
        cityTextField.text_Color =  UIColor.black
        
        stateTextField.textFieldType = AITextField.AITextFieldType.TextPickerTextField
        stateTextField.updateUIAsPerTextFieldType()
        stateTextField.createUnderline(withColor: APP_LINE_COLOR, padding: 0, height: 1)
        stateTextField.placeHolderLabel = stateLabel
        stateTextField.setLeftGap(width: 0, placeHolderImage: UIImage.init())
        stateTextField.setRightGap(width: 10, placeHolderImage:UIImage.init(named: "ic_downarrow_input")!)
        stateTextField.text_Color =  UIColor.black
        
        zipCodeTextField.textFieldType = AITextField.AITextFieldType.NumberTextField
        zipCodeTextField.updateUIAsPerTextFieldType()
        zipCodeTextField.createUnderline(withColor: APP_LINE_COLOR, padding: 0, height: 1)
        zipCodeTextField.placeHolderLabel = zipCodeLabel
        zipCodeTextField.setLeftGap(width: 0, placeHolderImage: UIImage.init())
        zipCodeTextField.setRightGap(width: 0, placeHolderImage: UIImage.init())
        zipCodeTextField.text_Color =  UIColor.black
        
        
        firstNameTextField.aiDelegate = self
        lastNameTextField.aiDelegate = self
        addressLine1TextField.aiDelegate = self
        addressLine2TextField.aiDelegate = self
        genderTextField.aiDelegate = self
        ageGroupTextField.aiDelegate = self
        ethnicityTextField.aiDelegate = self
        groupCodeTextField.aiDelegate = self
        referralCodeTextField.aiDelegate = self
        stateTextField.aiDelegate = self
        cityTextField.aiDelegate = self
        zipCodeTextField.aiDelegate = self
        
        var statesDict: NSDictionary?
        if let path = Bundle.main.path(forResource: "USStateAbbreviations", ofType: "plist") {
            statesDict = NSDictionary(contentsOfFile: path)
        }
        
        let states = statesDict?.allValues as! [String]
        let sortedStates = states.sorted { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending }
        
        statesArray = NSMutableArray()
        for state in sortedStates {
            statesArray.add(state)
        }
        
        stateTextField.pickerViewArray = statesArray
    }
    
    func updateTextFieldsUi(){
        
        firstNameTextField.updateUIAsPerTextFieldType()
        lastNameTextField.updateUIAsPerTextFieldType()
        addressLine1TextField.updateUIAsPerTextFieldType()
        addressLine2TextField.updateUIAsPerTextFieldType()
        zipCodeTextField.updateUIAsPerTextFieldType()
        genderTextField.updateUIAsPerTextFieldType()
        ageGroupTextField.updateUIAsPerTextFieldType()
        
        ethnicityTextField.updateUIAsPerTextFieldType()
        groupCodeTextField.updateUIAsPerTextFieldType()
        referralCodeTextField.updateUIAsPerTextFieldType()
        stateTextField.updateUIAsPerTextFieldType()
        zipCodeTextField.updateUIAsPerTextFieldType()
        cityTextField.updateUIAsPerTextFieldType()
        zipCodeTextField.updateUIAsPerTextFieldType()
        
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
        return 15
    }
    
    
    func keyBoardHidden(textField: UITextField) {
        if textField == firstNameTextField{
            lastNameTextField.becomeFirstResponder()
        }
        else if textField == lastNameTextField{
            addressLine1TextField.becomeFirstResponder()
        }
            
        else if textField == addressLine1TextField{
            addressLine2TextField.becomeFirstResponder()
        }
        else if textField == addressLine2TextField{
            cityTextField.becomeFirstResponder()
        }
        else if textField == cityTextField{
            stateTextField.becomeFirstResponder()
        }
        else if textField == stateTextField {
            zipCodeTextField.becomeFirstResponder()
        }
        else if textField == zipCodeTextField {
            genderTextField.becomeFirstResponder()
        }
        else if textField == genderTextField {
            ageGroupTextField.becomeFirstResponder()
        }
        else if textField == ageGroupTextField {
            ethnicityTextField.becomeFirstResponder()
        }
        else if textField == ethnicityTextField {
            groupCodeTextField.becomeFirstResponder()
        }
        else if textField == groupCodeTextField {
            referralCodeTextField.becomeFirstResponder()
        }else {
            textField.resignFirstResponder()
        }
        
    }
    
    func userSignUp(){
        
        
        if !isValid(){
            return
        }
        let reachbility:NetworkReachabilityManager = NetworkReachabilityManager()!
        let isReachable = reachbility.isReachable
        // Reachability
        if isReachable == false {
            self.showAlert(title: "", message: "The internet connection appears to be offline.".localized());
            return
        }
        
        let password = userDetailsDict["password"] as! String
        let phone_number = userDetailsDict["phone_number"] as! String
        let email = userDetailsDict["email"] as! String
        let zipcode = zipCodeTextField.text ?? ""
        let social_id = userDetailsDict["social_id"] as! String
        let contactPrefernce: Int = userDetailsDict["contact_preference"] as! Int
        var contact_preference = "1"
        if contactPrefernce == 0 {
            contact_preference = "2"
        } else {
            contact_preference = "1"
        }
        
        let first_name = firstNameTextField.text ?? ""
        let last_name = lastNameTextField.text ?? ""
        let address_line1 = addressLine1TextField.text ?? ""
        let address_line2 = addressLine2TextField.text ?? ""
        let city = cityTextField.text ?? ""
        let state = stateTextField.text ?? ""
        var gender = ""
        var age_group = ""
        var ethnicity = ""
        
        if selectedGenderIndex != nil {
            gender =  String.init(format: "%d", selectedGenderIndex)
        }
        if selectedAgeGroupIndex != nil {
            age_group  = String.init(format: "%d", selectedAgeGroupIndex)
        }
        if SelectedEthnicityIndex != nil {
            ethnicity  = String.init(format: "%d", SelectedEthnicityIndex)
        }
        
        let referral_code = referralCodeTextField.text ?? ""
        let group_code = groupCodeTextField.text ?? ""
        let platform = "1"
        let device_id = UIDevice.current.identifierForVendor!.uuidString
        let push_token = ""
        let currentLanguage = Localize.currentLanguage()
        
        var signup_type = "1"
        if !social_id.isEmpty {
            signup_type = "2"
        }

        let version_name = Bundle.main.releaseVersionNumber ?? ""
        let version_code = Bundle.main.buildVersionNumber ?? ""

        let additionalInfoDict : Dictionary = ["first_name": first_name,
                                               "last_name": last_name,
                                               "address_line1": address_line1,
                                               "address_line2": address_line2,
                                               "city": city,
                                               "state": state,
                                               "gender": gender,
                                               "age_group": age_group,
                                               "referral_code": referral_code,
                                               "group_code": group_code,
                                               "ethnicity": ethnicity]
        
        let parameters : Parameters = ["password" : password,
                          "phone_number" : phone_number,
                          "email" : email,
                          "zipcode": zipcode,
                          "social_id":social_id,
                          "contact_preference": contact_preference,
                          "additional_info" : additionalInfoDict,
                          "platform": platform,
                          "version_code":version_code,
                          "version_name":version_name,
                          "device_id": device_id,
                          "push_token": push_token,
                          "language": currentLanguage,
                          "signup_type": signup_type
            ]
        
        //print("parameters)
        
        registerActivityIndicator.startAnimating()
        let url = String(format: "%@/signUp", hostUrl)
        //print("url)
        Alamofire.postRequest(URL(string:url)!, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response:DataResponse<Any>) in
            
            switch response.result {
            case .success:
                DispatchQueue.main.async {
                    self.registerActivityIndicator.stopAnimating()
                }
                
                let json = JSON(data: response.data!)
                //print(""json response\(json)")
                
                if (json.dictionary != nil) {
                    let responseDict = json.dictionaryObject
                    if  let code = responseDict?["code"] {
                        let code = code as! NSNumber
                    if code.intValue == 200 {
                        let title = responseDict?["title"] ?? ""
                        let message = responseDict?["message"] ?? ""
                        self.showSignUpAlert(title : title as! String , message: message as! String);
                        self.view.endEditing(true)
                    }
                    else {
                        if let responseDict = json.dictionaryObject {
                            let alertMessage = responseDict["message"] as! String
                            self.showAlert(title: "", message: alertMessage)
                        }
                        
                    }
                }
                }
                break
                
            case .failure(let error):
                
                DispatchQueue.main.async {
                    self.registerActivityIndicator.stopAnimating()
                    self.showAlert(title: "", message:error.localizedDescription);

                }
                break
            }
            
            
        }
        
        
    }
    
    func getSelectedIndexFromPicker(selectedIndex: NSInteger, textField: AITextField) {
        let index = selectedIndex
        if (textField.tag == DropDownTags.states.rawValue) {
            selectedStateIndex = index
        }
        else if textField.tag == DropDownTags.gender.rawValue{
            selectedGenderIndex = index+1
        }
        else if textField.tag == DropDownTags.ageGroup.rawValue{
            selectedAgeGroupIndex = index+1
        }
        else if textField.tag == DropDownTags.ethnicity.rawValue{
            SelectedEthnicityIndex = index+1
        }
    }
    
    func showSignUpAlert(title : String , message : String) {
        
        // 1 - email 2- phone number
      /*  var contactPrefStr = 0
        var contact = ""
        var text_email = ""
        
        if let contactPrefernce = userDetailsDict["contact_preference"] {
            contactPrefStr = contactPrefernce as! Int
        }
        
        if contactPrefStr == 0 {
            contact = "cell phone number".localized()
            text_email = "text".localized()
            
        }
        else if contactPrefStr == 1 {
            contact = "email address".localized()
            text_email = "email".localized()
        }
        

        let titleStr : String = "SignUpAlertTitle".localized()
        
        let messageStr : String = "Before you are able to log in we need to verify your %@. You should receive a confirmation %@ soon. When it arrives, simply click on the link in the %@ and that will complete your registration process.".localizedFormat(contact,text_email,text_email)*/
        
        let messageStr = message
        let title = title
        let signUpAlert = UIAlertController.init(title: title, message:messageStr, preferredStyle: .alert)
        
        let hogan = NSMutableAttributedString(string: title)
        
        //Make the attributes, like size and color
        hogan.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFont(ofSize: 16.0), range: NSMakeRange(0,NSString(string: hogan.string).length))
        
        hogan.addAttribute(NSForegroundColorAttributeName, value: APP_GRREN_COLOR, range: NSMakeRange(0, NSString(string: hogan.string).length))
        
        signUpAlert.setValue(hogan, forKey: "attributedTitle")
        
        let closeBtn = UIAlertAction.init(title: "Close".localized(), style: .default, handler:{
            (action) in
            let loginVc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC")
            self.navigationController?.show(loginVc, sender: self)
            
        })
        
        signUpAlert .addAction(closeBtn)
        self.present(signUpAlert, animated: true, completion:nil)
        signUpAlert.view.tintColor = APP_GRREN_COLOR
        
    }
    
    func aiTextField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
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
    
    func isValid() -> Bool {
        if (zipCodeTextField.text?.characters.count)! > 0 {
                if (zipCodeTextField.text?.characters.count)! < 5 {
                    showAlert(title: "", message: "Please enter a valid zip code.".localized())
                    return false
            
            }
        }
        
        return true
    }

}

//
//  PersonalInformationTVC.swift
//  Snap2Save
//
//  Created by Appit on 12/19/16.
//  Copyright © 2016 Appit. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import Localize_Swift
import PKHUD

class PersonalInformationTVC: UITableViewController, AITextFieldProtocol {
    
    enum DropDownTags:Int {
        case states = 100
        case gender
        case ageGroup
        case ethnicity
    }
    
    var user : User = User()
    var additionalInfo : AdditionalInformation = AdditionalInformation()
    var languageSelectionButton: UIButton!
    var ageGroupArray : NSMutableArray!
    var statesArray : NSMutableArray!
    var ethnicityArray : NSMutableArray!
    var genderArray : NSMutableArray!
    var selectedStateIndex : NSInteger!
    var selectedGenderIndex : NSInteger!
    var selectedAgeGroupIndex : NSInteger!
    var selectedEthnicityIndex : NSInteger!
    
    // outlets
    
    
    @IBOutlet var userInformationLabel: UILabel!
    
    @IBOutlet var firstNameLabel: UILabel!
    
    @IBOutlet var firstNameTextField: AITextField!
    
    @IBOutlet var lastNamelabel: UILabel!
    
    @IBOutlet var lastNameTextField: AITextField!
    
    @IBOutlet var addressLabel: UILabel!
    
    @IBOutlet var addressLine1Label: UILabel!
    
    @IBOutlet var addressLine1TextField: AITextField!
    
    @IBOutlet var addressLine2Label: UILabel!
    
    @IBOutlet var addressLine2TextField: AITextField!
    
    @IBOutlet var cityLabel: UILabel!
    
    @IBOutlet var stateLabel: UILabel!
    
    @IBOutlet var zipcodeLabel: UILabel!
    @IBOutlet var cityTextField: AITextField!
    
    @IBOutlet var stateTextField: AITextField!
    
    @IBOutlet var zipCodeTextField: AITextField!
    
    @IBOutlet var additionalInformationLabel: UILabel!
    
    @IBOutlet var genderLabel: UILabel!
    
    @IBOutlet var genderTextField: AITextField!
    @IBOutlet var ageGroupLabel: UILabel!
    
    @IBOutlet var ageGroupTextField: AITextField!
    
    @IBOutlet var ethnicityLabel: UILabel!
    
    @IBOutlet var ethnicityTextField: AITextField!
    
    @IBOutlet var saveButton: UIButton!
    
    @IBOutlet var saveActivityIndicator: UIActivityIndicatorView!
    
    @IBAction func saveButtonAction(_ sender: UIButton) {
        
        if isInformationModified() == true {
            updateUserInformation()
        } else {
            self.showAlert(title: "", message: "alert.nochange".localized());
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        AppHelper.configSwiftLoader()
        
        AppHelper.setRoundCornersToView(borderColor: APP_ORANGE_COLOR, view: saveButton, radius: 2.0, width: 1.0)
        languageSelectionButton = LanguageUtility.createLanguageSelectionButton(withTarge: self, action: #selector(languageButtonClicked))
        LanguageUtility.addLanguageButton(languageSelectionButton, toController: self)
        reloadContent()
        loadTextFields()
        self.navigationItem.addBackButton(withTarge: self, action: #selector(backAction))
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnTableView(recognizer:)))
        self.view.addGestureRecognizer(tapGesture)
        
        getProfile()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadContent()
        AppHelper.getScreenName(screenName: "Personal Information screen")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        LanguageUtility.addOberverForLanguageChange(self, selector: #selector(reloadContent))
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        LanguageUtility.removeObserverForLanguageChange(self)
        super.viewDidDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: -
    
    @objc func tapOnTableView(recognizer: UITapGestureRecognizer) {
        
        self.view.endEditing(true)
    }
    
    
    @objc func languageButtonClicked() {
        self.showLanguageSelectionAlert()
    }
    
    @objc func backAction() {
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    @objc func reloadContent() {
        
        self.updateBackButtonText()
        self.languageSelectionButton.setTitle("language.button.title".localized(), for: .normal)
        self.title = "Personal Information".localized()
        self.updateTextFieldsUi()
        
        self.userInformationLabel.text = "USER INFORMATION".localized()
        self.firstNameLabel.text = "FIRST NAME".localized()
        self.lastNamelabel.text = "LAST NAME".localized()
        self.addressLabel.text = "ADDRESS".localized()
        self.addressLine1Label.text = "ADDRESS LINE 1".localized()
        self.addressLine2Label.text = "ADDRESS LINE 2".localized()
        self.cityLabel.text = "CITY".localized()
        self.additionalInformationLabel.text = "ADDITIONAL INFORMATION".localized()
        self.stateLabel.text = "STATE".localized()
        self.zipcodeLabel.text = "ZIP CODE".localized()
        self.genderLabel.text = "GENDER".localized()
        self.ethnicityLabel.text = "ETHNICITY / RACE".localized()
        self.ageGroupLabel.text = "AGE GROUP".localized()
        self.saveButton.setTitle("SAVE".localized(), for: .normal)
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
        
        if self.selectedGenderIndex != nil {
            self.genderTextField.text = self.genderArray.object(at: self.selectedGenderIndex - 1) as? String
        }
        
        if self.selectedAgeGroupIndex != nil {
            self.ageGroupTextField.text = self.ageGroupArray.object(at: self.selectedAgeGroupIndex - 1) as? String
        }
        
        if self.selectedEthnicityIndex != nil {
            self.ethnicityTextField.text = self.ethnicityArray.object(at: self.selectedEthnicityIndex - 1) as? String
        }
        
        self.tableView.reloadData()
        
        
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 11
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    // MARK: -
    
    func loadTextFields(){
        
        stateTextField.tag = 100
        genderTextField.tag = 101
        ageGroupTextField.tag = 102
        ethnicityTextField.tag = 103
        
        
        firstNameTextField.textFieldType = AITextField.AITextFieldType.NormalTextField
        firstNameTextField.updateUIAsPerTextFieldType()
        
        firstNameTextField.createUnderline(withColor: APP_LINE_COLOR, padding: 0, height: 1)
        firstNameTextField.placeHolderLabel = firstNameLabel
        //        mobileNumTextField.createBorder(borderColor: UIColor.red,xpos: 0)
        firstNameTextField.setLeftGap(width: 0, placeHolderImage: UIImage.init())
        firstNameTextField.setRightGap(width: 0, placeHolderImage: UIImage.init())
        firstNameTextField.text_Color =  UIColor.black
        
        lastNameTextField.textFieldType = AITextField.AITextFieldType.NormalTextField
        lastNameTextField.updateUIAsPerTextFieldType()
        lastNameTextField.createUnderline(withColor: APP_LINE_COLOR, padding: 0, height: 1)
        lastNameTextField.placeHolderLabel = lastNamelabel
        //        mobileNumTextField.createBorder(borderColor: UIColor.red,xpos: 0)
        lastNameTextField.setLeftGap(width: 0, placeHolderImage: UIImage.init())
        lastNameTextField.setRightGap(width: 0, placeHolderImage: UIImage.init())
        lastNameTextField.text_Color =  UIColor.black
        
        addressLine1TextField.textFieldType = AITextField.AITextFieldType.NormalTextField
        addressLine1TextField.updateUIAsPerTextFieldType()
        addressLine1TextField.createUnderline(withColor: APP_LINE_COLOR, padding: 0, height: 1)
        addressLine1TextField.placeHolderLabel = addressLine1Label
        //        mobileNumTextField.createBorder(borderColor: UIColor.red,xpos: 0)
        addressLine1TextField.setLeftGap(width: 0, placeHolderImage: UIImage.init())
        addressLine1TextField.setRightGap(width: 0, placeHolderImage: UIImage.init())
        addressLine1TextField.text_Color =  UIColor.black
        
        addressLine2TextField.textFieldType = AITextField.AITextFieldType.NormalTextField
        addressLine2TextField.updateUIAsPerTextFieldType()
        addressLine2TextField.createUnderline(withColor: APP_LINE_COLOR, padding: 0, height: 1)
        addressLine2TextField.placeHolderLabel = addressLine2Label
        //        mobileNumTextField.createBorder(borderColor: UIColor.red,xpos: 0)
        addressLine2TextField.setLeftGap(width: 0, placeHolderImage: UIImage.init())
        addressLine2TextField.setRightGap(width: 0, placeHolderImage: UIImage.init())
        addressLine2TextField.text_Color =  UIColor.black
        
        genderTextField.textFieldType = AITextField.AITextFieldType.TextPickerTextField
        genderTextField.updateUIAsPerTextFieldType()
        genderTextField.createUnderline(withColor: APP_LINE_COLOR, padding: 0, height: 1)
        genderTextField.placeHolderLabel = genderLabel
        //        mobileNumTextField.createBorder(borderColor: UIColor.red,xpos: 0)
        genderTextField.setLeftGap(width: 0, placeHolderImage: UIImage.init())
        genderTextField.setRightGap(width: 10, placeHolderImage: UIImage.init(named: "ic_downarrow_input")!)
        genderTextField.text_Color =  UIColor.black
        
        ageGroupTextField.textFieldType = AITextField.AITextFieldType.TextPickerTextField
        ageGroupTextField.updateUIAsPerTextFieldType()
        ageGroupTextField.createUnderline(withColor: APP_LINE_COLOR, padding: 0, height: 1)
        ageGroupTextField.placeHolderLabel = ageGroupLabel
        //        mobileNumTextField.createBorder(borderColor: UIColor.red,xpos: 0)
        ageGroupTextField.setLeftGap(width: 0, placeHolderImage: UIImage.init())
        ageGroupTextField.setRightGap(width:10, placeHolderImage: UIImage.init(named: "ic_downarrow_input")!)
        ageGroupTextField.text_Color =  UIColor.black
        
        ethnicityTextField.textFieldType = AITextField.AITextFieldType.TextPickerTextField
        ethnicityTextField.updateUIAsPerTextFieldType()
        ethnicityTextField.createUnderline(withColor: APP_LINE_COLOR, padding: 0, height: 1)
        ethnicityTextField.placeHolderLabel = ethnicityLabel
        //        mobileNumTextField.createBorder(borderColor: UIColor.red,xpos: 0)
        ethnicityTextField.setLeftGap(width: 0, placeHolderImage: UIImage.init())
        ethnicityTextField.setRightGap(width: 10, placeHolderImage:  UIImage.init(named: "ic_downarrow_input")!)
        ethnicityTextField.text_Color =  UIColor.black
        
        cityTextField.textFieldType = AITextField.AITextFieldType.NormalTextField
        cityTextField.updateUIAsPerTextFieldType()
        cityTextField.createUnderline(withColor: APP_LINE_COLOR, padding: 0, height: 1)
        cityTextField.placeHolderLabel = cityLabel
        //        mobileNumTextField.createBorder(borderColor: UIColor.red,xpos: 0)
        cityTextField.setLeftGap(width: 0, placeHolderImage: UIImage.init())
        cityTextField.setRightGap(width: 0, placeHolderImage: UIImage.init())
        cityTextField.text_Color =  UIColor.black
        
        stateTextField.textFieldType = AITextField.AITextFieldType.TextPickerTextField
        stateTextField.updateUIAsPerTextFieldType()
        stateTextField.createUnderline(withColor: APP_LINE_COLOR, padding: 0, height: 1)
        stateTextField.placeHolderLabel = stateLabel
        //        mobileNumTextField.createBorder(borderColor: UIColor.red,xpos: 0)
        stateTextField.setLeftGap(width: 0, placeHolderImage: UIImage.init())
        stateTextField.setRightGap(width: 10, placeHolderImage:UIImage.init(named: "ic_downarrow_input")!)
        stateTextField.text_Color =  UIColor.black
        
        zipCodeTextField.textFieldType = AITextField.AITextFieldType.NumberTextField
        zipCodeTextField.updateUIAsPerTextFieldType()
        zipCodeTextField.createUnderline(withColor: APP_LINE_COLOR, padding: 0, height: 1)
        zipCodeTextField.placeHolderLabel = zipcodeLabel
        //        mobileNumTextField.createBorder(borderColor: UIColor.red,xpos: 0)
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
        stateTextField.aiDelegate = self
        cityTextField.aiDelegate = self
        zipCodeTextField.aiDelegate = self
        
        var statesDict: NSDictionary?
        if let path = Bundle.main.path(forResource: "USStateAbbreviations", ofType: "plist") {
            statesDict = NSDictionary(contentsOfFile: path)
        }
        
        // let states = statesDict?.allValues as! [String]
        let stateKeys = statesDict?.allKeys as! [String]
        
        let sortedStates = stateKeys.sorted { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending }
        
        statesArray = NSMutableArray()
        for state in sortedStates {
            let str = statesDict?.value(forKey: state) as! String
            statesArray.add(str)
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
        stateTextField.updateUIAsPerTextFieldType()
        zipCodeTextField.updateUIAsPerTextFieldType()
        cityTextField.updateUIAsPerTextFieldType()
        zipCodeTextField.updateUIAsPerTextFieldType()
        
    }
    
    // MARK: - AITextField Delegate
    
    func getSelectedIndexFromPicker(selectedIndex: NSInteger, textField: AITextField) {
        let index = selectedIndex
        //print(""Index\(index)")
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
            selectedEthnicityIndex = index+1
        }
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
        else {
            textField.resignFirstResponder()
        }
    }
    
    
    
    func isInformationModified() -> Bool {
        
        let userData = UserDefaults.standard.object(forKey: USER_DATA)
        let userInfo = NSKeyedUnarchiver.unarchiveObject(with: userData as! Data)
        
        let user:User = userInfo as! User
        
        
        if user.additionalInformation?.first_name == firstNameTextField.text &&
            user.additionalInformation?.last_name == lastNameTextField.text &&
            user.additionalInformation?.address_line1 == addressLine1TextField.text &&
            user.additionalInformation?.address_line2 == addressLine2TextField.text &&
            user.additionalInformation?.city == cityTextField.text &&
            user.additionalInformation?.state == stateTextField.text &&
            user.zipcode == zipCodeTextField.text {
        
            if selectedGenderIndex != nil {
                if user.additionalInformation?.gender != String(selectedGenderIndex) {
                    return true
                }
            }
            if selectedAgeGroupIndex != nil {
                if user.additionalInformation?.age_group != String(selectedAgeGroupIndex) {
                    return true
                }
            }
            if selectedEthnicityIndex != nil {
                if user.additionalInformation?.ethnicity != String(selectedEthnicityIndex) {
                    return true
                }
            }
            
            return false    // Information not modified
        } else {
            return true // Information modified
        }
        
        
//        guard
//            user.additionalInformation?.first_name == firstNameTextField.text,
//            user.additionalInformation?.last_name == lastNameTextField.text,
//            user.additionalInformation?.address_line1 == addressLine1TextField.text,
//            user.additionalInformation?.address_line2 == addressLine2TextField.text,
//            user.additionalInformation?.city == cityTextField.text,
//            user.additionalInformation?.state == stateTextField.text,
//            user.zipcode == zipCodeTextField.text,
//            user.additionalInformation?.gender == "\(selectedGenderIndex)",
//            user.additionalInformation?.age_group == "\(selectedAgeGroupIndex)",
//            user.additionalInformation?.ethnicity == "\(selectedEthnicityIndex)"
//            else {
//                return true
//        }
//        
//        return false
    }
    
    func updateUserInformation(){
        
        if !isValid() {
            return
        }
        let reachbility:NetworkReachabilityManager = NetworkReachabilityManager()!
        let isReachable = reachbility.isReachable
        // Reachability
        if isReachable == false {
            self.showAlert(title: "", message: "The internet connection appears to be offline.".localized());
            return
        }
        
        let userData = UserDefaults.standard.object(forKey: USER_DATA)
        let userInfo = NSKeyedUnarchiver.unarchiveObject(with: userData as! Data)
        
        //print(""user info \(userInfo)")
        
        let user:User = userInfo as! User
        
        let device_id = UIDevice.current.identifierForVendor!.uuidString
        let user_id  = UserDefaults.standard.object(forKey: USER_ID) ?? ""
        let auth_token : String = UserDefaults.standard.object(forKey: AUTH_TOKEN) as! String
        let first_name = firstNameTextField.text ?? ""
        let last_name = lastNameTextField.text ?? ""
        let address_line1 = addressLine1TextField.text ?? ""
        let address_line2 = addressLine2TextField.text ?? ""
        let city = cityTextField.text ?? ""
        let state = stateTextField.text ?? ""
        let zipCode = zipCodeTextField.text ?? ""
        var gender = ""
        var age_group = ""
        var ethnicity = ""
        let currentLanguage = Localize.currentLanguage()
        
        if selectedGenderIndex != nil{
            gender =  String.init(format: "%d", selectedGenderIndex)
        }
        else{
            gender = user.additionalInformation?.gender ?? ""
        }
        if selectedAgeGroupIndex != nil{
            age_group  = String.init(format: "%d", selectedAgeGroupIndex)
        }
        else{
            age_group = user.additionalInformation?.age_group ?? ""
        }
        
        if selectedEthnicityIndex != nil{
            ethnicity  = String.init(format: "%d", selectedEthnicityIndex)
        }
        else{
            ethnicity = user.additionalInformation?.ethnicity ?? ""
        }
        let version_name = Bundle.main.releaseVersionNumber ?? ""
        let version_code = Bundle.main.buildVersionNumber ?? ""
        
        
        let parameters : Parameters = ["first_name" : first_name,
                                       "last_name" : last_name,
                                       "address_line1" : address_line1,
                                       "address_line2" : address_line2,
                                       "city":city,
                                       "state": state,
                                       "gender": gender,
                                       "age_group": age_group,
                                       "referral_code": "",
                                       "ethnicity": ethnicity,
                                       "user_id": user_id,
                                       "platform":"1",
                                       "zipcode" : zipCode,
                                       "version_code": version_code,
                                       "version_name": version_name,
                                       "device_id": device_id,
                                       "push_token":"",
                                       "auth_token": auth_token,
                                       "language":currentLanguage
        ]
        
        saveActivityIndicator.startAnimating()
        //print("parameters)
        let url = String(format: "%@/updatePersonalInformation", hostUrl)
        //print("url)
        Alamofire.postRequest(URL(string:url)!, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response:DataResponse<Any>) in
            switch response.result {
                
            case .success:
                DispatchQueue.main.async {
                    self.saveActivityIndicator.stopAnimating()
                    let json = JSON(data: response.data!)
                    //print(""json response\(json)")
                    let responseDict = json.dictionaryObject
                    //let code : NSNumber = responseDict?["code"] as! NSNumber
                    if let messageString = responseDict?["message"] {
                        
                        let alertMessage = messageString as! String
//                        let alertController = UIAlertController(title: "", message: alertMessage, preferredStyle: .alert)
//                        let defaultAction = UIAlertAction.init(title: "OK", style: .default, handler: {
//                            (action) in
//                            self.view.endEditing(true)
//                            _ = self.navigationController?.popViewController(animated: true)
//                        })
//                        
//                        alertController.addAction(defaultAction)
//                        self.present(alertController, animated: true, completion: nil)
                        
                          self.showAlert(title: "", message: alertMessage, action: #selector(self.alertAction), showCancel: false)
                    }
                    
                }
                break
                
            case .failure(let error):
                
                DispatchQueue.main.async {
                    self.saveActivityIndicator.stopAnimating()
                    self.showAlert(title: "", message: error.localizedDescription);
                }
                //print("error)
                break
            }
            
        }
    }
    
    func loadUserInformation() {
        // //print(""user id\(self.user.id)")
        let userData = UserDefaults.standard.object(forKey: USER_DATA)
        let userInfo = NSKeyedUnarchiver.unarchiveObject(with: userData as! Data)
        
        //print(""user info \(userInfo)")
        
        let user:User = userInfo as! User
        
        // let userAdditionalInfo : AdditionalInformation = self.user.additionalInformation!
        firstNameTextField.text = user.additionalInformation?.first_name
        lastNameTextField.text = user.additionalInformation?.last_name
        addressLine1TextField.text = user.additionalInformation?.address_line1
        addressLine2TextField.text = user.additionalInformation?.address_line2
        cityTextField.text = user.additionalInformation?.city
        stateTextField.text = user.additionalInformation?.state
        zipCodeTextField.text = user.zipcode
        
        if let gender = user.additionalInformation?.gender {
            if let index = Int(gender) {
                if index == 0 {
                    genderTextField.text = ""
                } else {
                    selectedGenderIndex = index
                    genderTextField.text = genderArray.object(at: index - 1) as? String
                }
            } else {
                genderTextField.text = ""
            }
        }
        
        
//        if (user.additionalInformation?.gender) != nil/* && ((user.additionalInformation?.gender?.characters.count)! > 0)*/{
//            
//            let index = Int((user.additionalInformation?.gender)!)!
//            if index == 0 {
//                genderTextField.text = ""
//            }
//            else{
//                selectedGenderIndex = index
//                genderTextField.text = genderArray.object(at: index - 1) as? String
//            }
//        }
        
        if let ageGroup = user.additionalInformation?.age_group {
            if let index = Int(ageGroup) {
                if index == 0 {
                    ageGroupTextField.text = ""
                } else {
                    selectedAgeGroupIndex = index
                    ageGroupTextField.text = ageGroupArray.object(at: index - 1) as? String
                }
            } else {
                ageGroupTextField.text = ""
            }
        }
        
        
//        
//        if (user.additionalInformation?.age_group) != nil /*&& ((user.additionalInformation?.gender?.characters.count)! > 0)*/ {
//            
//            let index = Int((user.additionalInformation?.age_group)!)!
//            if index == 0{
//                ageGroupTextField.text = ""
//            }
//            else{
//                selectedAgeGroupIndex = index
//                ageGroupTextField.text = ageGroupArray.object(at: index - 1) as? String
//            }
//        }
        
        if let ethnicity = user.additionalInformation?.ethnicity {
            if let index = Int(ethnicity) {
                if index == 0 {
                    ethnicityTextField.text = ""
                } else {
                    selectedEthnicityIndex = index
                    ethnicityTextField.text = ethnicityArray.object(at: index - 1) as? String
                }
            } else {
                ethnicityTextField.text = ""
            }
        }
        
//        if (user.additionalInformation?.ethnicity) != nil {
//            
//            let index = Int((user.additionalInformation?.ethnicity)!)!
//            if index == 0 {
//                ethnicityTextField.text = ""
//            }
//            else {
//                selectedEthnicityIndex = index
//                ethnicityTextField.text = ethnicityArray.object(at: index - 1) as? String
//                
//            }
//        }
//        
        
        
    }
    
    func getProfile(){
        
        let reachbility:NetworkReachabilityManager = NetworkReachabilityManager()!
        let isReachable = reachbility.isReachable
        // Reachability
        if isReachable == false {
            
            let alertMessage = "The internet connection appears to be offline.".localized()
//            let alertController = UIAlertController(title: "", message: alertMessage, preferredStyle: .alert)
//            let defaultAction = UIAlertAction.init(title: "OK", style: .default, handler: {
//                (action) in
//                self.view.endEditing(true)
//                _ = self.navigationController?.popViewController(animated: true)
//            })
//            
//            alertController.addAction(defaultAction)
//            self.present(alertController, animated: true, completion: nil)
            self.showAlert(title: "", message: alertMessage, action: #selector(alertAction), showCancel: false)
            return
        }
        
        
        let device_id = UIDevice.current.identifierForVendor!.uuidString
        let user_id  = UserDefaults.standard.object(forKey: USER_ID) ?? ""
        let auth_token : String = UserDefaults.standard.object(forKey: AUTH_TOKEN) as! String
        let currentLanguage = Localize.currentLanguage()
        let version_name = Bundle.main.releaseVersionNumber ?? ""
        let version_code = Bundle.main.buildVersionNumber ?? ""
        
        let parameters : Parameters = ["user_id": user_id,
                                       "platform":"1",
                                       "version_code": version_code,
                                       "version_name": version_name,
                                       "device_id": device_id,
                                       "push_token":"",
                                       "auth_token": auth_token,
                                       "language": currentLanguage
        ]
        
       // print(parameters)
        
        SwiftLoader.show(title: "Loading...".localized(), animated: true)
        let url = String(format: "%@/getProfile", hostUrl)
        //print("url)
        Alamofire.postRequest(URL(string:url)!, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response:DataResponse<Any>) in
            switch response.result {
                
            case .success:
                DispatchQueue.main.async {
                    // HUD.hide()
                    SwiftLoader.hide()
                }
                
                let json = JSON(data: response.data!)
                //print("json response\(json)")
                let responseDict = json.dictionaryObject
                if let code = responseDict?["code"] {
                    let code = code as! NSNumber
                    if code.intValue == 200 {
                        if let userDict = responseDict?["user"] {
                            self.user = User.prepareUser(dictionary: userDict as! [String : Any])
                            // self.user.auth_token = responseDict?["auth_token"] as! String
                            let userData = NSKeyedArchiver.archivedData(withRootObject: self.user)
                            UserDefaults.standard.set(userData, forKey: USER_DATA)
                            self.loadUserInformation()
                        }
                    }
                    else {
                        if let messageString = responseDict?["message"]{
                            let alertMessage : String = messageString as! String
                            self.showAlert(title: "", message: alertMessage)
                        }
                    }
                }
                break
                
            case .failure(let error):
                
                DispatchQueue.main.async {
                    //HUD.hide()
                    SwiftLoader.hide()
                    let message = error.localizedDescription
//                    let alertMessage = message
//                    let alertController = UIAlertController(title: "", message: alertMessage, preferredStyle: .alert)
//                    let defaultAction = UIAlertAction.init(title: "OK", style: .default, handler: {
//                        (action) in
//                        self.view.endEditing(true)
//                        _ = self.navigationController?.popViewController(animated: true)
//                    })
//                    
//                    alertController.addAction(defaultAction)
//                    self.present(alertController, animated: true, completion: nil)
                    self.showAlert(title: "", message: message, action: #selector(self.alertAction), showCancel: false)
                    
                }
                break
            }
            
        }
        
    }
    
    func aiTextField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == zipCodeTextField  {
            let currentCharacterCount = textField.text?.count ?? 0
            if (range.length + range.location > currentCharacterCount){
                return false
            }
            let newLength = currentCharacterCount + string.count - range.length
            return newLength <= 5
            
        }
        
        return true
    }
    
    func isValid() -> Bool {
        
        if (zipCodeTextField.text?.count)! == 0 {
            showAlert(title: "", message: "Please enter your zip code.".localized())
            return false
        }
        
        if (zipCodeTextField.text?.count)! < 5 {
                showAlert(title: "", message: "Please enter a valid zip code.".localized())
                return false
                
            }
        
        return true
    }
    
    @objc func alertAction() {
        self.view.endEditing(true)
        _ = self.navigationController?.popViewController(animated: true)
    }
    
}


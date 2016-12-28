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
    
    @IBAction func registerButtonAction(_ sender: UIButton) {
        
        userSignUp()
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
        
        loadTextFields();
        print(userDetailsDict)
        
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
        super.viewDidDisappear(animated)
        self.view.endEditing(true)
        LanguageUtility.removeObserverForLanguageChange(self)
    }
    
    
    func languageButtonClicked() {
        
        self.showLanguageSelectionAlert()
        
    }
    
    func reloadContent() {
        
        DispatchQueue.main.async {
            self.languageSelectionButton.setTitle("language.button.title".localized(), for: .normal)
            self.updateBackButtonText()
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
        }
    }

    func backButtonAction(){
        _ = self.navigationController?.popViewController(animated: true)
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
        //        mobileNumTextField.createBorder(borderColor: UIColor.red,xpos: 0)
        firstNameTextField.setLeftGap(width: 0, placeHolderImage: UIImage.init())
        firstNameTextField.setRightGap(width: 0, placeHolderImage: UIImage.init())
        firstNameTextField.text_Color =  UIColor.black
        
        lastNameTextField.textFieldType = AITextField.AITextFieldType.NormalTextField
        lastNameTextField.updateUIAsPerTextFieldType()
        lastNameTextField.createUnderline(withColor: APP_LINE_COLOR, padding: 0, height: 1)
        lastNameTextField.placeHolderLabel = lastNameLabel
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
        
        groupCodeTextField.textFieldType = AITextField.AITextFieldType.NormalTextField
        groupCodeTextField.updateUIAsPerTextFieldType()
        groupCodeTextField.createUnderline(withColor: APP_LINE_COLOR, padding: 0, height: 1)
        groupCodeTextField.placeHolderLabel = groupCodeLabel
        //        mobileNumTextField.createBorder(borderColor: UIColor.red,xpos: 0)
        groupCodeTextField.setLeftGap(width: 0, placeHolderImage: UIImage.init())
        groupCodeTextField.setRightGap(width: 0, placeHolderImage: UIImage.init())
        groupCodeTextField.text_Color =  UIColor.black
        
        referralCodeTextField.textFieldType = AITextField.AITextFieldType.NormalTextField
        referralCodeTextField.updateUIAsPerTextFieldType()
        referralCodeTextField.createUnderline(withColor: APP_LINE_COLOR, padding: 0, height: 1)
        referralCodeTextField.placeHolderLabel = referralCodeLabel
        //        mobileNumTextField.createBorder(borderColor: UIColor.red,xpos: 0)
        referralCodeTextField.setLeftGap(width: 0, placeHolderImage: UIImage.init())
        referralCodeTextField.setRightGap(width: 0, placeHolderImage: UIImage.init())
        referralCodeTextField.text_Color =  UIColor.black
        
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
        
        zipCodeTextField.textFieldType = AITextField.AITextFieldType.PhoneNumberTextField
        zipCodeTextField.updateUIAsPerTextFieldType()
        zipCodeTextField.createUnderline(withColor: APP_LINE_COLOR, padding: 0, height: 1)
        zipCodeTextField.placeHolderLabel = zipCodeLabel
        //        mobileNumTextField.createBorder(borderColor: UIColor.red,xpos: 0)
        zipCodeTextField.setLeftGap(width: 0, placeHolderImage: UIImage.init())
        zipCodeTextField.setRightGap(width: 0, placeHolderImage: UIImage.init())
        zipCodeTextField.text_Color =  UIColor.black
        
        /*  firstNameTextField.delegate = self
         lastNameTextField.delegate = self
         addressLine1TextField.delegate = self
         addressLine2TextField.delegate = self
         genderTextField.delegate = self
         ageGroupTextField.delegate = self
         ethnicityTextField.delegate = self
         groupCodeTextField.delegate = self
         referralCodeTextField.delegate = self*/
        
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
        
        genderArray = ["Male","Female"];
        ageGroupArray = ["16-25","26-35","36-45","46-55","56+"]
        ethnicityArray = ["1","2"]
        
        genderTextField.pickerViewArray = genderArray
        ageGroupTextField.pickerViewArray = ageGroupArray
        ethnicityTextField.pickerViewArray = ethnicityArray
        
        
        var statesDict: NSDictionary?
        if let path = Bundle.main.path(forResource: "USStateAbbreviations", ofType: "plist") {
            statesDict = NSDictionary(contentsOfFile: path)
        }
        
        let states = statesDict?.allKeys as! [String]
        statesArray = NSMutableArray()
        for state in states {
            statesArray.add(state)
        }
        
        stateTextField.pickerViewArray = statesArray
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
    func keyBoardHidden(textField: UITextField) {
        
    }
    
    func userSignUp(){
        
        let password = userDetailsDict["password"] as! String
        let phone_number = userDetailsDict["phone_number"] as! String
        let email = userDetailsDict["email"] as! String
        let zipcode = userDetailsDict["zipcode"] as! String
        let social_id = userDetailsDict["social_id"] as! String
        let contactPrefernce: Int = userDetailsDict["contact_preference"] as! Int
        var contact_preference = "1"
        if contactPrefernce == 0 {
            contact_preference = "1"
        } else{
            contact_preference = "2"
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
        
        if selectedGenderIndex != nil{
            gender =  String.init(format: "%d", selectedGenderIndex)
        }
        if selectedAgeGroupIndex != nil{
            age_group  = String.init(format: "%d", selectedAgeGroupIndex)
        }
        if SelectedEthnicityIndex != nil{
            ethnicity  = String.init(format: "%d", SelectedEthnicityIndex)
        }
        let referral_code = referralCodeTextField.text ?? ""
        let platform = "1"
        let device_id = UIDevice.current.identifierForVendor!.uuidString
        let push_token = "123213"
        let language = "en"
        
        let additionalInfoDict : Dictionary = ["first_name": first_name,
                                  "last_name": last_name,
                                  "address_line1": address_line1,
                                  "address_line2": address_line2,
                                  "city": city,
                                  "state": state,
                                  "gender": gender,
                                  "age_group": age_group,
                                  "referral_code": referral_code,
                                  "ethnicity": ethnicity]
        
        let parameters = ["password" : password,
                          "phone_number" : phone_number,
                          "email" : email,
                          "zipcode": zipcode,
                          "social_id":social_id,
                          "contact_preference": contact_preference,
                          "additional_info" : additionalInfoDict,
                          "platform": platform,
                          "version_code":"1",
                          "version_name":"1",
                          "device_id": device_id,
                          "push_token": push_token,
                          "language": language,
                          "signup_type": "1"
            ] as [String : Any]
        
        print(parameters)
        
        
        let url = String(format: "%@/signUp", hostUrl)
        print(url)
        Alamofire.postRequest(URL(string:url)!, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response:DataResponse<Any>) in
            
            switch response.result {
            case .success:
                let json = JSON(data: response.data!)
                print("json response\(json)")
                
                if (json.dictionary != nil){
                    // let jsonDict = json
                    let responseDict = json.dictionaryObject
                    let code = responseDict?["code"] as! NSNumber
                    if code.intValue == 200{
                        self.showSignUpAlert();
                        self.view.endEditing(true)
                    }
                    else{
                        if let responseDict = json.dictionaryObject {
                            let alertMessage = responseDict["message"] as! String
                            self.showAlert(title: "", message: alertMessage)
                        }
                        
                    }
                }
                break
                
            case .failure(let error):
                
                DispatchQueue.main.async {
                    //  _ = EZLoadingActivity.hide()
                }
                print(error)
                break
            }
            
            
        }
        
        
    }
    
    func getSelectedIndexFromPicker(selectedIndex: NSInteger, textField: AITextField) {
        let index = selectedIndex
        print("Index\(index)")
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
    
    func showSignUpAlert(){
        
        let titleStr : String = "SignUpAlertTitle".localized()
        let messageStr : String = "SignUpAlertMessage".localized()
        
        let signUpAlert = UIAlertController.init(title: titleStr, message:messageStr, preferredStyle: .alert)
        
        let hogan = NSMutableAttributedString(string: titleStr)
        
        //Make the attributes, like size and color
        hogan.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFont(ofSize: 16.0), range: NSMakeRange(0,NSString(string: hogan.string).length))
        
        hogan.addAttribute(NSForegroundColorAttributeName, value: APP_GRREN_COLOR, range: NSMakeRange(0, NSString(string: hogan.string).length))
        
        signUpAlert.setValue(hogan, forKey: "attributedTitle")
        
        let closeBtn = UIAlertAction.init(title: "Close".localized(), style: .default, handler:{
            (action) in
            let loginVc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC")
            self.navigationController?.show(loginVc, sender: self)
            
        })
        
        signUpAlert.view.tintColor = APP_GRREN_COLOR
        signUpAlert .addAction(closeBtn)
        self.present(signUpAlert, animated: true, completion:nil)
        
    }
    
}

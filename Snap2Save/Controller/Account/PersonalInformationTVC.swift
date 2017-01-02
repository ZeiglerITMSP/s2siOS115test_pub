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

class PersonalInformationTVC: UITableViewController,AITextFieldProtocol {

    enum DropDownTags:Int {
        case states = 100
        case gender
        case ageGroup
        case ethnicity
    }
    var user : User = User()
    var additionalInfo : UserAdditionalInformation = UserAdditionalInformation()
    var languageSelectionButton: UIButton!
    var ageGroupArray : NSMutableArray!
    var statesArray : NSMutableArray!
    var ethnicityArray : NSMutableArray!
    var genderArray : NSMutableArray!
    var selectedStateIndex : NSInteger!
    var selectedGenderIndex : NSInteger!
    var selectedAgeGroupIndex : NSInteger!
    var SelectedEthnicityIndex : NSInteger!

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
        updateUserInformation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        AppHelper.setRoundCornersToView(borderColor: APP_ORANGE_COLOR, view: saveButton, radius: 2.0, width: 1.0)
        languageSelectionButton = LanguageUtility.createLanguageSelectionButton(withTarge: self, action: #selector(languageButtonClicked))
        LanguageUtility.addLanguageButton(languageSelectionButton, toController: self)
        reloadContent()
        loadTextFields()
        loadUserInformation()
        getProfile()
        self.navigationItem.addBackButton(withTarge: self, action: #selector(backAction))
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: -
    func languageButtonClicked() {
        self.showLanguageSelectionAlert()
    }
    
    func backAction() {
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    func reloadContent() {
        
        self.updateBackButtonText()
        self.languageSelectionButton.setTitle("language.button.title".localized(), for: .normal)
        self.title = "Personal Information".localized()
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
        
        zipCodeTextField.textFieldType = AITextField.AITextFieldType.NormalTextField
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

    // MARK: - AITextField Delegate
    
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

    func updateUserInformation(){
        
        let device_id = UIDevice.current.identifierForVendor!.uuidString
        let user_id  = UserDefaults.standard.object(forKey: USER_ID) ?? ""
        let auth_token : String = UserDefaults.standard.object(forKey: AUTH_TOKEN) as! String
        let first_name = firstNameTextField.text ?? ""
        let last_name = lastNameTextField.text ?? ""
        let address_line1 = addressLine1TextField.text ?? ""
        let address_line2 = addressLine2TextField.text ?? ""
        let city = cityTextField.text ?? ""
        let state = stateTextField.text ?? ""
        
        let parameters = ["first_name" : first_name,
                          "last_name" : last_name,
                          "address_line1" : address_line1,
                          "address_line2" : address_line2,
                          "city":city,
                          "state": state,
                          "gender": selectedGenderIndex,
                          "age_group": selectedAgeGroupIndex,
                          "referral_code": "",
                          "ethnicity": SelectedEthnicityIndex,
                          "user_id": user_id,
                          "platform":"1",
                          "version_code": "1",
                          "version_name": "1",
                          "device_id": device_id,
                          "push_token":"123123",
                          "auth_token": auth_token,
                          "language":"en"
            ] as [String : Any]
        
        saveActivityIndicator.startAnimating()
        print(parameters)
        let url = String(format: "%@/updatePersonalInformation", hostUrl)
        print(url)
        Alamofire.postRequest(URL(string:url)!, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response:DataResponse<Any>) in
            switch response.result {
                
            case .success:
                DispatchQueue.main.async {
                    self.saveActivityIndicator.stopAnimating()
                }
                
                let json = JSON(data: response.data!)
                print("json response\(json)")
                let responseDict = json.dictionaryObject
                //let code : NSNumber = responseDict?["code"] as! NSNumber
                if let messageString = responseDict?["message"]{
                    let alertMessage : String = messageString as! String
                    self.showAlert(title: "", message: alertMessage)
                    
                }
                break
                
            case .failure(let error):
                
                DispatchQueue.main.async {
                    self.saveActivityIndicator.stopAnimating()
                }
                print(error)
                break
            }
            
        }
    }

    func loadUserInformation(){
        print("user id\(self.user.id)")
        print("user info \(self.user.userInfo)")
        //let userData = NSKeyedArchiver.archivedData(withRootObject: self.user)
        ///UserDefaults.standard.set(userData, forKey: LOGGED_USER)
        //let userData = UserDefaults.standard.object(forKey: LOGGED_USER)
        //let userInfo = NSKeyedUnarchiver.unarchiveObject(with: userData as! Data)
        
        //print("user info \(userInfo)")
        
       // let user:User = userInfo as! User
       // print("user id \(user.id)")
       // print("user info \(user.email)")

      //  additionalInfo = user.userInfo as! [String : Any]
       /* firstNameTextField.text = user.first_name
        lastNameTextField.text = user.last_name
        addressLine1TextField.text = additionalInfo.address_line1
        addressLine2TextField.text = ""
        cityTextField.text = ""
        stateTextField.text = ""
        zipCodeTextField.text = ""
        genderTextField.text = ""
        ageGroupTextField.text = ""
        ethnicityTextField.text = ""*/
        
    }
    
    func getProfile(){
        
        let device_id = UIDevice.current.identifierForVendor!.uuidString
        let user_id  = UserDefaults.standard.object(forKey: USER_ID) ?? ""
        let auth_token : String = UserDefaults.standard.object(forKey: AUTH_TOKEN) as! String
        
        let parameters = ["user_id": user_id,
                          "platform":"1",
                          "version_code": "1",
                          "version_name": "1",
                          "device_id": device_id,
                          "push_token":"123123",
                          "auth_token": auth_token,
                          "language":"en"
            ] as [String : Any]
        
        print(parameters)
        let url = String(format: "%@/getProfile", hostUrl)
        print(url)
        Alamofire.postRequest(URL(string:url)!, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response:DataResponse<Any>) in
            switch response.result {
                
            case .success:
                DispatchQueue.main.async {
                }
                
                let json = JSON(data: response.data!)
                print("json response\(json)")
                let responseDict = json.dictionaryObject
                //let code : NSNumber = responseDict?["code"] as! NSNumber
                //if let messageString = responseDict?["message"]{
                  //  let alertMessage : String = messageString as! String
                  //  self.showAlert(title: "", message: alertMessage)
                    
               // }
                if let code = responseDict?["code"] {
                    let code = code as! NSNumber
                if code.intValue == 200 {
                    
                    if let userDict = responseDict?["user"] {
                        self.user = User.prepareUser(dictionary: userDict as! [String : Any])
                        let userData = NSKeyedArchiver.archivedData(withRootObject: self.user)
                        UserDefaults.standard.set(userData, forKey: LOGGED_USER)
                        self.updateUserInformation()
                    }
                }
                }
                
                break
                
            case .failure(let error):
                
                DispatchQueue.main.async {
                }
                print(error)
                break
            }
            
        }

    }
}

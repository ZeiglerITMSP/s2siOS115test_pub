//
//  RedeemPointsAddressTVC.swift
//  Snap2Save
//
//  Created by Malathi on 23/02/17.
//  Copyright © 2017 Appit. All rights reserved.
//

import UIKit
import Localize_Swift
import Alamofire
import  SwiftyJSON


class RedeemPointsAddressTVC: UITableViewController,AITextFieldProtocol {

    enum DropDownTags:Int {
        case states = 100
    }

    var languageSelectionButton: UIButton!

    var statesArray : NSMutableArray = NSMutableArray()
    
    var selectedStateIndex : NSInteger!
    
    var user : User = User()

    @IBOutlet var messageLabel: UILabel!
    
    @IBOutlet var mailingAddressLabel: UILabel!
    
    @IBOutlet var firstNameLabel: UILabel!
    
    @IBOutlet var firstNameTF: AITextField!
    
    @IBOutlet var lastNameLabel: UILabel!
    
    @IBOutlet var lastNameTf: AITextField!
    
    @IBOutlet var addressLine1Tf: AITextField!
    @IBOutlet var addressLine1Label: UILabel!
    
    @IBOutlet var addressLine2Label: UILabel!
    
    @IBOutlet var addressLine2Tf: AITextField!
    
    @IBOutlet var cityLabel: UILabel!
    
    @IBOutlet var cityTf: AITextField!
    
    @IBOutlet var stateLabel: UILabel!
    
    @IBOutlet var stateTf: AITextField!
    
    @IBOutlet var zipCodeLabel: UILabel!
    
    @IBOutlet var zipCodeTf: AITextField!
    
    @IBOutlet var redeemNowButton: UIButton!
    
    @IBOutlet var redeemNowActivityIndicator: UIActivityIndicatorView!
    
    @IBAction func redeemNowButtonAction(_ sender: UIButton) {
        
        if !isValidData()
        {
            return
        }
        
        
        let redeemAlert = UIAlertController.init(title: nil, message: "Are you sure you want to redeem points?".localized(), preferredStyle: .alert)
        let okBtn = UIAlertAction.init(title: "OK".localized(), style: .default, handler:{
            (action) in
            self.getRedeemPoints()
        })
        
        let cancelBtn = UIAlertAction.init(title: "Cancel".localized(), style: .cancel, handler:nil)
        
        redeemAlert .addAction(okBtn)
        redeemAlert.addAction(cancelBtn)
        
        self.present(redeemAlert, animated: true, completion:nil)
        redeemAlert.view.tintColor = APP_GRREN_COLOR
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        AppHelper.setRoundCornersToView(borderColor: APP_ORANGE_COLOR, view: redeemNowButton, radius: 2.0, width: 1.0)
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 80
        
        // language button
        loadTextFields();

        reloadContent()
        languageSelectionButton = LanguageUtility.createLanguageSelectionButton(withTarge: self, action: #selector(languageButtonClicked))
        LanguageUtility.addLanguageButton(languageSelectionButton, toController: self)
        self.navigationItem.addBackButton(withTarge: self, action: #selector(backAction))
        

        getProfile()
        
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadContent()
        AppHelper.getScreenName(screenName: "Redeem Points Mailing Address screen")

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        LanguageUtility.addOberverForLanguageChange(self, selector: #selector(reloadContent))
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        LanguageUtility.removeObserverForLanguageChange(self)
        super.viewDidDisappear(animated)
    }
    
    func backAction() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func languageButtonClicked() {
        self.showLanguageSelectionAlert()
    }
    
    func reloadContent() {
        
        DispatchQueue.main.async {
            self.updateBackButtonText()
            self.languageSelectionButton.setTitle("language.button.title".localized(), for: .normal)
            self.updateTextFieldsUi()
            self.navigationItem.title = "Redeem Points".localized()
            self.messageLabel.text = "Your Save-A-Lot gift card will be mailed to the following address. If any of the information is incorrect or missing, please make changes or additions as necessary.".localized()
            self.mailingAddressLabel.text = "MAILING ADDRESS".localized()
            self.firstNameLabel.text = "FIRST NAME".localized()
            self.lastNameLabel.text = "LAST NAME".localized()
            self.addressLine1Label.text = "ADDRESS LINE 1".localized()
            self.addressLine2Label.text = "ADDRESS LINE 2".localized()
            self.cityLabel.text = "CITY".localized()
            self.stateLabel.text = "STATE".localized()
            self.zipCodeLabel.text = "ZIP CODE".localized()
            self.redeemNowButton.setTitle("REDEEM NOW".localized(), for: .normal)
            self.addressLine1Tf.placeholder = "Street address or PO box".localized()
            self.addressLine2Tf.placeholder = "Unit, Building, etc.".localized()
            self.tableView.reloadData()
        }
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
        return 8
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }

    
    func loadTextFields(){
        
        stateTf.tag = 100
        
        
        firstNameTF.textFieldType = AITextField.AITextFieldType.NormalTextField
        firstNameTF.updateUIAsPerTextFieldType()
        
        firstNameTF.createUnderline(withColor: APP_LINE_COLOR, padding: 0, height: 1)
        firstNameTF.placeHolderLabel = firstNameLabel
        //        mobileNumTextField.createBorder(borderColor: UIColor.red,xpos: 0)
        firstNameTF.setLeftGap(width: 0, placeHolderImage: UIImage.init())
        firstNameTF.setRightGap(width: 0, placeHolderImage: UIImage.init())
        firstNameTF.text_Color =  UIColor.black
        
        lastNameTf.textFieldType = AITextField.AITextFieldType.NormalTextField
        lastNameTf.updateUIAsPerTextFieldType()
        lastNameTf.createUnderline(withColor: APP_LINE_COLOR, padding: 0, height: 1)
        lastNameTf.placeHolderLabel = lastNameLabel
        //        mobileNumTextField.createBorder(borderColor: UIColor.red,xpos: 0)
        lastNameTf.setLeftGap(width: 0, placeHolderImage: UIImage.init())
        lastNameTf.setRightGap(width: 0, placeHolderImage: UIImage.init())
        lastNameTf.text_Color =  UIColor.black
        
        addressLine1Tf.textFieldType = AITextField.AITextFieldType.NormalTextField
        addressLine1Tf.updateUIAsPerTextFieldType()
        addressLine1Tf.createUnderline(withColor: APP_LINE_COLOR, padding: 0, height: 1)
        addressLine1Tf.placeHolderLabel = addressLine1Label
        //        mobileNumTextField.createBorder(borderColor: UIColor.red,xpos: 0)
        addressLine1Tf.setLeftGap(width: 0, placeHolderImage: UIImage.init())
        addressLine1Tf.setRightGap(width: 0, placeHolderImage: UIImage.init())
        addressLine1Tf.text_Color =  UIColor.black
        
        addressLine2Tf.textFieldType = AITextField.AITextFieldType.NormalTextField
        addressLine2Tf.updateUIAsPerTextFieldType()
        addressLine2Tf.createUnderline(withColor: APP_LINE_COLOR, padding: 0, height: 1)
        addressLine2Tf.placeHolderLabel = addressLine2Label
        //        mobileNumTextField.createBorder(borderColor: UIColor.red,xpos: 0)
        addressLine2Tf.setLeftGap(width: 0, placeHolderImage: UIImage.init())
        addressLine2Tf.setRightGap(width: 0, placeHolderImage: UIImage.init())
        addressLine2Tf.text_Color =  UIColor.black
        
       
        
        cityTf.textFieldType = AITextField.AITextFieldType.NormalTextField
        cityTf.updateUIAsPerTextFieldType()
        cityTf.createUnderline(withColor: APP_LINE_COLOR, padding: 0, height: 1)
        cityTf.placeHolderLabel = cityLabel
        //        mobileNumTextField.createBorder(borderColor: UIColor.red,xpos: 0)
        cityTf.setLeftGap(width: 0, placeHolderImage: UIImage.init())
        cityTf.setRightGap(width: 0, placeHolderImage: UIImage.init())
        cityTf.text_Color =  UIColor.black
        
        stateTf.textFieldType = AITextField.AITextFieldType.TextPickerTextField
        stateTf.updateUIAsPerTextFieldType()
        stateTf.createUnderline(withColor: APP_LINE_COLOR, padding: 0, height: 1)
        stateTf.placeHolderLabel = stateLabel
        //        mobileNumTextField.createBorder(borderColor: UIColor.red,xpos: 0)
        stateTf.setLeftGap(width: 0, placeHolderImage: UIImage.init())
        stateTf.setRightGap(width: 10, placeHolderImage:UIImage.init(named: "ic_downarrow_input")!)
        stateTf.text_Color =  UIColor.black
        
        zipCodeTf.textFieldType = AITextField.AITextFieldType.NumberTextField
        zipCodeTf.updateUIAsPerTextFieldType()
        zipCodeTf.createUnderline(withColor: APP_LINE_COLOR, padding: 0, height: 1)
        zipCodeTf.placeHolderLabel = zipCodeLabel
        //        mobileNumTextField.createBorder(borderColor: UIColor.red,xpos: 0)
        zipCodeTf.setLeftGap(width: 0, placeHolderImage: UIImage.init())
        zipCodeTf.setRightGap(width: 0, placeHolderImage: UIImage.init())
        zipCodeTf.text_Color =  UIColor.black
        
        
        firstNameTF.aiDelegate = self
        lastNameTf.aiDelegate = self
        addressLine1Tf.aiDelegate = self
        addressLine2Tf.aiDelegate = self
        stateTf.aiDelegate = self
        cityTf.aiDelegate = self
        zipCodeTf.aiDelegate = self
        
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
        
        stateTf.pickerViewArray = statesArray
    }

    func updateTextFieldsUi(){
        
        firstNameTF.updateUIAsPerTextFieldType()
        lastNameTf.updateUIAsPerTextFieldType()
        addressLine1Tf.updateUIAsPerTextFieldType()
        addressLine2Tf.updateUIAsPerTextFieldType()
        cityTf.updateUIAsPerTextFieldType()
        stateTf.updateUIAsPerTextFieldType()
        zipCodeTf.updateUIAsPerTextFieldType()
        
    }

    
    // MARK: - AITextField Delegate
    
    func getSelectedIndexFromPicker(selectedIndex: NSInteger, textField: AITextField) {
        let index = selectedIndex
        if (textField.tag == DropDownTags.states.rawValue) {
             selectedStateIndex = index
        }
    }

    func keyBoardHidden(textField: UITextField) {
        
        if textField == firstNameTF{
            lastNameTf.becomeFirstResponder()
        }
        else if textField == lastNameTf{
            addressLine1Tf.becomeFirstResponder()
        }
            
        else if textField == addressLine1Tf{
            addressLine2Tf.becomeFirstResponder()
        }
        else if textField == addressLine2Tf{
            cityTf.becomeFirstResponder()
        }
        else if textField == cityTf{
            stateTf.becomeFirstResponder()
        }
        else if textField == stateTf {
            zipCodeTf.becomeFirstResponder()
        }
        else {
            textField.resignFirstResponder()
        }
    }
    func aiTextField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == zipCodeTf {
            let currentCharacterCount = textField.text?.characters.count ?? 0
            if (range.length + range.location > currentCharacterCount){
                return false
            }
            let newLength = currentCharacterCount + string.characters.count - range.length
            return newLength <= 5
        }
        return true
    }

    func getProfile(){
        
        let reachbility:NetworkReachabilityManager = NetworkReachabilityManager()!
        let isReachable = reachbility.isReachable
        // Reachability
        if isReachable == false {
            
            let alertMessage = "The internet connection appears to be offline.".localized()
            let alertController = UIAlertController(title: "", message: alertMessage, preferredStyle: .alert)
            let defaultAction = UIAlertAction.init(title: "OK", style: .default, handler: {
                (action) in
                self.view.endEditing(true)
                _ = self.navigationController?.popViewController(animated: true)
            })
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            
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
                    let alertMessage = message
                    let alertController = UIAlertController(title: "", message: alertMessage, preferredStyle: .alert)
                    let defaultAction = UIAlertAction.init(title: "OK", style: .default, handler: {
                        (action) in
                        self.view.endEditing(true)
                        _ = self.navigationController?.popViewController(animated: true)
                    })
                    
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                    
                }
                break
            }
            
        }
        
    }
    
    func loadUserInformation() {
        
        let userData = UserDefaults.standard.object(forKey: USER_DATA)
        let userInfo = NSKeyedUnarchiver.unarchiveObject(with: userData as! Data)
        let user:User = userInfo as! User
        
        firstNameTF.text = user.additionalInformation?.first_name
        lastNameTf.text = user.additionalInformation?.last_name
        addressLine1Tf.text = user.additionalInformation?.address_line1
        addressLine2Tf.text = user.additionalInformation?.address_line2
        cityTf.text = user.additionalInformation?.city
        stateTf.text = user.additionalInformation?.state
        zipCodeTf.text = user.zipcode
    }
    
    func getRedeemPoints() {
        
        let reachbility:NetworkReachabilityManager = NetworkReachabilityManager()!
        let isReachable = reachbility.isReachable
        // Reachability
        if isReachable == false {
            self.showAlert(title: "", message: "The internet connection appears to be offline.".localized());
            return
        }
        
        SwiftLoader.show(title: "Loading...".localized(), animated: true)
        let device_id = UIDevice.current.identifierForVendor!.uuidString
        let user_id  = UserDefaults.standard.object(forKey: USER_ID) ?? ""
        let auth_token : String = UserDefaults.standard.object(forKey: AUTH_TOKEN) as! String
        let currentLanguage = Localize.currentLanguage()
        
        let version_name = Bundle.main.releaseVersionNumber ?? ""
        let version_code = Bundle.main.buildVersionNumber ?? ""
        
        let date = NSDate()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yy"
        let result = formatter.string(from: date as Date)
        
        let dateRes = formatter.date(from: result)
        let dateMilliSec = (dateRes?.timeIntervalSince1970)!*1000
        
        let first_name = firstNameTF.text ?? ""
        let last_name = lastNameTf.text ?? ""
        let address_line1 = addressLine1Tf.text ?? ""
        let address_line2 = addressLine2Tf.text ?? ""
        let city = cityTf.text ?? ""
        let state = stateTf.text ?? ""
        let zipCode = zipCodeTf.text ?? ""

        
        let address :[String : Any] = ["first_name": first_name,
                                       "last_name": last_name,
                                       "address_line1": address_line1,
                                       "address_line2": address_line2,
                                       "city": city,
                                       "state": state,
                                       "zipcode": zipCode]

        
        
        let parameters : Parameters = ["version_name": version_name,
                                       "platform": "1",
                                       "version_code": version_code,
                                       "language": currentLanguage,
                                       "auth_token": auth_token,
                                       "device_id": device_id,
                                       "user_id": user_id,
                                       "type" : 4,
                                       "date": dateMilliSec,
                                       "date_string": result,
                                       "address": address]
        
        //print(parameters)
        
        let url = String(format: "%@/redeemPoints", hostUrl)
        Alamofire.postRequest(URL(string:url)!, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response:DataResponse<Any>) in
            switch response.result {
                
            case .success:
                let json = JSON(data: response.data!)
                //print("json response\(json)")
                SwiftLoader.hide()
                let responseDict = json.dictionaryObject
                
                if let code = responseDict?["code"] {
                    let code = code as! NSNumber
                    if code.intValue == 200 {
                        
                        self.performSegue(withIdentifier: "RedeemPointsMessageVC", sender: self)
                        
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
                    SwiftLoader.hide()
                    self.showAlert(title: "", message:error.localizedDescription);
                }
                break
            }
            
            
        }

}
    
    
    func isValidData() -> Bool {
        
        if firstNameTF.text?.characters.count == 0 {
            showAlert(title: "", message: "Please enter your first name.".localized())
            return false
        }
        if lastNameTf.text?.characters.count == 0 {
            showAlert(title: "", message: "Please enter your last name.".localized())
            return false
        }
        if addressLine1Tf.text?.characters.count == 0  {
            showAlert(title: "", message: "Please enter your street address.".localized())
            return false
        }
//        if addressLine2Tf.text?.characters.count == 0 {
//            showAlert(title: "", message: "Please provide all information.".localized())
//            return false
//        }
        if cityTf.text?.characters.count == 0  {
            showAlert(title: "", message: "Please enter your city.".localized())
            return false
        }
        if stateTf.text?.characters.count == 0 {
            showAlert(title: "", message: "Please enter your state.".localized())
            return false
        }
        if (zipCodeTf.text?.characters.count)! < 5 {
            showAlert(title: "", message: "Please enter a valid zip code.".localized())
            return false
        }

      
        return true
    }
}

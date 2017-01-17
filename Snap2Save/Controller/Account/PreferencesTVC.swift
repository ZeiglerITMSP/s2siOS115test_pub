//
//  PreferencesTVC.swift
//  Snap2Save
//
//  Created by Appit on 12/19/16.
//  Copyright © 2016 Appit. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Localize_Swift
import PKHUD

class PreferencesTVC: UITableViewController,AITextFieldProtocol {
    
    @IBOutlet var reEnterEmailTextField: AIPlaceHolderTextField!
    
    var languageSelectionButton: UIButton!
    var user : User = User()
    // Outlets
    @IBOutlet var contactPreferenceLabel: UILabel!
    @IBOutlet var contactPreferenceSegmentControl: UISegmentedControl!
    @IBOutlet var saveButton: UIButton!
    
    @IBOutlet var saveActivityIndicator: UIActivityIndicatorView!
    @IBOutlet var reEnterMobileNumberTextField: AIPlaceHolderTextField!
    @IBOutlet var mobileNumberTextField: AIPlaceHolderTextField!
    @IBOutlet var emailPlaceHolderTextField: AIPlaceHolderTextField!
    // Actions
    @IBAction func contactPreferenceSegmentControlAction(_ sender: UISegmentedControl) {
        
    }
    
    @IBAction func saveButtonAction(_ sender: UIButton) {
        if !isValid(){
            return
        }
        updatePreferences()
    }
    
    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
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
        
        emailPlaceHolderTextField.contentTextField.textFieldType = AITextField.AITextFieldType.EmailTextField
        reEnterEmailTextField.contentTextField.textFieldType = AITextField.AITextFieldType.EmailTextField

        mobileNumberTextField.contentTextField.textFieldType = AITextField.AITextFieldType.PhoneNumberTextField
        reEnterMobileNumberTextField.contentTextField.textFieldType = AITextField.AITextFieldType.PhoneNumberTextField
        
        emailPlaceHolderTextField.contentTextField.updateUIAsPerTextFieldType()
        reEnterEmailTextField.contentTextField.updateUIAsPerTextFieldType()

        mobileNumberTextField.contentTextField.updateUIAsPerTextFieldType()
        reEnterMobileNumberTextField.contentTextField.updateUIAsPerTextFieldType()
        
        emailPlaceHolderTextField.contentTextField.aiDelegate = self
        reEnterEmailTextField.contentTextField.aiDelegate = self

        mobileNumberTextField.contentTextField.aiDelegate = self
        reEnterMobileNumberTextField.contentTextField.aiDelegate = self
        
        emailPlaceHolderTextField.contentTextField.returnKeyType = UIReturnKeyType.next
        reEnterEmailTextField.contentTextField.returnKeyType = UIReturnKeyType.next

        AppHelper.setRoundCornersToView(borderColor: APP_ORANGE_COLOR, view: saveButton, radius: 2.0, width: 1.0)
        languageSelectionButton = LanguageUtility.createLanguageSelectionButton(withTarge: self, action: #selector(languageButtonClicked))
        LanguageUtility.addLanguageButton(languageSelectionButton, toController: self)
        reloadContent()
        getProfile()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnTableView(recognizer:)))
        self.view.addGestureRecognizer(tapGesture)
        
        
    }
    
    
    func updateTextFieldsUi(){
        
        mobileNumberTextField.contentTextField.updateUIAsPerTextFieldType()
        reEnterMobileNumberTextField.contentTextField.updateUIAsPerTextFieldType()
        
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadContent()
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
    func languageButtonClicked() {
        self.showLanguageSelectionAlert()
    }
    
    func backButtonAction(){
        
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    func tapOnTableView(recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    
    func reloadContent() {
        
        DispatchQueue.main.async {
        self.updateBackButtonText()
        self.languageSelectionButton.setTitle("language.button.title".localized(), for: .normal)
        self.title = "Preferences".localized()
        self.updateTextFieldsUi()

        self.saveButton.setTitle("SAVE".localized(), for: .normal)
        self.contactPreferenceLabel.text = "CONTACT PREFERENCE".localized()
        self.contactPreferenceSegmentControl.setTitle("Text Message".localized(), forSegmentAt: 0)
        self.contactPreferenceSegmentControl.setTitle("Email".localized(), forSegmentAt: 1)
        self.emailPlaceHolderTextField.placeholderText = "EMAIL".localized()
        self.mobileNumberTextField.placeholderText = "10-DIGIT CELL PHONE NUMBER".localized()
       self.reEnterMobileNumberTextField.placeholderText = "RE-ENTER 10-DIGIT CELL PHONE NUMBER".localized()
        self.reEnterEmailTextField.placeholderText = "RE-ENTER EMAIL".localized()
        }
    }
    
  
    func keyBoardHidden(textField: UITextField) {
        
        if textField == emailPlaceHolderTextField.contentTextField {
            reEnterEmailTextField.contentTextField.becomeFirstResponder()
            //mobileNumberTextField.contentTextField.becomeFirstResponder()
        }
        else if textField == reEnterEmailTextField.contentTextField{
            mobileNumberTextField.contentTextField.becomeFirstResponder()
        }
        else if textField == mobileNumberTextField.contentTextField {
            reEnterMobileNumberTextField.contentTextField.becomeFirstResponder()
            
        } else {
            textField.resignFirstResponder()
            
        }
    }
    
    func aiTextField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == mobileNumberTextField.contentTextField || textField == reEnterMobileNumberTextField.contentTextField {
            
            let currentCharacterCount = textField.text?.characters.count ?? 0
            if (range.length + range.location > currentCharacterCount){
                return false
            }
            let newLength = currentCharacterCount + string.characters.count - range.length
            return newLength <= 10
            
        }
        
        return true
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 6
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    func updatePreferences()  {
        
        let reachbility:NetworkReachabilityManager = NetworkReachabilityManager()!
        let isReachable = reachbility.isReachable
        // Reachability
        if isReachable == false {
            self.showAlert(title: "", message: "Please check your internet connection".localized());
            return
        }
        
        
        let device_id = UIDevice.current.identifierForVendor!.uuidString
        let user_id  = UserDefaults.standard.object(forKey: USER_ID) ?? ""
        let auth_token : String = UserDefaults.standard.object(forKey: AUTH_TOKEN) as! String
        let mobileNumber = mobileNumberTextField.contentTextField.text ?? ""
        var contact_preference = "1"
        let contactPreference = contactPreferenceSegmentControl.selectedSegmentIndex
        if contactPreference == 0 {
            contact_preference = "2"
        }
        else if contactPreference == 1{
            contact_preference = "1"
        }
        let email = emailPlaceHolderTextField.contentTextField.text ?? ""
        let currentLanguage = Localize.currentLanguage()
        
        let parameters = ["user_id": user_id,
                          "phone_number": mobileNumber,
                          "email": email,
                          "contact_preference": contact_preference,
                          "platform":"1",
                          "version_code": "1",
                          "version_name": "1",
                          "device_id": device_id,
                          "push_token":"123123",
                          "auth_token": auth_token,
                          "language":currentLanguage
            ] as [String : Any]
        saveActivityIndicator.startAnimating()
        print(parameters)
        let url = String(format: "%@/updatePreferences", hostUrl)
        //print("url)
        Alamofire.postRequest(URL(string:url)!, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response:DataResponse<Any>) in
            switch response.result {
                
            case .success:
                let json = JSON(data: response.data!)
                print("json response\(json)")
                DispatchQueue.main.async {
                    self.saveActivityIndicator.stopAnimating()
                    
                    let responseDict = json.dictionaryObject
                    
                    if let code = responseDict?["code"] {
                        let code = code as! NSNumber
                        if code.intValue == 200 {
                            
                            let alertMessage = responseDict?["message"] as! String
                            let alertController = UIAlertController(title: "", message: alertMessage, preferredStyle: .alert)
                            let defaultAction = UIAlertAction.init(title: "OK", style: .default, handler: {
                                (action) in
                                
                                self.view.endEditing(true)
                                _ = self.navigationController?.popViewController(animated: true)
                                
                            })
                            alertController.addAction(defaultAction)
                            DispatchQueue.main.async {
                                
                                self.present(alertController, animated: true, completion: nil)
                            }
                            
                            
                        }
                        else {
                            if let responseDict = json.dictionaryObject {
                                let alertMessage = responseDict["message"] as! String
                                self.showAlert(title: "", message: alertMessage)
                            }
                            
                            
                        }
                    }

                    //let code : NSNumber = responseDict?["code"] as! NSNumber
                   /* if let messageString = responseDict?["message"] {
                        
                        let alertMessage = messageString as! String
                        let alertController = UIAlertController(title: "", message: alertMessage, preferredStyle: .alert)
                        let defaultAction = UIAlertAction.init(title: "OK", style: .default, handler: {
                            (action) in
                            self.view.endEditing(true)
                            _ = self.navigationController?.popViewController(animated: true)
                        })
                        
                        alertController.addAction(defaultAction)
                        self.present(alertController, animated: true, completion: nil)
                    }*/
                    
                }
                break
                
            case .failure(let error):
                
                DispatchQueue.main.async {
                    self.saveActivityIndicator.stopAnimating()
                    self.showAlert(title: "", message: "Sorry, Please try again later".localized());                }
                //print("error)
                break
            }
            
            
        }
        
        
    }
    
    func isValid() -> Bool  {
        
        let userData = UserDefaults.standard.object(forKey: USER_DATA)
        let userInfo = NSKeyedUnarchiver.unarchiveObject(with: userData as! Data)
        
        let user = userInfo as! User
        let currentEmail = user.email
        
        //let reEnterEmail = reEnterEmailTextField.contentTextField.text
        let email = emailPlaceHolderTextField.contentTextField.text
        
        let validEmail = AppHelper.isValidEmail(testStr: emailPlaceHolderTextField.contentTextField.text!)
        let validPhoneNumber = AppHelper.validate(value: mobileNumberTextField.contentTextField.text!)
        
        
        if contactPreferenceSegmentControl.selectedSegmentIndex == 1 {
            if  validEmail == false {
                self.showAlert(title: "", message: "You have chosen to be contacted by email, but have not provided a valid email address.".localized())
                return false
                
            }
//             if reEnterEmailTextField.contentTextField.text != emailPlaceHolderTextField.contentTextField.text{
//             self.showAlert(title: "", message: "Entries must match to proceed".localized())
//             return false
//             }
            
        }

        if currentEmail != email {
        if let email = emailPlaceHolderTextField.contentTextField.text {
            if email.characters.count > 0 {
                if validEmail == false {
                    self.showAlert(title: "", message: "Please enter a valid email address.".localized())
                    return false
                }
            }
            
           // if (reEnterEmailTextField.contentTextField.text?.characters.count)! > 0{
                
            if reEnterEmailTextField.contentTextField.text != emailPlaceHolderTextField.contentTextField.text{
                self.showAlert(title: "", message: "Entries must match to proceed".localized())
                    return false
                }
           // }

        
        }
        }
        else {
            if (reEnterEmailTextField.contentTextField.text?.characters.count)! > 0{
                
                if reEnterEmailTextField.contentTextField.text != emailPlaceHolderTextField.contentTextField.text{
                    self.showAlert(title: "", message: "Entries must match to proceed".localized())
                    return false
                }
            }
  
        }
       
        if mobileNumberTextField.contentTextField.text?.characters.count == 0 || validPhoneNumber == false{
            self.showAlert(title: "", message: "Please enter a 10-digit cell phone number.".localized())
            return false
        }
        
        if reEnterMobileNumberTextField.contentTextField.text != mobileNumberTextField.contentTextField.text{
            self.showAlert(title: "", message: "Entries must match to proceed".localized())
            return false
        }

        return true
    
        
    }
    
    func loadData() {
        
        let userData = UserDefaults.standard.object(forKey: USER_DATA)
        let userInfo = NSKeyedUnarchiver.unarchiveObject(with: userData as! Data)
        
        //print(""user info \(userInfo)")
        
        let user:User = userInfo as! User
        
        // let mobileNumber = UserDefaults.standard.object(forKey: MOBILE_NUMBER) ?? ""
        // let email = UserDefaults.standard.object(forKey: EMAIL) ?? ""
        
        mobileNumberTextField.contentTextField.text = user.phone_number
        //reEnterMobileNumberTextField.contentTextField.text = user.phone_number
        
        emailPlaceHolderTextField.contentTextField.text = user.email
        //reEnterEmailTextField.contentTextField.text = user.email
        if user.contact_preference == "1" {
            contactPreferenceSegmentControl.selectedSegmentIndex = 1
        }
        else if user.contact_preference == "2"{
            contactPreferenceSegmentControl.selectedSegmentIndex = 0
        }
    }
    
    func getProfile() {
        
        let reachbility:NetworkReachabilityManager = NetworkReachabilityManager()!
        let isReachable = reachbility.isReachable
        // Reachability
        if isReachable == false {
            self.showAlert(title: "", message: "Please check your internet connection".localized());
            return
        }
        
        HUD.allowsInteraction = false
        HUD.dimsBackground = false
        HUD.show(.progress)
        
        let device_id = UIDevice.current.identifierForVendor!.uuidString
        let user_id  = UserDefaults.standard.object(forKey: USER_ID) ?? ""
        let auth_token : String = UserDefaults.standard.object(forKey: AUTH_TOKEN) as! String
        let currentLanguage = Localize.currentLanguage()
        
        let parameters = ["user_id": user_id,
                          "platform":"1",
                          "version_code": "1",
                          "version_name": "1",
                          "device_id": device_id,
                          "push_token":"123123",
                          "auth_token": auth_token,
                          "language": currentLanguage
            ] as [String : Any]
        
        //print("parameters)
        let url = String(format: "%@/getProfile", hostUrl)
        //print("url)
        Alamofire.postRequest(URL(string:url)!, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response:DataResponse<Any>) in
            switch response.result {
                
            case .success:
                DispatchQueue.main.async {
                    HUD.hide()
                }
                let json = JSON(data: response.data!)
                //print(""json response\(json)")
                let responseDict = json.dictionaryObject
                if let code = responseDict?["code"] {
                    let code = code as! NSNumber
                    if code.intValue == 200 {
                        
                        if let userDict = responseDict?["user"] as? [String:Any] {
                            
                            self.user = User.prepareUser(dictionary: userDict )
                            let userData = NSKeyedArchiver.archivedData(withRootObject: self.user)
                            UserDefaults.standard.set(userData, forKey: USER_DATA)
                            let phoneNumber = userDict["phone_number"]
                            UserDefaults.standard.set(phoneNumber, forKey: MOBILE_NUMBER)
                            //print(""phoneNumber \(phoneNumber)")
                            let email = userDict["email"]
                            UserDefaults.standard.set(email, forKey: EMAIL)
                            //print(""email \(email)")
                            self.loadData()
                            
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
                    HUD.hide()
                    self.showAlert(title: "", message: "Sorry, Please try again later".localized());
                }
                //print("error)
                break
            }
            
        }
        
    }
 }

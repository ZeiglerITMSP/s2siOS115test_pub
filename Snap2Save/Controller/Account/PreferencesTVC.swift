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

class PreferencesTVC: UITableViewController,AITextFieldProtocol {
    
    var languageSelectionButton: UIButton!
    
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
        backButton.setTitleColor(UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.7), for: .normal)
        
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 17.0)
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0)
        
        let leftBarButton = UIBarButtonItem()
        leftBarButton.customView = backButton
        self.navigationItem.leftBarButtonItem = leftBarButton

        emailPlaceHolderTextField.contentTextField.textFieldType = AITextField.AITextFieldType.EmailTextField
        mobileNumberTextField.contentTextField.textFieldType = AITextField.AITextFieldType.PhoneNumberTextField
        reEnterMobileNumberTextField.contentTextField.textFieldType = AITextField.AITextFieldType.PhoneNumberTextField
        
        emailPlaceHolderTextField.contentTextField.updateUIAsPerTextFieldType()
        mobileNumberTextField.contentTextField.updateUIAsPerTextFieldType()
        reEnterMobileNumberTextField.contentTextField.updateUIAsPerTextFieldType()

        emailPlaceHolderTextField.contentTextField.aiDelegate = self
        mobileNumberTextField.contentTextField.aiDelegate = self
        reEnterMobileNumberTextField.contentTextField.aiDelegate = self
        
        AppHelper.setRoundCornersToView(borderColor: APP_ORANGE_COLOR, view: saveButton, radius: 2.0, width: 1.0)
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

    func reloadContent() {
        self.updateBackButtonText()
        self.languageSelectionButton.setTitle("language.button.title".localized(), for: .normal)
        self.title = "Preferences".localized()
        saveButton.setTitle("SAVE".localized(), for: .normal)
        contactPreferenceLabel.text = "CONTACT PREFERENCE".localized()
        contactPreferenceSegmentControl.setTitle("Text Message".localized(), forSegmentAt: 0)
        contactPreferenceSegmentControl.setTitle("Email".localized(), forSegmentAt: 1)
        emailPlaceHolderTextField.placeholderText = "EMAIL".localized()
        mobileNumberTextField.placeholderText = "10-DIGIT CELL PHONE NUMBER".localized()
        reEnterMobileNumberTextField.placeholderText = "RE-ENTER 10-DIGIT CELL PHONE NUMBER".localized()
        
        
    }
    func keyBoardHidden(textField: UITextField) {
        if textField == emailPlaceHolderTextField.contentTextField {
            mobileNumberTextField.contentTextField.becomeFirstResponder()
            
        } else if textField == mobileNumberTextField.contentTextField {
            reEnterMobileNumberTextField.contentTextField.becomeFirstResponder()
            
        } else {
            textField.resignFirstResponder()
            
        }
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
    
    func updatePreferences(){
        /*{
            "user_id": "1",
            "phone_number": "8179968861",
            "email": "test@gmail.com",
            "contact_preference": "1",
            "platform": "1",
            "version": "1",
            "device_id": "23423423werwerwerwe23",
            "push_token": "123123dwfwwe234234",
            "auth_token": "2322wwerwer324234",
            "language": "en"
        }*/
        
        let device_id = UIDevice.current.identifierForVendor!.uuidString
        let user_id  = UserDefaults.standard.object(forKey: USER_ID) ?? ""
        let auth_token : String = UserDefaults.standard.object(forKey: AUTH_TOKEN) as! String
        let mobileNumber = mobileNumberTextField.contentTextField.text ?? ""
        var contact_preference = "1"
        let contactPreference = contactPreferenceSegmentControl.selectedSegmentIndex
        if contactPreference == 0{
            contact_preference = "2"
        }
        else if contactPreference == 1{
            contact_preference = "1"
        }
        let email = emailPlaceHolderTextField.contentTextField.text ?? ""
        
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
                          "language":"en"
            ] as [String : Any]
        saveActivityIndicator.startAnimating()
        print(parameters)
        let url = String(format: "%@/updatePreferences", hostUrl)
        print(url)
        Alamofire.postRequest(URL(string:url)!, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response:DataResponse<Any>) in
            switch response.result {
                
            case .success:
                let json = JSON(data: response.data!)
                print("json response\(json)")
                DispatchQueue.main.async {
                    self.saveActivityIndicator.stopAnimating()
                    
                }

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
    
    func isValid() -> Bool{
        let validEmail = AppHelper.isValidEmail(testStr: emailPlaceHolderTextField.contentTextField.text!)
        let validPhoneNumber = AppHelper.validate(value: mobileNumberTextField.contentTextField.text!)
        
        if emailPlaceHolderTextField.contentTextField.text?.characters.count == 0 || validEmail == false{
            self.showAlert(title: "", message: "Please enter valid Email")
            return false
        }
        else if mobileNumberTextField.contentTextField.text?.characters.count == 0 || validPhoneNumber == false{
            self.showAlert(title: "", message: "Please enter 10 digit Phone Number")
            return false
        }
        else if reEnterMobileNumberTextField.contentTextField.text != mobileNumberTextField.contentTextField.text{
            self.showAlert(title: "", message: "Phone Numbers doesn't match")
            return false
        }
        return true
    }
}

//
//  ChangePasswordTVC.swift
//  Snap2Save
//
//  Created by Malathi on 28/12/16.
//  Copyright © 2016 Appit. All rights reserved.
//

import UIKit
import Localize_Swift
import SwiftyJSON
import Alamofire

class ChangePasswordTVC: UITableViewController,AITextFieldProtocol {
    
    var languageSelectionButton: UIButton!
    
    // outlets
    
    
    @IBOutlet var currentPasswordTextField: AIPlaceHolderTextField!
    
    @IBOutlet var newPasswordTextField: AIPlaceHolderTextField!
    
    @IBOutlet var reEnterNewPasswordTextField: AIPlaceHolderTextField!
    
    
    @IBOutlet var saveButton: UIButton!
    
    @IBOutlet var saveActivityIndicator: UIActivityIndicatorView!
    
    @IBAction func saveButtonAction(_ sender: UIButton) {
        if !isValid(){
            return
        }
        changePassword()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        currentPasswordTextField.contentTextField.textFieldType = AITextField.AITextFieldType.PasswordTextField
        newPasswordTextField.contentTextField.textFieldType = AITextField.AITextFieldType.PasswordTextField
        reEnterNewPasswordTextField.contentTextField.textFieldType = AITextField.AITextFieldType.PasswordTextField
        
        currentPasswordTextField.contentTextField.updateUIAsPerTextFieldType()
        newPasswordTextField.contentTextField.updateUIAsPerTextFieldType()
        reEnterNewPasswordTextField.contentTextField.updateUIAsPerTextFieldType()
        
        currentPasswordTextField.contentTextField.aiDelegate = self
        newPasswordTextField.contentTextField.aiDelegate = self
        reEnterNewPasswordTextField.contentTextField.aiDelegate = self
        
        
        languageSelectionButton = LanguageUtility.createLanguageSelectionButton(withTarge: self, action: #selector(languageButtonClicked))
        LanguageUtility.addLanguageButton(languageSelectionButton, toController: self)
        reloadContent()
        self.navigationItem.addBackButton(withTarge: self, action: #selector(backAction))
        AppHelper.setRoundCornersToView(borderColor: APP_ORANGE_COLOR, view: saveButton, radius: 2.0, width: 1.0)
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
    
    func backAction(){
        
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    func reloadContent() {
        DispatchQueue.main.async {
        self.languageSelectionButton.setTitle("language.button.title".localized(), for: .normal)
        self.updateBackButtonText()
        self.title = "Change Password".localized()
        self.saveButton.setTitle("SAVE".localized(), for: .normal)
        self.currentPasswordTextField.placeholderText = "CURRENT PASSWORD".localized()
        self.newPasswordTextField.placeholderText = "NEW PASSWORD (MUST BE ATLEAST 6 CHARACTERS)".localized()
        self.reEnterNewPasswordTextField.placeholderText = "RE-ENTER NEW PASSWORD".localized()
        }
    }
    
    func keyBoardHidden(textField: UITextField) {
        if textField == currentPasswordTextField.contentTextField{
            newPasswordTextField.contentTextField.becomeFirstResponder()
        }
        else if textField == newPasswordTextField.contentTextField{
            reEnterNewPasswordTextField.contentTextField.becomeFirstResponder()
        }
        else{
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
    func changePassword(){
        
        let reachbility:NetworkReachabilityManager = NetworkReachabilityManager()!
        let isReachable = reachbility.isReachable
        // Reachability
        print("isreachable \(isReachable)")
        if isReachable == false {
            self.showAlert(title: "", message: "Please check your internet connection".localized());
            return
        }
        

        let device_id = UIDevice.current.identifierForVendor!.uuidString
        let user_id  = UserDefaults.standard.object(forKey: USER_ID) ?? ""
        let auth_token : String = UserDefaults.standard.object(forKey: AUTH_TOKEN) as! String
        let newPassword = newPasswordTextField.contentTextField.text ?? ""
        let password = currentPasswordTextField.contentTextField.text ?? ""
        let currentLanguage = Localize.currentLanguage()

        let parameters = ["password": password,
                          "new_password": newPassword,
                          "user_id": user_id,
                          "platform":"1",
                          "version_code": "1",
                          "version_name": "1",
                          "device_id": device_id,
                          "push_token":"123123",
                          "auth_token": auth_token,
                          "language": currentLanguage
            ] as [String : Any]
        
        saveActivityIndicator.startAnimating()
        print(parameters)
        let url = String(format: "%@/changePassword", hostUrl)
        print(url)
        Alamofire.postRequest(URL(string:url)!, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response:DataResponse<Any>) in
            switch response.result {
                
            case .success:
                DispatchQueue.main.async {
                    self.saveActivityIndicator.stopAnimating()
                let json = JSON(data: response.data!)
                print("json response\(json)")
                let responseDict = json.dictionaryObject
                //let code : NSNumber = responseDict?["code"] as! NSNumber
                if let messageString = responseDict?["message"] {
                    
                    let alertMessage = messageString as! String
                    let alertController = UIAlertController(title: "", message: alertMessage, preferredStyle: .alert)
                    let defaultAction = UIAlertAction.init(title: "OK", style: .default, handler: {
                        (action) in
                        self.view.endEditing(true)
                        _ = self.navigationController?.popViewController(animated: true)
                    })
                    
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
                
            }
                break
                
            case .failure(let error):
                
                DispatchQueue.main.async {
                    self.saveActivityIndicator.stopAnimating()
                    self.showAlert(title: "", message: "Sorry, Please try again later".localized());
                }
                print(error)
                break
            }
    
        }
    }
    
    func isValid() -> Bool{
        if currentPasswordTextField.contentTextField.text?.characters.count == 0 {
            self.showAlert(title: "", message: "Please enter current password".localized())
            return false
        }
        else if (newPasswordTextField.contentTextField.text?.characters.count)! < 6 {
            self.showAlert(title: "", message: "Your password must be at least 6 characters in length.".localized())
            return false
        }
        else if reEnterNewPasswordTextField.contentTextField.text != newPasswordTextField.contentTextField.text {
            self.showAlert(title: "", message: "Passwords don't match".localized())
            return false
        }
        return true
    }
}

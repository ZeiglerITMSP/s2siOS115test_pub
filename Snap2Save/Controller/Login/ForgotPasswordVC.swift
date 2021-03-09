//
//  ForgotPasswordVC.swift
//  Snap2Save
//
//  Created by Appit on 12/19/16.
//  Copyright © 2016 Appit. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Localize_Swift

class ForgotPasswordVC: UIViewController,AITextFieldProtocol {
    
    // Properties
    var languageSelectionButton: UIButton!
    
    // Outlets
    @IBOutlet var msgLabel: UILabel!
    
    @IBOutlet var mobileNumberLabel: UILabel!
    
    @IBOutlet var mobileNumberTextField: AITextField!
    
    @IBOutlet var submitButton: UIButton!
    
    @IBOutlet var submitActivityIndicator: UIActivityIndicatorView!
    
    // Actions
    @IBAction func submitButtonAction(_ sender: UIButton) {
        
        let phoneNumber = AppHelper.removeSpecialCharacters(fromNumber: mobileNumberTextField.text!)
        let validMobileNum = AppHelper.validate(value: phoneNumber)
        
        if mobileNumberTextField.text?.characters.count == 0 || validMobileNum == false{
            self.showAlert(title: "", message: "Please enter 10-digit cell phone number.".localized())
            return
        }
        forgotPassword()
    }
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.title = "Forgot Password"
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
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        
        mobileNumberTextField.textFieldType = AITextField.AITextFieldType.PhoneNumberTextField
        mobileNumberTextField.updateUIAsPerTextFieldType()
        mobileNumberTextField.createUnderline(withColor: APP_LINE_COLOR, padding: 0, height: 1)
        mobileNumberTextField.placeHolderLabel = mobileNumberLabel
        mobileNumberTextField.setLeftGap(width: 0, placeHolderImage: UIImage.init())
        mobileNumberTextField.setRightGap(width: 0, placeHolderImage: UIImage.init())
        mobileNumberTextField.text_Color =  UIColor.black
        mobileNumberTextField.aiDelegate = self
        
        AppHelper.setRoundCornersToView(borderColor: APP_ORANGE_COLOR, view: submitButton, radius: 2.0, width: 1.0)
        
        // LANGUAGE BUTTON
        languageSelectionButton = LanguageUtility.createLanguageSelectionButton(withTarge: self, action: #selector(languageButtonClicked))
        LanguageUtility.addLanguageButton(languageSelectionButton, toController: self)
        reloadContent()
        
        // Tap Gesuture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnTableView(recognizer:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadContent()
        AppHelper.getScreenName(screenName: "ForgotPassword screen")

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
    
    
    
    @objc func reloadContent() {
        
        DispatchQueue.main.async {
            self.title = "Forgot Password".localized()
            self.languageSelectionButton.setTitle("language.button.title".localized(), for: .normal)
            self.msgLabel.text = "forgotPasswordMessage".localized()
            self.mobileNumberLabel.text = "10-DIGIT CELL PHONE NUMBER".localized()
            self.submitButton.setTitle("SUBMIT".localized(), for: .normal)
            self.updateBackButtonText()
            self.updateTextFieldsUi()
        }
    }
    
    func updateTextFieldsUi(){
        
        mobileNumberTextField.updateUIAsPerTextFieldType();
    }
    
    @objc func languageButtonClicked(){
        
        self.showLanguageSelectionAlert()
    }
    @objc func backButtonAction(){
        
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    
    func forgotPassword(){
        
        let reachbility:NetworkReachabilityManager = NetworkReachabilityManager()!
        let isReachable = reachbility.isReachable
        // Reachability
        if isReachable == false {
            self.showAlert(title: "", message: "The internet connection appears to be offline.".localized());
            return
        }
        
        let mobileNumber = mobileNumberTextField.text ?? ""
        let phoneNumber = AppHelper.removeSpecialCharacters(fromNumber: mobileNumber)

        let device_id = UIDevice.current.identifierForVendor!.uuidString
        let currentLanguage = Localize.currentLanguage()
        let version_name = Bundle.main.releaseVersionNumber ?? ""
        let version_code = Bundle.main.buildVersionNumber ?? ""

        let parameters  : Parameters = ["phone_number": phoneNumber,
                          "platform":"1",
                          "version_code": version_code,
                          "version_name": version_name,
                          "device_id": device_id,
                          "push_token":"",
                          "language": currentLanguage
            ]
        
        
        //print("parameters)
        submitActivityIndicator.startAnimating()
        
        let url = String(format: "%@/forgotPassword", hostUrl)
        //print("url)
        Alamofire.postRequest(URL(string:url)!, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response:DataResponse<Any>) in
            
            switch response.result {
            case .success:
                
                let json = JSON(data: response.data!)
                //print(""json response\(json)")
                DispatchQueue.main.async {
                    self.submitActivityIndicator.stopAnimating()
                }
                
                if let responseDict = json.dictionaryObject {
                    if let code = responseDict["code"] {
                        let code = code as! NSNumber
                        if code.intValue == 200 {
                            
                            let alertMessage = responseDict["message"] as! String
//                            let alertController = UIAlertController(title: "", message: alertMessage, preferredStyle: .alert)
//                            let defaultAction = UIAlertAction.init(title: "OK", style: .default, handler: {
//                                (action) in
//                                let loginVc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC")
//                                self.navigationController?.show(loginVc, sender: self)
//                                
//                                
//                            })
//                            alertController.addAction(defaultAction)
//                            DispatchQueue.main.async {
//                                
//                                self.present(alertController, animated: true, completion: nil)
//                            }
//                            
                            self.showAlert(title: "", message: alertMessage, action: #selector(self.alertAction), showCancel: false)
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
                    self.submitActivityIndicator.stopAnimating()
                    self.showAlert(title: "", message:error.localizedDescription);
                }
                //print("error)
                break
            }
            
            
        }
    }
    
    func keyBoardHidden(textField: UITextField) {
        if textField == mobileNumberTextField{
            textField.resignFirstResponder()
        }
        else {
            textField.resignFirstResponder()
        }
        
    }
    
    func aiTextField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == mobileNumberTextField {
            let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            let compo = newString.components(separatedBy: NSCharacterSet.decimalDigits.inverted)
            let decimalString = compo.joined(separator: "") as NSString
            let length = decimalString.length
            let hasLeadingOne = length > 0 && decimalString.character(at: 0) == (1 as unichar)
            
            if length == 0 || (length > 10 && !hasLeadingOne) || length > 11
            {
                let newLength = (textField.text! as NSString).length + (string as NSString).length - range.length as Int
                
                return (newLength > 10) ? false : true
            }
            var index = 0 as Int
            let formattedString = NSMutableString()
            
            if hasLeadingOne
            {
                formattedString.append("1 ")
                index += 1
            }
            if (length - index) > 3
            {
                let areaCode = decimalString.substring(with: NSMakeRange(index, 3))
                formattedString.appendFormat("(%@)", areaCode)
                index += 3
            }
            if length - index > 3
            {
                let prefix = decimalString.substring(with: NSMakeRange(index, 3))
                formattedString.appendFormat(" %@-", prefix)
                index += 3
            }
            
            let remainder = decimalString.substring(from: index)
            formattedString.append(remainder)
            textField.text = formattedString as String
            return false
        }
        
        return true
    }
    
    @objc func alertAction() {
        
        let loginVc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC")
        self.navigationController?.show(loginVc, sender: self)
  
    }
    
}

//
//  ResetPasswordVC.swift
//  Snap2Save
//
//  Created by Appit on 12/19/16.
//  Copyright © 2016 Appit. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import  Localize_Swift

class ResetPasswordVC: UIViewController ,AITextFieldProtocol{
    
    var languageSelectionButton: UIButton!
    var user_id : String!
    @IBOutlet var msgLabel: UILabel!
    
    @IBOutlet var passwordLabel: UILabel!

    @IBOutlet var reEnterPasswordLabel: UILabel!
    @IBOutlet var passwordTextField: AITextField!
    
    @IBOutlet var reEnterPasswordTextField: AITextField!
    
    @IBOutlet var resetPasswordButton: UIButton!
    
    @IBOutlet var resetPasswordActivityIndicator: UIActivityIndicatorView!
    @IBAction func resetPasswordButtonAction(_ sender: UIButton) {
        
        if (passwordTextField.text?.characters.count)! == 0 || (passwordTextField.text?.characters.count)! < 6{
            self.showAlert(title: "", message: "Password must be at least 6 characters in length.".localized())
            return
        }
            
        else if reEnterPasswordTextField.text != passwordTextField.text{
            self.showAlert(title: "", message: "Passwords don't match".localized())
            return
        }
        resetPassword()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Reset Password"
        passwordTextField.textFieldType = AITextField.AITextFieldType.PasswordTextField
        passwordTextField.updateUIAsPerTextFieldType()
        passwordTextField.createUnderline(withColor: APP_LINE_COLOR, padding: 0, height: 1)
        passwordTextField.placeHolderLabel = passwordLabel
        passwordTextField.setLeftGap(width: 0, placeHolderImage: UIImage.init())
        passwordTextField.setRightGap(width: 0, placeHolderImage: UIImage.init())
        passwordTextField.text_Color =  UIColor.black
        
        reEnterPasswordTextField.textFieldType = AITextField.AITextFieldType.PasswordTextField
        reEnterPasswordTextField.updateUIAsPerTextFieldType()
        reEnterPasswordTextField.createUnderline(withColor: APP_LINE_COLOR, padding: 0, height: 1)
        reEnterPasswordTextField.placeHolderLabel = reEnterPasswordLabel
        //        mobileNumTextField.createBorder(borderColor: UIColor.red,xpos: 0)
        reEnterPasswordTextField.setLeftGap(width: 0, placeHolderImage: UIImage.init())
        reEnterPasswordTextField.setRightGap(width: 0, placeHolderImage: UIImage.init())
        reEnterPasswordTextField.text_Color =  UIColor.black
        
        passwordTextField.aiDelegate = self
        reEnterPasswordTextField.aiDelegate = self
        
        AppHelper.setRoundCornersToView(borderColor: APP_ORANGE_COLOR, view: resetPasswordButton, radius: 3.0, width: 1.0)
        
        languageSelectionButton = LanguageUtility.createLanguageSelectionButton(withTarge: self, action: #selector(languageButtonClicked))
        LanguageUtility.addLanguageButton(languageSelectionButton, toController: self)
        reloadContent()
        
        // Tap Gesuture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnTableView(recognizer:)))
        self.view.addGestureRecognizer(tapGesture)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        LanguageUtility.addOberverForLanguageChange(self, selector: #selector(reloadContent))
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        LanguageUtility.removeObserverForLanguageChange(self)
        super.viewDidDisappear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
       // self.navigationController?.navigationBar.isTranslucent = false
        //let navBarBGImg = AppHelper.imageWithColor(color: APP_GRREN_COLOR)
        //self.navigationController?.navigationBar.setBackgroundImage(navBarBGImg, for: .default)
        self.navigationController?.navigationBar.barTintColor = APP_GRREN_COLOR
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        self.navigationItem.leftBarButtonItem = backButton
        reloadContent()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            self.title = "Reset Password".localized()
            self.languageSelectionButton.setTitle("language.button.title".localized(), for: .normal)
            self.msgLabel.text = "resetPasswordMessage".localized()
            self.passwordLabel.text = "NEW PASSWORD".localized()
            self.reEnterPasswordLabel.text = "RE-ENTER NEW PASSWORD".localized()
            self.resetPasswordButton.setTitle("RESET PASSWORD".localized(), for: .normal)
            self.updateBackButtonText()
            self.updateTextFieldsUi()
        }
    }
    
    func updateTextFieldsUi(){
        
        passwordTextField.updateUIAsPerTextFieldType();
        reEnterPasswordTextField.updateUIAsPerTextFieldType();
    }

    func keyBoardHidden(textField: UITextField) {
        if textField == passwordTextField {
            reEnterPasswordTextField.becomeFirstResponder()
        }
        else {
       textField.resignFirstResponder()
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func resetPassword(){
        
        let reachbility:NetworkReachabilityManager = NetworkReachabilityManager()!
        let isReachable = reachbility.isReachable
        // Reachability
        print("isreachable \(isReachable)")
        if isReachable == false {
            self.showAlert(title: "", message: "Please check your internet connection".localized());
            return
        }

        self.view.endEditing(true)
        let password = passwordTextField.text ?? ""
        let device_id = UIDevice.current.identifierForVendor!.uuidString
        let user_id = self.user_id ?? ""
        //let auth_token = UserDefaults.standard.string(forKey: "auth_token") ?? ""
        let currentLanguage = Localize.currentLanguage()

        let parameters = ["password":password,
                          "user_id":user_id,
                          "platform":"1",
                          "version_code": "1",
                          "version_name": "1",
                          "device_id": device_id,
                          "push_token":"123123",
                          "language": currentLanguage
            ] as [String : Any]
        
        
        print(parameters)
        resetPasswordActivityIndicator.startAnimating()
        let url = String(format: "%@/resetPassword", hostUrl)
        print(url)
        Alamofire.postRequest(URL(string:url)!, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response:DataResponse<Any>) in
            
            switch response.result {
            case .success:
                DispatchQueue.main.async {
                    self.resetPasswordActivityIndicator.stopAnimating()
                }

                let json = JSON(data: response.data!)
                print("json response\(json)")
                
                if let responseDict = json.dictionaryObject {
                    let alertMessage = responseDict["message"] as! String
                    let alertController = UIAlertController(title: "", message: alertMessage, preferredStyle: .alert)
                    let defaultAction = UIAlertAction.init(title: "OK", style: .default, handler: {
                        (action) in
                        let loginVc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC")
                        self.navigationController?.show(loginVc, sender: self)
                        self.view.endEditing(true)
                    })
                    
                    alertController.addAction(defaultAction)
                    DispatchQueue.main.async {
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
                
                break
                
            case .failure(let error):
                
                DispatchQueue.main.async {
                    self.resetPasswordActivityIndicator.stopAnimating()
                    self.showAlert(title: "", message: "Sorry, Please try again later".localized());                }
                print(error)
                break
            }
            
            
        }
    }

}

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
        /*let ResetPasswordVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ResetPasswordVC")
        self.navigationController?.show(ResetPasswordVC, sender: self)*/
        let validMobileNum = AppHelper.validate(value: mobileNumberTextField.text!)
        
        if mobileNumberTextField.text?.characters.count == 0 || validMobileNum == false{
            self.showAlert(title: "", message: "Please enter 10 digit Phone Number")
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
        backButton.setTitleColor(UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.7), for: .normal)
        
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
        
        
        mobileNumberTextField.textFieldType = AITextField.AITextFieldType.PhoneNumberTextField
        mobileNumberTextField.updateUIAsPerTextFieldType()
        mobileNumberTextField.createUnderline(withColor: APP_LINE_COLOR, padding: 0, height: 1)
        mobileNumberTextField.placeHolderLabel = mobileNumberLabel
        //        mobileNumTextField.createBorder(borderColor: UIColor.red,xpos: 0)
        mobileNumberTextField.setLeftGap(width: 0, placeHolderImage: UIImage.init())
        mobileNumberTextField.setRightGap(width: 0, placeHolderImage: UIImage.init())
        mobileNumberTextField.text_Color =  UIColor.black
        mobileNumberTextField.aiDelegate = self
        AppHelper.setRoundCornersToView(borderColor: APP_ORANGE_COLOR, view: submitButton, radius: 2.0, width: 1.0)
        
        // LANGUAGE BUTTON
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
    
    func reloadContent() {
        
        DispatchQueue.main.async {
            self.title = "Forgot Password".localized()
            self.languageSelectionButton.setTitle("language.button.title".localized(), for: .normal)
            self.msgLabel.text = "forgotPasswordMessage".localized()
            self.mobileNumberLabel.text = "10-DIGIT CELL PHONE NUMBER".localized()
            self.submitButton.setTitle("SUBMIT".localized(), for: .normal)
            self.updateBackButtonText()
        }
    }
    
    
    func languageButtonClicked(){
        
        self.showLanguageSelectionAlert()
    }
    func backButtonAction(){
        
        _ = self.navigationController?.popViewController(animated: true)
        
    }

    
    func forgotPassword(){
        
        let mobileNumber = mobileNumberTextField.text ?? ""
        let device_id = UIDevice.current.identifierForVendor!.uuidString
        
        let parameters = ["phone_number": mobileNumber,
                          "platform":"1",
                          "version_code": "1",
                          "version_name": "1",
                          "device_id": device_id,
                          "push_token":"123123",
                          "language":"en"
                        ] as [String : Any]
        
        
        print(parameters)
        submitActivityIndicator.startAnimating()
        
        let url = String(format: "%@/forgotPassword", hostUrl)
        print(url)
        Alamofire.postRequest(URL(string:url)!, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response:DataResponse<Any>) in
            
            switch response.result {
            case .success:
                
                let json = JSON(data: response.data!)
                print("json response\(json)")
                DispatchQueue.main.async {
                    self.submitActivityIndicator.stopAnimating()
                }

                if let responseDict = json.dictionaryObject {
                    let alertMessage = responseDict["message"] as! String
                    let alertController = UIAlertController(title: "", message: alertMessage, preferredStyle: .alert)
                    let defaultAction = UIAlertAction.init(title: "OK", style: .default, handler: {
                        (action) in
                        let loginVc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC")
                        self.navigationController?.show(loginVc, sender: self)
                    })

                    alertController.addAction(defaultAction)
                    DispatchQueue.main.async {
                        
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
                
                break
                
            case .failure(let error):
                
                DispatchQueue.main.async {
                    self.submitActivityIndicator.stopAnimating()
                }
                print(error)
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
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

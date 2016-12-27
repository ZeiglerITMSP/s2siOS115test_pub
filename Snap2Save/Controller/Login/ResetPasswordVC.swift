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

class ResetPasswordVC: UIViewController ,AITextFieldProtocol{
    
    var user_id : String!
    @IBOutlet var msgLabel: UILabel!
    
    @IBOutlet var passwordLabel: UILabel!

    @IBOutlet var reEnterPasswordLabel: UILabel!
    @IBOutlet var passwordTextField: AITextField!
    
    @IBOutlet var reEnterPasswordTextField: AITextField!
    
    @IBOutlet var resetPasswordButton: UIButton!
    
    @IBAction func resetPasswordButtonAction(_ sender: UIButton) {
        
        if (passwordTextField.text?.characters.count)! == 0 || (passwordTextField.text?.characters.count)! < 6{
            self.showAlert(title: "", message: "Please enter Password")
            return
        }
            
        else if reEnterPasswordTextField.text != passwordTextField.text{
            self.showAlert(title: "", message: "Passwords doesn't match")
            return
        }
        resetPassword()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = "Reset Password"
        
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
        
        
        
        passwordTextField.textFieldType = AITextField.AITextFieldType.PasswordTextField
        passwordTextField.updateUIAsPerTextFieldType()
        passwordTextField.createUnderline(withColor: APP_LINE_COLOR, padding: 0, height: 1)
        passwordTextField.placeHolderLabel = passwordLabel
        //        mobileNumTextField.createBorder(borderColor: UIColor.red,xpos: 0)
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

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.isTranslucent = false
        let navBarBGImg = AppHelper.imageWithColor(color: APP_GRREN_COLOR)
        self.navigationController?.navigationBar.setBackgroundImage(navBarBGImg, for: .default)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        //self.navigationController?.navigationBar.barTintColor = UIColor.red
        
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        self.navigationItem.leftBarButtonItem = backButton

    }
    func languageButtonClicked(){
        
        let languageAlert = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        let englishBtn = UIAlertAction.init(title: "English".localized, style: .default, handler:{
            (action) in
            print("Selected English")
        })
        let spanishBtn = UIAlertAction.init(title: "Spanish".localized, style: .default, handler:{
            (action) in
            print("Selected Spanish")
            
        })
        let cancelBtn = UIAlertAction.init(title: "Cancel", style: .cancel, handler:{
            (action) in
            
        })
        
        languageAlert.view.tintColor = APP_GRREN_COLOR
        languageAlert .addAction(englishBtn)
        languageAlert.addAction(spanishBtn)
        languageAlert.addAction(cancelBtn)
        
        self.present(languageAlert, animated: true, completion:nil)
        
        msgLabel.text = "resetPasswordMessage".localized
        passwordLabel.text = "NEW PASSWORD".localized
        reEnterPasswordLabel.text = "RE-ENTER NEW PASSWORD".localized

        resetPasswordButton.setTitle("RESET PASSWORD".localized, for: .normal)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func keyBoardHidden(textField: UITextField) {
        if textField == passwordTextField{
            reEnterPasswordTextField.becomeFirstResponder()
        }
       textField.resignFirstResponder()
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
        
        let password = passwordTextField.text ?? ""
        let device_id = UIDevice.current.identifierForVendor!.uuidString
        let user_id = self.user_id ?? ""
        //let auth_token = UserDefaults.standard.string(forKey: "auth_token") ?? ""
        
        let parameters = ["password":password,
                          "user_id":user_id,
                          "platform":"1",
                          "version_code": "1",
                          "version_name": "1",
                          "device_id": device_id,
                          "push_token":"123123",
                          "language":"en"
            ] as [String : Any]
        
        
        print(parameters)
        
        let url = String(format: "%@/resetPassword", hostUrl)
        print(url)
        Alamofire.postRequest(URL(string:url)!, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response:DataResponse<Any>) in
            
            switch response.result {
            case .success:
                
                let json = JSON(data: response.data!)
                print("json response\(json)")
                
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
                    //  _ = EZLoadingActivity.hide()
                }
                print(error)
                break
            }
            
            
        }
    }

}

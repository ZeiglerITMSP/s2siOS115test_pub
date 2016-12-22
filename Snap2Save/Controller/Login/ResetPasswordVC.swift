//
//  ResetPasswordVC.swift
//  Snap2Save
//
//  Created by Appit on 12/19/16.
//  Copyright © 2016 Appit. All rights reserved.
//

import UIKit

class ResetPasswordVC: UIViewController ,AITextFieldProtocol{
    
    @IBOutlet var msgLabel: UILabel!
    
    @IBOutlet var passwordLabel: UILabel!

    @IBOutlet var reEnterPasswordLabel: UILabel!
    @IBOutlet var passwordTextField: AITextField!
    
    @IBOutlet var reEnterPasswordTextField: AITextField!
    
    @IBOutlet var resetPasswordButton: UIButton!
    
    @IBAction func resetPasswordButtonAction(_ sender: UIButton) {
    }
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
        
        AppHelper.setRoundCornersToView(borderColor: APP_ORANGE_COLOR, view: resetPasswordButton, radius: 2.0, width: 1.0)

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
    func backButtonAction(){
        
        _ = self.navigationController?.popViewController(animated: true)
        
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

}

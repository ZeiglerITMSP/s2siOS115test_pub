//
//  ForgotPasswordVC.swift
//  Snap2Save
//
//  Created by Appit on 12/19/16.
//  Copyright © 2016 Appit. All rights reserved.
//

import UIKit

class ForgotPasswordVC: UIViewController {

    
    @IBOutlet var msgLabel: UILabel!
    
    @IBOutlet var mobileNumberLabel: UILabel!
    
    @IBOutlet var mobileNumberTextField: AITextField!
    
    @IBOutlet var submitButton: UIButton!
    
    @IBAction func submitButtonAction(_ sender: UIButton) {
        let ResetPasswordVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ResetPasswordVC")
        self.navigationController?.show(ResetPasswordVC, sender: self)
  
        
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

        
        mobileNumberTextField.textFieldType = AITextField.AITextFieldType.PhoneNumberTextField
        mobileNumberTextField.updateUIAsPerTextFieldType()
        mobileNumberTextField.createUnderline(withColor: APP_LINE_COLOR, padding: 0, height: 1)
        mobileNumberTextField.placeHolderLabel = mobileNumberLabel
        //        mobileNumTextField.createBorder(borderColor: UIColor.red,xpos: 0)
        mobileNumberTextField.setLeftGap(width: 0, placeHolderImage: UIImage.init())
        mobileNumberTextField.setRightGap(width: 0, placeHolderImage: UIImage.init())
        mobileNumberTextField.text_Color =  UIColor.black

        AppHelper.setRoundCornersToView(borderColor: APP_ORANGE_COLOR, view: submitButton, radius: 2.0, width: 1.0)
        msgLabel.text = "forgotPasswordMessage".localized
        mobileNumberLabel.text = "10-DIGIT CELL PHONE NUMBER".localized
        submitButton.setTitle("SUBMIT".localized, for: .normal)
        
    }

    func languageButtonClicked(){
        
        self.showLanguageSelectionAlert()
    }
    func backButtonAction(){
        
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

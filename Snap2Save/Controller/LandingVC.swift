//
//  WelcomeVC.swift
//  Snap2Save
//
//  Created by Appit on 12/5/16.
//  Copyright © 2016 Appit. All rights reserved.
//

import UIKit

class LandingVC: UIViewController {

    // Outlets
    @IBOutlet var downArrowImage: UIImageView!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var registerButton: UIButton!
    
    
    // Actions
    @IBOutlet var languageSelectionView: UIView!
    
    @IBOutlet var welcomeLabel: UILabel!
    
    @IBOutlet var selectLanguageLabel: UILabel!
    
    @IBAction func loginButtonAction(_ sender: UIButton) {
        
        let loginVc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC")
        self.navigationController?.show(loginVc, sender: self)
    }
    
    @IBAction func registerButtonAction(_ sender: UIButton) {
        let signUpVc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignupTVC")
        self.navigationController?.show(signUpVc, sender: self)

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let languageGes:UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(self.showLanguageSelectionAlert))
        languageGes.numberOfTapsRequired = 1
        languageSelectionView.addGestureRecognizer(languageGes)
        
        AppHelper.setRoundCornersToView(borderColor: loginButton.backgroundColor!, view: loginButton, radius: 2.0, width: 1)
        AppHelper.setRoundCornersToView(borderColor: registerButton.backgroundColor!, view: registerButton, radius: 2.0, width: 1)
        welcomeLabel.text = "WELCOME".localized
        selectLanguageLabel.text = "SELECTLANGUAGE".localized
        loginButton.setTitle("LOG IN".localized, for: .normal)
        registerButton.setTitle("REGISTER".localized, for: .normal)
        
//        let welcomeVc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WelcomePageVC")
//        self.navigationController?.show(welcomeVc, sender: self)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true;
        
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
    /*
    func showLanguageSelectionAlert(){
        
        let languageAlert = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        let englishBtn = UIAlertAction.init(title: "English".localized, style: .default, handler:{
            (action) in
            print("Selected English")
            })
        let spanishBtn = UIAlertAction.init(title: "Spanish".localized, style: .default, handler:{
            (action) in
            print("Selected Spanish")

        })
        let cancelBtn = UIAlertAction.init(title: "Cancel".localized, style: .cancel, handler:{
            (action) in
            
        })
        
        languageAlert.view.tintColor = APP_GRREN_COLOR
        languageAlert .addAction(englishBtn)
        languageAlert.addAction(spanishBtn)
        languageAlert.addAction(cancelBtn)

        self.present(languageAlert, animated: true, completion:nil)
    }
*/
}


extension UIViewController {
    
    
    func showLanguageSelectionAlert(){
        
        let languageAlert = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        let englishBtn = UIAlertAction.init(title: "English".localized, style: .default, handler:{
            (action) in
            print("Selected English")
        })
        let spanishBtn = UIAlertAction.init(title: "Spanish".localized, style: .default, handler:{ (action) in
            print("Selected Spanish")
            
            
            
        })
        let cancelBtn = UIAlertAction.init(title: "Cancel".localized, style: .cancel, handler:{
            (action) in
            
        })
        
        languageAlert.view.tintColor = APP_GRREN_COLOR
        languageAlert .addAction(englishBtn)
        languageAlert.addAction(spanishBtn)
        languageAlert.addAction(cancelBtn)
        
        self.present(languageAlert, animated: true, completion:nil)
    }

    
}


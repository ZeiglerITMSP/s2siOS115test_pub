//
//  WelcomeVC.swift
//  Snap2Save
//
//  Created by Appit on 12/5/16.
//  Copyright © 2016 Appit. All rights reserved.
//

import UIKit
import Localize_Swift

class LandingVC: UIViewController {


    // Outlets
    @IBOutlet var currentSelectedLabel: UILabel!
    @IBOutlet var downArrowImage: UIImageView!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var registerButton: UIButton!
    @IBOutlet var languageSelectionView: UIView!
    @IBOutlet var welcomeLabel: UILabel!
    @IBOutlet var selectLanguageLabel: UILabel!
    
    // Actions

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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true;
        NotificationCenter.default.addObserver(self, selector: #selector(reloadContent), name: NSNotification.Name( LCLLanguageChangeNotification), object: nil)
        
        reloadContent()
        AppHelper.getScreenName(screenName: "Landing Screen")
        
    }
    
    
    func reloadContent() {
        
         DispatchQueue.main.async {
            
            self.welcomeLabel.text = "WELCOME".localized()
            self.selectLanguageLabel.text = "SELECT LANGUAGE".localized()
            self.loginButton.setTitle("LOG IN".localized() , for: .normal)
            self.registerButton.setTitle("REGISTER".localized(), for: .normal)
            self.currentSelectedLabel.text = "selectedLanguageTitle".localized()
        }
        
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




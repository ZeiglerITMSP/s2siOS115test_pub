//
//  WelcomePageVC.swift
//  Snap2Save
//
//  Created by Appit on 12/19/16.
//  Copyright © 2016 Appit. All rights reserved.
//

import UIKit
import Localize_Swift

class WelcomePageVC: UIViewController {
    
    var languageSelectionButton: UIButton!

//outlets
    
    @IBOutlet var congratulationsLabel: UILabel!
    
    @IBOutlet var welcomeSecondLabel: UILabel!
    @IBOutlet var welcomeToLabel: UILabel!
    
    @IBOutlet var getStartedButton: UIButton!
    
    @IBAction func getStartedButtonAction(_ sender: UIButton) {
        
//        let loginVc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC")
//        self.navigationController?.show(loginVc, sender: self)
//        
//        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil);
        let initialViewController: UINavigationController = storyBoard.instantiateInitialViewController()! as! UINavigationController
        
        let loginVc:LoginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as! LoginVC

        initialViewController.pushViewController(loginVc, animated: false)
        
        UIApplication.shared.keyWindow?.rootViewController = initialViewController
        UIApplication.shared.keyWindow?.makeKeyAndVisible()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        AppHelper.setRoundCornersToView(borderColor:UIColor.init(red: 232.0/255.0, green: 126.0/255.0, blue: 51.0/255.0, alpha: 1.0), view: getStartedButton, radius: 2.0, width: 1.0)
        languageSelectionButton = LanguageUtility.createLanguageSelectionButton(withTarge: self, action: #selector(languageButtonClicked))
        LanguageUtility.addLanguageButton(languageSelectionButton, toController: self)
        
        reloadContent()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true;
        reloadContent()
        AppHelper.getScreenName(screenName: "Welcome screen")

        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: -
    
    func languageButtonClicked() {
        
        self.showLanguageSelectionAlert()
        
    }
    
    func reloadContent() {
        
        DispatchQueue.main.async {
            
            self.languageSelectionButton.setTitle("language.button.title".localized(), for: .normal)
            self.updateBackButtonText()
            self.congratulationsLabel.text = "Congratulations!".localized()
            self.welcomeToLabel.text = "WelcomeText".localized()
            self.getStartedButton.setTitle("GET STARTED!".localized(), for: .normal)
            
        }
        
        
    }

}

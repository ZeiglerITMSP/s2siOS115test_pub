//
//  RedeemPointsMessageVC.swift
//  Snap2Save
//
//  Created by Malathi on 23/02/17.
//  Copyright © 2017 Appit. All rights reserved.
//

import UIKit

class RedeemPointsMessageVC: UIViewController {

    var languageSelectionButton: UIButton!

    @IBOutlet var messageLabel: UILabel!
    
    @IBOutlet var doneButton: UIButton!
    
    
    @IBAction func doneButtonAction(_ sender: UIButton) {
        
        let rewardStatusVc = UIStoryboard.init(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "RewardStatusTVC")
        self.navigationController?.show(rewardStatusVc, sender: self)

    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        languageSelectionButton = LanguageUtility.createLanguageSelectionButton(withTarge: self, action: #selector(languageButtonClicked))
        
        LanguageUtility.addLanguageButton(languageSelectionButton, toController: self)
        
        reloadContent()

        AppHelper.setRoundCornersToView(borderColor: APP_ORANGE_COLOR, view: doneButton, radius: 2.0, width: 1.0)
        
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        self.navigationItem.leftBarButtonItem = backButton
        
       // self.navigationItem.addBackButton(withTarge: self, action: #selector(backAction))

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadContent()
        AppHelper.getScreenName(screenName: "Redeem Save a lot Message screen ")

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        LanguageUtility.addOberverForLanguageChange(self, selector: #selector(reloadContent))
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        LanguageUtility.removeObserverForLanguageChange(self)
        super.viewDidDisappear(animated)
    }
    
    func backAction() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func languageButtonClicked() {
        self.showLanguageSelectionAlert()
    }

    func reloadContent() {
        
        DispatchQueue.main.async {
           // self.updateBackButtonText()
            self.languageSelectionButton.setTitle("language.button.title".localized(), for: .normal)
            self.navigationItem.title = "Redeem Points".localized()
            self.messageLabel.text = "Your Save-A-Lot gift card will be mailed within 15 days, so be sure to watch for an envelope from Snap2Save!".localized()
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

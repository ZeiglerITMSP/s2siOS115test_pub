//
//  RedeemHealthPointsMessageVC.swift
//  Snap2Save
//
//  Created by Malathi on 23/02/17.
//  Copyright © 2017 Appit. All rights reserved.
//

import UIKit
import TTTAttributedLabel

class RedeemHealthPointsMessageVC: UIViewController,TTTAttributedLabelDelegate {

    @IBOutlet var urlLinkLabel: TTTAttributedLabel!
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var messageLabel: UILabel!
    
    @IBOutlet var addressLine3: UILabel!
    @IBOutlet var addressTitleLabel: UILabel!
    
    @IBOutlet var addressLine2: UILabel!
    @IBOutlet var addressLabel1: UILabel!
    
    
    @IBOutlet var doneButton: UIButton!
    
    @IBOutlet var bgContainerView: UIView!
    
    @IBOutlet var bgScrollView: UIScrollView!
    
    var languageSelectionButton: UIButton!

    @IBAction func doneButtonAction(_ sender: UIButton) {
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        languageSelectionButton = LanguageUtility.createLanguageSelectionButton(withTarge: self, action: #selector(languageButtonClicked))
        
        LanguageUtility.addLanguageButton(languageSelectionButton, toController: self)
        
        reloadContent()
        
        AppHelper.setRoundCornersToView(borderColor: APP_ORANGE_COLOR, view: doneButton, radius: 2.0, width: 1.0)
        
        /* let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
         self.navigationItem.leftBarButtonItem = backButton*/
        
        self.navigationItem.addBackButton(withTarge: self, action: #selector(backAction))

        self.urlLinkLabel.textColor = UIColor.white
        self.urlLinkLabel.textAlignment = NSTextAlignment.center
        self.urlLinkLabel.enabledTextCheckingTypes = NSTextCheckingAllTypes; // Automatically detect links when the label text is subsequently changed
        self.urlLinkLabel.delegate = self; // Delegate methods
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadContent()
    }
    
    override func viewDidLayoutSubviews() {
        bgScrollView.isScrollEnabled = true
        // Do any additional setup after loading the view
        bgScrollView.contentSize = CGSize(width :0, height : doneButton.frame.maxY + 40)
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
            self.updateBackButtonText()
            self.languageSelectionButton.setTitle("language.button.title".localized(), for: .normal)
            self.navigationItem.title = "Redeem Points".localized()
         
            self.titleLabel.text = "A $10 health care rebate has been added to your account!".localized()
            self.messageLabel.text = "To redeem health care rebates at Clinica Tepeyac, simply provide them with the 10-digit cell phone number on your Snap2Save account the next time you receive health care services at their clinic. They will verify your eligibility online and apply the credit to the cost of your visit or procedure.".localized()
            self.addressTitleLabel.text = "Clinica Tepeyac".localized()
            self.addressLabel1.text = "5075 Lincoln Street".localized()
            self.addressLine2.text = "Denver, CO 80216".localized()
            self.addressLine3.text = "(303) 458- 5302".localized()
          
            
            let subscriptionNotice:String = "By signing up you are agreeing to the Privacy Policy and End User Agreement of ShiftChange."
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineHeightMultiple = 1.2
            
            let subscriptionNoticeAttributedString = NSAttributedString(string:subscriptionNotice, attributes: [
                NSFontAttributeName: UIFont.systemFont(ofSize: 13),
                NSParagraphStyleAttributeName: paragraphStyle,
                NSForegroundColorAttributeName: UIColor.white.withAlphaComponent(0.80).cgColor,
                ])
            let subscriptionNoticeLinkAttributes = [
                NSFontAttributeName: UIFont.boldSystemFont(ofSize: 13),
                NSForegroundColorAttributeName: UIColor.white,
                NSUnderlineStyleAttributeName: true
                ] as [String : Any]
            let subscriptionNoticeActiveLinkAttributes = [
                NSFontAttributeName: UIFont.boldSystemFont(ofSize: 13),
                NSForegroundColorAttributeName: UIColor.gray,
                NSUnderlineStyleAttributeName: true
                ] as [String : Any]
            

            
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

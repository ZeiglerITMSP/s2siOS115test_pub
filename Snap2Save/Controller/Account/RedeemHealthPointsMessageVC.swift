//
//  RedeemHealthPointsMessageVC.swift
//  Snap2Save
//
//  Created by Malathi on 23/02/17.
//  Copyright © 2017 Appit. All rights reserved.
//

import UIKit
import TTTAttributedLabel
import SwiftyJSON
import Localize_Swift
import Alamofire


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
        AppHelper.getScreenName(screenName: "Redeem Health Points Message screen")

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
    
    @objc func languageButtonClicked() {
        self.showLanguageSelectionAlert()
    }
    
    @objc func reloadContent() {
        
        DispatchQueue.main.async {
            //self.updateBackButtonText()
            self.languageSelectionButton.setTitle("language.button.title".localized(), for: .normal)
            self.navigationItem.title = "Redeem Points".localized()
            self.doneButton.setTitle("DONE".localized(), for: .normal)
            self.titleLabel.text = "A $10 health care rebate has been added to your account!".localized()
            self.messageLabel.text = "To redeem health care rebates at Clinica Tepeyac, simply provide them with the 10-digit cell phone number on your Snap2Save account the next time you receive health care services at their clinic. They will verify your eligibility online and apply the credit to the cost of your visit or procedure.".localized()
            self.addressTitleLabel.text = "Clinica Tepeyac".localized()
            self.addressLabel1.text = "5075 Lincoln Street".localized()
            self.addressLine2.text = "Denver, CO 80216".localized()
            self.addressLine3.text = "(303) 458-5302".localized()
            
            let subscriptionNotice:String = "www.clinicatepeyac.org"
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineHeightMultiple = 1.2
            
            let subscriptionNoticeAttributedString = NSAttributedString(string:subscriptionNotice, attributes: [
                NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16),
                NSAttributedStringKey.paragraphStyle: paragraphStyle,
                NSAttributedStringKey.foregroundColor: UIColor(red: 0.0/0.0,
                                                        green: 122.0/255.0,
                                                        blue: 255.0/255.0,
                                                        alpha: 1) ,
                ])
            let subscriptionNoticeLinkAttributes = [
                NSFontAttributeName: UIFont.boldSystemFont(ofSize: 16),
                NSForegroundColorAttributeName: UIColor(red: 0.0/0.0,
                                                        green: 122.0/255.0,
                                                        blue: 255.0/255.0,
                                                        alpha: 1),
                NSUnderlineStyleAttributeName: true
                ] as [String : Any]
            self.urlLinkLabel.textAlignment = NSTextAlignment.left
            self.urlLinkLabel.delegate = self
            self.urlLinkLabel.numberOfLines = 0
            self.urlLinkLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
            //self.urlLinkLabel.textInsets = UIEdgeInsets(top:10, left:15, bottom:0, right:15)
            self.urlLinkLabel.setText(subscriptionNoticeAttributedString)
            self.urlLinkLabel.linkAttributes = subscriptionNoticeLinkAttributes
            self.urlLinkLabel.activeLinkAttributes = subscriptionNoticeLinkAttributes
            
            let subscribeLinkRange = (subscriptionNotice as NSString).range(of: "www.clinicatepeyac.org")
            let subscribeURL = NSURL(string:"www.clinicatepeyac.org")!
            self.urlLinkLabel.addLink(to: subscribeURL as URL!, with:subscribeLinkRange)
            
            
        }
    }
    
   /* override func viewWillLayoutSubviews() {
        
        self.bgScrollView.contentSize = CGSize(width : 0 ,height : self.doneButton.frame.maxY + 40)
        var rect : CGRect = self.bgContainerView.frame
        rect.size.height = self.doneButton.frame.maxY + 100
        self.bgContainerView.frame = rect

    }*/

    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        
        let storyboard = UIStoryboard(name: "Home", bundle: nil) as UIStoryboard
        let redeemVc = storyboard.instantiateViewController(withIdentifier: "RedeemPointsWebVC") as! RedeemPointsWebVC
        redeemVc.loadUrlStr = "https://www.clinicatepeyac.org"
        self.navigationController?.pushViewController(redeemVc, animated: true)
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

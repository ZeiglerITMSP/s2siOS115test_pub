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
            //self.updateBackButtonText()
            self.languageSelectionButton.setTitle("language.button.title".localized(), for: .normal)
            self.navigationItem.title = "Redeem Points".localized()
         
            self.titleLabel.text = "A $10 health care rebate has been added to your account!".localized()
            self.messageLabel.text = "To redeem health care rebates at Clinica Tepeyac, simply provide them with the 10-digit cell phone number on your Snap2Save account the next time you receive health care services at their clinic. They will verify your eligibility online and apply the credit to the cost of your visit or procedure.".localized()
            self.addressTitleLabel.text = "Clinica Tepeyac".localized()
            self.addressLabel1.text = "5075 Lincoln Street".localized()
            self.addressLine2.text = "Denver, CO 80216".localized()
            self.addressLine3.text = "(303) 458- 5302".localized()
            
            let subscriptionNotice:String = "www.clinicatepeyac.org"
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineHeightMultiple = 1.2
            
            let subscriptionNoticeAttributedString = NSAttributedString(string:subscriptionNotice, attributes: [
                NSFontAttributeName: UIFont.systemFont(ofSize: 16),
                NSParagraphStyleAttributeName: paragraphStyle,
                NSForegroundColorAttributeName: UIColor(red: 0.0/0.0,
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

    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        
        let storyboard = UIStoryboard(name: "Home", bundle: nil) as UIStoryboard
        let redeemVc = storyboard.instantiateViewController(withIdentifier: "RedeemPointsWebVC") as! RedeemPointsWebVC
        redeemVc.loadUrlStr = "https://www.google.co.in/"
        self.navigationController?.pushViewController(redeemVc, animated: true)
    }

    
    func getRedeemPoints() {
        
        let reachbility:NetworkReachabilityManager = NetworkReachabilityManager()!
        let isReachable = reachbility.isReachable
        // Reachability
        if isReachable == false {
            self.showAlert(title: "", message: "The internet connection appears to be offline.".localized());
            return
        }
        
        SwiftLoader.show(title: "Loading...".localized(), animated: true)
        let device_id = UIDevice.current.identifierForVendor!.uuidString
        let user_id  = UserDefaults.standard.object(forKey: USER_ID) ?? ""
        let auth_token : String = UserDefaults.standard.object(forKey: AUTH_TOKEN) as! String
        let currentLanguage = Localize.currentLanguage()
        
        let version_name = Bundle.main.releaseVersionNumber ?? ""
        let version_code = Bundle.main.buildVersionNumber ?? ""
        
        let date = NSDate()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        let result = formatter.string(from: date as Date)
        
        let dateMilliSec = CUnsignedLongLong((date.timeIntervalSince1970)*1000)
        
        /*let first_name = firstNameTF.text ?? ""
        let last_name = lastNameTf.text ?? ""
        let address_line1 = addressLine1Tf.text ?? ""
        let address_line2 = addressLine2Tf.text ?? ""
        let city = cityTf.text ?? ""
        let state = stateTf.text ?? ""
        let zipCode = zipCodeTf.text ?? ""*/
        
        
        let address :[String : Any] = ["first_name": "",
                                       "last_name": "",
                                       "address_line_1": "",
                                       "address_line_2": "",
                                       "city": "",
                                       "state": "",
                                       "zipcode": ""]
        
        
        
        let parameters : Parameters = ["version_name": version_name,
                                       "platform": "1",
                                       "version_code": version_code,
                                       "language": currentLanguage,
                                       "auth_token": auth_token,
                                       "device_id": device_id,
                                       "user_id": user_id,
                                       "type" : 5,
                                       "date": dateMilliSec,
                                       "date_string": result,
                                       "address": address]
        
        print(parameters)
        
        let url = String(format: "%@/redeemPoints", hostUrl)
        print(url)
        Alamofire.postRequest(URL(string:url)!, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response:DataResponse<Any>) in
            switch response.result {
                
            case .success:
                let json = JSON(data: response.data!)
                print("json response\(json)")
                SwiftLoader.hide()
                let responseDict = json.dictionaryObject
                
                if let code = responseDict?["code"] {
                    let code = code as! NSNumber
                    if code.intValue == 200 {
                        
                        let rewardStatusVc = UIStoryboard.init(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "RewardStatusTVC")
                        self.navigationController?.show(rewardStatusVc, sender: self)
                        
                    }
                    else {
                        
                        if let responseDict = json.dictionaryObject {
                            let alertMessage = responseDict["message"] as! String
                            self.showAlert(title: "", message: alertMessage)
                        }
                    }
                    
                }
                
                
                break
                
            case .failure(let error):
                
                DispatchQueue.main.async {
                    SwiftLoader.hide()
                    self.showAlert(title: "", message:error.localizedDescription);
                }
                break
            }
            
            
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

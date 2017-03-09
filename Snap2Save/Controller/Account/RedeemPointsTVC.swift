//
//  RedeemPointsTVC.swift
//  Snap2Save
//
//  Created by Appit on 2/22/17.
//  Copyright © 2017 Appit. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Localize_Swift

class RedeemPointsTVC: UITableViewController {

    
    var languageSelectionButton: UIButton!
    var  isSelected : Bool?
    // outlets
    
    @IBOutlet var redeemPointsTitleLabel: UILabel!
    
    @IBOutlet var saveALotLabel: UILabel!
    
    @IBOutlet var healthCareButton: UIButton!
    @IBOutlet var healthCareLabel: UILabel!
    @IBOutlet var saveALotButton: UIButton!
    
    @IBOutlet var continueButton: UIButton!
    
    @IBOutlet var continueActivityIndicator: UIActivityIndicatorView!
    
    // Actions
    
    @IBAction func continueButtonAction(_ sender: UIButton) {
        
        if self.isSelected == true {
            self.performSegue(withIdentifier: "redeemPointsAddressTVC", sender: self)
            
        }
        else {
            
            let redeemAlert = UIAlertController.init(title: nil, message: "Are you sure you want to redeem points?".localized(), preferredStyle: .alert)
            let okBtn = UIAlertAction.init(title: "Ok", style: .default, handler:{
                (action) in
                self.getRedeemPoints()
            })
            
            let cancelBtn = UIAlertAction.init(title: "Cancel".localized(), style: .cancel, handler:nil)
            
            redeemAlert .addAction(okBtn)
            redeemAlert.addAction(cancelBtn)
            
            self.present(redeemAlert, animated: true, completion:nil)
            redeemAlert.view.tintColor = APP_GRREN_COLOR
            
        }
        

        
    }
    @IBAction func saveALotButtonAction(_ sender: UIButton) {
        isSelected = true
        self.saveALotButton.setImage(UIImage.init(named: "radioOn"), for: .normal)
        self.healthCareButton.setImage(UIImage.init(named: "radioOff"), for: .normal)
    }
    
    @IBAction func healthCareButtonAction(_ sender: UIButton) {
        isSelected = false
        self.saveALotButton.setImage(UIImage.init(named: "radioOff"), for: .normal)
        self.healthCareButton.setImage(UIImage.init(named: "radioOn"), for: .normal)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        AppHelper.setRoundCornersToView(borderColor: APP_ORANGE_COLOR, view: continueButton, radius: 2.0, width: 1.0)
        
        // language button
        reloadContent()
        languageSelectionButton = LanguageUtility.createLanguageSelectionButton(withTarge: self, action: #selector(languageButtonClicked))
        LanguageUtility.addLanguageButton(languageSelectionButton, toController: self)
        self.navigationItem.addBackButton(withTarge: self, action: #selector(backAction))
        self.saveALotButton.setImage(UIImage.init(named: "radioOn"), for: .normal)
        self.healthCareButton.setImage(UIImage.init(named: "radioOff"), for: .normal)
        isSelected = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadContent()
        AppHelper.getScreenName(screenName: "Redeem Points screen")

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        LanguageUtility.addOberverForLanguageChange(self, selector: #selector(reloadContent))
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        LanguageUtility.removeObserverForLanguageChange(self)
        super.viewDidDisappear(animated)
    }

//        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//            let isSel = isSelected
//            if segue.identifier == "redeemPointsAddressTVC" {
//                let addressVC = segue.destination as! RedeemPointsAddressTVC
//            }
//            
//        }
    

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
            self.redeemPointsTitleLabel.text = "To redeem 500 points, please make your selection and click Continue.".localized()
            self.saveALotLabel.text = "$5 Save-A-Lot Gift Card".localized()
            self.healthCareLabel.text = "$10 Health Care Rebate".localized()
            self.continueButton.setTitle("CONTINUE".localized(), for: .normal)
            self.tableView.reloadData()
        }
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
        let dateRes = formatter.date(from: result)
        
        let dateMilliSec = (dateRes?.timeIntervalSince1970)!*1000
        
        /*let first_name = firstNameTF.text ?? ""
         let last_name = lastNameTf.text ?? ""
         let address_line1 = addressLine1Tf.text ?? ""
         let address_line2 = addressLine2Tf.text ?? ""
         let city = cityTf.text ?? ""
         let state = stateTf.text ?? ""
         let zipCode = zipCodeTf.text ?? ""*/
        
        
        let address :[String : Any] = ["first_name": "",
                                       "last_name": "",
                                       "address_line1": "",
                                       "address_line2": "",
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
       // print(url)
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
                        
                        let storyboard = UIStoryboard(name: "Home", bundle: nil) as UIStoryboard
                        let redeemVc = storyboard.instantiateViewController(withIdentifier: "RedeemHealthPointsMessageVC") as! RedeemHealthPointsMessageVC
                        self.navigationController?.pushViewController(redeemVc, animated: true)
                        
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
}

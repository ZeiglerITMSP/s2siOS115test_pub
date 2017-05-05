//
//  AccountTVC.swift
//  Snap2Save
//
//  Created by Appit on 12/19/16.
//  Copyright © 2016 Appit. All rights reserved.
//

import UIKit
import Localize_Swift
import Alamofire
import SwiftyJSON
import PKHUD


class AccountTVC: UITableViewController {
    
    // Properties
    var languageSelectionButton: UIButton!
    var user:User = User()
    let adSpotManager = AdSpotsManager()
    var accountOptions = ["Auto Log In", "Personal Information", "Preferences", "My Reward Program", "Change Password"]
    
    var isAutoLogin = false
    
    enum Rows: Int {
        case autoLogin
        case personalInformation
        case preferences
        case myRewardProgram
        case changePassword
    }

    // MARK: - Actions
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        languageSelectionButton = LanguageUtility.createLanguageSelectionButton(withTarge: self, action: #selector(languageButtonClicked))
        LanguageUtility.addLanguageButton(languageSelectionButton, toController: self)
        
        adSpotManager.delegate = self
        
        // Automatic height
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.register(UINib(nibName: "AdSpotTableViewCell", bundle: nil), forCellReuseIdentifier: "AdSpotTableViewCell")
        
        //        infoArray = ["Auto Log In", "Personal Information", "Preferences", "My Reward Program", "Change Password"];
        
        AppHelper.configSwiftLoader()
        let data = UserDefaults.standard.object(forKey: LOGGED_USER)
        let userInfo = NSKeyedUnarchiver.unarchiveObject(with: data as! Data)
        
        let user = userInfo as! User
        isAutoLogin = user.auto_login ?? true    // By default it is true
        UserDefaults.standard.set(isAutoLogin, forKey: USER_AUTOLOGIN)
        reloadContent()
    }
    
    // view will appear
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        SwiftLoader.show(title: "Loading...".localized(), animated: true)
        self.adSpotManager.getAdSpots(forScreen: .account)
        reloadContent()
        AppHelper.getScreenName(screenName: "Account screen")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        LanguageUtility.addOberverForLanguageChange(self, selector: #selector(languageChanged))
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        LanguageUtility.removeObserverForLanguageChange(self)
        super.viewDidDisappear(animated)
    }
    
    
    func languageButtonClicked() {
        self.showLanguageSelectionAlert()
    }
    
    func languageChanged() {
        
        SwiftLoader.show(title: "Loading...".localized(), animated: true)
        reloadContent()
        adSpotManager.downloadAdImages()
    }
    
    
    func reloadContent() {
        DispatchQueue.main.async {
            self.languageSelectionButton.setTitle("language.button.title".localized(), for: .normal)
            self.navigationItem.title = "Account".localized()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func showAlert() {
        
        let logOutAlert = UIAlertController.init(title: nil, message: "Are you sure you want to log out?".localized(), preferredStyle: .alert)
        let englishBtn = UIAlertAction.init(title: "OK".localized(), style: .default, handler:{
            (action) in
            self.userLogout()
        })
        
        let cancelBtn = UIAlertAction.init(title: "Cancel".localized(), style: .cancel, handler:nil)
        
        logOutAlert .addAction(englishBtn)
        logOutAlert.addAction(cancelBtn)
        
        self.present(logOutAlert, animated: true, completion:nil)
        logOutAlert.view.tintColor = APP_GRREN_COLOR
        
    }
    
    func userLogout() {
        
        
        SwiftLoader.show(title: "Loading...".localized(), animated: true)
        let device_id = UIDevice.current.identifierForVendor!.uuidString
        let user_id  = UserDefaults.standard.object(forKey: USER_ID) ?? ""
        let auth_token : String = UserDefaults.standard.object(forKey: AUTH_TOKEN) as! String
        let currentLanguage = Localize.currentLanguage()
        let version_name = Bundle.main.releaseVersionNumber ?? ""
        let version_code = Bundle.main.buildVersionNumber ?? ""
        
        let parameters : Parameters = ["user_id": user_id,
                                       "auth_token": auth_token,
                                       "platform":"1",
                                       "version_code": version_code,
                                       "version_name": version_name,
                                       "device_id": device_id,
                                       "push_token":"",
                                       "language":currentLanguage
        ]
        
        let url = String(format: "%@/logOut", hostUrl)
        Alamofire.postRequest(URL(string:url)!, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response:DataResponse<Any>) in
            
            self.moveTologinScree()
            
            //            switch response.result {
            //
            //            case .success:
            //                //let json = JSON(data: response.data!)
            //               // //print(""json response\(json)")
            //
            //                //let appDomain = Bundle.main.bundleIdentifier
            //                //UserDefaults.standard.removePersistentDomain(forName: appDomain!)
            //
            //
            //                break
            //
            //            case .failure(let error):
            //
            //                DispatchQueue.main.async {
            //                    self.showAlert(title: "", message:error.localizedDescription);
            //                }
            //                ////print("error)
            //                break
            //            }
            //
            
        }
    }
    
    func clearUserData() {
        // clear user data
        UserDefaults.standard.removeObject(forKey: USER_ID)
        UserDefaults.standard.removeObject(forKey: AUTH_TOKEN)
        UserDefaults.standard.removeObject(forKey: LOGGED_USER)
        UserDefaults.standard.removeObject(forKey: USER_DATA)
        UserDefaults.standard.removeObject(forKey: INFO_SCREENS)
        
        // AppDelegate.getDelegate().setDetaultValues()
    }
    
    func moveTologinScree() {
        
        // clear user data before you logout
        self.clearUserData()
        // hide activity
        SwiftLoader.hide()
        print("swift loader")
        
        // get view controller to move
        let storyBoard = UIStoryboard(name: "Main", bundle: nil);
        let initialViewController: UINavigationController = storyBoard.instantiateInitialViewController()! as! UINavigationController
        let user: User = User()
        AppDelegate.getDelegate().user = user
        self.tableView.delegate = nil
        self.tableView.dataSource = nil
        
        UIApplication.shared.keyWindow?.rootViewController = initialViewController
        UIApplication.shared.keyWindow?.makeKeyAndVisible()
        
    }
    
    func updateAutologinStatusInServer(isOn: Bool) {
        
        let reachbility:NetworkReachabilityManager = NetworkReachabilityManager()!
        let isReachable = reachbility.isReachable
        // Reachability
        if isReachable == false {
            self.showAlert(title: "", message: "The internet connection appears to be offline.".localized());
            return
        }
        //HUD.allowsInteraction = false
        //HUD.dimsBackground = false
        //HUD.show(.progress)
        SwiftLoader.show(title: "Loading...".localized(), animated: true)
        let device_id = UIDevice.current.identifierForVendor!.uuidString
        let user_id  = UserDefaults.standard.object(forKey: USER_ID) ?? ""
        let auth_token : String = UserDefaults.standard.object(forKey: AUTH_TOKEN) as! String
        let currentLanguage = Localize.currentLanguage()
        
        let version_name = Bundle.main.releaseVersionNumber ?? ""
        let version_code = Bundle.main.buildVersionNumber ?? ""
        
        let parameters : Parameters = ["user_id": user_id,
                                       "auto_login": isOn,
                                       "auth_token": auth_token,
                                       "platform":"1",
                                       "version_code": version_code,
                                       "version_name": version_name,
                                       "device_id": device_id,
                                       "language":currentLanguage
        ]
        
        ////print("parameters)
        
        let url = String(format: "%@/updateSettings", hostUrl)
        ////print("url)
        Alamofire.postRequest(URL(string:url)!, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response:DataResponse<Any>) in
            switch response.result {
                
            case .success:
                let json = JSON(data: response.data!)
                ////print(""json response\(json)")
                SwiftLoader.hide()
                let responseDict = json.dictionaryObject
                
                if let code = responseDict?["code"] {
                    let code = code as! NSNumber
                    if code.intValue == 200 {
                        
                        if let userDict = responseDict?["user"] {
                            
                            self.user = User.prepareUser(dictionary: userDict as! [String : Any])
                            AppDelegate.getDelegate().user = self.user
                            
                            let userData = NSKeyedArchiver.archivedData(withRootObject: self.user)
                            UserDefaults.standard.set(userData, forKey: LOGGED_USER)
                            UserDefaults.standard.set(isOn, forKey: USER_AUTOLOGIN)
                            
                        }
                        
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

// MARK: - Table view data source, delegate
extension AccountTVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return accountOptions.count
        } else if section == 1 {
            return 1
        } else if section == 2 {
            return adSpotManager.adSpots.count
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let accountSwitchCell = tableView.dequeueReusableCell(withIdentifier: "AccountSwitchCell") as! AccountSwitchCell
                accountSwitchCell.delegate = self
                accountSwitchCell.myTitleLabel.text = accountOptions[indexPath.row].localized()
                accountSwitchCell.mySwitch.isOn = isAutoLogin
                
                return accountSwitchCell
            } else {
                let basicCell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! AccountCell
                basicCell.titleLabel?.text = accountOptions[indexPath.row].localized()
                basicCell.titleLabel?.textColor = UIColor(colorLiteralRed: 74/255, green: 74/255, blue: 74/255, alpha: 1)
                return basicCell
            }
        }
        else if indexPath.section == 1 {
            let basicCell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! AccountCell
            basicCell.titleLabel?.text = "Log Out".localized()
            basicCell.titleLabel?.textColor = UIColor(colorLiteralRed: 236/255, green: 80/255, blue: 30/255, alpha: 1)
            return basicCell
        }
        else if indexPath.section == 2 { // Ads image cell
            
            let adSpotTableViewCell = tableView.dequeueReusableCell(withIdentifier: "AdSpotTableViewCell") as! AdSpotTableViewCell
            
            let spot = adSpotManager.adSpots[indexPath.row]
            let type = spot["type"]
            let image = adSpotManager.adSpotImages["\(type!)"]
            
            adSpotTableViewCell.adImageView.image = image
            
            return adSpotTableViewCell
        }
        
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
        return cell
        
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            if indexPath.row == Rows.autoLogin.rawValue {
                
            } else if indexPath.row == Rows.personalInformation.rawValue {
                self.performSegue(withIdentifier: "PersonalInformationTVC", sender: self)
            } else if indexPath.row == Rows.preferences.rawValue {
                self.performSegue(withIdentifier: "PreferencesTVC", sender: self)
            } else if indexPath.row == Rows.myRewardProgram.rawValue {
                self.performSegue(withIdentifier: "RewardStatusTVC", sender: self)
            } else if indexPath.row == Rows.changePassword.rawValue {
                self.performSegue(withIdentifier: "ChangePasswordTVC", sender: self)
            }
        }
        else if indexPath.section == 1 {
            if indexPath.row == 0 {
                self.showAlert()
            }
        }
        else if indexPath.section == 2 {
            self.adSpotManager.showAdSpotDetails(spot: adSpotManager.adSpots[indexPath.row], inController: self)
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       
        if adSpotManager.adSpots.count > 0 {
            return 0.001
        } else {
            if section <= 1 {
                return 30
            } else {
                return 0.001
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let data = UserDefaults.standard.object(forKey: LOGGED_USER)
        let userInfo = NSKeyedUnarchiver.unarchiveObject(with: data as! Data)
        let user = userInfo as! User
        
        let isFaceBookUser = user.signup_type
        if indexPath.section == 0 {
            // hide change password row, when logged through facebook
            if indexPath.row == Rows.changePassword.rawValue {
                if  isFaceBookUser == "2" {
                    return 0
                }
            }
        } else if indexPath.section == 2 {
            let spot = adSpotManager.adSpots[indexPath.row]
            let type = spot["type"]
            if let adImage = adSpotManager.adSpotImages["\(type!)"] {
                if adImage.size.width > self.view.frame.width {
                    let height = AppHelper.getRatio(width: adImage.size.width,
                                                    height: adImage.size.height,
                                                    newWidth: self.view.frame.width)
                    return height
                }
            }
            return UITableViewAutomaticDimension
        }
        
        return UITableViewAutomaticDimension
    }
    
}


extension AccountTVC: AccountSwitchCellDelegate {
    
    func didSwithStateChanged(isOn: Bool) {
        isAutoLogin = isOn
        self.updateAutologinStatusInServer(isOn: isOn)
    }
    
}

extension AccountTVC: AdSpotsManagerDelegate {
    
    func didFinishLoadingSpots() {
        SwiftLoader.hide()
        self.tableView.reloadData()
    }
    
    func didFailedLoadingSpots(description: String) {
        SwiftLoader.hide()
        self.tableView.reloadData()
    }
    
}

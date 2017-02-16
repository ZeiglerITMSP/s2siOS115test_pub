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
    
    var languageSelectionButton: UIButton!
    var infoArray : NSMutableArray!
    var user:User = User()
    
    @IBOutlet var autoLoginLabel: UILabel!
    
    @IBOutlet var preferencesLabel: UILabel!
    @IBOutlet var personalInfoLabel: UILabel!
    
    @IBOutlet var logOutLabel: UILabel!
    @IBOutlet var changePasswordLabel: UILabel!
    
    @IBOutlet var loginSwitch: UISwitch!
    
    @IBAction func autoLoginSwitchAction(_ sender: UISwitch) {
        self.updateSettings()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
        languageSelectionButton = LanguageUtility.createLanguageSelectionButton(withTarge: self, action: #selector(languageButtonClicked))
        LanguageUtility.addLanguageButton(languageSelectionButton, toController: self)
        
        infoArray = ["Auto Log In","Personal Information","Preferences","Change Password"];
        
        AppHelper.configSwiftLoader()
        let data = UserDefaults.standard.object(forKey: LOGGED_USER)
        let userInfo = NSKeyedUnarchiver.unarchiveObject(with: data as! Data)
        let user = userInfo as! User
        
        let isAutoLogin : Bool = user.auto_login ?? true
        loginSwitch.isOn = isAutoLogin
        UserDefaults.standard.set(self.loginSwitch.isOn, forKey: USER_AUTOLOGIN)
        reloadContent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadContent()
        AppHelper.getScreenName(screenName: "Account screen")

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        LanguageUtility.addOberverForLanguageChange(self, selector: #selector(reloadContent))
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        LanguageUtility.removeObserverForLanguageChange(self)
        super.viewDidDisappear(animated)
    }
    
    func languageButtonClicked() {
        self.showLanguageSelectionAlert()
    }
    
    func reloadContent(){
        
        DispatchQueue.main.async {
     
            self.languageSelectionButton.setTitle("language.button.title".localized(), for: .normal)
            
            self.navigationItem.title = "Account".localized()
            
//            self.navigationController?.navigationItem.title = "Acc"
            
            self.autoLoginLabel.text = "Auto Log In".localized()
            self.personalInfoLabel.text = "Personal Information".localized()
            self.preferencesLabel.text = "Preferences".localized()
            self.changePasswordLabel.text = "Change Password".localized()
            self.logOutLabel.text = "Log Out".localized()
            
            }
   
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0{
            return infoArray.count
        }
        else if section == 1{
            return 1
        }
        else{
            return 0
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
            
            }
            else if indexPath.row == 1 {
                self.performSegue(withIdentifier: "PersonalInformationTVC", sender: self)
            }
            else if indexPath.row == 2 {
                //PreferencesTVC
                self.performSegue(withIdentifier: "PreferencesTVC", sender: self)
                
            }
            else if indexPath.row == 3 {
                self.performSegue(withIdentifier: "ChangePasswordTVC", sender: self)
            }
        }
        else if indexPath.section == 1 {
            if indexPath.row == 0 {
                self.showAlert()
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let data = UserDefaults.standard.object(forKey: LOGGED_USER)
        let userInfo = NSKeyedUnarchiver.unarchiveObject(with: data as! Data)
        let user = userInfo as! User
        
        let isFaceBookUser = user.signup_type
        if indexPath.section == 0 {
        if indexPath.row == 3 {
            if  isFaceBookUser == "2" {
                return 0
            }
        }
        }
        return UITableViewAutomaticDimension
    }

    func showAlert() {
        
        let logOutAlert = UIAlertController.init(title: nil, message: "Are you sure you want to log out?".localized(), preferredStyle: .alert)
        let englishBtn = UIAlertAction.init(title: "Ok", style: .default, handler:{
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
        
//        let reachbility:NetworkReachabilityManager = NetworkReachabilityManager()!
//        let isReachable = reachbility.isReachable
//        // Reachability
//        if isReachable == false {
//            self.showAlert(title: "", message: "Please check your internet connection".localized());
//            return
//        }
//        

        SwiftLoader.show(animated: true)
        
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
        // get view controller to move
        let storyBoard = UIStoryboard(name: "Main", bundle: nil);
        let initialViewController: UINavigationController = storyBoard.instantiateInitialViewController()! as! UINavigationController
        let user: User = User()
        AppDelegate.getDelegate().user = user
        UIApplication.shared.keyWindow?.rootViewController = initialViewController
    }
    
    func updateSettings() {
        
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
                          "auto_login": loginSwitch.isOn,
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
                            UserDefaults.standard.set(self.loginSwitch.isOn, forKey: USER_AUTOLOGIN)

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

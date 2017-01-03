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


class AccountTVC: UITableViewController {
    
    var languageSelectionButton: UIButton!
    var infoArray : NSMutableArray!
    
    @IBOutlet var autoLoginLabel: UILabel!
    
    @IBOutlet var preferencesLabel: UILabel!
    @IBOutlet var personalInfoLabel: UILabel!
    
    @IBOutlet var logOutLabel: UILabel!
    @IBOutlet var changePasswordLabel: UILabel!
    
    @IBOutlet var loginSwitch: UISwitch!
    
    @IBAction func autoLoginSwitchAction(_ sender: UISwitch) {
        
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
        
        reloadContent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadContent()
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
        
        self.languageSelectionButton.setTitle("language.button.title".localized(), for: .normal)
        self.title = "Account".localized()
        autoLoginLabel.text = "Auto Log In".localized()
        personalInfoLabel.text = "Personal Information".localized()
        preferencesLabel.text = "Preferences".localized()
        changePasswordLabel.text = "Change Password".localized()
        logOutLabel.text = "Log Out".localized()
        
        
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
    func showAlert() {
        
        let logOutAlert = UIAlertController.init(title: nil, message: "Are you sure \nDo you want to Logout", preferredStyle: .alert)
        let englishBtn = UIAlertAction.init(title: "Ok", style: .default, handler:{
            (action) in
            self.userLogout()
        })
        
        let cancelBtn = UIAlertAction.init(title: "Cancel".localized(), style: .cancel, handler:nil)
        
        logOutAlert.view.tintColor = APP_GRREN_COLOR
        logOutAlert .addAction(englishBtn)
        logOutAlert.addAction(cancelBtn)
        
        self.present(logOutAlert, animated: true, completion:nil)
        
    }
    
    func userLogout() {
        
        let device_id = UIDevice.current.identifierForVendor!.uuidString
        let user_id  = UserDefaults.standard.object(forKey: USER_ID) ?? ""
        let auth_token : String = UserDefaults.standard.object(forKey: AUTH_TOKEN) as! String
        let currentLanguage = Localize.currentLanguage()
        
        
        let parameters = ["user_id": user_id,
                          "auth_token": auth_token,
                          "platform":"1",
                          "version_code": "1",
                          "version_name": "1",
                          "device_id": device_id,
                          "push_token":"123123",
                          "language":currentLanguage
            ] as [String : Any]
        
        print(parameters)
        let url = String(format: "%@/logOut", hostUrl)
        print(url)
        Alamofire.postRequest(URL(string:url)!, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response:DataResponse<Any>) in
            switch response.result {
                
            case .success:
                let json = JSON(data: response.data!)
                print("json response\(json)")
                
                //let appDomain = Bundle.main.bundleIdentifier
                //UserDefaults.standard.removePersistentDomain(forName: appDomain!)
                self.clearUserData()
                
                let storyBoard = UIStoryboard(name: "Main", bundle: nil);
                let initialViewController: UINavigationController = storyBoard.instantiateInitialViewController()! as! UINavigationController
                
                //  let loginVc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LandingVC")
                //  initialViewController.pushViewController(loginVc, animated: true)
                
                UIApplication.shared.keyWindow?.rootViewController = initialViewController
                
                break
                
            case .failure(let error):
                
                DispatchQueue.main.async {
                    
                }
                print(error)
                break
            }
            
            
        }
    }
    
    func clearUserData() {
        
        UserDefaults.standard.removeObject(forKey: USER_ID)
        UserDefaults.standard.removeObject(forKey: AUTH_TOKEN)
        UserDefaults.standard.removeObject(forKey: LOGGED_USER)
    }
    
}

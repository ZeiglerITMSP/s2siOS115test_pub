//
//  ServicesTVC.swift
//  Snap2Save
//
//  Created by Appit on 12/20/16.
//  Copyright © 2016 Appit. All rights reserved.
//

import UIKit
import Localize_Swift
import Alamofire
import SwiftyJSON

class ServicesTVC: UITableViewController {
    
    // Properties
    let ebtWebView: EBTWebView = EBTWebView.shared
    
    var tempLoginUrl = ""
    var infoScreensArray = [[String:Any]]()
    var infoScreenDetailArray = [Any]()
    var screensDict = [String : Any]()
    
    
    
    // Outlets
    @IBOutlet weak var ebtLabel: UILabel!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var faqLabel: UILabel!
    @IBOutlet weak var contactUsLabel: UILabel!
    @IBOutlet weak var termsLabel: UILabel!
    @IBOutlet weak var privacyPolicyLabel: UILabel!
    
    var ebtActivityIndicator =  UIActivityIndicatorView()
    @IBOutlet var rewardLabel: UILabel!
    
    
    
    var FlowSegentedControl: UISegmentedControl!
    
    
    var languageSelectionButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // language selection
        languageSelectionButton = LanguageUtility.createLanguageSelectionButton(withTarge: self, action: #selector(languageButtonClicked))
        LanguageUtility.addLanguageButton(languageSelectionButton, toController: self)
        
        // TEST
        
        reloadContent()
        
       // staticInfoScreenArray = ["faq", "about", "terms", "reward", "privacy", "contactus"]
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.infoScreens()
        
        reloadContent()
        
        AppHelper.getScreenName(screenName: "Services screen")
        
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
    
    //    // TEST
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //
    //        if segue.identifier == "EBTLoginTVC" {
    //
    //            let loginVC = segue.destination as! EBTLoginTVC
    //            loginVC.tempLoginUrl = tempLoginUrl
    //        }
    //    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  section ==  0 {
            // TEST
            return 1
        }
        else {
            return infoScreensArray.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "EBTTableViewCell") as! EBTTableViewCell
                cell.ebtLabel.text = "EBT".localized()
                self.ebtActivityIndicator = cell.ebtActivityIndicator
                return cell
            }
            else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "FlowSegmentTableViewCell") as! FlowSegmentTableViewCell
                //cell.ebtLabel.text = "EBT".localized()
                self.FlowSegentedControl =  cell.flowSegmentControl
                self.FlowSegentedControl.isHidden = true
                return cell
            }
        }
        else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "InfoScreenTableViewCell")as! InfoScreenTableViewCell
            let dict = infoScreensArray[indexPath.row]
            let currentLanguage = Localize.currentLanguage()
            if currentLanguage == "en"
            {
                cell.titleLabel.text = dict["en_title"] as! String?
            }
            else if currentLanguage == "es"
            {
                cell.titleLabel.text = dict["es_title"] as! String?
            }
            
            return cell
        }
        
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            
            if indexPath.row == 0 {
                
                let reachbility:NetworkReachabilityManager = NetworkReachabilityManager()!
                let isReachable = reachbility.isReachable
                // Reachability
                if isReachable == false {
                    self.showAlert(title: "", message: "The internet connection appears to be offline.".localized());
                } else {
                    loadLoginPage()
                }
                
            }
        }
        else if indexPath.section == 1 {
            
            //let currentLanguage = Localize.currentLanguage()
            
           // let infoScreens : [String : Any] = UserDefaults.standard.object(forKey: INFO_SCREENS) as! [String : Any]
            
            let servicesWebVc = UIStoryboard.init(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "ServicesWebViewVC") as! ServicesWebViewVC
            
           // var url : String = ""
            
            let dict = infoScreensArray[indexPath.row]
            servicesWebVc.infoDict = dict
            self.navigationController?.show(servicesWebVc, sender: self)

            /*if indexPath.row == 0 {
                
                
              /*  if currentLanguage == "es" {
                    url = infoScreens["about_es"] as! String? ?? ""
                }
                else {
                    url = infoScreens["about"] as! String? ?? ""
                    
                }
                servicesWebVc.urlStr_es = infoScreens["about_es"] as! String? ?? ""
                servicesWebVc.urlStr_en = infoScreens["about"] as! String? ?? ""
                
                servicesWebVc.loadUrl = url
                servicesWebVc.type = ServicesWebViewVC.ServiceType.aboutSnap2Save*/
                
            }
                
            else if indexPath.row == 1 {
                //                var url : String = ""
                if currentLanguage == "es" {
                    url = infoScreens["faq_es"] as! String? ?? ""
                }
                else {
                    url = infoScreens["faq"] as! String? ?? ""
                }
                
                servicesWebVc.urlStr_es = infoScreens["faq_es"] as! String? ?? ""
                servicesWebVc.urlStr_en = infoScreens["faq"] as! String? ?? ""
                
                
                servicesWebVc.loadUrl = url
                servicesWebVc.type = ServicesWebViewVC.ServiceType.FAQ
                
            }
                
            else if indexPath.row == 2 {
                //  var url : String  = ""
                if currentLanguage == "es" {
                    url = infoScreens["reward_es"] as! String? ?? ""
                }
                else {
                    url = infoScreens["reward"] as! String? ?? ""
                }
                
                servicesWebVc.urlStr_es = infoScreens["reward_es"] as! String? ?? ""
                servicesWebVc.urlStr_en = infoScreens["reward"] as! String? ?? ""
                
                servicesWebVc.loadUrl = url
                servicesWebVc.type = ServicesWebViewVC.ServiceType.reward
                
                
            }
                
                
            else if indexPath.row == 3 {
                // var url  : String = ""
                if currentLanguage == "es" {
                    url = infoScreens["terms_es"] as! String? ?? ""
                }
                else {
                    url = infoScreens["terms"] as! String? ?? ""
                }
                servicesWebVc.urlStr_es = infoScreens["terms_es"] as! String? ?? ""
                servicesWebVc.urlStr_en = infoScreens["terms"] as! String? ?? ""
                
                servicesWebVc.loadUrl = url
                servicesWebVc.type = ServicesWebViewVC.ServiceType.termsOfService
                
                
            }
                
            else if indexPath.row == 4 {
                
                // var url : String = ""
                if currentLanguage == "es" {
                    url = infoScreens["privacy_es"] as! String? ?? ""
                }
                else {
                    url = infoScreens["privacy"] as! String? ?? ""
                }
                servicesWebVc.urlStr_es = infoScreens["privacy_es"] as! String? ?? ""
                servicesWebVc.urlStr_en = infoScreens["privacy"] as! String? ?? ""
                
                servicesWebVc.loadUrl = url
                servicesWebVc.type = ServicesWebViewVC.ServiceType.privacyPolicy
                
                
            }
                
            else if indexPath.row == 5 {
                
                // var url : String = ""
                if currentLanguage == "es" {
                    url = infoScreens["contactus_es"] as! String? ?? ""
                }
                else {
                    url = infoScreens["contactus"] as! String? ?? ""
                }
                servicesWebVc.urlStr_es = infoScreens["contactus_es"] as! String? ?? ""
                servicesWebVc.urlStr_en = infoScreens["contactus"] as! String? ?? ""
                
                servicesWebVc.loadUrl = url
                servicesWebVc.type = ServicesWebViewVC.ServiceType.contactUs
                
            }
            
            if !url.isEmpty || url.characters.count > 0
            {
                self.navigationController?.show(servicesWebVc, sender: self)
            }
        }*/
        
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    }
    func infoScreens()
    {
        let reachbility:NetworkReachabilityManager = NetworkReachabilityManager()!
        let isReachable = reachbility.isReachable
        // Reachability
        if isReachable == false {
            self.showAlert(title: "", message: "The internet connection appears to be offline.".localized());
            return
        }
        
        let user_id  = UserDefaults.standard.object(forKey: USER_ID) ?? ""
        let device_id = UIDevice.current.identifierForVendor!.uuidString
        let currentLanguage = Localize.currentLanguage()
        let version_name = Bundle.main.releaseVersionNumber ?? ""
        let version_code = Bundle.main.buildVersionNumber ?? ""
        let auth_token : String = UserDefaults.standard.object(forKey: AUTH_TOKEN) as! String
        
        
        let parameters  : Parameters = ["user_id": user_id,
                                        "platform":"1",
                                        "version_code": version_code,
                                        "version_name": version_name,
                                        "device_id": device_id,
                                        "language": currentLanguage,
                                        "auth_token":auth_token
        ]
        
        
        //print(parameters)
        SwiftLoader.show(title: "Loading...", animated: true)

        let url = String(format: "%@/infoScreensList", hostUrl)
        //print("url)
        Alamofire.postRequest(URL(string:url)!, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response:DataResponse<Any>) in
            
            switch response.result {
            case .success:
                
                let json = JSON(data: response.data!)
               // print("json response\(json)")
                DispatchQueue.main.async {
                    SwiftLoader.hide()
                }
                
                if let responseDict = json.dictionaryObject {
                    if let code = responseDict["code"] {
                        let code = code as! NSNumber
                        if code.intValue == 200 {
                            if let screens = responseDict["screens"]
                            {
                                self.screensDict = screens as! [String : Any]
                                
                                var listArray = [[String:Any]]()
                                for infoScreen in self.screensDict {
                                    listArray.append(infoScreen.value as! [String:Any])
                                }
                                
                               // print(listArray)
                                
                                
                                let sortedList = listArray.sorted { (dict1, dict2) -> Bool in
                                    (dict1["order"] as! Int) < (dict2["order"] as! Int)
                                }
                                
                               // print(sortedList)
                                
                                self.infoScreensArray = sortedList
                                
                                //let sortedArray = (listArray as NSArray).sortedArray(using: [NSSortDescriptor(key: "order", ascending: true)]) as! [[String:AnyObject]]

                                // print(sortedArray)
                                
                                self.tableView.reloadData()
                            
                            }
                            
                            
                        }
                        else {
                            if let responseDict = json.dictionaryObject {
                                let alertMessage = responseDict["message"] as! String
                                self.showAlert(title: "", message: alertMessage)
                            }
                            
                            
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
    
    // MARK: -
    
    func languageButtonClicked() {
        
        self.showLanguageSelectionAlert()
    }
    
    func reloadContent() {
        
        DispatchQueue.main.async {
            
            self.languageSelectionButton.setTitle("language.button.title".localized(), for: .normal)
            self.navigationItem.title = "Services".localized()
//            self.ebtLabel.text = "EBT".localized()
//            self.aboutLabel.text = "About Snap2Save".localized()
//            self.faqLabel.text = "Help".localized()
//            self.contactUsLabel.text = "Contact Us".localized()
//            self.termsLabel.text = "Terms of Service".localized()
//            self.privacyPolicyLabel.text = "Privacy Policy".localized()
//            self.rewardLabel.text = "Reward Program".localized()
            self.tableView.reloadData()
        }
    }
    
    
}



extension ServicesTVC {
    
    func loadLoginPage() {
        
        self.ebtActivityIndicator.startAnimating()
        // config..
        ebtWebView.responder = self
        let webView = ebtWebView.webView!
        self.view.addSubview(webView)
        self.view.sendSubview(toBack: webView)
        webView.isHidden = true
        
        var loginUrl = kEBTLoginUrl
        //        // TEST
        //        // For testing only
        //        if self.FlowSegentedControl.selectedSegmentIndex == 1 {
        //            loginUrl = "http://internal.appit.ventures/s2s/flow2/ebt_login.html"
        //        } else if self.FlowSegentedControl.selectedSegmentIndex == 2 {
        //            loginUrl = "http://internal.appit.ventures/s2s/flow3/ebt_login.html"
        //        } else if self.FlowSegentedControl.selectedSegmentIndex == 3 {
        //            loginUrl = "http://internal.appit.ventures/s2s/flow4/ebt_login.html"
        //        } else if self.FlowSegentedControl.selectedSegmentIndex == 4 {
        //            loginUrl = "http://internal.appit.ventures/s2s/flow5/ebt_login.html"
        //        } else if self.FlowSegentedControl.selectedSegmentIndex == 5 {
        //            loginUrl = "https://ucard.chase.com/locale?request_locale=en"
        //        }
        //
        //        tempLoginUrl = loginUrl
        
        if Localize.currentLanguage() == "es" {
            // .. es url
            loginUrl = kEBTLoginUrl_es
        }
        
        
        let url = NSURL(string: loginUrl)
        let request = NSURLRequest(url: url! as URL)
        
        
        
        ebtWebView.webView.load(request as URLRequest)
    }
    
    //    func validatePage() {
    //
    //        // isCurrentPage
    //        let jsLoginValidation = "$('#button_logon').text().trim();"
    //        let javaScript = jsLoginValidation
    //
    //        ebtWebView.webView.evaluateJavaScript(javaScript) { (result, error) in
    //
    //            if let resultString = result as? String {
    //                let resultTrimmed = resultString.trimmingCharacters(in: .whitespacesAndNewlines)
    //                if resultTrimmed == "ebt.logon".localized() {
    //
    //                    self.ebtActivityIndicator.stopAnimating()
    //                    self.performSegue(withIdentifier: "EBTLoginTVC", sender: nil)
    //
    //                } else {
    //                    self.ebtActivityIndicator.stopAnimating()
    //
    //                }
    //
    //            } else {
    //                print(error ?? "")
    //            }
    //
    //        }
    //    }
    
    func validatePage() {
        
        ebtWebView.getPageHeading(completion: { result in
            
            if let pageTitle = result {
                // isCurrentPage
                if pageTitle == "ebt.logon".localized() {
                    // current page
                    self.ebtActivityIndicator.stopAnimating()
                    self.performSegue(withIdentifier: "EBTLoginTVC", sender: nil)
                    
                } else {
                    self.ebtActivityIndicator.stopAnimating()
                }
                
            } else {
                //print(error ?? "")
            }
            
        })
    }
    
    
}

extension ServicesTVC: EBTWebViewDelegate {
    
    func didFinishLoadingWebView() {
        
        validatePage()
    }
}




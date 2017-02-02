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

class ServicesTVC: UITableViewController {
    
    // Properties
    let ebtWebView: EBTWebView = EBTWebView.shared
    
    
    
    // Outlets
    @IBOutlet weak var ebtLabel: UILabel!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var faqLabel: UILabel!
    @IBOutlet weak var contactUsLabel: UILabel!
    @IBOutlet weak var termsLabel: UILabel!
    @IBOutlet weak var privacyPolicyLabel: UILabel!
    
    @IBOutlet weak var ebtActivityIndicator: UIActivityIndicatorView!
    @IBOutlet var rewardLabel: UILabel!
    
    
    
    @IBOutlet weak var FlowSegentedControl: UISegmentedControl!
    
    
    var languageSelectionButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // language selection
        languageSelectionButton = LanguageUtility.createLanguageSelectionButton(withTarge: self, action: #selector(languageButtonClicked))
        LanguageUtility.addLanguageButton(languageSelectionButton, toController: self)
        
        reloadContent()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
    
    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            
            if indexPath.row == 0 {
                
                let reachbility:NetworkReachabilityManager = NetworkReachabilityManager()!
                let isReachable = reachbility.isReachable
                // Reachability
                if isReachable == false {
                    self.showAlert(title: "", message: "Please check your internet connection".localized());
//                    return
                } else {
                    loadLoginPage()
                }
                
            }
        }
        else if indexPath.section == 1 {
            
            let currentLanguage = Localize.currentLanguage()
            
            let infoScreens : [String : Any] = UserDefaults.standard.object(forKey: INFO_SCREENS) as! [String : Any]
            
            let servicesWebVc = UIStoryboard.init(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "ServicesWebViewVC") as! ServicesWebViewVC
            
            if indexPath.row == 0 {
                
                var url = ""
                if currentLanguage == "es" {
                    url = infoScreens["about_es"] as! String? ?? ""
                }
                else {
                 url = infoScreens["about"] as! String? ?? ""
                    
                }
                servicesWebVc.urlStr_es = infoScreens["about_es"] as! String? ?? ""
                servicesWebVc.urlStr_en = infoScreens["about"] as! String? ?? ""

                servicesWebVc.loadUrl = url
                servicesWebVc.type = ServicesWebViewVC.ServiceType.aboutSnap2Save
                
            }
                
            else if indexPath.row == 1 {
                var url = ""
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
                var url = ""
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
                var url = ""
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
                
                var url = ""
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
                
                var url = ""
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
            self.navigationController?.show(servicesWebVc, sender: self)
        }
            
      /*  else if indexPath.section == 2 {
            
            let currentLanguage = Localize.currentLanguage()
            let servicesWebVc = UIStoryboard.init(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "ServicesWebViewVC") as! ServicesWebViewVC
            let infoScreens : [String : Any] = UserDefaults.standard.object(forKey: INFO_SCREENS) as! [String : Any]
            
            if indexPath.row == 0 {
                var url = ""
                if currentLanguage == "es" {
                    url = infoScreens["terms_es"] as! String? ?? ""
                }
                else {
                    url = infoScreens["terms"] as! String? ?? ""
                }
                servicesWebVc.loadUrl = url 
                servicesWebVc.type = ServicesWebViewVC.ServiceType.termsOfService


            }
                
            else if indexPath.row == 1 {
                
                var url = ""
                if currentLanguage == "es" {
                    url = infoScreens["privacy_es"] as! String? ?? ""
                }
                else {
                    url = infoScreens["privacy"] as! String? ?? ""
                }
                servicesWebVc.loadUrl = url 
                servicesWebVc.type = ServicesWebViewVC.ServiceType.privacyPolicy


            }
            self.navigationController?.show(servicesWebVc, sender: self)
            
        }*/
        
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    

    
    // MARK: -
    
    func languageButtonClicked() {
        
        self.showLanguageSelectionAlert()
    }
    
    func reloadContent() {
        
        DispatchQueue.main.async {
            
            self.languageSelectionButton.setTitle("language.button.title".localized(), for: .normal)
            self.navigationItem.title = "Services".localized()
            self.ebtLabel.text = "EBT".localized()
            self.aboutLabel.text = "About Snap2Save".localized()
            self.faqLabel.text = "FAQ".localized()
            self.contactUsLabel.text = "Contact Us".localized()
            self.termsLabel.text = "Terms of Service".localized()
            self.privacyPolicyLabel.text = "Privacy Policy".localized()
            self.rewardLabel.text = "Reward Program".localized()
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
        
        var loginUrl = kEBTLoginUrl
        
        // For testing only
        if self.FlowSegentedControl.selectedSegmentIndex == 1 {
            loginUrl = "http://internal.appit.ventures/s2s/flow2/ebt_login.html"
        } else if self.FlowSegentedControl.selectedSegmentIndex == 2 {
            loginUrl = "http://internal.appit.ventures/s2s/flow3/ebt_login.html"
        } else if self.FlowSegentedControl.selectedSegmentIndex == 3 {
            loginUrl = "http://internal.appit.ventures/s2s/flow4/ebt_login.html"
        } else if self.FlowSegentedControl.selectedSegmentIndex == 4 {
            loginUrl = "http://internal.appit.ventures/s2s/flow5/ebt_login.html"
        } else if self.FlowSegentedControl.selectedSegmentIndex == 5 {
            loginUrl = "https://ucard.chase.com/locale?request_locale=en"
        }
        
        if Localize.currentLanguage() == "es" {
            // .. es url
            loginUrl = kEBTLoginUrl_es
        }
        
        let url = NSURL(string: loginUrl)
        let request = NSURLRequest(url: url! as URL)
        
        
        ebtWebView.webView.load(request as URLRequest)
    }
    
    func validatePage() {
        
        // isCurrentPage
        let jsLoginValidation = "$('#button_logon').text().trim();"
        let javaScript = jsLoginValidation
        
        ebtWebView.webView.evaluateJavaScript(javaScript) { (result, error) in
            
            if let resultString = result as? String {
                let resultTrimmed = resultString.trimmingCharacters(in: .whitespacesAndNewlines)
                if resultTrimmed == "ebt.logon".localized() {
                    
                    self.ebtActivityIndicator.stopAnimating()
                    self.performSegue(withIdentifier: "EBTLoginTVC", sender: nil)
                    
                } else {
                    self.ebtActivityIndicator.stopAnimating()
                    
                }
                
            } else {
                print(error ?? "")
            }
            
        }
    }

    
}

extension ServicesTVC: EBTWebViewDelegate {
    
    func didFinishLoadingWebView() {
        
        validatePage()
    }
}




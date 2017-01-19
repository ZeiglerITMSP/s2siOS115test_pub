//
//  ServicesTVC.swift
//  Snap2Save
//
//  Created by Appit on 12/20/16.
//  Copyright © 2016 Appit. All rights reserved.
//

import UIKit
import  Localize_Swift

class ServicesTVC: UITableViewController {
    
    
    // Outlets
    @IBOutlet weak var ebtLabel: UILabel!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var faqLabel: UILabel!
    @IBOutlet weak var contactUsLabel: UILabel!
    @IBOutlet weak var termsLabel: UILabel!
    @IBOutlet weak var privacyPolicyLabel: UILabel!
    
    
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
                performSegue(withIdentifier: "EBTLoginTVC", sender: nil)
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
                servicesWebVc.loadUrl = url
                servicesWebVc.type = ServicesWebViewVC.ServiceType.FAQ

            }
                
            else if indexPath.row == 2 {
                
                var url = ""
                if currentLanguage == "es" {
                    url = infoScreens["contactus_es"] as! String? ?? ""
                }
                else {
                    url = infoScreens["contactus"] as! String? ?? ""
                }

                servicesWebVc.loadUrl = url 
                servicesWebVc.type = ServicesWebViewVC.ServiceType.contactUs


            }
            
            self.navigationController?.show(servicesWebVc, sender: self)
        }
            
        else if indexPath.section == 2 {
            
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
            self.ebtLabel.text = "EBT".localized()
            self.aboutLabel.text = "About Snap2Save".localized()
            self.faqLabel.text = "FAQ".localized()
            self.contactUsLabel.text = "Contact Us".localized()
            self.termsLabel.text = "Terms of Service".localized()
            self.privacyPolicyLabel.text = "Privacy Policy".localized()
        }
    }
    

}

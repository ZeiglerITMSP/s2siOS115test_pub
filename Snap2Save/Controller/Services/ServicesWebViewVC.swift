//
//  ServicesWebViewVC.swift
//  Snap2Save
//
//  Created by Malathi on 11/01/17.
//  Copyright © 2017 Appit. All rights reserved.
//

import UIKit
import Localize_Swift

class ServicesWebViewVC: UIViewController {
    
    var languageSelectionButton: UIButton!
    
    enum ServiceType {
        
        case aboutSnap2Save
        case FAQ
        case contactUs
        case termsOfService
        case privacyPolicy
        case reward
    }
    var loadUrl : String = ""
    
    var urlStr_en : String = ""
    var urlStr_es : String = ""
    
    var type : ServiceType? = nil
    var currentlanguage = ""
    var oldLanguage = ""
    
    @IBOutlet var servicesWebView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationItem.addBackButton(withTarge: self, action: #selector(backAction))
        servicesWebView.delegate = self
        servicesWebView.scalesPageToFit = true
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        languageSelectionButton = LanguageUtility.createLanguageSelectionButton(withTarge: self, action: #selector(languageButtonClicked))
        LanguageUtility.addLanguageButton(languageSelectionButton, toController: self)
        reloadContent()
        
        oldLanguage = Localize.currentLanguage()
        loadWebView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        oldLanguage = Localize.currentLanguage()
        
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
    
    // MARK: -
    
    func backAction() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func languageButtonClicked() {
        
        self.showLanguageSelectionAlert()
    }
    
    func reloadContent() {
        
        DispatchQueue.main.async {
            
            if self.type == ServiceType.aboutSnap2Save{
                self.title = "About Snap2Save".localized()
            }
            else if self.type == ServiceType.FAQ{
                self.title = "Help".localized()
            }
            else if self.type == ServiceType.contactUs{
                self.title = "Contact Us".localized()
            }
            else if self.type == ServiceType.termsOfService{
                self.title = "Terms of Service".localized()
            }
            else if self.type == ServiceType.privacyPolicy{
                self.title = "Privacy Policy".localized()
            }
            else if self.type == ServiceType.reward{
                self.title = "Reward Program".localized()
            }
            
            self.languageSelectionButton.setTitle("language.button.title".localized(), for: .normal)
            self.updateBackButtonText()
            
            self.currentlanguage = Localize.currentLanguage()
            
            if self.oldLanguage != self.currentlanguage {
                self.oldLanguage = self.currentlanguage
                self.servicesWebView.loadRequest(URLRequest(url: URL(string:"about:blank")!))
                
                self.loadWebView()
                
            }
        }
        
    }
    
    func loadWebView() {
        var url : URL? = nil
        currentlanguage = Localize.currentLanguage()
        if currentlanguage == "es" {
            url = URL(string : urlStr_es )
        }
        else if currentlanguage == "en" {
            url = URL(string : urlStr_en )
        }
        
        if url != nil {
            let request = URLRequest(url: url!)
            servicesWebView.loadRequest(request)
            servicesWebView.scalesPageToFit = true
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


extension ServicesWebViewVC: UIWebViewDelegate {
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        
        let script = "document.getElementsByTagName('body')[0].innerHTML.length";
        
        if let lenght = self.servicesWebView.stringByEvaluatingJavaScript(from: script) {
            
            let len : Int = Int(lenght)!
            
            if len == 0 {
                SwiftLoader.show(title: "Loading...".localized(), animated: true)
            }
        }
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SwiftLoader.hide()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        SwiftLoader.hide()
    }
    
}

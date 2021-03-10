//
//  ServicesWebViewVC.swift
//  Snap2Save
//
//  Created by Malathi on 11/01/17.
//  Copyright © 2017 Appit. All rights reserved.
//

import UIKit
import Localize_Swift
import Google

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
    
    var infoDict = [String : Any]()
    
    @IBOutlet var servicesWebView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationItem.addBackButton(withTarge: self, action: #selector(backAction))
        servicesWebView.delegate = self
        servicesWebView.scalesPageToFit = true
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
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
    
    @objc func backAction() {
        
//         _ = self.navigationController?.popViewController(animated: true)
        if servicesWebView.canGoBack == true {
            servicesWebView.goBack()
        } else {
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func languageButtonClicked() {
        
        self.showLanguageSelectionAlert()
    }
    
    @objc func reloadContent() {
        
        DispatchQueue.main.async {
            
           /* if self.type == ServiceType.aboutSnap2Save{
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
            }*/
            
      
            if let gai = GAI.sharedInstance() {
                gai.trackUncaughtExceptions = true  // report uncaught exceptions
                // gai.logger.logLevel = GAILogLevel.verbose  // remove before app release
            }

            let tracker = GAI.sharedInstance().defaultTracker
            
            if Localize.currentLanguage() == "es"
            {
                self.title = self.infoDict["es_title"] as? String
            }
            
            else if Localize.currentLanguage() == "en"
            {
                self.title = self.infoDict["en_title"] as! String?
            }

            let builder = GAIDictionaryBuilder.createEvent(withCategory: "Services",
                                                           action: "ButtonClick",
                                                           label: self.title,
                                                           value: 1).build()
            
            tracker?.send(builder as [NSObject : AnyObject]?)

            self.title="";
            self.languageSelectionButton.setTitle("language.button.title".localized(), for: .normal)
            self.updateBackButtonText()

            self.currentlanguage = Localize.currentLanguage()
            
            if self.oldLanguage != self.currentlanguage {
                self.oldLanguage = self.currentlanguage
//                self.servicesWebView.loadRequest(URLRequest(url: URL(string:"about:blank")!))
                
                self.loadWebView()
                
            }
        }
        
    }
    
    func loadWebView() {
        var url : URL? = nil
        currentlanguage = Localize.currentLanguage()
        if currentlanguage == "es" {
            let url_str = infoDict["es_url"] as! String
            url = URL(string : url_str )
        }
        else if currentlanguage == "en" {
            let url_str = infoDict["en_url"] as! String
            url = URL(string : url_str )
        }
        
        if url != nil {
            let request = URLRequest(url: url!)
            servicesWebView.loadRequest(request)
            servicesWebView.scalesPageToFit = true
        }
    }
    
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

//
//  OffersDetailsViewController.swift
//  Snap2Save
//
//  Created by Malathi on 17/01/17.
//  Copyright © 2017 Appit. All rights reserved.
//

import UIKit
import  Localize_Swift

class OffersDetailsViewController: UIViewController {

    var languageSelectionButton: UIButton!
    var screenLanguage: String!
    
    // paramaters
    var urlString_en : String = ""
    var urlString_es : String = ""
    var navigationTitle: String?
    
//    var oldLanguage : String = ""
//    var currentlang : String = ""
    
    var loader: SwiftLoader?
    
    @IBOutlet var offersWebView: UIWebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        offersWebView.delegate = self
        // language button
        languageSelectionButton = LanguageUtility.createLanguageSelectionButton(withTarge: self, action: #selector(languageButtonClicked))
        LanguageUtility.addLanguageButton(languageSelectionButton, toController: self)
        self.navigationItem.addBackButton(withTarge: self, action: #selector(backAction))
        
//        oldLanguage = Localize.currentLanguage()
        
        updateTitles()
        loadWebView()
        
        screenLanguage = Localize.currentLanguage()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
//        oldLanguage = Localize.currentLanguage()
//        reloadContent()

        if screenLanguage != Localize.currentLanguage() {
            screenLanguage = Localize.currentLanguage()
            languageChanged()
        } else {
            updateTitles()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        LanguageUtility.addOberverForLanguageChange(self, selector: #selector(languageChanged))
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        LanguageUtility.removeObserverForLanguageChange(self)
        super.viewDidDisappear(animated)
    }
    

    
    @objc func languageButtonClicked() {
        self.showLanguageSelectionAlert()
    }
    
    @objc func languageChanged() {
        
        updateTitles()
        loadWebView()
    }
    
    func updateTitles() {
        
        DispatchQueue.main.async {
            self.languageSelectionButton.setTitle("language.button.title".localized(), for: .normal)
            self.updateBackButtonText()
            self.navigationItem.title = self.navigationTitle?.localized()
            
//            self.currentlang = Localize.currentLanguage()
//            if self.oldLanguage != self.currentlang {
//                self.oldLanguage = self.currentlang
//                self.offersWebView.loadRequest(URLRequest(url: URL(string:"about:blank")!))
//                self.loadWebView()
//            }
            
        }
    }
    
//    func reloadContent() {
//        DispatchQueue.main.async {
//            self.languageSelectionButton.setTitle("language.button.title".localized(), for: .normal)
//            self.updateBackButtonText()
//            self.navigationItem.title = self.navigationTitle?.localized()
//            
//            self.currentlang = Localize.currentLanguage()
//            if self.oldLanguage != self.currentlang {
//                self.oldLanguage = self.currentlang
//                self.offersWebView.loadRequest(URLRequest(url: URL(string:"about:blank")!))
//                self.loadWebView()
//                
//            }
//        }
//    }

    @objc func backAction() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func loadWebView() {
        // get url
        var url : URL? =  nil
        if Localize.currentLanguage() == "en" {
            url = URL(string : urlString_en )
        } else if Localize.currentLanguage() == "es" {
            url = URL(string : urlString_es )
        }
        // load web page
        if url != nil {
            let request = URLRequest(url: url!)
            offersWebView.loadRequest(request)
            offersWebView.scalesPageToFit = true
            DispatchQueue.main.async {
                self.loader = SwiftLoader.show(inView: self.offersWebView, title: "Loading...".localized(), animated: true, config: AppHelper.getConfigSwiftLoader())
//                self.loader?.start()
            }
        }
    }
}

extension OffersDetailsViewController: UIWebViewDelegate {  
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        
//        let script = "document.getElementsByTagName('body')[0].innerHTML.length";
//        if let lenght = self.offersWebView.stringByEvaluatingJavaScript(from: script) {
//        
//        let len : Int = Int(lenght)!
//            if len == 0 {
//                self.loader = SwiftLoader.show(inView: self.offersWebView, title: "Loading...".localized(), animated: true, config: AppHelper.getConfigSwiftLoader())
//            }
//        }
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.loader?.hideFromView()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        self.loader?.hideFromView()
    }
    
}

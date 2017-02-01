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
    var urlString_en : String = ""
    var urlString_es : String = ""
    var oldLanguage : String = ""
    var currentlang : String = ""
    
    var loader: SwiftLoader?
    
    @IBOutlet var offersWebView: UIWebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        offersWebView.delegate = self
        languageSelectionButton = LanguageUtility.createLanguageSelectionButton(withTarge: self, action: #selector(languageButtonClicked))
        LanguageUtility.addLanguageButton(languageSelectionButton, toController: self)
        self.navigationItem.addBackButton(withTarge: self, action: #selector(backAction))
        
        oldLanguage = Localize.currentLanguage()
        loadWebView()

        reloadContent()

        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        oldLanguage = Localize.currentLanguage()
        reloadContent()
        
        loader?.start()

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
    
    func languageButtonClicked() {
        self.showLanguageSelectionAlert()
    }
    
    
    func reloadContent() {
        DispatchQueue.main.async {
            self.languageSelectionButton.setTitle("language.button.title".localized(), for: .normal)
            self.updateBackButtonText()
            self.navigationItem.title = "Offers".localized()
            self.currentlang = Localize.currentLanguage()
            if self.oldLanguage != self.currentlang {
                self.oldLanguage = self.currentlang
                self.offersWebView.loadRequest(URLRequest(url: URL(string:"about:blank")!))

                self.loadWebView()
                
            }
        }
    }

    func backAction() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func loadWebView() {
        
        var url : URL? =  nil
        if Localize.currentLanguage() == "en" {
            url = URL(string : urlString_en )
        }
        else if Localize.currentLanguage() == "es" {
            url = URL(string : urlString_es )
        }
        if url != nil {
        let request = URLRequest(url: url!)
        offersWebView.loadRequest(request)
        offersWebView.scalesPageToFit = true
        }
    }
}

extension OffersDetailsViewController: UIWebViewDelegate {  
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        
        let script = "document.getElementsByTagName('body')[0].innerHTML.length";
        
        if let lenght = self.offersWebView.stringByEvaluatingJavaScript(from: script) {
        
        let len : Int = Int(lenght)!
        
            if len == 0 {
                
                var config : SwiftLoader.Config = SwiftLoader.Config()
                config.size = 110
                config.spinnerColor = APP_GRREN_COLOR
                config.foregroundColor = .black
                config.backgroundColor = .white
                config.foregroundAlpha = 0.1
                config.titleTextColor = APP_GRREN_COLOR
                
                loader = SwiftLoader.show(inView: offersWebView, title: "TEST..", animated: true, config: config)
                
//                SwiftLoader.show(title: "Loading...".localized(), animated: true)
            }
        }
        
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        loader?.hideFromView()
//        SwiftLoader.hide()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        loader?.hideFromView()
//        SwiftLoader.hide()
    }
    
}

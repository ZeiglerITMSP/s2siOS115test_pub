//
//  RedeemPointsWebVC.swift
//  Snap2Save
//
//  Created by Malathi on 27/02/17.
//  Copyright © 2017 Appit. All rights reserved.
//

import UIKit
import Localize_Swift

class RedeemPointsWebVC: UIViewController {

    var loadUrlStr : String = ""
    var languageSelectionButton: UIButton!
    var currentlanguage : String = ""
    var oldLanguage : String = ""

    @IBOutlet var redeemPointsWebView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //redeemPointsWebView.delegate = self
        
        self.navigationItem.addBackButton(withTarge: self, action: #selector(backAction))
        languageSelectionButton = LanguageUtility.createLanguageSelectionButton(withTarge: self, action: #selector(languageButtonClicked))
        LanguageUtility.addLanguageButton(languageSelectionButton, toController: self)
        reloadContent()
        oldLanguage = Localize.currentLanguage()
        loadWebView()


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

    func backAction() {
        _ = self.navigationController?.popViewController(animated: true)
    }

    func reloadContent() {
        DispatchQueue.main.async {
            self.navigationItem.title = "Redeem Points".localized()
            self.updateBackButtonText()
            self.languageSelectionButton.setTitle("language.button.title".localized(), for: .normal)
            self.currentlanguage = Localize.currentLanguage()
            if self.oldLanguage != self.currentlanguage {
                self.oldLanguage = self.currentlanguage
                
                self.loadWebView()
                
            }

        }
        
    }
    
    func languageButtonClicked() {
        self.showLanguageSelectionAlert()
    }

    func loadWebView() {
        var url : URL? = nil
        currentlanguage = Localize.currentLanguage()
        if currentlanguage == "es" {
            url = URL(string : "http://www.clinicatepeyac.org/" )
        }
        else if currentlanguage == "en" {
            url = URL(string : "http://www.clinicatepeyac.org/" )
        }
        if url != nil {
            let request = URLRequest(url: url!)
            redeemPointsWebView.loadRequest(request)
            redeemPointsWebView.scalesPageToFit = true
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


//extension RedeemPointsWebVC: UIWebViewDelegate {
//
//func webViewDidStartLoad(_ webView: UIWebView) {
//    
////    let script = "document.getElementsByTagName('body')[0].innerHTML.length";
//    
//   // if let lenght = self.servicesWebView.stringByEvaluatingJavaScript(from: script) {
//        
//      //  let len : Int = Int(lenght)!
//        
//        //if len == 0 {
//            SwiftLoader.show(title: "Loading...".localized(), animated: true)
//       // }
////}
//}
//
//func webViewDidFinishLoad(_ webView: UIWebView) {
//    SwiftLoader.hide()
//}
//
//func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
//    SwiftLoader.hide()
//}
//}

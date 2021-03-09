//
//  EBTHelpVC.swift
//  Snap2Save
//
//  Created by Appit on 2/14/17.
//  Copyright © 2017 Appit. All rights reserved.
//

import UIKit
import Localize_Swift

class EBTHelpVC: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    var languageSelectionButton: UIButton!
    
    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()

        loadWebView()
        
        // language selection
        languageSelectionButton = LanguageUtility.createLanguageSelectionButton(withTarge: self, action: #selector(languageButtonClicked))
        LanguageUtility.addLanguageButton(languageSelectionButton, toController: self)
        // backbutton
        self.addCloseButton(withTarge: self, action: #selector(backAction))
     
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        LanguageUtility.addOberverForLanguageChange(self, selector: #selector(reloadContent))
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
//        LanguageUtility.removeObserverForLanguageChange(self)
        super.viewDidDisappear(animated)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: -
    
    func loadWebView() {
        
        let urlString = Localize.currentLanguage() == "en" ? kEBTHelp : kEBTHelp_es
        let url : URL? = URL(string: urlString)
        
        if url != nil {
            let request = URLRequest(url: url!)
            webView.loadRequest(request)
            webView.scalesPageToFit = true
        }
    }
    
    // MARK: -
    
    @objc func backAction() {
        
        //        removeHelpTab()
        _ = self.navigationController?.popViewController(animated: false)
    }
    
    @objc func languageButtonClicked() {
        
        self.showLanguageSelectionAlert()
        
    }

    func addCloseButton(withTarge target: Any, action: Selector) {
        
        // Back Action
        let backButton = UIButton.init(type: .custom)
        backButton.frame = CGRect(x:0,y:0,width:80,height:25)
        backButton.setTitle("Close".localized() , for: .normal)
        backButton.setTitleColor(UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0), for: .normal)
        
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 17.0)
        backButton.addTarget(target, action: action, for: .touchUpInside)
        backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0)
        
        let leftBarButton = UIBarButtonItem()
        leftBarButton.customView = backButton
        
        self.navigationItem.leftBarButtonItem = leftBarButton
    }

    
    
}

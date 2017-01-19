//
//  OffersDetailsViewController.swift
//  Snap2Save
//
//  Created by Malathi on 17/01/17.
//  Copyright © 2017 Appit. All rights reserved.
//

import UIKit

class OffersDetailsViewController: UIViewController {

    var languageSelectionButton: UIButton!
    var urlString : String = ""

    @IBOutlet var offersWebView: UIWebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        languageSelectionButton = LanguageUtility.createLanguageSelectionButton(withTarge: self, action: #selector(languageButtonClicked))
        LanguageUtility.addLanguageButton(languageSelectionButton, toController: self)
        self.navigationItem.addBackButton(withTarge: self, action: #selector(backAction))
        reloadContent()
        
        let url = URL(string : urlString )
        let request = URLRequest(url: url!)
        offersWebView.loadRequest(request)
        offersWebView.scalesPageToFit = true
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
    

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    func languageButtonClicked() {
        self.showLanguageSelectionAlert()
    }
    
    
    func reloadContent() {
        DispatchQueue.main.async {
            self.languageSelectionButton.setTitle("language.button.title".localized(), for: .normal)
            self.updateBackButtonText()
            self.navigationItem.title = "Offers".localized()
            
        }
    }

    func backAction() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    

}
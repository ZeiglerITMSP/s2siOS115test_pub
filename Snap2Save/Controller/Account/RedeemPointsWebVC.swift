//
//  RedeemPointsWebVC.swift
//  Snap2Save
//
//  Created by Malathi on 27/02/17.
//  Copyright © 2017 Appit. All rights reserved.
//

import UIKit

class RedeemPointsWebVC: UIViewController {

    var loadUrlStr : String = ""

    @IBOutlet var redeemPointsWebView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        reloadContent()

       let  loadUrl = URL(string : loadUrlStr )
        self.navigationItem.addBackButton(withTarge: self, action: #selector(backAction))

        if loadUrl != nil {
            let request = URLRequest(url: loadUrl!)
            redeemPointsWebView.loadRequest(request)
            redeemPointsWebView.scalesPageToFit = true
        }
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

    func backAction() {
        _ = self.navigationController?.popViewController(animated: true)
    }

    func reloadContent() {
        DispatchQueue.main.async {
            self.updateBackButtonText()
            //self.languageSelectionButton.setTitle("language.button.title".localized(), for: .normal)
            self.navigationItem.title = "Redeem Points".localized()
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

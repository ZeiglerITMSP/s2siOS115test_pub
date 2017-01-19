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

    enum ServiceType {
        
        case aboutSnap2Save
        case FAQ
        case contactUs
        case termsOfService
        case privacyPolicy
    }
    var loadUrl : String = ""
    var type : ServiceType? = nil
    
    @IBOutlet var servicesWebView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.addBackButton(withTarge: self, action: #selector(backAction))

        let url = URL(string : loadUrl )
        let request = URLRequest(url: url!)
        servicesWebView.loadRequest(request)
        servicesWebView.scalesPageToFit = true
        reloadContent()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]

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
    
    // MARK: -
    
    func backAction() {
        _ = self.navigationController?.popViewController(animated: true)
    }

    func reloadContent() {
        
        DispatchQueue.main.async {
            
            if self.type == ServiceType.aboutSnap2Save{
                self.title = "About Snap2Save".localized()
            }
            else if self.type == ServiceType.FAQ{
                self.title = "FAQ".localized()
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
            self.updateBackButtonText()
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

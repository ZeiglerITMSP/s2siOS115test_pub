//
//  ServicesTVC.swift
//  Snap2Save
//
//  Created by Appit on 12/20/16.
//  Copyright © 2016 Appit. All rights reserved.
//

import UIKit

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

//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
//        if indexPath.section == 0 {
//            if indexPath.row == 0 {
//                performSegue(withIdentifier: "EBTLoginTVC", sender: nil)
//            }
//        }
//        
//    }
//    
    // MARK: -
    
    
    
    
    func languageButtonClicked() {
        
        self.showLanguageSelectionAlert()
    }
    
    func reloadContent() {
        
        DispatchQueue.main.async {
            
            self.languageSelectionButton.setTitle("language.button.title".localized(), for: .normal)
            
            self.navigationController?.navigationItem.title = "Services".localized()
            
            self.ebtLabel.text = "EBT".localized()
            self.aboutLabel.text = "About Snap2Save".localized()
            self.faqLabel.text = "FAQ".localized()
            self.contactUsLabel.text = "Contact Us".localized()
            self.termsLabel.text = "Terms of Service".localized()
            self.privacyPolicyLabel.text = "Privacy Policy".localized()
        }
    }

    
    

}

//
//  OffersVC.swift
//  Snap2Save
//
//  Created by Appit on 1/3/17.
//  Copyright © 2017 Appit. All rights reserved.
//

import UIKit

class OffersVC: UIViewController {

    var languageSelectionButton: UIButton!

    override func viewDidLoad() {
        
        super.viewDidLoad()
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

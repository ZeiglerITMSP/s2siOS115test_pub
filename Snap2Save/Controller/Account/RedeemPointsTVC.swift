//
//  RedeemPointsTVC.swift
//  Snap2Save
//
//  Created by Appit on 2/22/17.
//  Copyright © 2017 Appit. All rights reserved.
//

import UIKit

class RedeemPointsTVC: UITableViewController {

    
    var languageSelectionButton: UIButton!

    // outlets
    
    @IBOutlet var redeemPointsTitleLabel: UILabel!
    
    @IBOutlet var saveALotLabel: UILabel!
    
    @IBOutlet var healthCareButton: UIButton!
    @IBOutlet var healthCareLabel: UILabel!
    @IBOutlet var saveALotButton: UIButton!
    
    @IBOutlet var continueButton: UIButton!
    
    @IBOutlet var continueActivityIndicator: UIActivityIndicatorView!
    
    // Actions
    
    @IBAction func continueButtonAction(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "redeemPointsAddressTVC", sender: self)
        
    }
    @IBAction func saveALotButtonAction(_ sender: UIButton) {
        
        self.saveALotButton.setImage(UIImage.init(named: "radioOn"), for: .normal)
        self.healthCareButton.setImage(UIImage.init(named: "radioOff"), for: .normal)
    }
    
    @IBAction func healthCareButtonAction(_ sender: UIButton) {
        
        self.saveALotButton.setImage(UIImage.init(named: "radioOff"), for: .normal)
        self.healthCareButton.setImage(UIImage.init(named: "radioOn"), for: .normal)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        AppHelper.setRoundCornersToView(borderColor: APP_ORANGE_COLOR, view: continueButton, radius: 2.0, width: 1.0)
        
        // language button
        reloadContent()
        languageSelectionButton = LanguageUtility.createLanguageSelectionButton(withTarge: self, action: #selector(languageButtonClicked))
        LanguageUtility.addLanguageButton(languageSelectionButton, toController: self)
        self.navigationItem.addBackButton(withTarge: self, action: #selector(backAction))
        
        self.saveALotButton.setImage(UIImage.init(named: "radioOn"), for: .normal)
        self.healthCareButton.setImage(UIImage.init(named: "radioOff"), for: .normal)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
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
    
    func languageButtonClicked() {
        self.showLanguageSelectionAlert()
    }
    
    func reloadContent() {
        
        DispatchQueue.main.async {
            self.updateBackButtonText()
            self.languageSelectionButton.setTitle("language.button.title".localized(), for: .normal)
            self.navigationItem.title = "Redeem Points".localized()
            self.redeemPointsTitleLabel.text = "To redeem 500 points, please make your selection and click Continue.".localized()
            self.saveALotLabel.text = "$5 Save-A-Lot Gift Card".localized()
            self.healthCareLabel.text = "$10 Health Care Rebate".localized()
            self.continueButton.setTitle("CONTINUE".localized(), for: .normal)
            self.tableView.reloadData()
        }
    }
    

    

}

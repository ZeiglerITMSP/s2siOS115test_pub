//
//  RewardStatusTVC.swift
//  Snap2Save
//
//  Created by Appit on 2/22/17.
//  Copyright © 2017 Appit. All rights reserved.
//

import UIKit

class RewardStatusTVC: UITableViewController {

    // Properties
    var languageSelectionButton: UIButton!
    
    
    
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // language button
        languageSelectionButton = LanguageUtility.createLanguageSelectionButton(withTarge: self, action: #selector(languageButtonClicked))
        LanguageUtility.addLanguageButton(languageSelectionButton, toController: self)
        
        // Automatic height
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44
        // back 
        self.navigationItem.addBackButton(withTarge: self, action: #selector(backAction))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        LanguageUtility.addOberverForLanguageChange(self, selector: #selector(reloadContent))
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        LanguageUtility.removeObserverForLanguageChange(self)
        super.viewDidDisappear(animated)
    }
    
    // MARK: -
    
    func backAction() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func languageButtonClicked() {
        self.showLanguageSelectionAlert()
    }
    
    func reloadContent() {
        
        DispatchQueue.main.async {
            
            self.languageSelectionButton.setTitle("language.button.title".localized(), for: .normal)
            self.navigationItem.title = "Reward Status".localized()
            
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        if section == 0 {
            return 3
        } else {
            return 5
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 1 {
            return "RECENT ACTIVITY".localized()
        }
        
        return nil
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 1 {
            
            let header = tableView.dequeueReusableCell(withIdentifier: "RecentActivityHeader") as! RecentActivityHeader
            header.delegate = self
            // set text
            header.titleLabel.text = "RECENT ACTIVITY".localized()
            header.filterButton.setTitle("Filter".localized(), for: .normal)
            
            return header
        }
        
        return nil
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.1
        } else {
            return 50
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "RedeemPointsTotalCell") as! RedeemPointsTotalCell
                cell.delegate = self
                // button style
                AppHelper.setRoundCornersToView(borderColor: APP_ORANGE_COLOR, view: cell.redeemPointsButton, radius: 2.0, width: 1.0)
                // set text
                cell.currentPointTotalTitleLabel.text = "Current Point Total".localized()
                cell.lifetimePointsEarnedTitleLabel.text = "Lifetime Points Earned:".localized()
                cell.redeemPointsButton.setTitle("REDEEM POINTS NOW".localized(), for: .normal)
                // set values
                
                return cell
            } else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "BlankCell")
                return cell!
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "RewardDetailCell") as! RewardDetailCell
                // set text
                cell.titleLabel.text = "Unused Health Care Rebates".localized()
                
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RewardRecentActivityCell") as! RewardRecentActivityCell
            return cell
        }
        
    }
    

}

extension RewardStatusTVC: RecentActivityHeaderDelegate {
    
    func handleFilter() {
        self.performSegue(withIdentifier: "RewardFilterTVC", sender: self)
    }
}

extension RewardStatusTVC: RedeemPointsTotalDelegate {
    
    func handleRedeemPoints() {
        self.performSegue(withIdentifier: "RedeemPointsTVC", sender: self)
    }
}

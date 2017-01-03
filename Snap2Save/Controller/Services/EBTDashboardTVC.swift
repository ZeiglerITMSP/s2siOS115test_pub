//
//  EBTDashboardTVC.swift
//  Snap2Save
//
//  Created by Appit on 1/2/17.
//  Copyright © 2017 Appit. All rights reserved.
//

import UIKit

class EBTDashboardTVC: UITableViewController {

    
    struct Transaction {
        
        var company:String
        var amount:String
        var date:String
    }
    
    
    // Properties
    let accountDetailTitles = ["EBT BALANCE", "CASH BALANCE", "Next Deposit", "Next Deposit On"]
    
    var recentTransactions: [Transaction]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Back Action
        self.navigationItem.addBackButton(withTarge: self, action: #selector(backAction))
        
        // Automatic height
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44
        
       // ebtWebView.responder = self
        
        populateData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: -
    
    func populateData() {
        
        
        recentTransactions = [Transaction]()
        
        let transaction = Transaction(company: Lorem.name, amount: Lorem.decimalNumber(lLenght: 3, rLenght: 2), date: Lorem.dateString())
        
        recentTransactions?.append(transaction)
        recentTransactions?.append(transaction)
        recentTransactions?.append(transaction)
        recentTransactions?.append(transaction)
        recentTransactions?.append(transaction)
        
        
        self.tableView.reloadData()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        if (recentTransactions != nil) && (recentTransactions!.count > 0) {
            return 2
        }
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            
            return accountDetailTitles.count
            
        } else if section == 1 {
            
            return (recentTransactions?.count)!
        }
        
        return 0
    }

    // MARK: - Table view
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let detailedCell = tableView.dequeueReusableCell(withIdentifier: "DetailedCell", for: indexPath) as! DetailedCell
            
            detailedCell.titleLabel.text = accountDetailTitles[indexPath.row]
            
            return detailedCell
            
        } else if indexPath.section == 1 {
            
            let detailedSubtitleCell = tableView.dequeueReusableCell(withIdentifier: "DetailedSubtitleCell", for: indexPath) as! DetailedSubtitleCell
            
            let transaction = recentTransactions![indexPath.row]
            
            detailedSubtitleCell.titleLabel.text = transaction.company
            detailedSubtitleCell.detailLabel.text = transaction.amount
            detailedSubtitleCell.subtitleLabel.text = transaction.date
            
            
            return detailedSubtitleCell
        } else {
            
            return UITableViewCell()
        }
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 1 {
            return "RECENT TRANSACTIONS".localized()
        }
        
        return nil
    }
    

    // MARK: -
    
    func backAction() {
        
        showAlert(title: "Are you sure ?", message: "The process will be cancelled.", action: #selector(cancelProcess))
    }
    
    func cancelProcess() {
        
        // Define identifier
        let notificationName = Notification.Name("POPTOLOGIN")
        // Post notification
        NotificationCenter.default.post(name: notificationName, object: nil)
    }
    

}

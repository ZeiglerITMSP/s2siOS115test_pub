//
//  EBTDashboardTVC.swift
//  Snap2Save
//
//  Created by Appit on 1/2/17.
//  Copyright © 2017 Appit. All rights reserved.
//

import UIKit
import SwiftyJSON

class EBTDashboardTVC: UITableViewController {

    
    struct Transaction {
        
        var company:String
        var amount:String
        var date:String
    }

    
    fileprivate enum ActionType {
        
        case accountDetails
        case transactions
        case tabClick
    }
    
    // Properties
    let ebtWebView: EBTWebView = EBTWebView.shared
    fileprivate var actionType: ActionType?
    
//    var accountDetailTitles = ["Account Type", "Account Status", "Available Balance"]
    var accountDetails = [[String:String?]]()
    var recentTransactions: [Transaction]?
    
    var accountType: String?
    var accountStatus: String?
    var availableBalance: String?
    var trasactions = [Any]()
    
    @IBOutlet weak var loaderView: UIView!
    
    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()

        AppHelper.configSwiftLoader()
        
        // Back Action
        self.navigationItem.addBackButton(withTarge: self, action: #selector(backAction))
        
        // Automatic height
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44
        
        ebtWebView.responder = self
        
        validatePage()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        ebtWebView.responder = self
        
        let webView = ebtWebView.webView!
        self.view.addSubview(webView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: -
    
    
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        let sections = accountDetails.count + trasactions.count
        
        if sections == 0 {
            SwiftLoader.show(title: "Loading...", animated: true)
//            loaderView.isHidden = false
        } else {
            SwiftLoader.hide()
//            loaderView.isHidden = true
        }
        
        return sections
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            
            if accountDetails.count == 0 {
                return 1
            }
            
            return accountDetails.count
        } else if section == 1 {
            return trasactions.count
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
                
                let detail = accountDetails[indexPath.row]
                
                let value = detail["value"]
                detailedCell.titleLabel.text = detail["title"]!
                detailedCell.detailLabel.text = value ?? ""
                
                return detailedCell
                
            } else if indexPath.section == 1 {
                
                let detailedSubtitleCell = tableView.dequeueReusableCell(withIdentifier: "DetailedSubtitleCell", for: indexPath) as! DetailedSubtitleCell
                
                let record = trasactions[indexPath.row] as? [String:String]
                
                detailedSubtitleCell.titleLabel.text = record?["location"]
                detailedSubtitleCell.detailLabel.text = record?["debit_amount"]
                detailedSubtitleCell.subtitleLabel.text = record?["date"]
                
                
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
        
//        self.navigationController?.popViewController(animated: true)
        showAlert(title: "Are you sure ?", message: "The process will be cancelled.", action: #selector(cancelProcess))
    }
    
    func cancelProcess() {
        
        _ = self.navigationController?.popToRootViewController(animated: true)
        
//        // Define identifier
//        let notificationName = Notification.Name("POPTOLOGIN")
//        // Post notification
//        NotificationCenter.default.post(name: notificationName, object: nil)
    }
    
    // JavaScript
    
    func validatePage() {
        
        ebtWebView.getPageTitle(completion: { pageTitle in
            
            if pageTitle == "Account Summary" {
                
                self.getAccountDetails()
                
            } else {
                
            }
        })
        
    }
    
    func getAccountDetails() {
        
//        let jsAccountTypeText = "$('.widgetLabel:eq(0)').text()"
//        let jsAccountStatusText = "$('.widgetLabel:eq(1)').text()"
//        let jsAvailableBalanceText = "$('.widgetLabel:eq(2)').text()"
        
//        let jsAccountTypeValue = "$('.widgetValue:eq(0)').text()"
//        let jsAccountStatusValue = "$('.widgetValue:eq(1)').text()"
//        let jsAvailableBalanceValue = "$('.widgetValue:eq(2)').text()"

        let jsEBTBalance = "$($(\"td.widgetValue:contains('SNAP')\").parent().parent().find('td.widgetValue')[2]).html().trim()"
        let jsCashBalance = "$($(\"td.widgetValue:contains('CASH')\").parent().parent().find('td.widgetValue')[2]).html().trim()"
        
        execute(javaScript: jsEBTBalance, completion: { result in
            
            let detail = ["title" : "EBT Balance".localized(), "value": result]
            self.accountDetails.append(detail)
            
            self.execute(javaScript: jsCashBalance, completion: { result in
                
                let detail = ["title" : "CASH Balance".localized() , "value": result]
                self.accountDetails.append(detail)
                
                self.perform(#selector(self.getTransactionActivityUlr), with: self, afterDelay: 3)
//                self.getTransactionActivityUlr()
            })
        })
    }
 
    
    func execute(javaScript:String, completion: @escaping (String?) -> ()) {
        
        ebtWebView.webView.evaluateJavaScript(javaScript) { (result, error) in
            if error != nil {
                print(error ?? "error nil")
                
                completion(nil)
                
            } else {
                
                print(result ?? "result nil")
                let resultString = result as! String
                let resultTrimmed = resultString.trimmingCharacters(in: .whitespacesAndNewlines)
                
                completion(resultTrimmed)
            }
        }
    }
    
    // Transaction History
    
    func getTransactionActivityUlr() {
        
        let js = "$('.green_bullet:eq(1) a').attr('href');"
        
        ebtWebView.webView.evaluateJavaScript(js) { (result, error) in
            if error != nil {
                print(error ?? "error nil")
            } else {
                print(result ?? "result nil")
                let stringResult = result as! String
                let trimmedText = stringResult.trimmingCharacters(in: .whitespacesAndNewlines)
                print(trimmedText)
                
                if trimmedText.characters.count > 0 {
                    
                    self.loadTransactionActivityPage(url: trimmedText)
                    
                } else {
                    
                    
                }
            }
        }
    }

    
    func loadTransactionActivityPage(url:String) {
        
        actionType = .transactions
        
        let js = "window.location.href = '\(url)';"
        
        ebtWebView.webView.evaluateJavaScript(js) { (result, error) in
            
            print(error ?? "error nil")
            print(result ?? "result nil")
        }
    }

    func validateTransactionPage() {
        
        ebtWebView.getPageTitle(completion: { pageTitle in
            
            if pageTitle == "Transaction Activity" {
                
                self.validateTransactionsTab()
                
            } else {
                
            }
        })
        
    }
    
    
    func validateTransactionsTab() {
        
        let jsLoginValidation = "$('#transActTabs li.ui-state-active').attr('id');"
        let javaScript = jsLoginValidation
        
        ebtWebView.webView.evaluateJavaScript(javaScript) { (result, error) in
            
            if let resultString = result as? String {
                
                let resultTrimmed = resultString.trimmingCharacters(in: .whitespacesAndNewlines)
                
                if resultTrimmed == "allactTab" {
                    
                    self.getTransactions()
                } else {
                    self.clickTransactionsTab()
                }
            } else {
                print(error ?? "")
            }
        }
    }
    
    
    func clickTransactionsTab() {
        
        actionType = ActionType.tabClick
        
        let jsTabClick = "$('#allactTab a').click();"
        let javaScript = jsTabClick
        
        ebtWebView.webView.evaluateJavaScript(javaScript) { (result, error) in
            
            if let resultString = result as? String {
                
                let resultTrimmed = resultString.trimmingCharacters(in: .whitespacesAndNewlines)
                
                if resultTrimmed == "allactTab" {
                    
                    self.getTransactions()
                } else {
                    
                }
            } else {
                print(error ?? "")
            }
        }
    }
    
    func validateTabClick() {
        
        let jsLoginValidation = "$('#transActTabs li.ui-state-active').attr('id');"
        let javaScript = jsLoginValidation
        
        ebtWebView.webView.evaluateJavaScript(javaScript) { (result, error) in
            
            if let resultString = result as? String {
                
                let resultTrimmed = resultString.trimmingCharacters(in: .whitespacesAndNewlines)
                
                if resultTrimmed == "allactTab" {
                    
                    self.getTransactions()
                } else {
                    
                }
            } else {
                print(error ?? "")
            }
        }
    }
    


    func getTransactions() {
        
        let js = "function transactionActivity() {" +
                    "var list = [];" +
                    "var table = $('#allCompletedTxnGrid tbody');" +
                    "table.find('tr').each(function (i) {" +
                    "var $tds = $(this).find('td')," +
                    "t_date = $tds.eq(2).text();" +
                    "if (t_date) {" +
                        "list[i] = {" +
                        "date: t_date," +
                        "transaction: $tds.eq(3).text()," +
                        "location: $tds.eq(4).text()," +
                        "account: $tds.eq(5).text()," +
                        "card: $tds.eq(6).text()," +
                        "debit_amount: $tds.eq(7).text()," +
                        "credit_amount: $tds.eq(8).text()," +
                        "available_balance: $tds.eq(9).text()" +
                        "};" +
                    "}" +
                "});" +
                "arr = $.grep(list, function (n) {" +
                "return n == 0 || n" +
            "});" +
            "var jsonSerialized = JSON.stringify(arr);" +
            "return jsonSerialized;" +
        "}" +
        "transactionActivity();"
        
        
        ebtWebView.webView.evaluateJavaScript(js) { (result, error) in
            if error != nil {
                print(error ?? "error nil")
            } else {
                print(result ?? "result nil")
                let stringResult = result as! String
                let trimmedText = stringResult.trimmingCharacters(in: .whitespacesAndNewlines)
                print(trimmedText)
                
                if trimmedText.characters.count > 0 {
                    
                    let json = JSON.parse(trimmedText)
                    print("json response\(json)")
                    
                    if let responseArray = json.arrayObject {

                        print(responseArray)
                        
                        self.trasactions =  responseArray
                        
                        self.tableView.reloadData()
                        
                        
                        /*
                         account = SNAP;
                         "available_balance" = "$ 312.30";
                         card = 0339;
                         "credit_amount" = "$ 0.00";
                         date = "12/10/2016";
                         "debit_amount" = "$ 89.62";
                         location = "WM SUPERCEWal-Mart Super CenterAURORACO";
                         transaction = "POS Purchase Debit";
 */
                        
                    }
                   // self.loadTransactionActivityPage(url: trimmedText)
                    
                } else {
                    
                    self.tableView.reloadData()
                }
            }
        }
        
    }

}

extension EBTDashboardTVC: EBTWebViewDelegate {
    
    
    func didFinishLoadingWebView() {
        
        if actionType == .transactions {
            
            actionType = nil
            validateTransactionPage()
            
            
        } else if actionType == .tabClick {
            
            actionType = nil
            validateTabClick()
        }
   
    }
    
}


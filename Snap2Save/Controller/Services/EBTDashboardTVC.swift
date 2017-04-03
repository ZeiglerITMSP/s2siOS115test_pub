//
//  EBTDashboardTVC.swift
//  Snap2Save
//
//  Created by Appit on 1/2/17.
//  Copyright © 2017 Appit. All rights reserved.
//

import UIKit
import Localize_Swift
import SwiftyJSON
import Alamofire

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
    var ebtWebView: EBTWebView = EBTWebView.shared
    fileprivate var actionType: ActionType?
    
    var accountDetails = [[String:String?]]()
    var recentTransactions: [Transaction]?
    
    var accountType: String?
    var accountStatus: String?
    var availableBalance: String?
    var trasactions = [Any]()
    
    var ebtBalance: String?
    var cashBalance: String?
    var transactionsString: String?
    // timer
    var startTime: Date!
    // load more
//    var isLoadingMoreActivity:Bool = false
//    var hasMoreActivity:Bool = true
    
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
        
        // Load more
//        self.tableView.toLoadMore {
//            
//            if self.trasactions.count > 0 {
//                if (!self.isLoadingMoreActivity && self.hasMoreActivity) {
//                    self.isLoadingMoreActivity = true
//                    self.goToNextPage()
//                }
//            }
//        }
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        ebtWebView.responder = self
        
        let webView = ebtWebView.webView!
        self.view.addSubview(webView)
        self.view.sendSubview(toBack: webView)
        webView.isHidden = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: -
    
    
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        var sections = 0
        
        if accountDetails.count > 0 {
            sections += 1
        }
        if trasactions.count > 0 {
            sections += 1
        }
        
        // loader
        if sections == 0 {
            SwiftLoader.show(title: "Loading...".localized(), animated: true)
        } else {
            SwiftLoader.hide()
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
            detailedSubtitleCell.detailLabel2.text = record?["credit_amount"]
            detailedSubtitleCell.subtitleLabel.text = record?["date"]
            detailedSubtitleCell.subtitleTwoLabel.text = record?["account"]
            
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
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.1
        } else {
            return 40
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    // MARK: -
    
    func backAction() {
        
        _ = self.navigationController?.popToRootViewController(animated: true)
        //        self.navigationController?.popViewController(animated: true)
        //  showAlert(title: "Are you sure ?".localized(), message: "The process will be cancelled.".localized(), action: #selector(cancelProcess))
    }
    
    func cancelProcess() {
        
        //        ebtWebView = nil
        _ = self.navigationController?.popToRootViewController(animated: true)
        
        //        // Define identifier
        //        let notificationName = Notification.Name("POPTOLOGIN")
        //        // Post notification
        //        NotificationCenter.default.post(name: notificationName, object: nil)
    }
    
    // JavaScript
    
    func validatePage() {
        
        ebtWebView.getPageHeading(completion: { pageTitle in
            
            if pageTitle == "ebt.accountSummary".localized() {
                
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
        
        let jsEBTBalance = "$($(\"td.widgetValue:contains('SNAP')\").parent().parent().find('td.widgetValue')[2]).html().trim();"
        let jsCashBalance = "$($(\"td.widgetValue:contains('CASH')\").parent().parent().find('td.widgetValue')[2]).html().trim();"
        
        execute(javaScript: jsEBTBalance, completion: { result in
            
            let detail = ["title" : "SNAP Balance".localized(), "value": result]
            self.accountDetails.append(detail)
            self.ebtBalance = result
            
            self.execute(javaScript: jsCashBalance, completion: { result in
                
                let detail = ["title" : "CASH Balance".localized() , "value": result]
                self.accountDetails.append(detail)
                self.cashBalance = result
                self.getTransactionActivityUlr()
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
        
        ebtWebView.getPageHeading(completion: { pageTitle in
            
            if pageTitle == "ebt.transactionActivity".localized() {
                
                self.validateTransactionsTab()
            } else {
                print("END WITH DATA")
                self.tableView.reloadData()
                self.sendEBTInformationToServer()
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
                                      //  self.perform(#selector(self.transactionsHistoryStartEndDates), with: self, afterDelay: 10)
                    self.startStartEndDatesTimer()
                    // load 90 days transactions
                   // self.transactionsHistoryStartEndDates()
//                    self.getTransactions()
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
                    self.startStartEndDatesTimer()
                                       // self.perform(#selector(self.transactionsHistoryStartEndDates), with: self, afterDelay: 10)
                    // load 90 days transactions
                   // self.transactionsHistoryStartEndDates()
//                    self.getTransactions()
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
                    
                                       // self.perform(#selector(self.transactionsHistoryStartEndDates), with: self, afterDelay: 10)
                    self.startStartEndDatesTimer()
//                    self.actionType = ActionType.tranasctionsWithDates
//                    self.transactionsHistoryStartEndDates()
//                    self.getTransactions()
                } else {
                    
                }
            } else {
                print(error ?? "")
            }
        }
    }
    
    func startStartEndDatesTimer() {
        // On first time setStartTime
        if startTime == nil {
            startTime = Date()
        }
        // every time calcuate elapsed time
        let elapsed = Date().timeIntervalSince(startTime)
        // if elapsed time is not yet reached to 30 seconds, start timer to check transactions after 2 seconds, if elapsed time is reached to 30 seconds, so there is not need to check tranasctions - End
        if elapsed < 30 {
            let _ = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(checkForStartEndDateFields), userInfo: nil, repeats: false)
        } else {
            print("END")
            startTime = nil
            
            self.tableView.reloadData()
            self.sendEBTInformationToServer()
        }
        
    }

    func checkForStartEndDateFields() {
        
        let jsIsLastPage = "$('#fromDateTransHistory').attr('id');"
        ebtWebView.webView.evaluateJavaScript(jsIsLastPage) { (result, error) in
            print(result ?? "no result")
            if (result as? String) != nil {
                self.transactionsHistoryStartEndDates()
            } else {
                self.startStartEndDatesTimer()
            }
        }
        
    }
    
    func transactionsHistoryStartEndDates() {
        
        startTime = nil
        
        let jsTransactionDates = "var formatD = function(d){" +
          "  var dd = d.getDate()," +
          "  dm = d.getMonth()+1," +
          "  dy = d.getFullYear();" +
          "  if (dd<10) dd='0'+dd;" +
          "  if (dm<10) dm='0'+dm;" +
         "   return dm+'/'+dd+'/'+dy;" +
        "};" +
        "var endDate = new Date(), startDate = new Date(endDate.valueOf());" +
        "startDate.setDate(endDate.getDate()-90);" +
        "$('#fromDateTransHistory').val(formatD(startDate));" +
        "$('#toDateTransHistory').val(formatD(endDate));" +
        "$('#searchAll').click()"
        
        let javaScript = jsTransactionDates
        
        ebtWebView.webView.evaluateJavaScript(javaScript) { (result, error) in
            print(result ?? "")
            print(error ?? "")
           self.perform(#selector(self.getTransactions), with: self, afterDelay: 8)
        }
    }
    
    
    /// get startTime, on every time this method is called, it will checks for elapsed time, if 30 seconds reached, end. else check transactions after 2 seconds.
    func getTransactions() {
        // On first time setStartTime
        if startTime == nil {
            startTime = Date()
        }
        // every time calcuate elapsed time
        let elapsed = Date().timeIntervalSince(startTime)
        // if elapsed time is not yet reached to 30 seconds, start timer to check transactions after 2 seconds, if elapsed time is reached to 30 seconds, so there is not need to check tranasctions - End
        if elapsed < 30 {
            print("FIRE")
            let _ = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(runTransactionsScript), userInfo: nil, repeats: false)
            //            timer.fire()
        } else {
            print("END")
            startTime = nil
            
            self.tableView.reloadData()
            self.sendEBTInformationToServer()
        }
        
    }
    
    
    func runTransactionsScript() {
        
        let js = "function transactionActivity() {" +
            "var list = [];" +
            "var table = $('#allCompletedTxnGrid tbody');" +
            "table.find('tr').each(function (i) {" +
            "var $tds = $(this).find('td')," +
            "t_date = $tds.eq(2).text().trim();" +
            "if (t_date) {" +
            "list[i] = {" +
            "date: t_date," +
            "transaction: $tds.eq(3).text().trim()," +
            "location: $tds.eq(4).text().trim()," +
            "account: $tds.eq(5).text().trim()," +
            "card: $tds.eq(6).text().trim()," +
            "debit_amount: $tds.eq(7).text().trim()," +
            "credit_amount: $tds.eq(8).text().trim()," +
            "available_balance: $tds.eq(9).text().trim()" +
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
                print("trimmedText:")
                print(trimmedText)
                
                if trimmedText.characters.count > 0 {
                    self.transactionsString = trimmedText
                    
                    let json = JSON.parse(trimmedText)
                    print("json response \(json)")
                    
                    if let responseArray = json.arrayObject {
                        
                        if responseArray.count == 0 {
                            self.getTransactions()
                        } else {
                            self.trasactions.append(contentsOf: responseArray)
                          //  self.tableView.reloadData()
                            
                            // stop load more
//                            DispatchQueue.main.async {
//                                self.tableView.doneRefresh()
//                            }
                          //  self.isLoadingMoreActivity = false
                            
                            // next button click
                            
                            self.goToNextPage()
                            // only get 90 transactions.
//                            if self.trasactions.count < 90 {
//
//                            } else {
//                                self.sendEBTInformationToServer()
//                            }
                            
                            
                            
                        }
                    }
                    
                } else {
                    
                    self.getTransactions()
                    //                        self.tableView.reloadData()
                    //                        self.sendEBTInformationToServer()
                }
            }
        }
        
    }
    
    
    func goToNextPage() {
        
        // check if next page exists, and go to next page
        let jsIsLastPage = "$('#next_allCompletedTxnGrid_pager.ui-state-disabled').attr('id');"
        ebtWebView.webView.evaluateJavaScript(jsIsLastPage) { (result, error) in
            print(result ?? "no result")
            if (result as? String) != nil {
                // next_allCompletedTxnGrid_pager
                print("LAST PAGE")
                self.tableView.reloadData()
//                self.hasMoreActivity = false
//                self.tableView.endLoadMore()
                // send all transactions to server
                self.sendEBTInformationToServer()
            } else { // click next page
                let jsNextPageClick = "$('#next_allCompletedTxnGrid_pager > a').click();"
                let javaScript = jsNextPageClick
                
                self.ebtWebView.webView.evaluateJavaScript(javaScript) { (result, error) in
                     self.getTransactions()
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

extension EBTDashboardTVC {
    // MAKR: Web Service
    
    func sendEBTInformationToServer() {
        
        // Reachability
        let reachbility:NetworkReachabilityManager = NetworkReachabilityManager()!
        let isReachable = reachbility.isReachable
        if isReachable == false {
            return
        }
        
        let version_name = Bundle.main.releaseVersionNumber ?? ""
        let version_code = Bundle.main.buildVersionNumber ?? ""
        
        let currentLanguage = Localize.currentLanguage()
        let device_id = UIDevice.current.identifierForVendor!.uuidString
        let user_id  = UserDefaults.standard.object(forKey: USER_ID) ?? ""
        let auth_token : String = UserDefaults.standard.object(forKey: AUTH_TOKEN) as! String
        
        let ebt_user_id = EBTUser.shared.userID ?? ""
        let type = EBTUser.shared.loggedType
        let transactions = transactionsString ?? ""
        let ebt_balance = ebtBalance ?? ""
        let cash_balance = cashBalance ?? ""
        
        let parameters : Parameters = ["platform":"1",
                                       "version_code": version_code,
                                       "version_name": version_name,
                                       
                                       "language": currentLanguage,
                                       "auth_token": auth_token,
                                       "device_id": device_id,
                                       
                                       "user_id": user_id,
                                       "ebt_user_id": ebt_user_id,
                                       "type": type,
                                       
                                       "transactions": transactions,
                                       "ebt_balance": ebt_balance,
                                       "cash_balance": cash_balance
        ]
        
        print(parameters)
        let url = String(format: "%@/saveEbtInfo", hostUrl)
        print(url)
        Alamofire.postRequest(URL(string:url)!, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response:DataResponse<Any>) in
            switch response.result {
                
            case .success:
                DispatchQueue.main.async {
                    
                    let json = JSON(data: response.data!)
                    print("json response\(json)")
                    let responseDict = json.dictionaryObject
                    
                    if let code = responseDict?["code"] {
                        let code = code as! NSNumber
                        if code.intValue == 200 {
                            
                        } else {
                            
                        }
                    }
                }
                break
                
            case .failure(let error):
                print(error)
                break
            }
            
        }
    }
    
}


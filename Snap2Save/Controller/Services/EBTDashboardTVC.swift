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
import SwiftyJSON

var isViewingDashboard = false

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
    
    let snapBalanceKey = "snapBalance"
    let cashBalanceKey = "cashBalance"
    var accountDetails = [[String:String?]]() {
        didSet {
            accountDetails = accountDetails.reversed()
        }
    }
    var recentTransactions: [Transaction]?
    
    var accountType: String?
    var accountStatus: String?
    var availableBalance: String?
    var trasactions = [Any]()
    
    let adSpotManager = AdSpotsManager()
    //    var transactionsString: String = ""
    // timer
    var startTime: Date!
    
    // test
    var pageNumber: Int = 1 // 0 for internal build, 1 for live
    
    // load more
    var isTransactionsLoading = false
    var accoutDetailsLoaded = false
    
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
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.register(UINib(nibName: "AdSpotTableViewCell", bundle: nil), forCellReuseIdentifier: "AdSpotTableViewCell")
        
        adSpotManager.delegate = self
        
        ebtWebView.responder = self
        
        actionType = ActionType.accountDetails
        loadDataIntoTable()
        
        self.isTransactionsLoading = false
        self.accoutDetailsLoaded = true
        self.tableView.reloadData()
        self.sendEBTInformationToServer()
        
        SwiftLoader.hide()
        
        adSpotManager.getAdSpots(forScreen: .ebtBalance)
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        ebtWebView.responder = self
        
        let webView = ebtWebView.webView!
        self.view.addSubview(webView)
        self.view.sendSubview(toBack: webView)
        webView.isHidden = true
        
        isViewingDashboard = true

    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        isViewingDashboard = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: -
    
    @objc func backAction() {
        
        //    _ = self.navigationController?.popToRootViewController(animated: true)
        showAlert(title: "ebt.processTerminate.title".localized(),
                  message: "ebt.processTerminate.dashboard".localized(), action: #selector(cancelProcess))
    }
    
    @objc func cancelProcess() {
        
        //        ebtWebView = nil
        
        // ebtWebView.loadEmptyPage()
        _ = self.navigationController?.popToRootViewController(animated: true)
        
        //        // Define identifier
        //        let notificationName = Notification.Name("POPTOLOGIN")
        //        // Post notification
        //        NotificationCenter.default.post(name: notificationName, object: nil)
    }
    
    func showForceQuitAlert() {
        
        self.showAlert(title: "", message: "ebt.alert.timeout.message".localized(), action: #selector(self.cancelProcess), showCancel: false)
        EBTUser.shared.isForceQuit = true
    }
    
    func exitProcessIfPossible() {
        
        if self.ebtWebView.isPageLoading == false {
            self.showForceQuitAlert()
        }
    }
    
}

// MARK: - Table view data source, delegate
extension EBTDashboardTVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
//        var sections = 0
//        
//        if accountDetails.count > 0 {
//            sections += 1
//        }
//        if trasactions.count > 0 || isTransactionsLoading == true {
//            sections += 1
//        }
//        
//        // loader
//        if sections == 0 {
//            SwiftLoader.show(title: "Loading...".localized(), animated: true)
//        } else {
//            SwiftLoader.hide()
//        }
//        
//        return sections
        
        
        if accoutDetailsLoaded == false {
            SwiftLoader.show(title: "Loading...".localized(), animated: true)
        } else {
            SwiftLoader.hide()
        }
        
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 1 {
            return adSpotManager.adSpots.count
        } else if section == 0 {
            return accountDetails.count
        } else if section == 2 {
            
            var transactionsCount = trasactions.count
            
            if isTransactionsLoading {
                transactionsCount += 1
            }
            
            return transactionsCount
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 1 {
            
            let spot = adSpotManager.adSpots[indexPath.row]
            let type = spot["type"]
            if let adImage = adSpotManager.adSpotImages["\(type!)"] {
                if adImage.size.width > self.view.frame.width {
                    let height = AppHelper.getRatio(width: adImage.size.width,
                                                    height: adImage.size.height,
                                                    newWidth: self.view.frame.width)
                    
                    return height
                }
            }
            
            return UITableViewAutomaticDimension
        }
        
        return UITableViewAutomaticDimension
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 1 {
            let adSpotTableViewCell = tableView.dequeueReusableCell(withIdentifier: "AdSpotTableViewCell") as! AdSpotTableViewCell
            
            let spot = adSpotManager.adSpots[indexPath.row]
            let type = spot["type"]
            let image = adSpotManager.adSpotImages["\(type!)"]
            adSpotTableViewCell.adImageView.image = image
            
            return adSpotTableViewCell

        } else if indexPath.section == 0 {
            
            let detailedCell = tableView.dequeueReusableCell(withIdentifier: "DetailedCell", for: indexPath) as! DetailedCell
            
            let detail = accountDetails[indexPath.row]
            
            let value = detail["value"]
            detailedCell.titleLabel.text = detail["title"]!
            detailedCell.detailLabel.text = value ?? ""
            
            return detailedCell
            
        } else if indexPath.section == 2 {
            
            if indexPath.row < trasactions.count {
                
                let detailedSubtitleCell = tableView.dequeueReusableCell(withIdentifier: "DetailedSubtitleCell", for: indexPath) as! DetailedSubtitleCell
                
                let record = trasactions[indexPath.row] as? [String:String]
                detailedSubtitleCell.titleLabel.text = record?["transaction_type"]
                detailedSubtitleCell.subtitleLabel.text = record?["date"]

                var account_type = ""
                if (record?["account_type"] ?? "Cash") == "Cash" {
                    account_type = "ebt.cash"
                } else if (record?["account_type"] ?? "Cash") == "Food" {
                    account_type = "ebt.snap"
                }
                detailedSubtitleCell.subtitleTwoLabel.text = account_type.localized().uppercased()
                
                // amount
                let debit_amount = record?["deposit_amount"]
                let credit_amount = record?["completion_amount"]
                if credit_amount?.containNumbers1To9() == true {
                    detailedSubtitleCell.detailLabel.text = credit_amount?.replacingOccurrences(of: "-", with: "")
                    detailedSubtitleCell.detailLabel.textColor = UIColor.black
                } else {
                    detailedSubtitleCell.detailLabel.text = debit_amount
                    detailedSubtitleCell.detailLabel.textColor = APP_GRREN_COLOR
                }
                
                return detailedSubtitleCell
            } else {
                let loaderCell = tableView.dequeueReusableCell(withIdentifier: "LoadMoreActivityTVC") as! LoadMoreActivityTVC
                loaderCell.startAnimiatingActivit()
                return loaderCell
            }
            
        } else {
            
            return UITableViewCell()
        }
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 2 {
            return "RECENT TRANSACTIONS".localized()
        }
        
        return nil
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 || section == 1 {
            return 0.1
        } else {
            return 40
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1 {
            adSpotManager.showAdSpotDetails(spot: adSpotManager.adSpots[indexPath.row], inController: self)
        }
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
}


// MARK: - JavaScript
extension EBTDashboardTVC {
    
    func loadDataIntoTable() {
        trasactions = EBTData.shared.transactionsArray

        for key in EBTData.shared.accountBalancesObject.keys {
            if key.contains("cash") {
                accountDetails.append(["title" : "CASH Balance".localized(), "value": EBTData.shared.accountBalancesObject[key]!, "key": self.cashBalanceKey])
            } else if key.contains("food") {
                accountDetails.append(["title" : "SNAP Balance".localized(), "value": EBTData.shared.accountBalancesObject[key]!, "key": self.snapBalanceKey])
            }
        }
    }
    
    func validatePage() {
        
        ebtWebView.getPageHeading(completion: { pageTitle in
            
            if pageTitle == "ebt.accountSummary".localized() {
                if self.actionType == ActionType.accountDetails {
                    self.getAccountDetails()
                }
            } else {
                
                self.validateTransactionPage()
                
                //                if actionType == .transactions {
                //                    actionType = nil
                //                    validateTransactionPage()
                //                } else if actionType == .tabClick {
                //                    actionType = nil
                //                    validateTabClick()
                //                }
            }
        })
        
    }
    
    func getAccountDetails() {
        
        let jsEBTBalance = "getSnapBalance();"
        let jsCashBalance = "getCashBalance();"
        
        execute(javaScript: jsEBTBalance, completion: { result in
            
            if result != nil {
                let detail = ["title" : "SNAP Balance".localized(), "value": result, "key": self.snapBalanceKey]
                self.accountDetails.append(detail)
                //                guard let valueString = result?.removeSpecialChars(validCharacters: "0123456789.") else { return
                //                }
                //                let valueInDouble = Double(valueString) ?? 0
                //                if valueInDouble > 0 {
                //                    let detail = ["title" : "SNAP Balance".localized(), "value": result, "key": self.snapBalanceKey]
                //                    self.accountDetails.append(detail)
                //                }
            }
            
            self.execute(javaScript: jsCashBalance, completion: { result in
                if result != nil {
                    let detail = ["title" : "CASH Balance".localized() , "value": result, "key": self.cashBalanceKey]
                    self.accountDetails.append(detail)
                    
                    //                    guard let valueString = result?.removeSpecialChars(validCharacters: "0123456789.") else { return
                    //                    }
                    //                    let valueInDouble = Double(valueString) ?? 0
                    //                    if valueInDouble > 0 {
                    //                        let detail = ["title" : "CASH Balance".localized() , "value": result, "key": self.cashBalanceKey]
                    //                        self.accountDetails.append(detail)
                    //                    }
                }
                self.accoutDetailsLoaded = true
                self.isTransactionsLoading = true
                self.tableView.reloadData()
                self.getTransactionActivityURL()
            })
        })
    }
    
    
    func execute(javaScript:String, completion: @escaping (String?) -> ()) {
        
        ebtWebView.webView.evaluateJavaScript(javaScript) { (result, error) in
            if error != nil {
                //print(error ?? "error nil")
                
                completion(nil)
                
            } else {
                
                //print(result ?? "result nil")
                let resultString = result as! String
                let resultTrimmed = resultString.trimmingCharacters(in: .whitespacesAndNewlines)
                
                completion(resultTrimmed)
            }
        }
    }
    
    // Transaction History
    func getTransactionActivityURL() {
        
        let js = "getTransactionsPageURL();"
        
        ebtWebView.webView.evaluateJavaScript(js) { (result, error) in
            if error != nil {
                //print(error ?? "error nil")
            } else {
                //print(result ?? "result nil")
                let stringResult = result as! String
                let trimmedText = stringResult.trimmingCharacters(in: .whitespacesAndNewlines)
                //print(trimmedText)
                
                if trimmedText.characters.count > 0 {
                    
                    self.loadTransactionActivityPage(url: trimmedText)
                    
                } else {
                    
                    
                }
            }
        }
    }
    
    
    func loadTransactionActivityPage(url:String) {
        
        actionType = .transactions
        let js = "loadTransactionsPage('\(url)');"
        
        ebtWebView.webView.evaluateJavaScript(js) { (result, error) in
            
            //print(error ?? "error nil")
            //print(result ?? "result nil")
        }
    }
    
    func validateTransactionPage() {
        
        ebtWebView.getPageHeading(completion: { pageTitle in
            
            if pageTitle == "ebt.transactionActivity".localized() {
                
                
                if self.actionType == .transactions {
                    self.actionType = nil
                    self.validateTransactionsTab()
                } else if self.actionType == .tabClick {
                    self.actionType = nil
                    self.validateTabClick()
                }
                
            } else {
                //print("END WITH DATA")
                self.isTransactionsLoading = false
                self.tableView.reloadData()
                self.sendEBTInformationToServer()
                
                // check if redirected to loginpage or other page
                self.exitProcessIfPossible()
            }
        })
        
    }
    
    func validateTransactionsTab() {
        
        let jsLoginValidation = "validateTransactionsTab();"
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
                //print(error ?? "")
            }
        }
    }
    
    
    func clickTransactionsTab() {
        
        actionType = ActionType.tabClick
        
        let jsTabClick = "clickTransactionsTab();"
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
               // print(error ?? "")
            }
        }
    }
    
    func validateTabClick() {
        
        let jsLoginValidation = "validateTransactionsTabClick();"
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
                //print(error ?? "")
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
            //print("END")
            startTime = nil
            self.isTransactionsLoading = false
            self.tableView.reloadData()
            self.sendEBTInformationToServer()
        }
    }
    
    @objc func checkForStartEndDateFields() {
        
        let jsIsLastPage = "checkForStartEndDateFields();"
        ebtWebView.webView.evaluateJavaScript(jsIsLastPage) { (result, error) in
            //print(result ?? "no result")
            if (result as? String) != nil {
                self.transactionsHistoryStartEndDates()
            } else {
                self.startStartEndDatesTimer()
            }
        }
        
    }
    
    func transactionsHistoryStartEndDates() {
        
        startTime = nil
        
        //        let jsTransactionDates = "var formatD = function(d){" +
        //          "  var dd = d.getDate()," +
        //          "  dm = d.getMonth()+1," +
        //          "  dy = d.getFullYear();" +
        //          "  if (dd<10) dd='0'+dd;" +
        //          "  if (dm<10) dm='0'+dm;" +
        //         "   return dm+'/'+dd+'/'+dy;" +
        //        "};" +
        //        "var endDate = new Date(), startDate = new Date(endDate.valueOf());" +
        //        "startDate.setDate(endDate.getDate()-90);" +
        //        "$('#fromDateTransHistory').val(formatD(startDate));" +
        //        "$('#toDateTransHistory').val(formatD(endDate));" +
        //        "$('#searchAll').click()"
        
        let javaScript = "setTransactionsHistoryStartEndDates();"
        
        ebtWebView.webView.evaluateJavaScript(javaScript) { (result, error) in
            //print(result ?? "")
            //print(error ?? "")
            self.perform(#selector(self.getTransactions), with: self, afterDelay: 8)
        }
    }
    
    
    /// get startTime, on every time this method is called, it will checks for elapsed time, if 30 seconds reached, end. else check transactions after 2 seconds.
    @objc func getTransactions() {
        // On first time setStartTime
        if startTime == nil {
            startTime = Date()
        }
        // every time calcuate elapsed time
        let elapsed = Date().timeIntervalSince(startTime)
        // if elapsed time is not yet reached to 30 seconds, start timer to check transactions after 2 seconds, if elapsed time is reached to 30 seconds, so there is not need to check tranasctions - End
        if elapsed < 20 {
            
            
            //print("FIRE")
            
            let _ = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.checkPageNumber), userInfo: nil, repeats: false)
            
            //            timer.fire()
        } else {
            //print("END")
            startTime = nil
            
            self.isTransactionsLoading = false
            self.tableView.reloadData()
            self.sendEBTInformationToServer()
        }
        
    }
    
    
    @objc func checkPageNumber() {
        
        let jsPageNumber = "getCurrentPageNumber();"
        ebtWebView.webView.evaluateJavaScript(jsPageNumber, completionHandler: { (result, error) in
            
            if result != nil {
                let resultString = result as! String
                let currentPageNumber = Int(resultString)
                //print(currentPageNumber ?? "-")
                if currentPageNumber == self.pageNumber {
                    
                    self.runTransactionsScript()
                    //                    let _ = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.runTransactionsScript), userInfo: nil, repeats: false)
                } else {
                    self.getTransactions()
                }
            }
            
        })
    }
    
    func runTransactionsScript() {
        
        //        let js = "function transactionActivity() {" +
        //            "var list = [];" +
        //            "var table = $('#allCompletedTxnGrid tbody');" +
        //            "table.find('tr').each(function (i) {" +
        //            "var $tds = $(this).find('td')," +
        //            "t_date = $tds.eq(2).text().trim();" +
        //            "if (t_date) {" +
        //            "list[i] = {" +
        //            "id: this.id," +
        //            "date: t_date," +
        //            "transaction: $tds.eq(3).text().trim()," +
        //            "location: $tds.eq(4).text().trim()," +
        //            "account: $tds.eq(5).text().trim()," +
        //            "card: $tds.eq(6).text().trim()," +
        //            "debit_amount: $tds.eq(7).text().trim()," +
        //            "credit_amount: $tds.eq(8).text().trim()," +
        //            "available_balance: $tds.eq(9).text().trim()" +
        //            "};" +
        //            "}" +
        //            "});" +
        //            "arr = $.grep(list, function (n) {" +
        //            "return n == 0 || n" +
        //            "});" +
        //            "var jsonSerialized = JSON.stringify(arr);" +
        //            "return jsonSerialized;" +
        //            "}" +
        //        "transactionActivity();"
        
        let js = "getTransactions();"
        
        ebtWebView.webView.evaluateJavaScript(js) { (result, error) in
            if error != nil {
                //print(error ?? "error nil")
            } else {
                let stringResult = result as! String
                let trimmedText = stringResult.trimmingCharacters(in: .whitespacesAndNewlines)
                
                if trimmedText.characters.count > 0 {
                    // self.transactionsString.append(trimmedText)
                    
                    let json = JSON.parse(trimmedText)
                    //print("json response \(json)")
                    if let responseArray = json.arrayObject {
                        if responseArray.count == 0 {
                            self.getTransactions()
                        } else {
                            let status = self.validateNewTransactions(responseArray: responseArray)
                            if status {
                                self.appendTransactions(responseArray: responseArray)
                            } else {
                                // repeated transactions
                                self.isTransactionsLoading = false
                                self.tableView.reloadData()
                                self.sendEBTInformationToServer()
                            }
                        }
                    }
                } else {
                    self.getTransactions()
                }
            }
        }
        
    }
    
    
    func validateNewTransactions(responseArray: [Any]) -> Bool {
        
        if trasactions.count > 0 {
            // check transaction dates
            let dateFormat = "mm/dd/yyyy"
            // get last transaction date
            let lastTransaction = self.trasactions.last as! [String:Any]
            let lastDateString = lastTransaction["date"] as! String
            let lastDate = AppHelper.getDate(fromString: lastDateString, withFormat: dateFormat)!
            // get new transaction date
            let newTransaction = responseArray.first as! [String:Any]
            let newDateString = newTransaction["date"] as! String
            let newDate = AppHelper.getDate(fromString: newDateString, withFormat: dateFormat)!
            // compare dates
            if newDate <= lastDate {    // new transaction date have to be same date of old transaction or past date.
                return true
            }
        } else {
            return true
        }
        
        return false
    }
    
    func appendTransactions(responseArray: [Any]) {
        // get last indexPath
        let lastRow = self.trasactions.count
        var newIndexPaths = [IndexPath]()
        for row in 0...responseArray.count - 1 {
            let indexPath = IndexPath(row: lastRow + row, section: 2)
            newIndexPaths.append(indexPath)
        }
        self.trasactions.append(contentsOf: responseArray)
        
        self.startTime = nil
        self.pageNumber += 1 //= self.pageNumber + 1
        
        self.tableView.beginUpdates()
        self.tableView.insertRows(at: newIndexPaths, with: .none)
        self.tableView.endUpdates()
        
        self.goToNextPage()
    }
    
    
    
    func goToNextPage() {
        
        // check if next page exists, and go to next page
        let jsIsLastPage = "isLastPage();"
        ebtWebView.webView.evaluateJavaScript(jsIsLastPage) { (result, error) in
            //print(result ?? "no result")
            if (result as? String) != nil {
                // next_allCompletedTxnGrid_pager
                //print("LAST PAGE")
                self.isTransactionsLoading = false
                self.tableView.reloadData()
                self.sendEBTInformationToServer()
            } else { // click next page
                //print("NEXT PAGE")
                let jsNextPageClick = "gotoNextPage();"
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
        
        validatePage()
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
        
        let paramsJSON = JSON(self.trasactions)
        let paramsString = paramsJSON.rawString(.utf8, options: .prettyPrinted)
        
        let ebtBalanceFiltered = self.accountDetails.filter { (row) -> Bool in
            return row["key"]! == self.snapBalanceKey
        }
        
        let cashBalanceFiltered = self.accountDetails.filter { (row) -> Bool in
            return row["key"]! == self.cashBalanceKey
        }
        
        let ebt_balance = ebtBalanceFiltered.first?["value"] ?? ""
        let cash_balance = cashBalanceFiltered.first?["value"] ?? ""
        
        let parameters : Parameters = ["platform":"1",
                                       "version_code": version_code,
                                       "version_name": version_name,
                                       
                                       "language": currentLanguage,
                                       "auth_token": auth_token,
                                       "device_id": device_id,
                                       
                                       "user_id": user_id,
                                       "ebt_user_id": ebt_user_id,
                                       "type": type,
                                       
                                       "transactions": paramsString,
                                       "ebt_balance": ebt_balance!,
                                       "cash_balance": cash_balance!
        ]
        
        //print(parameters)
        let url = String(format: "%@/saveEbtInfo", hostUrl)
        //print(url)
        Alamofire.postRequest(URL(string:url)!, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response:DataResponse<Any>) in
            switch response.result {
                
            case .success:
                DispatchQueue.main.async {
                    
                    let json = JSON(data: response.data!)
                    //print("json response\(json)")
                    let responseDict = json.dictionaryObject
                    
                    if let code = responseDict?["code"] {
                        let code = code as! NSNumber
                        if code.intValue == 200 {
                            
                        } else {
                            
                        }
                    }
                }
                break
                
            case .failure(let _):
                //print(error)
                break
            }
            
        }
    }
    
}


// MARK: - Ads
extension EBTDashboardTVC: AdSpotsManagerDelegate {
    
    func didFinishLoadingSpots() {
        tableView.reloadSections([1], with: .automatic)
    }
    
    func didFailedLoadingSpots(description: String) {
        
    }
    
}

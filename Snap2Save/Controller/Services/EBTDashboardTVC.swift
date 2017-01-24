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
        
        
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, -60, 0)
        
        //  yourtableviewname.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        ebtWebView.responder = self
        
        let webView = ebtWebView.webView!
        self.view.addSubview(webView)
        webView.sendSubview(toBack: self.view)
        
        
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
            SwiftLoader.show(title: "Loading...".localized(), animated: true)
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
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    // MARK: -
    
    func backAction() {
        
        //        self.navigationController?.popViewController(animated: true)
        showAlert(title: "Are you sure ?".localized(), message: "The process will be cancelled.".localized(), action: #selector(cancelProcess))
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
            self.ebtBalance = result
            
            self.execute(javaScript: jsCashBalance, completion: { result in
                
                let detail = ["title" : "CASH Balance".localized() , "value": result]
                self.accountDetails.append(detail)
                self.cashBalance = result
                
//                self.perform(#selector(self.getTransactionActivityUlr), with: self, afterDelay: 5)
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
        
        print("getTransactionActivityUlr ++++++++++")
        
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
//                    self.perform(#selector(self.getTransactions), with: self, afterDelay: 10)
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
//                    self.perform(#selector(self.getTransactions), with: self, afterDelay: 10)
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
                    
//                    self.perform(#selector(self.getTransactions), with: self, afterDelay: 10)
                    self.getTransactions()
                } else {
                    
                }
            } else {
                print(error ?? "")
            }
        }
    }
    
    func getTransactions() {
        
        let jsTransactionActivity = "function transactionActivity() {" +
        "var list = []; " +
        "var table = $('#allCompletedTxnGrid tbody'); " +
        "table.find('tr').each(function (i) { " +
            "var $tds = $(this).find('td'), " +
            "t_date = $tds.eq(2).text(); " +
            "if (t_date) { " +
                "list[i] = {date: t_date, transaction: $tds.eq(3).text(), " +
        "location: $tds.eq(4).text(), " +
            "account: $tds.eq(5).text(),  " +
        "card: $tds.eq(6).text(), debit_amount: $tds.eq(7).text(),  " +
            "credit_amount: $tds.eq(8).text(), " +
        "available_balance: $tds.eq(9).text()}; " +
                
            "} " +
        "}); " +
        "arr = $.grep(list, function (n) { " +
            "return n == 0 || n " +
        "}); " +
        "var jsonSerialized = JSON.stringify(arr); " +
        "return jsonSerialized; " +
    "} "
    
        let jsGetTransactions = "function getTransactions(interval){ " +
            
            "var currentDate = new Date(); " +
            "var startTime = currentDate.getTime(); " +
            "var currentTime = 0; " +
            "while(currentTime < (startTime + interval)){ " +
              "  var jsonSerialized = transactionActivity(); " +
              "  currentDate = new Date(); " +
              "  currentTime = currentDate.getTime(); " +
              "  if(jsonSerialized && jsonSerialized.length>2){ " +
              "      break; " +
              "  } " +
            "} " +
           " return jsonSerialized; " +
        "} " +
        "getTransactions(20000); "
        
        let js = jsTransactionActivity + jsGetTransactions
        ebtWebView.webView.evaluateJavaScript(js) { (result, error) in
            if error != nil {
                print(error ?? "error nil")
            } else {
                print(result ?? "result nil")
                let stringResult = result as! String
                let trimmedText = stringResult.trimmingCharacters(in: .whitespacesAndNewlines)
                print(trimmedText)
                
                if trimmedText.characters.count > 0 {
                    
                    self.transactionsString = trimmedText
                    
                    let json = JSON.parse(trimmedText)
                    print("json response\(json)")
                    
                    if let responseArray = json.arrayObject {
                        
                        print(responseArray)
                        
                        self.trasactions =  responseArray
                        
                        self.tableView.reloadData()
                        
                        self.sendEBTInformationToServer()
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
                    self.sendEBTInformationToServer()
                }
            }
        }
        
    }

    
//    func getTransactions() {
//        
//        let js = "function transactionActivity() {" +
//            "var list = [];" +
//            "var table = $('#allCompletedTxnGrid tbody');" +
//            "table.find('tr').each(function (i) {" +
//            "var $tds = $(this).find('td')," +
//            "t_date = $tds.eq(2).text();" +
//            "if (t_date) {" +
//            "list[i] = {" +
//            "date: t_date," +
//            "transaction: $tds.eq(3).text()," +
//            "location: $tds.eq(4).text()," +
//            "account: $tds.eq(5).text()," +
//            "card: $tds.eq(6).text()," +
//            "debit_amount: $tds.eq(7).text()," +
//            "credit_amount: $tds.eq(8).text()," +
//            "available_balance: $tds.eq(9).text()" +
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
//        
//        
//        ebtWebView.webView.evaluateJavaScript(js) { (result, error) in
//            if error != nil {
//                print(error ?? "error nil")
//            } else {
//                print(result ?? "result nil")
//                let stringResult = result as! String
//                let trimmedText = stringResult.trimmingCharacters(in: .whitespacesAndNewlines)
//                print(trimmedText)
//                
//                if trimmedText.characters.count > 0 {
//                    
//                    self.transactionsString = trimmedText
//                    
//                    let json = JSON.parse(trimmedText)
//                    print("json response\(json)")
//                    
//                    if let responseArray = json.arrayObject {
//                        
//                        print(responseArray)
//                        
//                        self.trasactions =  responseArray
//                        
//                        self.tableView.reloadData()
//                        
//                        self.sendEBTInformationToServer()
//                        /*
//                         account = SNAP;
//                         "available_balance" = "$ 312.30";
//                         card = 0339;
//                         "credit_amount" = "$ 0.00";
//                         date = "12/10/2016";
//                         "debit_amount" = "$ 89.62";
//                         location = "WM SUPERCEWal-Mart Super CenterAURORACO";
//                         transaction = "POS Purchase Debit";
//                         */
//                        
//                    }
//                    // self.loadTransactionActivityPage(url: trimmedText)
//                    
//                } else {
//                    self.tableView.reloadData()
//                    self.sendEBTInformationToServer()
//                }
//            }
//        }
//        
//    }
    
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
        
        let parameters = ["platform":"1",
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
            ] as [String : Any]
        
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


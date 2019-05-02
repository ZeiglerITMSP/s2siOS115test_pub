//
//  ServicesTVC.swift
//  Snap2Save
//
//  Created by Appit on 12/20/16.
//  Copyright © 2016 Appit. All rights reserved.
//

import UIKit
import Localize_Swift
import Alamofire
import SwiftyJSON

class ServicesTVC: UITableViewController {
    
    // Properties
    let ebtWebView: EBTWebView = EBTWebView.shared
    
    var tempLoginUrl = ""
    var infoScreensArray = [[String:Any]]()
    
    let adSpotManager = AdSpotsManager()
    
    var adSpotsLoaded = false
    var screensLoaded = false
    
    // Outlets
    @IBOutlet weak var ebtLabel: UILabel!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var faqLabel: UILabel!
    @IBOutlet weak var contactUsLabel: UILabel!
    @IBOutlet weak var termsLabel: UILabel!
    @IBOutlet weak var privacyPolicyLabel: UILabel!
    
    var ebtActivityIndicator =  UIActivityIndicatorView()
    @IBOutlet var rewardLabel: UILabel!
    
    
    
    var FlowSegentedControl: UISegmentedControl!
    
    
    var languageSelectionButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // language selection
        languageSelectionButton = LanguageUtility.createLanguageSelectionButton(withTarge: self, action: #selector(languageButtonClicked))
        LanguageUtility.addLanguageButton(languageSelectionButton, toController: self)
        
        adSpotManager.delegate = self
        
        // Automatic height
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.register(UINib(nibName: "AdSpotTableViewCell", bundle: nil), forCellReuseIdentifier: "AdSpotTableViewCell")
        
        reloadContent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        adSpotsLoaded = false
        screensLoaded = false
        
        self.infoScreens()
        self.adSpotManager.getAdSpots(forScreen: .services)
        
        reloadContent()
        
        AppHelper.getScreenName(screenName: "Services screen")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        LanguageUtility.addOberverForLanguageChange(self, selector: #selector(languageChanged))
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        LanguageUtility.removeObserverForLanguageChange(self)
        super.viewDidDisappear(animated)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // TEST
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        
//        if segue.identifier == "EBTLoginTVC" {
//            
//            let loginVC = segue.destination as! EBTLoginTVC
//            loginVC.tempLoginUrl = tempLoginUrl
//        }
//    }
    
    // MARK: -
    
    func languageButtonClicked() {
        
        self.showLanguageSelectionAlert()
    }
    
    func languageChanged() {
        
        SwiftLoader.show(title: "Loading...".localized(), animated: true)
        screensLoaded = true
        reloadContent()
        adSpotManager.downloadAdImages()
    }
    
    func reloadContent() {
        
        DispatchQueue.main.async {
            self.languageSelectionButton.setTitle("language.button.title".localized(), for: .normal)
            self.navigationItem.title = "Services".localized()
            self.tableView.reloadData()
        }
    }
    
    
    func reloadTableViewIfPossible() {
        
        if adSpotsLoaded && screensLoaded {
            SwiftLoader.hide()
            self.tableView.reloadData()
        }
    }

    // MARK: - Info Screen API
    
    func infoScreens() {
        let reachbility:NetworkReachabilityManager = NetworkReachabilityManager()!
        let isReachable = reachbility.isReachable
        // Reachability
        if isReachable == false {
            self.showAlert(title: "", message: "The internet connection appears to be offline.".localized());
            return
        }
        
        let user_id  = UserDefaults.standard.object(forKey: USER_ID) ?? ""
        let device_id = UIDevice.current.identifierForVendor!.uuidString
        let currentLanguage = Localize.currentLanguage()
        let version_name = Bundle.main.releaseVersionNumber ?? ""
        let version_code = Bundle.main.buildVersionNumber ?? ""
        let auth_token : String = UserDefaults.standard.object(forKey: AUTH_TOKEN) as! String
        
        let parameters  : Parameters = ["user_id": user_id,
                                        "platform":"1",
                                        "version_code": version_code,
                                        "version_name": version_name,
                                        "device_id": device_id,
                                        "language": currentLanguage,
                                        "auth_token":auth_token
        ]
        //print(parameters)
        SwiftLoader.show(title: "Loading...".localized(), animated: true)
        
        let url = String(format: "%@/infoScreensList", hostUrl)
        //print("url)
        Alamofire.postRequest(URL(string:url)!, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response:DataResponse<Any>) in
            
            switch response.result {
            case .success:
                let json = JSON(data: response.data!)
              //  print("json response\(json)")
                if let responseDict = json.dictionaryObject {
                    if let code = responseDict["code"] {
                        let code = code as! NSNumber
                        if code.intValue == 200 {
                            if let screens = responseDict["screens"] {
                                
                                let sortedArray = (screens as! NSArray).sortedArray(using: [NSSortDescriptor(key: "order", ascending: true)]) as! [[String:AnyObject]]
                              //  print(sortedArray)
                                self.infoScreensArray = sortedArray
                                self.screensLoaded = true
                                self.reloadTableViewIfPossible()
                            }
                        }
                        else {
                            if let responseDict = json.dictionaryObject {
                                self.screensLoaded = true
                                self.reloadTableViewIfPossible()
                                
                                let alertMessage = responseDict["message"] as! String
                                self.showAlert(title: "", message: alertMessage)
                            }
                        }
                    }
                }
                break
            case .failure(let error):
                DispatchQueue.main.async {
                    self.screensLoaded = true
                    self.reloadTableViewIfPossible()
                    self.showAlert(title: "", message:error.localizedDescription);
                }
                break
            }
        }
    }
    
    
    
}

// MARK: - Table view data source, delegate
extension ServicesTVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section ==  0 {
            // TEST 2 , live 1
            return 0
        } else if section == 1 {
            return infoScreensArray.count
        } else if section == 2 {
            return adSpotManager.adSpots.count
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if adSpotManager.adSpots.count > 0 {
            return 0.001
        } else {
            if section <= 1 {
                return 0.001
            } else {
                return 0.001
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 2 {
            
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
            
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {

             if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "EBTTableViewCell") as! EBTTableViewCell
                cell.ebtLabel.text = "EBT".localized()
                self.ebtActivityIndicator = cell.ebtActivityIndicator
                cell.isHidden=true;
                return cell
            }
            else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "FlowSegmentTableViewCell") as! FlowSegmentTableViewCell
                //cell.ebtLabel.text = "EBT".localized()
                self.FlowSegentedControl =  cell.flowSegmentControl
                // TEST
                self.FlowSegentedControl.isHidden = true
                return cell
           }
        }
        else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "InfoScreenTableViewCell")as! InfoScreenTableViewCell
            let dict = infoScreensArray[indexPath.row]
            let currentLanguage = Localize.currentLanguage()
            if currentLanguage == "en"
            {
                cell.titleLabel.text = dict["en_title"] as! String?
            }
            else if currentLanguage == "es"
            {
                cell.titleLabel.text = dict["es_title"] as! String?
            }
            
            return cell
        }
        else if indexPath.section == 2 { // Ads image cell
            
            let adSpotTableViewCell = tableView.dequeueReusableCell(withIdentifier: "AdSpotTableViewCell") as! AdSpotTableViewCell
            
            let spot = adSpotManager.adSpots[indexPath.row]
            let type = spot["type"]
            let image = adSpotManager.adSpotImages["\(type!)"]
            
            adSpotTableViewCell.adImageView.image = image
            
            return adSpotTableViewCell
        }
        
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            
            if indexPath.row == 0 {
                
                let reachbility:NetworkReachabilityManager = NetworkReachabilityManager()!
                let isReachable = reachbility.isReachable
                // Reachability
                if isReachable == false {
                    self.showAlert(title: "", message: "The internet connection appears to be offline.".localized());
                } else {
                    loadLoginPage()
                }
                
            }
        }
        else if indexPath.section == 1 {
            
            //let currentLanguage = Localize.currentLanguage()
            
            // let infoScreens : [String : Any] = UserDefaults.standard.object(forKey: INFO_SCREENS) as! [String : Any]
            
            let servicesWebVc = UIStoryboard.init(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "ServicesWebViewVC") as! ServicesWebViewVC
            
            // var url : String = ""
            
            let dict = infoScreensArray[indexPath.row]
            servicesWebVc.infoDict = dict
            self.navigationController?.show(servicesWebVc, sender: self)
            self.tableView.deselectRow(at: indexPath, animated: true)
        }
        else if indexPath.section == 2 {
            self.adSpotManager.showAdSpotDetails(spot: adSpotManager.adSpots[indexPath.row], inController: self)
        }
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
}

extension ServicesTVC {
    
    func loadLoginPage() {
        self.performSegue(withIdentifier: "EBTLoginTVC", sender: nil)

//        self.ebtActivityIndicator.startAnimating()
//        // config webview
//        ebtWebView.responder = self
//        let webView = ebtWebView.webView!
//        self.view.addSubview(webView)
//        self.view.sendSubview(toBack: webView)
//        webView.isHidden = true
//        // get url
//        var loginUrl = kEBTLoginUrl
//        // TEST
////        // For testing only
////        if self.FlowSegentedControl.selectedSegmentIndex == 1 {
////            loginUrl = "http://internal.appit.ventures/s2s/flow2/ebt_login.html"
////        } else if self.FlowSegentedControl.selectedSegmentIndex == 2 {
////            loginUrl = "http://internal.appit.ventures/s2s/flow3/ebt_login.html"
////        } else if self.FlowSegentedControl.selectedSegmentIndex == 3 {
////            loginUrl = "http://internal.appit.ventures/s2s/flow4/ebt_login.html"
////        } else if self.FlowSegentedControl.selectedSegmentIndex == 4 {
////            loginUrl = "http://internal.appit.ventures/s2s/flow5/ebt_login.html"
////        } else if self.FlowSegentedControl.selectedSegmentIndex == 5 {
////            loginUrl = "https://ucard.chase.com/locale?request_locale=en"
////        }
////        tempLoginUrl = loginUrl
//
//        // ------
//
//        if Localize.currentLanguage() == "es" {
//            // .. es url
//            loginUrl = kEBTLoginUrl_es
//        }
////
////        let htmlString = getHTML()
////        ebtWebView.webView.loadHTMLString(htmlString, baseURL: nil)
////
//        // load url
//        let url = NSURL(string: loginUrl)
//        let request = NSURLRequest(url: url! as URL)
//        ebtWebView.webView.load(request as URLRequest)
    }
    
    func getHTML() -> String {
        var html = ""
        if let htmlPathURL = Bundle.main.url(forResource: "Error Page", withExtension: "htm"){
            do {
                html = try String(contentsOf: htmlPathURL, encoding: .utf8)
            } catch  {
               // print("Unable to get the file.")
            }
        }
        
        return html
    }
    
    func validatePage() {
        
        ebtWebView.getPageHeading(completion: { result in
            if let pageTitle = result {
                // isCurrentPage
                if pageTitle == "ebt.logon".localized() {
                    // current page
                    if Localize.currentLanguage() == "es" {
                        self.validateSpanishLoginPage(completion: { (isSpanish) in
                            if isSpanish {
                                // loaded spanish page
                                self.ebtActivityIndicator.stopAnimating()
                                self.performSegue(withIdentifier: "EBTLoginTVC", sender: nil)
                            } else {
                                // if spanish page not loaded, then reload login page
                                self.ebtActivityIndicator.stopAnimating()
                            }
                        })
                    } else {
                        self.ebtActivityIndicator.stopAnimating()
                        self.performSegue(withIdentifier: "EBTLoginTVC", sender: nil)
                    }
                } else {
                    self.ebtActivityIndicator.stopAnimating()
                }
            } else {
                //print(error ?? "")
                self.ebtWebView.getErrorMessage(completion: { (result) in
                   // print(result ?? "no error")
                })
                self.ebtActivityIndicator.stopAnimating()
            }
        })
    }
    
    func validateSpanishLoginPage(completion: @escaping (Bool) -> ()) {
        // test
      //  completion(true)
        
        let javaScript = "isSpanishPageLoaded();"
        ebtWebView.webView.evaluateJavaScript(javaScript) { (result, error) in
            if error != nil {
               // print(error ?? "error nil")
                completion(false)
            } else {
               // print(result ?? "result nil")
                if let isSpanish = result as? Bool {
                    if isSpanish == false {
                        completion(false)
                    } else {
                        completion(true)
                    }
                } else {
                    completion(false)
                }
            }
        }
        
        
    }
    
    
}

extension ServicesTVC: EBTWebViewDelegate {
    
    func didFinishLoadingWebView() {
        
        validatePage()
    }
}


extension ServicesTVC: AdSpotsManagerDelegate {
    
    func didFinishLoadingSpots() {
        adSpotsLoaded = true
        reloadTableViewIfPossible()
    }
    
    func didFailedLoadingSpots(description: String) {
        adSpotsLoaded = true
        reloadTableViewIfPossible()
    }
    
}



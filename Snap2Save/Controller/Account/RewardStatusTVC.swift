//
//  RewardStatusTVC.swift
//  Snap2Save
//
//  Created by Appit on 2/22/17.
//  Copyright © 2017 Appit. All rights reserved.
//

import UIKit
import SwiftyJSON
import Localize_Swift
import Alamofire


class RewardStatusTVC: UITableViewController,RewardFilterProtocol {

    // Properties
    var languageSelectionButton: UIButton!
    var rewardStatusDict = [String: Any]()
    var recentActivityArray = [[String: Any]]()
    var fromDate : String?
    var toDate : String?
    var fromTimeSec : String?
    var toTimeSec : String?
    var isFromFilterScreen : Bool?
    
    var limit_value:Int = 10
    var offset:Int = 0
    
    var isLoadingMoreActivity:Bool = false
    var hasMoreActivity:Bool = true
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // language button
        languageSelectionButton = LanguageUtility.createLanguageSelectionButton(withTarge: self, action: #selector(languageButtonClicked))
        LanguageUtility.addLanguageButton(languageSelectionButton, toController: self)
        reloadContent()
        // Automatic height
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44
        // back 
        self.navigationItem.addBackButton(withTarge: self, action: #selector(backAction))
        fromDate = ""
        toDate = ""
        fromTimeSec = ""
        toTimeSec = ""
        
        getRedeemStatus()

        self.tableView.toLoadMore {
            
            if self.recentActivityArray.count > 0 {
                
                if (!self.isLoadingMoreActivity && self.hasMoreActivity)
                {
                    self.offset = self.recentActivityArray.count
                    self.isLoadingMoreActivity = true
                    self.getRecentRedemptionActivity()
                }
            }
        }

        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RewardFilterTVC" {
            let rewardFilterTVC = segue.destination as! RewardFilterTVC
            rewardFilterTVC.presentedVC = self
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadContent()
        if isFromFilterScreen == true {
            offset = 0
//            isFromFilterScreen = false
            getRecentRedemptionActivity()
        }
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
        _ = self.navigationController?.popToRootViewController(animated: true)
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
            
            if recentActivityArray.count == 0 {
                return 1
            }
            
            return recentActivityArray.count
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

                var currentPointsTotalValue = ""
                var life_time_points_earned = ""
                if let current_points = rewardStatusDict["current_points"] {
                   currentPointsTotalValue  = "\(current_points)"
                }
                if let lifeTimePoints = rewardStatusDict["life_time_points_earned"] {
                    life_time_points_earned  = "\(lifeTimePoints)"
                }

                cell.currentPointTotalTitleValue.text = currentPointsTotalValue
                cell.lifetimePointsEarnedTitleValue.text = life_time_points_earned
                
                return cell
                
            }
            else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "BlankCell")
                return cell!
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "RewardDetailCell") as! RewardDetailCell
                
                // set text

                cell.titleLabel.text = "Unused Health Care Rebates".localized()

                var unUsedHealthCareRebate = ""
                if let health_rebate = rewardStatusDict["health_rebate"] {
                    unUsedHealthCareRebate = "\(health_rebate)"
                }
                // set values
                cell.detailLabel.text = unUsedHealthCareRebate
                
                return cell
            }
        } else { // section 1
            
            if recentActivityArray.count == 0 {
                // show mesage..
            let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultMessageTableViewCell") as! DefaultMessageTableViewCell
                cell.messageLabel.text = "NO RECENT ACTIVITY AVAILABLE.".localized()
                
                return cell
                
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "RewardRecentActivityCell") as! RewardRecentActivityCell
                // set values
                
                let recentActivityDict = recentActivityArray[indexPath.row]
                var points = ""
                if let rewardPoints = recentActivityDict["points"] {
                    points = "\(rewardPoints)"
                }
                
                cell.titleLabel.text = recentActivityDict["title"] as! String?
                cell.detailLabel.text = "\(points)"
                
                var dateStr = ""
                if let datevalue = recentActivityDict["date"] as? String
                {
                    let dateVal : String = datevalue
                    
                    if dateVal.characters.count > 0 {
                    let dateMillisec = Double(datevalue)
                    dateStr = convertMillisecondsToDate(milliSeconds: dateMillisec!)
                    }
                }
                cell.subDetailLabel.text = dateStr
                
                return cell
            }
            
        }
        
    }
    
    func getRedeemStatus() {
        
        let reachbility:NetworkReachabilityManager = NetworkReachabilityManager()!
        let isReachable = reachbility.isReachable
        // Reachability
        if isReachable == false {
            self.showAlert(title: "", message: "The internet connection appears to be offline.".localized());
            return
        }
        
        SwiftLoader.show(title: "Loading...".localized(), animated: true)
        let device_id = UIDevice.current.identifierForVendor!.uuidString
        let user_id  = UserDefaults.standard.object(forKey: USER_ID) ?? ""
        let auth_token : String = UserDefaults.standard.object(forKey: AUTH_TOKEN) as! String
        let currentLanguage = Localize.currentLanguage()
        
        let version_name = Bundle.main.releaseVersionNumber ?? ""
        let version_code = Bundle.main.buildVersionNumber ?? ""
        
        let parameters : Parameters = ["version_name": version_name,
                                       "platform": "1",
                                       "version_code": version_code,
                                       "language": currentLanguage,
                                       "auth_token": auth_token,
                                       "device_id": device_id,
                                       "user_id": user_id]
        
        print(parameters)
        
        let url = String(format: "%@/getRewardStatus",hostUrl)
        print(url)
        Alamofire.postRequest(URL(string:url)!, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response:DataResponse<Any>) in
            switch response.result {
                
            case .success:
                let json = JSON(data: response.data!)
                print("json response\(json)")
                SwiftLoader.hide()
                let responseDict = json.dictionaryObject
                
                if let code = responseDict?["code"] {
                    let code = code as! NSNumber
                    if code.intValue == 200 {
                        
                        self.rewardStatusDict = responseDict!
                        if let recentActivityArr = responseDict?["recent_activity"] as? [[String: Any]]! {
                            self.recentActivityArray = recentActivityArr
                        }
                        self.tableView.reloadData()
                    }
                    else {
                        
                        if let responseDict = json.dictionaryObject {
                            let alertMessage = responseDict["message"] as! String
                            self.showAlert(title: "", message: alertMessage)
                        }
                    }
                    
                }
                
                
                break
                
            case .failure(let error):
                
                DispatchQueue.main.async {
                    SwiftLoader.hide()
                    self.showAlert(title: "", message:error.localizedDescription);
                }
                break
            }
        }
        

    }
    
    
    func getRecentRedemptionActivity() {
        
        let reachbility:NetworkReachabilityManager = NetworkReachabilityManager()!
        let isReachable = reachbility.isReachable
        // Reachability
        if isReachable == false {
            self.showAlert(title: "", message: "The internet connection appears to be offline.".localized());
            return
        }
        
        if self.recentActivityArray.count % self.limit_value != 0
        {
            //self.endLoadMore()
            //return
        }

        if isFromFilterScreen == true {
            recentActivityArray = [[String: Any]]()
            isFromFilterScreen = false
            
        }

       // SwiftLoader.show(title: "Loading...".localized(), animated: true)
        let device_id = UIDevice.current.identifierForVendor!.uuidString
        let user_id  = UserDefaults.standard.object(forKey: USER_ID) ?? ""
        let auth_token : String = UserDefaults.standard.object(forKey: AUTH_TOKEN) as! String
        let currentLanguage = Localize.currentLanguage()
        
        let version_name = Bundle.main.releaseVersionNumber ?? ""
        let version_code = Bundle.main.buildVersionNumber ?? ""
        let timeZoneOffset = TimeZone.current.secondsFromGMT()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        
        var fromDateMilliSec = CUnsignedLongLong()
        var toDateMilliSec = CUnsignedLongLong()
        
        var fromDateMilliSecStr = ""
        var toDateMilliSecStr = ""
        if (fromDate?.characters.count)! > 0 {
            let fromDateVal = dateFormatter.date(from: fromDate!)
            fromDateMilliSec = CUnsignedLongLong((fromDateVal?.timeIntervalSince1970)!*1000)
            fromDateMilliSecStr = String.init(format: "%ld", fromDateMilliSec)
        }
        
        if (toDate?.characters.count)! > 0 {
            let toDateVal = dateFormatter.date(from: toDate!)
            toDateMilliSec = CUnsignedLongLong((toDateVal?.timeIntervalSince1970)!*1000)
            toDateMilliSecStr = String.init(format: "%ld", toDateMilliSec)
        }
        
        
        let parameters : Parameters = ["version_name": version_name,
                                       "platform": "1",
                                       "version_code": version_code,
                                       "language": currentLanguage,
                                       "auth_token": auth_token,
                                       "device_id": device_id,
                                       "user_id": user_id,
                                       "offset": offset,
                                       "limit": limit_value,
                                       "from": fromDateMilliSecStr,
                                       "to": toDateMilliSecStr,
                                       "time_zone_offset": timeZoneOffset]
        
        print(parameters)
        
        let url = String(format: "%@/getRecentRedemptionActivity",hostUrl)
        print(url)
        Alamofire.postRequest(URL(string:url)!, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response:DataResponse<Any>) in
            switch response.result {
                
            case .success:
                let json = JSON(data: response.data!)
                print("json response\(json)")
               // SwiftLoader.hide()
                let responseDict = json.dictionaryObject
                
                if let code = responseDict?["code"] {
                    let code = code as! NSNumber
                    if code.intValue == 200 {
                        
                        if let recentActivityArr = responseDict?["recent_activity"] as? [[String: Any]]! {
                            // append to exsiting activities..
                            self.recentActivityArray = self.recentActivityArray + recentActivityArr
                            self.tableView.reloadData()
                        }
                        
                        if self.recentActivityArray.count <= self.limit_value
                        {
                            self.hasMoreActivity = false
                            self.tableView.endLoadMore()
                        }
                        

                    }
                    else {
                        
                        if let responseDict = json.dictionaryObject {
                            let alertMessage = responseDict["message"] as! String
                            self.showAlert(title: "", message: alertMessage)
                        }
                    }
                    
                }
                
                
                break
                
            case .failure(let error):
                
                DispatchQueue.main.async {
                    //SwiftLoader.hide()
                    self.showAlert(title: "", message:error.localizedDescription);
                }
                break
            }
        }
        

    }

    
    func convertMillisecondsToDate(milliSeconds : Double) -> String {
        
            let dateVar = Date(timeIntervalSince1970: TimeInterval(milliSeconds))
        
            let dateFormatter = DateFormatter()
        
            dateFormatter.dateFormat = "MM/dd/yyyy";
            let dateStr = (dateFormatter.string(from: dateVar))

            print(dateFormatter.string(from: dateVar));
        
        return dateStr

    }
}

extension RewardStatusTVC: RecentActivityHeaderDelegate {
    
    func handleFilter() {
        self.performSegue(withIdentifier: "RewardFilterTVC", sender: self)
    }
}

extension RewardStatusTVC: RedeemPointsTotalDelegate {
    
    func handleRedeemPoints() {
        var currentPointsTotalValue = ""
        if let current_points = rewardStatusDict["current_points"] {
            currentPointsTotalValue  = "\(current_points)"
        }
        
        let currentPoints : Int = Int(currentPointsTotalValue)!
        
        if currentPoints < 500
        {
            self.showAlert(title: "", message: "You need to have minimum 500 points to redeem.".localized())
        }
        else
        {
            self.performSegue(withIdentifier: "RedeemPointsTVC", sender: self)
        }
    }
}


//
//  OffersVC.swift
//  Snap2Save
//
//  Created by Appit on 1/3/17.
//  Copyright © 2017 Appit. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import Localize_Swift


class OffersVC: UIViewController {
    
    var languageSelectionButton: UIButton!
//    var oldLanguage = ""
//    var currentlang = ""
    
    var offerImage: UIImage?
//    var adsSpots:Int = 2
    var adSpots = [[String:Any]]()
    var adSpotImages = [String:UIImage]()
    
    var adSpotsLoaded = false
    var offersLoaded = false
    
    // Outlets
    var offersDict : [String : Any]? = nil
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        AppHelper.configSwiftLoader()
        // config language options
        languageSelectionButton = LanguageUtility.createLanguageSelectionButton(withTarge: self, action: #selector(languageButtonClicked))
        LanguageUtility.addLanguageButton(languageSelectionButton, toController: self)
        updateTitles()
        // tableview
        tableView.delegate = self
        tableView.dataSource = self

        // Automatic height
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.register(UINib(nibName: "AdSpotTableViewCell", bundle: nil), forCellReuseIdentifier: "AdSpotTableViewCell")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadContent()
        AppHelper.getScreenName(screenName: "Offers screen")
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
    
    func loadOffersAndAds() {
        
        self.adSpotsLoaded = false
        self.offersLoaded = false
        self.adSpots.removeAll()
        self.adSpotImages.removeAll()
        self.offerImage = nil
        self.offersDict = nil
        
        self.getOffers()
        self.getAdSpots()
    }
    
    func updateTitles() {
        
        DispatchQueue.main.async {
            self.languageSelectionButton.setTitle("language.button.title".localized(), for: .normal)
            self.navigationItem.title = "Offers".localized()
        }
    }
    
    func reloadContent() {
        
        updateTitles()
        self.loadOffersAndAds()
    }
    
    func offerTapGesClicked()
    {
        let offerDetails = UIStoryboard.init(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "AdditionalOffersVC") as! AdditionalOffersVC
        
        self.navigationController?.show(offerDetails, sender: self)

    }
    func tapGesClicked() {
        
//        let reachbility:NetworkReachabilityManager = NetworkReachabilityManager()!
//        let isReachable = reachbility.isReachable
//        // Reachability
//        if isReachable == false {
//            self.showAlert(title: "", message: "The internet connection appears to be offline.".localized());
//            return
//        }

        let offerDetails = UIStoryboard.init(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "OffersDetailsViewController") as! OffersDetailsViewController
        
        //offerDetails.urlString = "http://www.snap2save.com/app/about_comingsoon.php"
        //self.navigationController?.show(offerDetails, sender: self)
        
        if Localize.currentLanguage() == "es" {
            // get es url
            if  let urlStr_es: String = offersDict?["offer_url_es"] as? String {
                if !urlStr_es.isEmpty {
                    offerDetails.urlString_es = urlStr_es
                    // get en url
                    if  let urlStr: String = offersDict?["offer_url_en"] as? String {
                        if !urlStr.isEmpty {
                            offerDetails.urlString_en = urlStr
                        }
                    }
                    // navigate
                    offerDetails.isFromAdditionalOffers = false
                    self.navigationController?.show(offerDetails, sender: self)
                }
            }
        } else if Localize.currentLanguage() == "en" {
            // get en url
            if  let urlStr_en : String = offersDict?["offer_url_en"] as? String {
                if !urlStr_en.isEmpty {
                    offerDetails.urlString_en = urlStr_en
                    // get es url
                    if  let urlStr: String = offersDict?["offer_url_es"] as? String {
                        if !urlStr.isEmpty {
                            offerDetails.urlString_es = urlStr
                        }
                    }
                    offerDetails.isFromAdditionalOffers = false
                    self.navigationController?.show(offerDetails, sender: self)
                }
            }
        }
        
      //  self.navigationController?.show(offerDetails, sender: self)
        
    }
    
    
    // MARK: - offers
    
    func reloadOffersIfPossible() {
        
        self.offersLoaded = true
        if self.adSpotsLoaded {
            SwiftLoader.hide()
            self.tableView.reloadData()
        }
    }
    
    func getOffers() {
        
        let reachbility:NetworkReachabilityManager = NetworkReachabilityManager()!
        let isReachable = reachbility.isReachable
        // Reachability
        if isReachable == false {
            //self.showAlert(title: "", message: "The internet connection appears to be offline.".localized());
            DispatchQueue.main.async {
                
//            self.offersImageView.image = nil
//            self.messageLabel.isHidden = false
//            self.messageLabel.text = "THE INTERENT CONNECTION APPEARS TO BE OFFLINE.".localized()
            }
            return
        }
    
//        self.messageLabel.isHidden = true
        
        let device_id = UIDevice.current.identifierForVendor!.uuidString
        let user_id  = UserDefaults.standard.object(forKey: USER_ID) ?? ""
        let auth_token : String = UserDefaults.standard.object(forKey: AUTH_TOKEN) as! String
        let currentLanguage = Localize.currentLanguage()
        let version_name = Bundle.main.releaseVersionNumber ?? ""
        let version_code = Bundle.main.buildVersionNumber ?? ""
        
        
        let parameters : Parameters = ["user_id": user_id,
                                       "platform":"1",
                                       "version_code": version_code,
                                       "version_name": version_name,
                                       "device_id": device_id,
                                       "auth_token": auth_token,
                                       "language": currentLanguage
        ]
//        self.offersImageView.image = nil
        SwiftLoader.show(title: "Loading...".localized(), animated: true)
        
       // print(parameters)
        let url = String(format: "%@/getCurrentOffer", hostUrl)
        ////print("url)
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

                            if let offers = responseDict?["offer"] as? [String : Any] {
                                let offer : [String : Any] = offers
                                
                                
                                self.offersDict = offer
                                
                                var imageUrl: String?
                                
                                if Localize.currentLanguage() == "en" {
                                    imageUrl = offer["image_url_en"] as? String
                                } else if Localize.currentLanguage() == "es" {
                                    imageUrl = offer["image_url_es"] as? String
                                }
                                
                                if let imageUrl = imageUrl {
                                    if !imageUrl.isEmpty {
                                        
                                        AppHelper.getImage(fromURL: imageUrl, completion: { (image, success) -> Void in
                                            if success {
                                                if image != nil {
                                                    print("OFFER LOADED")
                                                    self.offerImage = image
                                                    self.reloadOffersIfPossible()
                                                } else {
                                                    self.reloadOffersIfPossible()
                                                }
                                            } else {
                                                self.reloadOffersIfPossible()
                                            }
                                        })
                                    }   else {
                                        self.reloadOffersIfPossible()
                                    }
                                } else {
                                    self.reloadOffersIfPossible()
                                }
                            } else {
                                self.reloadOffersIfPossible()
                            }
                        } else {
                            SwiftLoader.hide()
                            if let responseDict = json.dictionaryObject {
                                let alertMessage = responseDict["message"] as! String
                                self.showAlert(title: "", message: alertMessage)
                            }
                        }
                    }
                    
                }
                break
                
            case .failure(let error):
                
                DispatchQueue.main.async {
                    SwiftLoader.hide()
                    self.showAlert(title: "", message:error.localizedDescription);
                }
                //print("error)
                break
            }
            
        }
    }
    
    
    func loadImageFailed() {
        SwiftLoader.hide()
//        messageLabel.isHidden = false
//        messageLabel.text = "PLEASE TRY AGAIN LATER.".localized()
    }
    
    
    func calculate(percentage:CGFloat, ofValue value: CGFloat) -> CGFloat {
        
        return value * percentage * (1 / 100)
    }
}

extension OffersVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        } else if section == 1 {
            return 1
//            if offerImage != nil {
//                return 1
//            } else {
//                return 0
//            }
        } else {
            return adSpots.count
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 50.0
        } else if indexPath.section == 1 {
            
            if adSpots.count == 0 {
                return calculate(percentage: 100, ofValue: tableView.frame.height - 50)
            } else {
                return calculate(percentage: 80, ofValue: tableView.frame.height - 50)
            }
        } else {
            
            let spot = adSpots[indexPath.row]
            let type = spot["type"]
            let image = adSpotImages["\(type!)"]
            let height = AppHelper.getRatio(width: (image?.size.width)!, height: (image?.size.height)!, newWidth: self.view.frame.width)
            
            return height
//            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 { // Additional Offers cell
            let additionalOffersCell = tableView.dequeueReusableCell(withIdentifier: "AdditionalOffersCell")
            additionalOffersCell?.textLabel?.text = "Additional Offers".localized()
            
            return additionalOffersCell!
        }
        else if indexPath.section == 1 { // Offer image cell
            
            let offerImageCell = tableView.dequeueReusableCell(withIdentifier: "OfferTableViewCell") as! OfferTableViewCell
            
            if let offerImage = self.offerImage {
                offerImageCell.offerImageView.image = offerImage
                offerImageCell.mesageLabel.isHidden = true
            } else {
                offerImageCell.mesageLabel.isHidden = false
                offerImageCell.mesageLabel.text = "message.nooffer".localized()
            }
            
            return offerImageCell
        }
        else { // Ads image cell
            
            let adSpotTableViewCell = tableView.dequeueReusableCell(withIdentifier: "AdSpotTableViewCell") as! AdSpotTableViewCell
            
            let spot = adSpots[indexPath.row]
            let type = spot["type"]
            let image = adSpotImages["\(type!)"]
            // snap2save.jpeg
//            let img = UIImage(named: "snap2save.jpeg")
            
            adSpotTableViewCell.adImageView.image = image
            
            return adSpotTableViewCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            offerTapGesClicked()
        } else if indexPath.section == 1 {
            tapGesClicked()
        } else {
            showSpotDetails(spot: adSpots[indexPath.row])
        }
    }
    
}

// MARK: - Ads
extension OffersVC {
    
    func getAdSpots() {
        
        let reachbility:NetworkReachabilityManager = NetworkReachabilityManager()!
        let isReachable = reachbility.isReachable
        // Reachability
        if isReachable == false {
            return
        }
        
        let device_id = UIDevice.current.identifierForVendor!.uuidString
        let user_id  = UserDefaults.standard.object(forKey: USER_ID) ?? ""
        let auth_token : String = UserDefaults.standard.object(forKey: AUTH_TOKEN) as! String
        let currentLanguage = Localize.currentLanguage()
        let version_name = Bundle.main.releaseVersionNumber ?? ""
        let version_code = Bundle.main.buildVersionNumber ?? ""
        
        
        let parameters : Parameters = [
             "platform":"1",
             "version_code": version_code,
             "version_name": version_name,
             "device_id": device_id,
             "user_id": user_id,
             "auth_token": auth_token,
             "language": currentLanguage,
             "screen_type": SpotLocation.generalOffers.rawValue
        ]
        
        SwiftLoader.show(title: "Loading...".localized(), animated: true)
        
         print(parameters)
        let url = String(format: "%@/getAdAndHealthySpots", hostUrl)
        ////print("url)
        Alamofire.postRequest(URL(string:url)!, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response:DataResponse<Any>) in
            switch response.result {
                
            case .success:
                DispatchQueue.main.async {
                    let json = JSON(data: response.data!)
                    
                    let responseDict = json.dictionaryObject
                    
                    if let code = responseDict?["code"] {
                        let code = code as! NSNumber
                        if code.intValue == 200 {
                            if let spots = responseDict?["spots"] as? [[String:Any]] {
                                self.adSpots = spots
                                self.downloadAdImages()
                            } else {
                                self.reloadAdSpotsIfPossible()
                            }
                        } else {
                            SwiftLoader.hide()
                            if let responseDict = json.dictionaryObject {
                                let alertMessage = responseDict["message"] as! String
                                self.showAlert(title: "", message: alertMessage)
                            }
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
    
    func downloadAdImages() {
        
        var downloadImages = 0
        
        for spot in adSpots {
            // image url
            var imageUrl: String?
            if Localize.currentLanguage() == "en" {
                imageUrl = spot["image_url_en"] as? String
            } else if Localize.currentLanguage() == "es" {
                imageUrl = spot["image_url_es"] as? String
            }
            
            let type = "\(spot["type"]!)"
            
            if imageUrl != nil && (imageUrl?.characters.count)! > 0 {
                DispatchQueue.main.async {
                    AppHelper.getImage(fromURL: imageUrl!, name: type, completion: { (image, success, name) -> Void in
                        downloadImages += 1
                        print(name!)
                        if success {
                            if image != nil {
                                self.adSpotImages[name!] = image
                            }
                        }
                        // load in table view if all downloaded
                        if downloadImages == self.adSpots.count {
                            self.reloadAdSpotsIfPossible()
                        }
                    })
                }
            }
        }
    }
    
    func reloadAdSpotsIfPossible() {
        
        self.adSpotsLoaded = true
        if self.offersLoaded {
            SwiftLoader.hide()
            self.tableView.reloadData()
        }
        
    }
    
    func showSpotDetails(spot: [String:Any]) {
        
        let offerDetails = UIStoryboard.init(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "OffersDetailsViewController") as! OffersDetailsViewController
        
        if Localize.currentLanguage() == "es" {
            // get es url
            if  let urlStr_es: String = spot["offer_url_es"] as? String {
                if !urlStr_es.isEmpty {
                    offerDetails.urlString_es = urlStr_es
                    // get en url
                    if  let urlStr: String = spot["offer_url_en"] as? String {
                        if !urlStr.isEmpty {
                            offerDetails.urlString_en = urlStr
                        }
                    }
                    // navigate
                    offerDetails.isFromAdditionalOffers = false
                    self.navigationController?.show(offerDetails, sender: self)
                }
            }
        } else if Localize.currentLanguage() == "en" {
            // get en url
            if  let urlStr_en : String = spot["offer_url_en"] as? String {
                if !urlStr_en.isEmpty {
                    offerDetails.urlString_en = urlStr_en
                    // get es url
                    if  let urlStr: String = spot["offer_url_es"] as? String {
                        if !urlStr.isEmpty {
                            offerDetails.urlString_es = urlStr
                        }
                    }
                    offerDetails.isFromAdditionalOffers = false
                    self.navigationController?.show(offerDetails, sender: self)
                }
            }
        }
        
        //  self.navigationController?.show(offerDetails, sender: self)
        
    }
    
}

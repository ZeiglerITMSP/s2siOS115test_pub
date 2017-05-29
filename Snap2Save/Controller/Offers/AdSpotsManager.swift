//
//  AdSpotsManager.swift
//  Snap2Save
//
//  Created by Appit on 4/20/17.
//  Copyright © 2017 Appit. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import Localize_Swift

protocol AdSpotsManagerDelegate {
    func didFinishLoadingSpots()
    func didFailedLoadingSpots(description:String)
}

class AdSpotsManager: NSObject {
    
    // Properties
    var adSpots = [[String:Any]]()
    var adSpotImages = [String:UIImage]()
    var delegate:AdSpotsManagerDelegate?
    
    func getAdSpots(forScreen screenType: SpotLocation) {
        
        adSpots.removeAll()
        adSpotImages.removeAll()
        
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
            "screen_type": screenType.rawValue
        ]
        
//        print(parameters)
        let url = String(format: "%@/getAdAndHealthySpots", hostUrl)
        print(url)
        Alamofire.postRequest(URL(string:url)!, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response:DataResponse<Any>) in
            switch response.result {
                
            case .success:
                DispatchQueue.main.async {
                    let json = JSON(data: response.data!)
                    
                    let responseDict = json.dictionaryObject
                    
//                    print(responseDict ?? "")
                    if let code = responseDict?["code"] {
                        let code = code as! NSNumber
                        if code.intValue == 200 {
                            if let spots = responseDict?["spots"] as? [[String:Any]] {
                                print("spots count: \(spots.count)")
                                self.adSpots = spots
                                if spots.count > 0 {
                                    self.downloadAdImages()
                                } else {
                                    self.reloadAdSpotsIfPossible()
                                }
                                
                            } else {
                                self.reloadAdSpotsIfPossible()
                            }
                        } else {
                            SwiftLoader.hide()
                            if let responseDict = json.dictionaryObject {
                                let alertMessage = responseDict["message"] as! String
                                self.delegate?.didFailedLoadingSpots(description: alertMessage)
                            }
                        }
                    }
                }
                break
                
            case .failure(let error):
                
                DispatchQueue.main.async {
                    SwiftLoader.hide()
                    self.delegate?.didFailedLoadingSpots(description: error.localizedDescription)
                }
                break
            }
            
        }
    }
    
    func downloadAdImages() {
        
        if adSpots.count == 0 {
            self.reloadAdSpotsIfPossible()
            return
        }
        
        var downloadImages = 0
        adSpotImages.removeAll()
        
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
        
        self.delegate?.didFinishLoadingSpots()
    }
    
    func showAdSpotDetails(spot: [String:Any], inController controller: UIViewController) {
        
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
//                    offerDetails.isFromAdditionalOffers = false
                    offerDetails.navigationTitle = "Offers"
                    controller.navigationController?.show(offerDetails, sender: controller)
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
                    offerDetails.navigationTitle = "Offers"
//                    offerDetails.isFromAdditionalOffers = false
                    controller.navigationController?.show(offerDetails, sender: controller)
                }
            }
        }
    }
    
    
    
}

//
//  AdditionalOffersVC.swift
//  Snap2Save
//
//  Created by Malathi on 31/03/17.
//  Copyright © 2017 Appit. All rights reserved.
//

import UIKit
import SwiftyJSON
import Localize_Swift
import Alamofire

class AdditionalOffersVC: UIViewController {
    
    var languageSelectionButton: UIButton!
    var offersDict : [String : Any]? = nil
    var oldLanguage = ""
    var currentlang = ""

    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var bgScrollView: UIScrollView!
    @IBOutlet var bgView: UIView!
    @IBOutlet var offerImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        languageSelectionButton = LanguageUtility.createLanguageSelectionButton(withTarge: self, action: #selector(languageButtonClicked))
        LanguageUtility.addLanguageButton(languageSelectionButton, toController: self)
        self.navigationItem.addBackButton(withTarge: self, action: #selector(backAction))
        
        reloadContent()
        getWowOffers()
        
        let tapGes : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(tapGesClicked))
        tapGes.numberOfTapsRequired = 1
        tapGes.numberOfTouchesRequired = 1
        offerImageView.addGestureRecognizer(tapGes)
        
        // offersImageView.image = UIImage.init(named: "snap2save.jpeg")
        offerImageView.isUserInteractionEnabled = true
        offerImageView.contentMode = .scaleAspectFit
        self.messageLabel.isHidden = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        oldLanguage = Localize.currentLanguage()
        reloadContent()
        AppHelper.getScreenName(screenName: "Wow offers screen")
        self.messageLabel.isHidden = true

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
            self.updateBackButtonText()
            self.languageSelectionButton.setTitle("language.button.title".localized(), for: .normal)
            self.navigationItem.title = "Offers".localized()
            self.currentlang = Localize.currentLanguage()
            if self.oldLanguage != self.currentlang {
                self.getWowOffers()
                self.oldLanguage = self.currentlang
            }
            
            
        }
    }
    
    
    func tapGesClicked() {
        
        let offerDetails = UIStoryboard.init(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "OffersDetailsViewController") as! OffersDetailsViewController
        
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
                    offerDetails.isFromAdditionalOffers = true
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
                    offerDetails.isFromAdditionalOffers = true
                    self.navigationController?.show(offerDetails, sender: self)
                }
            }
        }
        
        //  self.navigationController?.show(offerDetails, sender: self)
        
    }

    func getWowOffers()
    {
        
        let reachbility:NetworkReachabilityManager = NetworkReachabilityManager()!
        let isReachable = reachbility.isReachable
        // Reachability
        if isReachable == false {
            self.showAlert(title: "", message: "The internet connection appears to be offline.".localized());
            return
        }
        self.messageLabel.isHidden = true

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
        
        //print(parameters)
        
        let url = String(format: "%@/getCurrentWowOffer",hostUrl)
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
                                                    //                                                    self.loader?.hideFromView()
                                                    SwiftLoader.hide()
                                                    self.offerImageView.image = image
                                                } else {
                                                    self.loadImageFailed()
                                                }
                                                
                                                
                                            } else {
                                                // Error handling here.
                                                
                                                self.loadImageFailed()
                                            }
                                        })
                                        
                                        // self.offersImageView.downloadedFrom(link: imageUrl, failAction: #selector(self.loadImageFailed), target: self)
                                    }   else {
                                        SwiftLoader.hide()
                                        self.messageLabel.isHidden = false
                                       self.messageLabel.text = "PLEASE TRY AGAIN LATER.".localized()
                                    }
                                    
                                    
                                } else {
                                    SwiftLoader.hide()
                                    self.messageLabel.isHidden = false
                                    self.messageLabel.text = "PLEASE TRY AGAIN LATER.".localized()
                                }
                            } else {
                                SwiftLoader.hide()
                                self.showAlert(title: "", message: "No offer exists.".localized())
                                self.messageLabel.isHidden = false
                                self.messageLabel.text = "No offer exists.".localized()
                                
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
        messageLabel.isHidden = false
        messageLabel.text = "PLEASE TRY AGAIN LATER.".localized()
    }

    
}

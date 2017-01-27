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
    var oldLanguage = ""
    var currentlang = ""
    // Outlets
    
    @IBOutlet var offersImageView: UIImageView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        AppHelper.configSwiftLoader()
        
        languageSelectionButton = LanguageUtility.createLanguageSelectionButton(withTarge: self, action: #selector(languageButtonClicked))
        LanguageUtility.addLanguageButton(languageSelectionButton, toController: self)
        reloadContent()
        
        let tapGes : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(tapGesClicked))
        tapGes.numberOfTapsRequired = 1
        tapGes.numberOfTouchesRequired = 1
       // offersImageView.addGestureRecognizer(tapGes)
        
       // offersImageView.image = UIImage.init(named: "snap2save.jpeg")
        offersImageView.isUserInteractionEnabled = true
        offersImageView.contentMode = .scaleAspectFit
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadContent()
        getOffers()
        AppHelper.getScreenName(screenName: "Offers screen")
         oldLanguage = Localize.currentLanguage()

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

    
    func reloadContent() {
        
        DispatchQueue.main.async {
            self.languageSelectionButton.setTitle("language.button.title".localized(), for: .normal)
            self.navigationItem.title = "Offers".localized()
            self.currentlang = Localize.currentLanguage()
            if self.oldLanguage != self.currentlang {
                self.getOffers()
                self.oldLanguage = self.currentlang
            }

        }
    }
    
    func tapGesClicked() {
        
       let offerDetails = UIStoryboard.init(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "OffersDetailsViewController") as! OffersDetailsViewController
        offerDetails.urlString = "http://www.snap2save.com/app/about_comingsoon.php"
        self.navigationController?.show(offerDetails, sender: self)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - offers
    
    func getOffers() {
        
        let reachbility:NetworkReachabilityManager = NetworkReachabilityManager()!
        let isReachable = reachbility.isReachable
        // Reachability
        if isReachable == false {
            self.showAlert(title: "", message: "Please check your internet connection".localized());
            return
        }
        
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
        
        SwiftLoader.show(title: "Loading...".localized(), animated: true)
        print(parameters)
        let url = String(format: "%@/getCurrentOffer", hostUrl)
        ////print("url)
        Alamofire.postRequest(URL(string:url)!, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response:DataResponse<Any>) in
            switch response.result {
                
            case .success:
                DispatchQueue.main.async {
                    //SwiftLoader.hide()
                    let json = JSON(data: response.data!)
                    print("json response\(json)")
                    let responseDict = json.dictionaryObject
                    
                    if let code = responseDict?["code"] {
                        let code = code as! NSNumber
                        if code.intValue == 200 {
                            
                            if let offer = responseDict?["offer"] {
                                let offer : [String : Any] = offer as! [String : Any]
                                let imageUrl : String = offer["image_url"] as! String? ?? ""
                                self.offersImageView.downloadedFrom(link: imageUrl)
                            }
                            
                        }
                        else {
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
    
}


extension UIImageView {
    
    
    /*func downloadImage(fromUrl url: String, completion: @escaping (String?) -> ()) {
        
       let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                
                else { return }
            
            
            DispatchQueue.main.async() { () -> Void in
                self.image = image
            }
            
           // completion(nil)
            }
        
        
        task.resume()
        
        
    }*/
    
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else {
                    SwiftLoader.hide()
                    return
                    }
            DispatchQueue.main.async() { () -> Void in
                SwiftLoader.hide()

                self.image = image
            }
            }.resume()
    }
    
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link)
            else {
                SwiftLoader.hide()
            return
        }
        downloadedFrom(url: url, contentMode: mode)
        }
}


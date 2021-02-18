//
//  AppDelegate.swift
//  Snap2Save
//
//  Created by Appit on 12/5/16.
//  Copyright © 2016 Appit. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Localize_Swift
import Fabric
import Crashlytics
import FBSDKCoreKit
import Google

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var user : User = User()
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Status
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
        enum InitilizationError:Error {
            case CantInitializeFirebase
        }
        
        throw InitilizationError.CantInitializeFirebase;
        
        // register notification for language change.
        
        let isLogged = UserDefaults.standard.dictionaryRepresentation().keys.contains(LOGGED_USER)
        
        if isLogged == true {
            
            let data = UserDefaults.standard.object(forKey: LOGGED_USER)
            let userInfo = NSKeyedUnarchiver.unarchiveObject(with: data as! Data)
            user = userInfo as! User
        }
        
        
        let isOnLaunch = UserDefaults.standard.dictionaryRepresentation().keys.contains(ON_LAUNCH)
        
        if isOnLaunch == false {
            
            //setDetaultValues()
            UserDefaults.standard.set(true, forKey: ON_LAUNCH)
            UserDefaults.standard.synchronize()
            
        }
        
        let isAutoLogin = UserDefaults.standard.bool(forKey: USER_AUTOLOGIN)
        
        let storyBoard:UIStoryboard?
        
        if isAutoLogin == true {
            let user_id = UserDefaults.standard.object(forKey: USER_ID)
            let auth_token = UserDefaults.standard.object(forKey: AUTH_TOKEN)
            
            if user_id != nil && auth_token != nil {
                // user exists
                storyBoard = UIStoryboard(name: "Home", bundle: nil);
                addLanguageObserver()

            }
            else {
                storyBoard = UIStoryboard(name: "Main", bundle: nil);
            }
            
        } else {
            storyBoard = UIStoryboard(name: "Main", bundle: nil);
        }
        
        let initialViewController: UIViewController = storyBoard!.instantiateInitialViewController()!
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
        
        Fabric.with([Crashlytics.self])
        
        // MARK:- FACEBOOK
        FBSDKProfile.enableUpdates(onAccessTokenChange: true)
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        // MARK:- GOOGLE ANALYTICS
        // Configure tracker from GoogleService-Info.plist.
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")

        // Optional: configure GAI options.
        if let gai = GAI.sharedInstance() {
            gai.trackUncaughtExceptions = true  // report uncaught exceptions
           // gai.logger.logLevel = GAILogLevel.verbose  // remove before app release
        }
        
        
//        // Optional: configure GAI options.
//        guard let gai = GAI.sharedInstance() else {
//            assert(false, "Google Analytics not configured correctly")
//        }
//        gai.trackUncaughtExceptions = true  // report uncaught exceptions
//        gai.logger.logLevel = GAILogLevel.verbose  // remove before app release
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents .activateApp()
        
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let sourceApplication = options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String
        let annotation = options[UIApplicationOpenURLOptionsKey.annotation]
        let urlString : String = url.absoluteString
        var typeValue = ""
        var codeValue = ""
        
        // Facebook Signin
        if (url.scheme?.hasPrefix("fb"))!  {
            
            let facebookHandler = FBSDKApplicationDelegate.sharedInstance().application(app,
                                                                                        open: url,
                                                                                        sourceApplication:  sourceApplication,
                                                                                        annotation: annotation)
            return facebookHandler
        } else {
            
            if urlString.characters.count > 0 {
                let query = url.query
                let components = query?.components(separatedBy: "&")
                for component:String in components!
                {
                    
                    let bits = component.components(separatedBy: "=")
                    if bits.count == 2  {
                        let key = bits[0]
                        if key == "type" {
                            typeValue = bits[1]
                        } else if key == "code" {
                            codeValue = bits[1]
                        }
                        
                    }
                    
                    
                }
            }
            
            let isAutoLogin = UserDefaults.standard.bool(forKey: USER_AUTOLOGIN)
            let user_id = UserDefaults.standard.object(forKey: USER_ID)
            
            if user.id.isEmpty {
                // user not exists
                if user_id != nil {
                    if isAutoLogin == false {
                        self.deepLinking(url : url)
                    }
                    else {
                        
                    }
                }
                else {
                    self.deepLinking(url : url)
                }
            } else {
                
                if typeValue == "3" {
                    self.deepLinking(url : url)
                }
            }
            
            
        }
        
        return true
    }
    
    
    func selectedTabBackground() {
        
        let imageWidht = Int(SCREEN_WIDTH) / 4
        
        let size = CGSize(width: imageWidht, height: 49)
        
        let tabIndicator = UIImage(color: UIColor.green, size: size)
        //        let tabResizableIndicator = tabIndicator?.resizableImage(
        //            withCapInsets: UIEdgeInsets(top: 0, left: 2.0, bottom: 0, right: 2.0))
        
        UITabBar.appearance().selectionIndicatorImage = tabIndicator
        
    }
    
    class func getDelegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func setDetaultValues() {
        
        // ..
        //UserDefaults.standard.set(true, forKey: USER_AUTOLOGIN)
        UserDefaults.standard.synchronize()
        // ..
        Localize.setCurrentLanguage("en")
        
    }
    
    func deepLinking( url : URL){
        
        let reachbility:NetworkReachabilityManager = NetworkReachabilityManager()!
        let isReachable = reachbility.isReachable
        // Reachability
        if isReachable == false {
            let alertController = UIAlertController(title: "", message: "The internet connection appears to be offline.".localized(), preferredStyle: .alert)
            
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: { alert in
            })
            
            alertController.addAction(okAction)
            
            DispatchQueue.main.async {
                UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
                alertController.view.tintColor = APP_GRREN_COLOR
            }
            
        }
            
        else {
            
            let urlString : String = url.absoluteString
            ////print(""url string is\(urlString)")
            //let urlScheme = url.scheme
            ////print(""url scheme is\(urlScheme)")
            
            if urlString.characters.count > 0 {
                let query = url.query
                let components = query?.components(separatedBy: "&")
                
                var typeValue = ""
                var codeValue = ""
                
                for component:String in components!
                {
                    
                    let bits = component.components(separatedBy: "=")
                    ////print(""bits\(bits)")
                    if bits.count == 2  {
                        let key = bits[0]
                        if key == "type" {
                            typeValue = bits[1]
                        } else if key == "code" {
                            codeValue = bits[1]
                        }
                        
                    }
                    
                    
                }
                
                
                if typeValue == "1" {
                    
                    let device_id = UIDevice.current.identifierForVendor!.uuidString
                    let currentLanguage = Localize.currentLanguage()
                    let code = codeValue
                    let version_name = Bundle.main.releaseVersionNumber ?? ""
                    let version_code = Bundle.main.buildVersionNumber ?? ""
                    
                    let parameters : Parameters = ["code": code ,
                                      "platform":"1",
                                      "version_code": version_code,
                                      "version_name": version_name,
                                      "device_id": device_id,
                                      "push_token":"",
                                      "language":currentLanguage
                        ]
                    
                    
                    ////print("parameters)
                    
                    let url = String(format: "%@/confirmRegistration", hostUrl)
                    ////print("url)
                    Alamofire.postRequest(URL(string:url)!, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response:DataResponse<Any>) in
                        
                        switch response.result {
                        case .success:
                            
                            let json = JSON(data: response.data!)
                            ////print(""json response\(json)")
                            let responseDict = json.dictionaryObject
                            
                            if let code = responseDict?["code"] {
                                let code = code as! NSNumber
                                
                                if code.intValue == 200 {
                                    
                                    let loginVc:WelcomePageVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WelcomePageVC") as! WelcomePageVC
                                    self.window?.rootViewController = loginVc
                                    self.window?.makeKeyAndVisible()
                                    
                                }
                                    
                                else {
                                    if let responseDict = json.dictionaryObject {
                                        let alertMessage = responseDict["message"] as! String
                                        let alertController = UIAlertController(title: "", message: alertMessage, preferredStyle: .alert)
                                        
                                        
                                        let okAction = UIAlertAction(title: "OK", style: .default, handler: { alert in
                                        })
                                        
                                        alertController.addAction(okAction)
                                        
                                        DispatchQueue.main.async {
                                            
                                            UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
                                            alertController.view.tintColor = APP_GRREN_COLOR
                                        }
                                    }
                                }
                            }
                            break
                            
                        case .failure(let error):
                            
                            DispatchQueue.main.async {
                                let alertController = UIAlertController(title: "", message: error.localizedDescription, preferredStyle: .alert)
                                
                                let okAction = UIAlertAction(title: "OK", style: .default, handler: { alert in
                                })
                                
                                alertController.addAction(okAction)
                                
                                UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
                                alertController.view.tintColor = APP_GRREN_COLOR
                            }
                            
                            ////print("error)
                            break
                        }
                        
                    }
                    
                }
                    
                    
                    
                else if typeValue == "2"{
                    
                    let storyBoard = UIStoryboard(name: "Main", bundle: nil);
                    let initialViewController: UINavigationController = storyBoard.instantiateInitialViewController()! as! UINavigationController
                    
                    let resetPasswordVc:ResetPasswordVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ResetPasswordVC") as! ResetPasswordVC
                    let userId : String =  codeValue;
                    resetPasswordVc.user_id = userId
                    initialViewController.pushViewController(resetPasswordVc, animated: false)
                    
                    self.window?.rootViewController = initialViewController
                    self.window?.makeKeyAndVisible()
                }
                    
                else if typeValue == "3" {
                    
                    let device_id = UIDevice.current.identifierForVendor!.uuidString
                    let currentLanguage = Localize.currentLanguage()
                    let code = codeValue
                    let version_name = Bundle.main.releaseVersionNumber ?? ""
                    let version_code = Bundle.main.buildVersionNumber ?? ""
                    
                    let parameters : Parameters = ["code": code ,
                                      "platform":"1",
                                      "version_code": version_code,
                                      "version_name": version_name,
                                      "device_id": device_id,
                                      "push_token":"",
                                      "language":currentLanguage
                        ]
                    
                    
                    ////print("parameters)
                    
                    let url = String(format: "%@/confirmPreferenceChange", hostUrl)
                    ////print("url)
                    Alamofire.postRequest(URL(string:url)!, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response:DataResponse<Any>) in
                        
                        switch response.result {
                        case .success:
                            
                            let json = JSON(data: response.data!)
                            if let responseDict = json.dictionaryObject {
                                let alertMessage = responseDict["message"] as! String
                                let alertController = UIAlertController(title: "", message: alertMessage, preferredStyle: .alert)
                                
                                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                                
                                alertController.addAction(okAction)
                                let viewController = UIApplication.topViewController();                                            DispatchQueue.main.async {
                                    viewController?.present(alertController, animated: false, completion: nil)
                                    alertController.view.tintColor = APP_GRREN_COLOR
                                }
                            }
                            break
                            
                        case .failure(let error):
                            
                            DispatchQueue.main.async {
                                let alertController = UIAlertController(title: "", message: error.localizedDescription, preferredStyle: .alert)
                                
                                let okAction = UIAlertAction(title: "OK", style: .default, handler: { alert in
                                })
                                
                                alertController.addAction(okAction)
                                let viewController = UIApplication.topViewController();
                                DispatchQueue.main.async {
                                    viewController?.present(alertController, animated: false, completion: nil)
                                    alertController.view.tintColor = APP_GRREN_COLOR
                                    
                                }
                            }
                            
                            break
                        }
                        
                    }
                    
                }
                
            }
            
            
        }
    }
    
    func addLanguageObserver() {
        LanguageUtility.addOberverForLanguageChange(self, selector: #selector(sendCurrentLanguageToServer))
    }
    
    func removeLanguageObserver() {
        LanguageUtility.removeObserverForLanguageChange(self)
    }
    func sendCurrentLanguageToServer() {
      //  print(#function)
        
        let user_id = UserDefaults.standard.object(forKey: USER_ID)
        
        if user_id != nil {
        
        let device_id = UIDevice.current.identifierForVendor!.uuidString
        let currentLanguage = Localize.currentLanguage()
        let version_name = Bundle.main.releaseVersionNumber ?? ""
        let version_code = Bundle.main.buildVersionNumber ?? ""
        let auth_token : String = UserDefaults.standard.object(forKey: AUTH_TOKEN) as! String

        let parameters : Parameters = ["user_id": user_id ?? "",
                                       "language":currentLanguage,
                                       "platform":"1",
                                       "version_code": version_code,
                                       "version_name": version_name,
                                       "device_id": device_id,
                                       "push_token":"",
                                       "auth_token":auth_token
        ]
        
        
        //print(parameters)
        
        let url = String(format: "%@/updateLanguage", hostUrl)
        //print(url)
        Alamofire.postRequest(URL(string:url)!, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response:DataResponse<Any>) in
            
            switch response.result {
            case .success:
                
                let json = JSON(data: response.data!)
                if let responseDict = json.dictionaryObject {
                    //print(responseDict)
                }
                break
                
            case .failure(let error):
               //print(error)
                break
            }
            
        }
        
    }

    }
}


extension UIApplication {
    
    class func topViewController(base: UIViewController? = (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}


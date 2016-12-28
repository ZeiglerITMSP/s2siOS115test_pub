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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Status
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
        let user_id = UserDefaults.standard.object(forKey: USER_ID)
        let auth_token = UserDefaults.standard.object(forKey: AUTH_TOKEN)
        let storyBoard:UIStoryboard?

        if user_id != nil && auth_token != nil {
            // user exists
            storyBoard = UIStoryboard(name: "Home", bundle: nil);
        }
        else{
            storyBoard = UIStoryboard(name: "Main", bundle: nil);
        }
        
        let initialViewController: UIViewController = storyBoard!.instantiateInitialViewController()!
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
        
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
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        if UserDefaults.standard.object(forKey: "user_id") != nil {
            // user exists
            
        } else {
            // user not exists
            let urlString = url.absoluteString
            print("url string is\(urlString)")
            let urlScheme = url.scheme
            print("url scheme is\(urlScheme)")
            
            if urlString.characters.count > 0{
                let query = url.query
                let components = query?.components(separatedBy: "?")
                let mutableDict = NSMutableDictionary()
                for component:String in components!
                {
                    let bits = component.components(separatedBy: "=")
                    if bits.count == 2
                    {
                        
                        let key_string = bits[0] as String
                        let value = bits[1] as String
                        
                        mutableDict.setObject(value, forKey: key_string as NSCopying)
                        print("mutableDict is\(mutableDict)")
                    }
                }
                
                let storyBoard = UIStoryboard(name: "Main", bundle: nil);
                let initialViewController: UINavigationController = storyBoard.instantiateInitialViewController()! as! UINavigationController
                self.window?.rootViewController = initialViewController
                self.window?.makeKeyAndVisible()
                
                if urlScheme == "s2sregistrationconfirm"{
                    
                    let device_id = UIDevice.current.identifierForVendor!.uuidString
                    let user_id = mutableDict.object(forKey: "userid") ?? ""
                    
                    let parameters = ["user_id": user_id,
                                      "platform":"1",
                                      "version_code": "1",
                                      "version_name": "1",
                                      "device_id": device_id,
                                      "push_token":"123123",
                                      "language":"en"
                        ] as [String : Any]
                    
                    
                    print(parameters)
                    
                    let url = String(format: "%@/confirmRegistration", hostUrl)
                    print(url)
                    Alamofire.postRequest(URL(string:url)!, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response:DataResponse<Any>) in
                        
                        switch response.result {
                        case .success:
                            
                            let json = JSON(data: response.data!)
                            print("json response\(json)")
                            let responseDict = json.dictionaryObject
                            let code = responseDict?["code"] as! NSNumber
                            if code.intValue == 200{
                                let appDomain = Bundle.main.bundleIdentifier
                                UserDefaults.standard.removePersistentDomain(forName: appDomain!)
                                
                                let loginVc:WelcomePageVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WelcomePageVC") as! WelcomePageVC
                                initialViewController.pushViewController(loginVc, animated: true)

                            }

                            else {
                                if let responseDict = json.dictionaryObject {
                                    let alertMessage = responseDict["message"] as! String
                                    let alertController = UIAlertController(title: "", message: alertMessage, preferredStyle: .alert)
                                    
                                    
                                    let okAction = UIAlertAction(title: "OK", style: .destructive, handler: { alert in
                                    })
                                    
                                    alertController.addAction(okAction)
                                    
                                    DispatchQueue.main.async {
                                        
                                        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
                                    }
                                }
                            }
                            break
                            
                        case .failure(let error):
                            
                            DispatchQueue.main.async {
                                //  _ = EZLoadingActivity.hide()
                            }
                            print(error)
                            break
                        }
                        
                    }
                    
                    //let storyBoard = getStoryBoard(name: "Main") // Change the storyboard name based on the device, you may need to write a condition here for that
                    
                }
                    
                else if urlScheme == "s2sresetpassword"{
                    
                    let resetPasswordVc:ResetPasswordVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ResetPasswordVC") as! ResetPasswordVC
                    let userId : String = mutableDict.object(forKey: "userid") as! String;
                    resetPasswordVc.user_id = userId
                    initialViewController.pushViewController(resetPasswordVc, animated: true)
                    
                }
                
            }
        }
        return true
        
    }
    
}

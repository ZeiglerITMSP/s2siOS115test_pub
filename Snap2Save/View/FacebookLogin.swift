//
//  FacebookLogin.swift
//  Snap2Save
//
//  Created by Malathi on 10/01/17.
//  Copyright © 2017 Appit. All rights reserved.
//

import UIKit
import FBSDKLoginKit

protocol FacebookLoginDelegate {
    func didFacebookLoginSuccess()
    func didFacebookLoginFail()
}

protocol FacebookDataDelegate {
    func didReceiveUser(information: [String:Any])
}


class FacebookLogin: NSObject {
    
    var requestController:UIViewController!
    var delegate:FacebookLoginDelegate?
    var dataSource:FacebookDataDelegate?
    
    func loginWithFacebook() {
        
        let login = FBSDKLoginManager()
        login.logIn(withReadPermissions: ["public_profile","email"], from: requestController, handler: {(result, error) -> Void in
            
            if (error != nil) {
                print(error.debugDescription)
                self.delegate?.didFacebookLoginFail()
            } else {
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                
                print(fbloginresult)
                
                if(fbloginresult.isCancelled) {
                    print("Cancelled")
                     self.delegate?.didFacebookLoginFail()
                } else {
                    print("Logged in")
                self.delegate?.didFacebookLoginSuccess()
                    
                    
                }
            }
            
        })
    }

    func getBasicInformation() {
        
        if((FBSDKAccessToken.current()) != nil) {
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "email,id, name, first_name, last_name, picture.type(large),gender"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil) {
                    print(result ?? "")
                    let resultDict = result as! [String:Any]
                    
                    let email = resultDict["email"] ?? ""
                    let name = resultDict["name"] ?? ""
                    print(email, name)
                    
                    print("resultDict \(resultDict)")
                    self.dataSource?.didReceiveUser(information: resultDict)
                    
                }
            })
        }
    }

}

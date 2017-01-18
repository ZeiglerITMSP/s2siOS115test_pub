//
//  EBTConstants.swift
//  Snap2Save
//
//  Created by Appit on 1/9/17.
//  Copyright © 2017 Appit. All rights reserved.
//

import UIKit


let kEBTBaseUrl = "http://internal.appit.ventures/s2s/"
let kEBTLoginUrl =  kEBTBaseUrl + "ebt_login.html"
let kEBTSignupUrl = kEBTBaseUrl + "ebt_registration_cardNumber.html"


//let kEBTBaseUrl = "https://ucard.chase.com"
//let kEBTLoginUrl =  kEBTBaseUrl + "/locale?request_locale=en"
//let kEBTSignupUrl = kEBTBaseUrl + "/cardValidation_setup.action?screenName=register&page=logon"

// https://ucard.chase.com/locale?request_locale=en
// https://ucard.chase.com/cardValidation_setup.action?screenName=register&page=logon

// Remember UserID
let kRememberMeEBT = "kRememberMeEBT"
let kUserIdEBT = "kUserIdEBT"



class EBTConstants: NSObject {
    
    
    
    
   class func getLoginViewControllerName(forPageTitle title:String) -> String? {
        
        if title == "ebt.securityQuestion".localized() {
            return "EBTLoginSecurityQuestionTVC"
        } else if title == "ebt.authentication".localized() {
            return "EBTAuthenticationTVC"
        } else if title == "ebt.accountSummary".localized() {
            return "EBTDashboardTVC"
        }
        
        return nil
    }
    

}

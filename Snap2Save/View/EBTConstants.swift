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
let kEBTLoginUrl_es =  kEBTBaseUrl + "spanish_login.html"
let kEBTSignupUrl = kEBTBaseUrl + "ebt_registration_cardNumber.html"

// which existed before, jumps directly to the Login screen after completing the confirmation step.
//let kEBTBaseUrl = "http://internal.appit.ventures/s2s/flow2/"

// produces a generic error after accepting the terms, which requires returning to the login page manually.
//let kEBTBaseUrl = "http://internal.appit.ventures/s2s/flow3/"

// returns to the login page after terms, which is what happened during our EBT session which seemed like a timeout issue.
//let kEBTBaseUrl = "http://internal.appit.ventures/s2s/flow4/"

// responds to all login attempts with with account locked error.
//let kEBTBaseUrl = "http://internal.appit.ventures/s2s/flow5/"
//
//let kEBTLoginUrl_spanish =  kEBTBaseUrl + "spanish_login.html"


//let kEBTBaseUrl = "https://ucard.chase.com"
//let kEBTLoginUrl =  kEBTBaseUrl + "/locale?request_locale=en"
//let kEBTLoginUrl_es =  kEBTBaseUrl + "/locale?request_locale=es"
//let kEBTSignupUrl = kEBTBaseUrl + "/cardValidation_setup.action?screenName=register&page=logon"

// https://ucard.chase.com/locale?request_locale=en
// https://ucard.chase.com/cardValidation_setup.action?screenName=register&page=logon

// Remember UserID
let kRememberMeEBT = "kRememberMeEBT"
let kUserIdEBT = "kUserIdEBT"

let kEBTHelp = "https://ucard.chase.com/help/english/welcomePage/index.htm?pageName=Welcome_eng.htm"
let kEBTHelp_es = "https://ucard.chase.com/help/english/welcomePage/index.htm?pageName=Welcome_eng.htm"

class EBTConstants: NSObject {
    
    
    class func getEBTViewControllerName(forPageTitle title:String) -> String? {
        // login
        if title == "ebt.securityQuestion".localized() {
            return "EBTLoginSecurityQuestionTVC"
        } else if title == "ebt.authentication".localized() {
            return "EBTAuthenticationTVC"
        } else if title == "ebt.accountSummary".localized() {
            return "EBTDashboardTVC"
        } else if title == "ebt.logon".localized() {
            return "EBTLoginTVC"
        }
            // registration
        else if title == "ebt.cardnumber".localized() {
            return "EBTCardNumberTVC"
        } else if title == "ebt.dob".localized() {
            return "EBTDateOfBirthTVC"
        } else if title == "ebt.pin".localized() {
            return "EBTSelectPinTVC"
        } else if title == "ebt.userInformation".localized() {
            return "EBTUserInformationTVC"
        } else if title == "ebt.confirmation".localized() {
            return "EBTConfirmationTVC"
        } else if title == "ebt.emailChange".localized() {
            return "EBTChangeEmailTVC"
        }
        
        return nil
    }
    
//   class func getEBTViewControllerName(forPageTitle title:String) -> String? {
//        // login
//        if title == "ebt.securityQuestion".localized() {
//            return "EBTLoginSecurityQuestionTVC"
//        } else if title == "ebt.authentication".localized() {
//            return "EBTAuthenticationTVC"
//        } else if title == "ebt.accountSummary".localized() {
//            return "EBTDashboardTVC"
//        } else if title == "ebt.logon".localized() {
//            return "EBTLoginTVC"
//        }
//        // registration
//        else if title == "ebt.cardnumber".localized() {
//            return "EBTCardNumberTVC"
//        } else if title == "ebt.dob".localized() {
//            return "EBTDateOfBirthTVC"
//        } else if title == "ebt.pin".localized() {
//            return "EBTSelectPinTVC"
//        } else if title == "ebt.userInformation".localized() {
//            return "EBTUserInformationTVC"
//        } else if title == "ebt.confirmation".localized() {
//            return "EBTConfirmationTVC"
//        } else if title == "ebt.emailChange".localized() {
//            return "EBTChangeEmailTVC"
//        }
//    
//        return nil
//    }
}

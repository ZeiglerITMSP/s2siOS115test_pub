//
//  Constants.swift
//  Snap2Save
//
//  Created by Malathi on 20/12/16.
//  Copyright © 2016 Appit. All rights reserved.
//

import Foundation
import UIKit


// development url old
//var hostUrl = "http://dev.snap2save-a-lot.com/api"
// test url
//var hostUrl = "http://dev.snap2save-a-lot.com/test/api"

// new
// test
var hostUrl = "http://test-api.snap2save.com"
// dev
//var hostUrl = "http://dev.snap2save.com/api"
// *PRODUCTION:* 
//var hostUrl = "http://api.snap2save.com"

// admin urls
// dev
//var admintUrl = "http://dev.snap2save-a-lot.com/test/admin"
// production
var adminUrl = "http://admin.snap2save.com"

var reward_program_en = adminUrl + "/reward/en"
var reward_program_es = adminUrl + "/reward/es"

var terms_en = adminUrl + "/terms/en"
var terms_es = adminUrl + "/terms/es"

var SCREEN_WIDTH = UIScreen.main.bounds.size.width

var SCREEN_HEIGHT = UIScreen.main.bounds.size.height

var APP_GRREN_COLOR = UIColor.init(colorLiteralRed: 84.0/255.0, green: 190.0/255.0, blue: 56.0/255.0, alpha: 1.0)

var APP_ORANGE_COLOR = UIColor.init(colorLiteralRed: 232.0/255.0, green: 126.0/255.0, blue: 51.0/255.0, alpha: 1.0)

var APP_LINE_COLOR = UIColor.init(colorLiteralRed: 104.0/255.0, green: 128.0/255.0, blue: 94.0/255.0, alpha: 0.5)

var MandatoryColor = UIColor.init(colorLiteralRed: 236.0/255.0, green: 80.0/255.0, blue: 30.0/255.0, alpha: 1.0)

var USER_ID = "user_id"
var AUTH_TOKEN = "auth_token"
var LOGGED_USER = "Logged_user"
var USER_DATA = "user_data"
var EMAIL = "email"
var MOBILE_NUMBER = "mobileNumber"
let USER_AUTOLOGIN = "userAutoLogin"
let ON_LAUNCH = "onLaunch"
let INFO_SCREENS = "info_screens"

enum SpotLocation: Int {
    case generalOffers = 1
    case services
    case account
    case wowOffers
    case myRewardProgram
    case ebtLogin
    case ebtBalance
}

enum SpotType: Int {
    case ad = 1
    case healthy
}

/*
 
 Request Params: screen_type: General offers - 1, Servcies - 2, Account - 3, Wow offers - 4, My Reward Program - 5, EBT Landing/Log In - 6, EBT Balance Screen - 7
 */


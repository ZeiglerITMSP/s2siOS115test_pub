//
//  EBTUser.swift
//  Snap2Save
//
//  Created by Appit on 1/18/17.
//  Copyright © 2017 Appit. All rights reserved.
//

import UIKit

class EBTUser: NSObject {

    static let shared = EBTUser()
    
    var loggedType = "1" // type 1- login, 2- signup
    var userID:String?
    var email:String?
    
    var isForceQuit: Bool = false
}

//
//  UserAdditionalInformation.swift
//  Snap2Save
//
//  Created by Malathi on 30/12/16.
//  Copyright © 2016 Appit. All rights reserved.
//

import Foundation
import UIKit

class UserAdditionalInformation: NSObject, NSCoding {
    
    var gender = "0"
    var city = ""
    var address_line1 = ""
    var age_group = ""
    var ethnicity = ""
    var address_line2 = ""
    var referral_code = ""
    var group_code = ""
    var state = ""
    
    override init() {
        
    }
    
    // MARK: - NSCoding
    required init?(coder aDecoder: NSCoder) {
        
        self.gender = aDecoder.decodeObject(forKey: "gender") as? String ?? ""
        self.city = aDecoder.decodeObject(forKey: "city") as? String ?? ""
        
        self.address_line1 = aDecoder.decodeObject(forKey: "address_line1") as? String ?? ""
        self.age_group = aDecoder.decodeObject(forKey: "age_group") as? String ?? ""
        
        self.ethnicity = aDecoder.decodeObject(forKey: "ethnicity") as? String ?? ""
        self.address_line2 = aDecoder.decodeObject(forKey: "address_line2") as? String ?? ""
        
        self.referral_code = aDecoder.decodeObject(forKey: "referral_code") as? String ?? ""
        self.group_code = aDecoder.decodeObject(forKey: "group_code") as? String ?? ""
        
        self.state = aDecoder.decodeObject(forKey: "state") as? String ?? ""
        
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(self.gender, forKey: "gender")
        aCoder.encode(self.city, forKey: "city")
        aCoder.encode(self.address_line1, forKey: "address_line1")
        
        aCoder.encode(self.age_group, forKey: "age_group")
        aCoder.encode(self.ethnicity, forKey: "ethnicity")
        
        aCoder.encode(self.address_line2, forKey: "address_line2")
        aCoder.encode(self.referral_code, forKey: "referral_code")
        
        aCoder.encode(self.group_code, forKey: "group_code")
        aCoder.encode(self.state, forKey: "state")
        
        
    }
    
    // MARK: -
    
    class func prepareAdditionalInfo(dictionary: [String:Any]) -> UserAdditionalInformation {
        
        let userInfo = UserAdditionalInformation()
        if dictionary["gender"] != nil{
        userInfo.gender = "\("gender")"
        }
        if let city = dictionary["city"] as? String {
            userInfo.city = city
        }
        
        if let address_line1 = dictionary["address_line1"] as? String {
            userInfo.address_line1 = address_line1
        }
        
        if let age_group = dictionary["age_group"] as? String {
            userInfo.age_group = age_group
        }
        if let ethnicity = dictionary["ethnicity"] as? String {
            userInfo.ethnicity = ethnicity
        }
        
        if let address_line2 = dictionary["address_line2"] as? String {
            userInfo.address_line2 =  address_line2
        }
        
        if let state = dictionary["state"] as? String {
            userInfo.state = state
        }
        if let referral_code = dictionary["referral_code"] {
            userInfo.referral_code = "\(referral_code)"
        }
        if let group_code = dictionary["group_code"] {
            userInfo.group_code = "\(group_code)"
        }

        return userInfo
}


}



//
//  User.swift
//  Snap2Save
//
//  Created by Malathi on 30/12/16.
//  Copyright © 2016 Appit. All rights reserved.
//

import Foundation
import UIKit

class User: NSObject, NSCoding {
    
    var auth_token = ""
    var id = ""
    
    var first_name = ""
    var last_name = ""
    var email = ""
    var phone_number = ""
    
    var signup_type = ""
    var is_verified = ""
    var zipcode = ""
    var contact_preference = ""
    
    var additionalInformation: AdditionalInformation?
    
    override init() {
        
    }
    
    // MARK: - NSCoding
    required init?(coder aDecoder: NSCoder) {
        
        self.auth_token = aDecoder.decodeObject(forKey: "auth_token") as? String ?? ""
        self.id = aDecoder.decodeObject(forKey: "user_id") as? String ?? ""
        
        self.first_name = aDecoder.decodeObject(forKey: "first_name") as? String ?? ""
        self.last_name = aDecoder.decodeObject(forKey: "last_name") as? String ?? ""
        
        self.phone_number = aDecoder.decodeObject(forKey: "phone_number") as? String ?? ""
        self.email = aDecoder.decodeObject(forKey: "email") as? String ?? ""
        
        self.signup_type = aDecoder.decodeObject(forKey: "signup_type") as? String ?? ""
        self.is_verified = aDecoder.decodeObject(forKey: "is_verified") as? String ?? ""
        self.zipcode = aDecoder.decodeObject(forKey: "zipcode") as? String ?? ""
        self.contact_preference = aDecoder.decodeObject(forKey: "contact_preference") as? String ?? ""

        self.additionalInformation = aDecoder.decodeObject(forKey: "additional_info") as? AdditionalInformation
        
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(self.auth_token, forKey: "auth_token")
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.email, forKey: "email")
        aCoder.encode(self.first_name, forKey: "first_name")
        aCoder.encode(self.last_name, forKey: "last_name")
        
        aCoder.encode(self.phone_number, forKey: "phone_number")
        
        aCoder.encode(self.signup_type, forKey: "signup_type")
        aCoder.encode(self.is_verified, forKey: "is_verified")
        aCoder.encode(self.zipcode, forKey: "zipcode")
        aCoder.encode(self.zipcode, forKey: "contact_preference")
        aCoder.encode(self.additionalInformation, forKey: "additional_info")
    }
    
    // MARK: -
    
    class func prepareUser(dictionary: [String:Any]) -> User {
        
        let user = User()
        
        if let authtoken = dictionary["auth_token"] as? String {
            user.auth_token = authtoken
        }
        if let id = dictionary["id"] {
            user.id = "\(id)"
        }
        
        if let email = dictionary["email"] as? String {
            user.email = email
        }
        
        if let first_name = dictionary["first_name"] as? String {
            user.first_name = first_name
        }
        if let last_name = dictionary["last_name"] as? String {
            user.last_name = last_name
        }
        
        if let phone_number = dictionary["phone_number"]  {
            user.phone_number =  "\(phone_number)"
        }
        
        if let signup_type = dictionary["signup_type"] {
            user.signup_type = "\(signup_type)"
        }
        
        if let is_verified = dictionary["is_verified"] as? String {
            user.is_verified = is_verified
        }
        if let contact_preference = dictionary["contact_preference"]{
            user.contact_preference = "\(contact_preference)"
        }
        if let zip_code = dictionary["zipcode"]{
            user.zipcode = "\(zip_code)"
        }
        if let additionalInformation = dictionary["additional_info"] as? [String:Any] {
            user.additionalInformation = AdditionalInformation.prepareAdditionalInfo(dictionary: additionalInformation)
        }

        return user
    }
    
}

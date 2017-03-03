//
//  RecentActivity.swift
//  Snap2Save
//
//  Created by Malathi on 02/03/17.
//  Copyright © 2017 Appit. All rights reserved.
//

import Foundation
import UIKit
class RecentActivity: NSObject, NSCoding {
    
    var points = ""
    var title = ""
    var date_string = ""
    var date = ""
    
    var additionalInformation: AdditionalInformation?
    
    override init() {
        
    }
    
    // MARK: - NSCoding
    required init?(coder aDecoder: NSCoder) {
        
        self.points = aDecoder.decodeObject(forKey: "points") as? String ?? ""
        self.title = aDecoder.decodeObject(forKey: "title") as? String ?? ""
        
        self.date_string = aDecoder.decodeObject(forKey: "date_string") as? String ?? ""
        self.date = aDecoder.decodeObject(forKey: "date") as? String ?? ""

        
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(self.points, forKey: "points")
        aCoder.encode(self.title, forKey: "title")
        aCoder.encode(self.date_string, forKey: "date_string")
        aCoder.encode(self.date, forKey: "date")
        
    }
    
    // MARK: -
    
    class func prepareRewardActivity(dictionary: [String:Any]) -> RecentActivity {
        
        let rewardActivity = RecentActivity()
        
        if let points = dictionary["points"] {
            rewardActivity.points = "\(points)"
        }
        if let title = dictionary["title"] as? String {
            rewardActivity.title = title
        }
        
        if let email = dictionary["date_string"] as? String {
            rewardActivity.date_string = email
        }
        
        if let email = dictionary["date"] as? String {
            rewardActivity.date = email
        }

        
        return rewardActivity
    }
    
}

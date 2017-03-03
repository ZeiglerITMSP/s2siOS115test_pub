//
//  RewardStatus.swift
//  Snap2Save
//
//  Created by Malathi on 02/03/17.
//  Copyright © 2017 Appit. All rights reserved.
//

import Foundation
import UIKit
class RewardStatus: NSObject, NSCoding {
    
    var health_rebate = ""
    var life_time_points_earned = ""
    var current_points = ""
    
    var recentActivity: RecentActivity?
    
    override init() {
        
    }
    
    // MARK: - NSCoding
    required init?(coder aDecoder: NSCoder) {
        
        self.health_rebate = aDecoder.decodeObject(forKey: "health_rebate") as? String ?? ""
        self.life_time_points_earned = aDecoder.decodeObject(forKey: "life_time_points_earned") as? String ?? ""
        
        self.current_points = aDecoder.decodeObject(forKey: "current_points") as? String ?? ""
        self.recentActivity = aDecoder.decodeObject(forKey: "recent_activity") as? RecentActivity
        
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(self.health_rebate, forKey: "health_rebate")
        aCoder.encode(self.life_time_points_earned, forKey: "life_time_points_earned")
        aCoder.encode(self.current_points, forKey: "current_points")
        
        
        aCoder.encode(self.recentActivity, forKey: "recent_activity")
    }
    
    // MARK: -
    
    class func prepareRewardStatus(dictionary: [String:Any]) -> RewardStatus {
        
        let rewardStatus = RewardStatus()
        
        if let healthRebate = dictionary["health_rebate"] {
            rewardStatus.health_rebate = "\(healthRebate)"
        }
        if let lifeTimePoints = dictionary["life_time_points_earned"] as? String {
            rewardStatus.life_time_points_earned = lifeTimePoints
        }
        
        if let email = dictionary["current_points"] as? String {
            rewardStatus.current_points = email
        }
        
        if let recentActivity = dictionary["recent_activity"] as? [String:Any] {
            //rewardStatus.recent_activity = re.prepareAdditionalInfo(dictionary: additionalInformation)
            
            rewardStatus.recentActivity  = RecentActivity.prepareRewardActivity(dictionary: recentActivity)
        }
        
        return rewardStatus
    }
    
}

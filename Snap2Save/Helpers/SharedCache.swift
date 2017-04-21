//
//  SharedCache.swift
//  Snap2Save
//
//  Created by Appit on 4/21/17.
//  Copyright © 2017 Appit. All rights reserved.
//

import UIKit

class SharedCache: NSObject {
    
    static let shared: SharedCache = SharedCache()
    
    let imageCache = NSCache<NSString, UIImage>()
    
    private override init() {
        super.init()
        
        
    }
    
    
}

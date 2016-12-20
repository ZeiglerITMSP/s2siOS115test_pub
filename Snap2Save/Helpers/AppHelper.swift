//
//  AppHelper.swift
//  Snap2Save
//
//  Created by Malathi on 19/12/16.
//  Copyright © 2016 Appit. All rights reserved.
//

import Foundation
import UIKit

class AppHelper
{
class func setRoundCornersToView(borderColor:UIColor,view:UIView,radius:CGFloat,width:CGFloat)
{
    view.layer.cornerRadius = radius
    view.layer.borderColor = borderColor.cgColor
    view.layer.borderWidth = width
    view.layer.masksToBounds = true
    ////print("border created")
}
    
}

extension UIColor {
    public convenience init?(hexString: String) {
        let r, g, b, a: CGFloat
        
        if hexString.hasPrefix("#") {
            let start = hexString.index(hexString.startIndex, offsetBy: 1)
            let hexColor = hexString.substring(from: start)
            
            if hexColor.characters.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        
        return nil
    }
}
extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}

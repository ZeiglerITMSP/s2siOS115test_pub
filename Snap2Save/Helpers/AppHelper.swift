//
//  AppHelper.swift
//  Snap2Save
//
//  Created by Malathi on 19/12/16.
//  Copyright © 2016 Appit. All rights reserved.
//

import Foundation
import UIKit
import Localize_Swift

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
    class func imageWithColor( color:UIColor) -> UIImage
    {
        
        let rect = CGRect.init(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContextWithOptions(CGSize.init(width: 1.0, height: 1.0), false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return image
    }
    
    class func validMobileNumber( mobileNumber : String) -> Bool{
        
        if  mobileNumber.characters.count == 10{
            return true
        }
        return false
    }
    
   class  func validate(value: String) -> Bool {
    let PHONE_REGEX = "^\\d{3}\\d{3}\\d{4}$"
    let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
    let result =  phoneTest.evaluate(with: value)
    return result
    }
    
    class func isValidEmail(testStr:String) -> Bool {
        // //print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
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

// MARK: - Alert
extension UIViewController {
    
    func showAlert(title:String? , message:String?) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        DispatchQueue.main.async {
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func showAlert(title:String? , message:String?, action:Selector) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        
        let okAction = UIAlertAction(title: "OK", style: .destructive, handler: { alert in
            self.perform(action)
        })
        
        let cancelAction = UIAlertAction(title: "CANCEL", style: .cancel, handler: nil)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        DispatchQueue.main.async {
            
            self.present(alertController, animated: true, completion: nil)
        }
    }

    
}


// MARK: - Navigation Bar
extension UIViewController {
    
    func updateBackButtonText() {
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back".localized() , style: .plain, target: nil, action: nil)
    }
}

extension UINavigationItem {
    
    func addBackButton(withTarge target: Any, action: Selector) {
        
        // Back Action
        let backButton = UIButton.init(type: .custom)
        backButton.frame = CGRect(x:0,y:0,width:80,height:25)
        backButton.setImage(UIImage.init(named: "ic_back"), for: .normal)
        backButton.setTitle("Back", for: .normal)
        backButton.setTitleColor(UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.7), for: .normal)
        
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 17.0)
        backButton.addTarget(target, action: action, for: .touchUpInside)
        backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0)
        
        let leftBarButton = UIBarButtonItem()
        leftBarButton.customView = backButton
        self.leftBarButtonItem = leftBarButton
    }
    
}





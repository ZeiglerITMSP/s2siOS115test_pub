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
    
    func showAlert(title:String , message:String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        DispatchQueue.main.async {
            
            self.present(alertController, animated: true, completion: nil)
        }
    }

    
}


// MARK: - Navigation Bar
extension UIViewController {
    
    func updateBackButtonText() {
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
    }
}

// MARK: - Language
extension UIViewController {
    
    
    func showLanguageSelectionAlert(){
        let languageAlert = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        
        
        let englishBtn = UIAlertAction.init(title: "English".localized(), style: .default, handler:{
            (action) in
            print("Selected English")
            Localize.setCurrentLanguage("en")
            
        })
        let spanishBtn = UIAlertAction.init(title: "Spanish".localized(), style: .default, handler:{ (action) in
            print("Selected Spanish")
            Localize.setCurrentLanguage("es")
        })
        let cancelBtn = UIAlertAction.init(title: "Cancel".localized(), style: .cancel, handler:{
            (action) in
            
        })
        
        languageAlert.view.tintColor = APP_GRREN_COLOR
        languageAlert .addAction(englishBtn)
        languageAlert.addAction(spanishBtn)
        languageAlert.addAction(cancelBtn)
        
        self.present(languageAlert, animated: true, completion:nil)
    }
    
    
}




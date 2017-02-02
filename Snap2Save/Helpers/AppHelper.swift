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
import LocalAuthentication

class AppHelper {
    
    class func getImage(fromURL urlString:String, completion: (_ image: UIImage?, _ success: Bool) -> Void) {
        guard let url = NSURL(string: urlString),
            let data = NSData(contentsOf: url as URL),
            let image = UIImage(data: data as Data)
            else {
                completion(nil, false);
                return
        }
        
        completion(image, true)
    }
    
    class func setRoundCornersToView(borderColor:UIColor?,view:UIView,radius:CGFloat,width:CGFloat) {
        
        view.layer.cornerRadius = radius
        if let borderColor = borderColor {
            view.layer.borderColor = borderColor.cgColor
            view.layer.borderWidth = width
        }
        
        view.layer.masksToBounds = true
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
    
    
    class  func validate(value: String) -> Bool {
        let PHONE_REGEX = "^\\d{3}\\d{3}\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        return result
    }
    
    class func isValidEmail(testStr:String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    class func isValid(input:String) -> Bool {
        
        let regex = try! NSRegularExpression(pattern: ".*[^A-Za-z0-9].*", options: NSRegularExpression.Options())
        if regex.firstMatch(in: input, options: NSRegularExpression.MatchingOptions(), range:NSMakeRange(0, input.characters.count)) != nil {
            return false
        }
        
        return true
    }
    
    
    class func removeSpecialCharacters(fromNumber inputString:String) -> String {
        let validCharacters : Set<Character> = Set("1234567890".characters)
        return String(inputString.characters.filter {validCharacters.contains($0) })
    }
    
    
    class func makeAsRequired(text:String) -> NSAttributedString {
        
        let mobileNumTxt = text + " *"
        let mobileNumTxtAttribute = NSMutableAttributedString.init(string: mobileNumTxt)
        
        let string_to_color = "*"
        let contactStrRange = (mobileNumTxt as NSString).range(of: string_to_color)
        
        mobileNumTxtAttribute.addAttribute(NSForegroundColorAttributeName, value: APP_ORANGE_COLOR , range: contactStrRange)
        
        return mobileNumTxtAttribute
    }
    
    class func configSwiftLoader() {
        
        SwiftLoader.setConfig(getConfigSwiftLoader())
    }
    
    class func getConfigSwiftLoader() -> SwiftLoader.Config {
        
        var config : SwiftLoader.Config = SwiftLoader.Config()
        config.size = 110
        config.spinnerColor = APP_GRREN_COLOR
        config.foregroundColor = .black
        config.backgroundColor = .white
        config.foregroundAlpha = 0.1
        config.titleTextColor = APP_GRREN_COLOR
        
        return config
    }
    

    class func isTouchIDAvailable() -> Bool {
        
        let context = LAContext()
        var error: NSError?
        let status = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        return status
    }
    
    
    class func getScreenName(screenName : String) {
        
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: screenName)
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
 
    }
 
}


extension String {
    
    public func makeAsRequired() -> NSAttributedString {
        
        let mobileNumTxt = self + " *"
        let mobileNumTxtAttribute = NSMutableAttributedString.init(string: mobileNumTxt)
        
        let string_to_color = "*"
        let contactStrRange = (mobileNumTxt as NSString).range(of: string_to_color)
        
        mobileNumTxtAttribute.addAttribute(NSForegroundColorAttributeName, value: MandatoryColor , range: contactStrRange)
        
        return mobileNumTxtAttribute
    }
    
    public func makeAstrikRequired() -> NSAttributedString {
        
        let mobileNumTxtAttribute = NSMutableAttributedString.init(string: self)
        
        let string_to_color = "*"
        let contactStrRange = (self as NSString).range(of: string_to_color)
        
        mobileNumTxtAttribute.addAttribute(NSForegroundColorAttributeName, value: MandatoryColor , range: contactStrRange)
        
        return mobileNumTxtAttribute
    }
    
}

extension String {
    
    func removeWhiteSpaces() -> String {
        
        return self.trimmingCharacters(in: .whitespaces)
    }
    
    
    //    func heightWith(constrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
    //        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
    //        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
    //
    //        return boundingBox.height
    //    }
    
    func height(constraintedWidth width: CGFloat, font: UIFont) -> CGFloat {
        
        let label =  UILabel(frame: CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.text = self
        label.sizeToFit()
        
        return label.frame.height
    }
    
    public func toPhoneNumber() -> String {
        return self.replacingOccurrences(of: "(\\d{3})(\\d{3})(\\d+)", with: "($1) $2-$3", options: .regularExpression, range: nil)
    }
    
    
}

extension Dictionary where Value: Equatable {
    
    func getKey(forValue val: Value) -> Key? {
        return first(where: { $1 == val })?.0
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


// MARK: - Alert
extension UIViewController {
    
    func showAlert(title:String? , message:String?) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK".localized() , style: .default, handler: nil)
        alertController.addAction(defaultAction)
        DispatchQueue.main.async {
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func showAlert(title:String? , message:String?, action:Selector?, showCancel:Bool? = true) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        
        let okAction = UIAlertAction(title: "OK".localized() , style: .default, handler: { alert in
            
            if action != nil {
                self.perform(action)
            }
        })
        
        let cancelAction = UIAlertAction(title: "CANCEL".localized() , style: .cancel, handler: nil)
        
        alertController.addAction(okAction)
        
        if showCancel == true {
            alertController.addAction(cancelAction)
        }
        
        DispatchQueue.main.async {
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    
}


// MARK: - Navigation Bar
extension UIViewController {
    
    func updateBackButtonText() {
        
        let backButton = self.navigationItem.leftBarButtonItem?.customView as? UIButton
        backButton?.setTitle("Back".localized() , for: .normal)
        
    }
}

extension UINavigationItem {
    
    func addBackButton(withTarge target: Any, action: Selector) {
        
        // Back Action
        let backButton = UIButton.init(type: .custom)
        backButton.frame = CGRect(x:0,y:0,width:80,height:25)
        backButton.setImage(UIImage.init(named: "ic_back"), for: .normal)
        backButton.setTitle("Back".localized() , for: .normal)
        backButton.setTitleColor(UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0), for: .normal)
        
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 17.0)
        backButton.addTarget(target, action: action, for: .touchUpInside)
        backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0)
        
        let leftBarButton = UIBarButtonItem()
        leftBarButton.customView = backButton
        self.leftBarButtonItem = leftBarButton
    }
    
}


public extension UIImage {
    
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
    
}
public extension Bundle {
    
   public var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
   public var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}

public extension UIImageView {
    
    
    
    
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit, failAction:Selector?, target:UIViewController) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else {
                 
                    DispatchQueue.main.async() { () -> Void in
                    

                    if failAction != nil {
                        
                        target.perform(failAction)
                    }
                    }
                    return
            }
            DispatchQueue.main.async() { () -> Void in
                SwiftLoader.hide()
                self.image = image
            }
            }.resume()
    }
    
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit, failAction:Selector?, target:UIViewController) {
        guard let url = URL(string: link)
            else {
                
                if failAction != nil {
                        target.perform(failAction)
                }
                return
        }
        downloadedFrom(url: url, contentMode: mode, failAction: failAction, target: target)
    }
}







//
//  LanguageUtility.swift
//  Snap2Save
//
//  Created by Appit on 12/26/16.
//  Copyright © 2016 Appit. All rights reserved.
//

import UIKit
import Localize_Swift

class LanguageUtility: NSObject {

    // Language button
    class func createLanguageSelectionButton(withTarge target:Any, action:Selector) -> UIButton {
        
        let languageButton = UIButton.init(type: .system)
        languageButton.frame = CGRect(x:0,y:0,width:60,height:25)
        languageButton.setTitle("ENGLISH".localized(), for: .normal)
        languageButton.setTitleColor(UIColor.white, for: .normal)
        languageButton.backgroundColor = UIColor.init(red: 232.0/255.0, green: 126.0/255.0, blue: 51.0/255.0, alpha: 1.0)
        languageButton.addTarget(target, action: action, for: .touchUpInside)
        languageButton.titleLabel?.font = UIFont.systemFont(ofSize: 11.0)
        AppHelper.setRoundCornersToView(borderColor: UIColor.init(red: 232.0/255.0, green: 126.0/255.0, blue: 51.0/255.0, alpha: 1.0), view:languageButton , radius:2.0, width: 1.0)
        
        return languageButton
    }
    
    class func addLanguageButton(_ languageButton:UIButton, toController controller:UIViewController) {
        
        let rightBarButton = UIBarButtonItem()
        rightBarButton.customView = languageButton
        controller.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    
    // Notifications
    class func addOberverForLanguageChange(_ observer:Any, selector:Selector) {
    
        NotificationCenter.default.addObserver(observer,
                                               selector: selector,
                                               name: NSNotification.Name( LCLLanguageChangeNotification),
                                               object: nil)
    }
    
    class func removeObserverForLanguageChange(_ observer:Any) {
        
        NotificationCenter.default.removeObserver(observer, name: NSNotification.Name( LCLLanguageChangeNotification), object: nil)
    }
    
    
}

// MARK: - Language
extension UIViewController {
    
    /// Language selection alert
    func showLanguageSelectionAlert() {
        
        let languageAlert = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let englishBtn = UIAlertAction.init(title: "language.alert.english".localized(), style: .default, handler: {
            (action) in
            print("Selected English")
            Localize.setCurrentLanguage("en")
            
        })
        let spanishBtn = UIAlertAction.init(title: "language.alert.spanish".localized() , style: .default, handler:{ (action) in
            print("Selected Spanish")
            Localize.setCurrentLanguage("es")
        })
        
        let cancelBtn = UIAlertAction.init(title: "Cancel".localized(), style: .cancel, handler:nil)
        
        languageAlert.view.tintColor = APP_GRREN_COLOR
        languageAlert .addAction(englishBtn)
        languageAlert.addAction(spanishBtn)
        languageAlert.addAction(cancelBtn)
        
        self.present(languageAlert, animated: true, completion:nil)
    }

}

//
//  TabViewController.swift
//  Snap2Save
//
//  Created by Appit on 12/29/16.
//  Copyright © 2016 Appit. All rights reserved.
//

import UIKit

class TabViewController: UITabBarController {

    
    let titles = ["OFFERS", "SERVICES", "ACCOUNT", "WebView"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        selectedTabBackground()
        updateTabBarItemsTitle()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        LanguageUtility.addOberverForLanguageChange(self, selector: #selector(updateTabBarItemsTitle))
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        LanguageUtility.removeObserverForLanguageChange(self)
        super.viewDidDisappear(animated)
    }

    
    // MARK: -
    
    func selectedTabBackground() {
        
        self.tabBar.tintColor = UIColor.white
        
        let imageWidht = Int(UIScreen.main.bounds.size.width) / (self.tabBar.items?.count)!
        let imageHeight = self.tabBar.frame.height / 2
        
        let size = CGSize(width: CGFloat(imageWidht / 2) + 2, height: imageHeight)
        // create image
        let color = UIColor(red: 84/255, green: 190/255, blue: 56/255, alpha: 1.0)
        let tabIndicatorImage = UIImage(color: color , size: size)
        
        self.tabBar.selectionIndicatorImage = tabIndicatorImage
    }
    
    func updateTabBarItemsTitle() {
        
        if (self.tabBar.items != nil) {
            
            for index in 0..<self.tabBar.items!.count {
                
                let tabBarItem = self.tabBar.items![index]
                tabBarItem.title = titles[index].localized()
            }
        }
    }

    
}

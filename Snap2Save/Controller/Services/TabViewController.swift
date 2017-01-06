//
//  TabViewController.swift
//  Snap2Save
//
//  Created by Appit on 12/29/16.
//  Copyright © 2016 Appit. All rights reserved.
//

import UIKit

class TabViewController: UITabBarController {

    // Properties
    let titles = ["OFFERS", "SERVICES", "ACCOUNT", "WebView"]
    var bgView:UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
        self.tabBar.tintColor = UIColor.white
        
        updateTabBarItemsTitle()
        
        self.selectedIndex = 0
        updateSelectedItemBackground()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        updateSelectedItemBackground()
        LanguageUtility.addOberverForLanguageChange(self, selector: #selector(updateTabBarItemsTitle))
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        LanguageUtility.removeObserverForLanguageChange(self)
        super.viewDidDisappear(animated)
    }

    
    // MARK: -
    
    
    func updateSelectedItemBackground() {
        
         DispatchQueue.main.async {
            
            
            if self.bgView != nil {
                self.bgView.removeFromSuperview()
            }
            
            // Add background color to middle tabBarItem
            let itemIndex = self.selectedIndex
            
            let bgColor = UIColor(red: 84/255, green: 190/255, blue: 56/255, alpha: 1.0)
            
            let itemWidth = self.tabBar.frame.width / CGFloat(self.tabBar.items!.count)
            
            let positionX = itemWidth * CGFloat(itemIndex)
            
            self.bgView = UIView(frame: CGRect(x: positionX, y: 0, width: itemWidth, height: self.tabBar.frame.height))
            
            self.bgView.backgroundColor = bgColor
            
            self.tabBar.insertSubview(self.bgView, at: 1)
            
        }
        
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

extension TabViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        updateSelectedItemBackground()
    }
    
}



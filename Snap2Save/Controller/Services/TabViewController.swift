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
        
        addSeperatorsToTabBar()
        
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
    
    func addSeperatorsToTabBar() {
        
        let itemWidth = (self.tabBar.frame.size.width / CGFloat(self.tabBar.items!.count))
        // this is the separator width.  0.5px matches the line at the top of the tab bar
        let separatorWidth: CGFloat = 0.5
        // iterate through the items in the Tab Bar, except the last one
        for i in 0...(self.tabBar.items!.count - 2) {
            // make a new separator at the end of each tab bar item
            let separator = UIView(frame: CGRect(x: itemWidth * CGFloat(i + 1) - CGFloat(separatorWidth / 2), y: 0, width: CGFloat(separatorWidth), height: self.tabBar.frame.size.height))
            // set the color to light gray (default line color for tab bar)
            separator.backgroundColor = UIColor.lightGray
            
            self.tabBar.addSubview(separator)
            self.tabBar.bringSubview(toFront: separator)
        }
        
    }
    
    @objc func updateTabBarItemsTitle() {
        
        if (self.tabBar.items != nil) {
            
            for index in 0..<self.tabBar.items!.count {
                
                let tabBarItem = self.tabBar.items![index]
                var title = ""
                switch index {
                case 0:
                    title = "OFFERS".localized()
                case 1:
                    title = "SERVICES".localized()
                case 2:
                    title = "ACCOUNT".localized()
                case 3:
                    title = "EBT HELP".localized()
                    
                default: break
                    
                }
                tabBarItem.title = title
//                tabBarItem.title = titles[index].localized()
            }
        }
    }
    
    func removeHelpTab() {
        
        //        let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "EBTHelpVCNavigation") as! UINavigationController
        
        let tabBarController = self.tabBarController as! TabViewController
        if tabBarController.viewControllers?.count == 4 {
            tabBarController.viewControllers?.removeLast()
            tabBarController.updateSelectedItemBackground()
        }
    }
    
    func backAction() {

        //    _ = self.navigationController?.popToRootViewController(animated: true)
        showAlert(title: "ebt.processTerminate.title".localized(),
                  message: "ebt.processTerminate.dashboard".localized(), action: #selector(cancelProcess))
    }

    @objc func cancelProcess() {
        let navController = self.selectedViewController as? UINavigationController
        _ = navController?.popToRootViewController(animated: true)
    }

}

extension TabViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        if tabBarController.selectedIndex == 0 {
            if viewController.childViewControllers.count > 1 {
                if let offersNavVC = viewController as? UINavigationController {
                    offersNavVC.popToRootViewController(animated: false)
                }
            }
        }
        updateSelectedItemBackground()
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if isViewingDashboard {
            self.backAction()
            return false
        } else {
            return true
        }
    }
}



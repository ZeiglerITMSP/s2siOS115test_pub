//
//  WelcomePageVC.swift
//  Snap2Save
//
//  Created by Appit on 12/19/16.
//  Copyright © 2016 Appit. All rights reserved.
//

import UIKit

class WelcomePageVC: UIViewController {
//outlets
    
    @IBOutlet var congratulationsLabel: UILabel!
    
    @IBOutlet var welcomeToLabel: UILabel!
    
    @IBOutlet var getStartedButton: UIButton!
    
    @IBAction func getStartedButtonAction(_ sender: UIButton) {
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        congratulationsLabel.text = "Congratulations!".localized
        welcomeToLabel.text = "WelcomeText".localized
        getStartedButton.setTitle("Get Started!".localized, for: .normal)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  OffersVC.swift
//  Snap2Save
//
//  Created by Appit on 1/3/17.
//  Copyright © 2017 Appit. All rights reserved.
//

import UIKit

class OffersVC: UIViewController {

    var languageSelectionButton: UIButton!

    // Outlets
    
    @IBOutlet var offersImageView: UIImageView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        languageSelectionButton = LanguageUtility.createLanguageSelectionButton(withTarge: self, action: #selector(languageButtonClicked))
        LanguageUtility.addLanguageButton(languageSelectionButton, toController: self)
        reloadContent()
        
        let tapGes : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(tapGesClicked))
        tapGes.numberOfTapsRequired = 1
        tapGes.numberOfTouchesRequired = 1
        offersImageView.addGestureRecognizer(tapGes)
        
        offersImageView.image = UIImage.init(named: "snap2save.jpeg")
        offersImageView.isUserInteractionEnabled = true
        offersImageView.contentMode = .scaleAspectFit
        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadContent()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        LanguageUtility.addOberverForLanguageChange(self, selector: #selector(reloadContent))
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        LanguageUtility.removeObserverForLanguageChange(self)
        super.viewDidDisappear(animated)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func languageButtonClicked() {
        self.showLanguageSelectionAlert()
    }

    
    func reloadContent() {
        
        DispatchQueue.main.async {
            self.languageSelectionButton.setTitle("language.button.title".localized(), for: .normal)
            self.navigationItem.title = "Offers".localized()

        }
        
    }
    
    func tapGesClicked() {
        
       let offerDetails = UIStoryboard.init(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "OffersDetailsViewController") as! OffersDetailsViewController
        offerDetails.urlString = "http://www.snap2save.com/app/about_comingsoon.php"
        self.navigationController?.show(offerDetails, sender: self)
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

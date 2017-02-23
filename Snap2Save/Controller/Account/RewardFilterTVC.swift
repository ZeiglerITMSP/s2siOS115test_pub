//
//  RewardFilterTVC.swift
//  Snap2Save
//
//  Created by Appit on 2/22/17.
//  Copyright © 2017 Appit. All rights reserved.
//

import UIKit

class RewardFilterTVC: UITableViewController,AITextFieldProtocol {

    // Properties
    var languageSelectionButton: UIButton!
    
    // Outlets
    
    
    @IBOutlet var dateRange: UILabel!
    
    @IBOutlet weak var fromDateField: AIPlaceHolderTextField!
    @IBOutlet weak var toDateField: AIPlaceHolderTextField!
    @IBOutlet weak var filterButton: UIButton!
    // Actions
    @IBAction func filterButtonAction(_ sender: UIButton) {
        

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // config fields
        reloadContent()
        fromDateField.contentTextField.setRightGap(width: 10, placeHolderImage: UIImage(named:"ic_downarrow_input")!)
        fromDateField.contentTextField.textFieldType = .DatePickerTextField
        fromDateField.contentTextField.updateUIAsPerTextFieldType()
        
        toDateField.contentTextField.setRightGap(width: 10, placeHolderImage: UIImage(named:"ic_downarrow_input")!)
        toDateField.contentTextField.textFieldType = .DatePickerTextField
        toDateField.contentTextField.updateUIAsPerTextFieldType()
        // button style
        AppHelper.setRoundCornersToView(borderColor: APP_ORANGE_COLOR, view: filterButton, radius: 2.0, width: 1.0)
        
        fromDateField.contentTextField.aiDelegate = self
        toDateField.contentTextField.aiDelegate = self
        
        // language button
        languageSelectionButton = LanguageUtility.createLanguageSelectionButton(withTarge: self, action: #selector(languageButtonClicked))
        LanguageUtility.addLanguageButton(languageSelectionButton, toController: self)
        
        // Automatic height
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44
        
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        // back
        self.navigationItem.addBackButton(withTarge: self, action: #selector(backAction))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
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
    
    // MARK: -
    func backAction() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func languageButtonClicked() {
        self.showLanguageSelectionAlert()
    }
    
    func reloadContent() {
        
        DispatchQueue.main.async {
            self.updateBackButtonText()
            self.languageSelectionButton.setTitle("language.button.title".localized(), for: .normal)
            self.navigationItem.title = "Reward Status".localized()
            self.fromDateField.placeholderText = "FROM".localized()
            self.toDateField.placeholderText = "TO".localized()
            
            self.dateRange.text = "DATE RANGE".localized()
            self.filterButton.setTitle("FILTER".localized(), for: .normal)
            self.tableView.reloadData()
        }
    }
    
    // MARK :-
    
    func keyBoardHidden(textField: UITextField) {
        if textField == fromDateField.contentTextField {
            fromDateField.contentTextField.resignFirstResponder()
            toDateField.contentTextField.becomeFirstResponder()
        }
        
        else if textField == toDateField.contentTextField {
            toDateField.contentTextField.resignFirstResponder()
        }
    }
    
    
}

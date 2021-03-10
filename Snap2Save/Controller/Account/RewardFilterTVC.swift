//
//  RewardFilterTVC.swift
//  Snap2Save
//
//  Created by Appit on 2/22/17.
//  Copyright © 2017 Appit. All rights reserved.
//

import UIKit

@objc protocol RewardFilterProtocol {
    @objc optional func rewardFilter(fromDate : String ,toDate : String)
}


class RewardFilterTVC: UITableViewController, AITextFieldProtocol {

    // Properties
    var languageSelectionButton: UIButton!
    var rewardFilterDelegate : RewardFilterProtocol?
    var presentedVC: RewardStatusTVC?
    var toDateTime : String = String()
    var fromDateTime : String = String()
    // Outlets
    
    @IBOutlet var dateRange: UILabel!
    @IBOutlet weak var fromDateField: AIPlaceHolderTextField!
    @IBOutlet weak var toDateField: AIPlaceHolderTextField!
    @IBOutlet weak var filterButton: UIButton!
    // Actions
    @IBAction func filterButtonAction(_ sender: UIButton) {
        
        if !isValid(){
            return
        }
        let fromDateStr = fromDateField.contentTextField.text!
        fromDateTime = fromDateStr + " 00:00 AM"
        let endDateStr = toDateField.contentTextField.text!
        toDateTime = endDateStr + " 11:59 PM"
        
       // presentedVC?.fromDate = fromDateField.contentTextField.text!

        //presentedVC?.toDate = toDateField.contentTextField.text!
         presentedVC?.fromDate = fromDateTime

        presentedVC?.toDate = toDateTime
        
        presentedVC?.isFromFilterScreen = true
        
        _ = self.navigationController?.popViewController(animated: true)

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
        
        fromDateField.contentTextField.dateFormatString = "MM/dd/yy"
        toDateField.contentTextField.dateFormatString = "MM/dd/yy"
        
        
        let myMutableStringTitle = NSMutableAttributedString(string:"MM/DD/YY".localized(), attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14.0)]) // Font
        fromDateField.contentTextField.attributedPlaceholder = myMutableStringTitle
        toDateField.contentTextField.attributedPlaceholder = myMutableStringTitle

        AppHelper.setRoundCornersToView(borderColor: APP_ORANGE_COLOR, view: filterButton, radius: 2.0, width: 1.0)
        
        fromDateField.contentTextField.aiDelegate = self
        toDateField.contentTextField.aiDelegate = self
        
        // language button
        languageSelectionButton = LanguageUtility.createLanguageSelectionButton(withTarge: self, action: #selector(languageButtonClicked))
        LanguageUtility.addLanguageButton(languageSelectionButton, toController: self)
        
        // Automatic height
        self.tableView.rowHeight = UITableView.automaticDimension
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
        super.viewWillAppear(animated)
        reloadContent()
        AppHelper.getScreenName(screenName: "Reward Filter screen")
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
    @objc func backAction() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @objc func languageButtonClicked() {
        self.showLanguageSelectionAlert()
    }
    
    @objc func reloadContent() {
        
        DispatchQueue.main.async {
            self.updateBackButtonText()
            self.languageSelectionButton.setTitle("language.button.title".localized(), for: .normal)
            self.updateTextFieldsUi()
            self.navigationItem.title = "Reward Status".localized()
            self.fromDateField.placeholderText = "FROM".localized()
            self.toDateField.placeholderText = "TO".localized()
            
            self.dateRange.text = "DATE RANGE".localized()
            self.filterButton.setTitle("FILTER".localized(), for: .normal)
            
            self.fromDateField.contentTextField.placeholder = "MM/DD/YY".localized()
            self.toDateField.contentTextField.placeholder = "MM/DD/YY".localized()
            
            let myMutableStringTitle = NSMutableAttributedString(string:"MM/DD/YY".localized(), attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14.0)]) // Font
            self.fromDateField.contentTextField.attributedPlaceholder = myMutableStringTitle
            self.toDateField.contentTextField.attributedPlaceholder = myMutableStringTitle
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
    func updateTextFieldsUi(){
        
        fromDateField.contentTextField.updateUIAsPerTextFieldType()
        toDateField.contentTextField.updateUIAsPerTextFieldType()
        
    }

    func isValid() -> Bool {
        
       
        if fromDateField.contentTextField.text?.count == 0 || toDateField.contentTextField.text?.count == 0
        {
            showAlert(title: "", message: "Please enter a date range to view specific transactions.".localized())
            return false

        }
        
//        if toDateField.contentTextField.text?.characters.count == 0 {
//            showAlert(title: "", message: "Please enter to date.".localized())
//            return false
//            
//        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        
        var fromDateMilliSec : Double = 0.0
        var toDateMilliSec : Double = 0.0
        
     /*   if (fromDateField?.contentTextField.text?.characters.count)! > 0 {
            let fromDateVal = dateFormatter.date(from: fromDateField.contentTextField.text!)
            fromDateMilliSec = CUnsignedLongLong((fromDateVal?.timeIntervalSince1970)!*1000)
        }
        
        if (toDateField?.contentTextField.text?.characters.count)! > 0 {
            let toDateVal = dateFormatter.date(from: toDateField.contentTextField.text!)
            toDateMilliSec = CUnsignedLongLong((toDateVal?.timeIntervalSince1970)!*1000)
        }
        */
        
        
       /* if (fromDateField?.contentTextField.text?.characters.count)! > 0 {
            let fromDateVal = dateFormatter.date(from: fromDateField.contentTextField.text!)
            fromDateMilliSec = Int64(((fromDateVal?.timeIntervalSince1970)!*1000.0).rounded())
            
           // print("Double value \(fromDateMilliSecdouble)")
            
          //  print("Unsigned value \(fromDateMilliSec)")
        }
        
        if (toDateField?.contentTextField.text?.characters.count)! > 0 {
            let toDateVal = dateFormatter.date(from: toDateField.contentTextField.text!)
            toDateMilliSec = Int64(((toDateVal?.timeIntervalSince1970)!*1000.0).rounded())
            
        }
*/
        if (fromDateField?.contentTextField.text?.count)! > 0 {
            let fromDateVal = dateFormatter.date(from: fromDateField.contentTextField.text!)
            
            fromDateMilliSec = (fromDateVal?.timeIntervalSince1970)!*1000
            
            // print("Double value \(fromDateMilliSecdouble)")
            
            //  print("Unsigned value \(fromDateMilliSec)")
        }
        
        if (toDateField?.contentTextField.text?.count)! > 0 {
            let toDateVal = dateFormatter.date(from: toDateField.contentTextField.text!)
            //let toDateVal = dateFormatter.date(from: toDateTime)

            toDateMilliSec = (toDateVal?.timeIntervalSince1970)!*1000
            
        }

        
        if fromDateMilliSec > toDateMilliSec {
            showAlert(title: "", message: "The TO date must be later than or equal to the FROM date.".localized())
            return false
        }

        return true
    }
}

//
//  RedeemPointsAddressTVC.swift
//  Snap2Save
//
//  Created by Malathi on 23/02/17.
//  Copyright © 2017 Appit. All rights reserved.
//

import UIKit

class RedeemPointsAddressTVC: UITableViewController,AITextFieldProtocol {

    enum DropDownTags:Int {
        case states = 100
    }

    var languageSelectionButton: UIButton!

    var statesArray : NSMutableArray?
    
    var selectedStateIndex : NSInteger!

    @IBOutlet var messageLabel: UILabel!
    
    @IBOutlet var mailingAddressLabel: UILabel!
    
    @IBOutlet var firstNameLabel: UILabel!
    
    @IBOutlet var firstNameTF: AITextField!
    
    @IBOutlet var lastNameLabel: UILabel!
    
    @IBOutlet var lastNameTf: AITextField!
    
    @IBOutlet var addressLine1Tf: AITextField!
    @IBOutlet var addressLine1Label: UILabel!
    
    @IBOutlet var addressLine2Label: UILabel!
    
    @IBOutlet var addressLine2Tf: AITextField!
    
    @IBOutlet var cityLabel: UILabel!
    
    @IBOutlet var cityTf: AITextField!
    
    @IBOutlet var stateLabel: UILabel!
    
    @IBOutlet var stateTf: AITextField!
    
    @IBOutlet var zipCodeLabel: UILabel!
    
    @IBOutlet var zipCodeTf: AITextField!
    
    @IBOutlet var redeemNowButton: UIButton!
    
    @IBOutlet var redeemNowActivityIndicator: UIActivityIndicatorView!
    
    @IBAction func redeemNowButtonAction(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "RedeemPointsMessageVC", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 80
        
        AppHelper.setRoundCornersToView(borderColor: APP_ORANGE_COLOR, view: redeemNowButton, radius: 2.0, width: 1.0)
        
        // language button
        reloadContent()
        languageSelectionButton = LanguageUtility.createLanguageSelectionButton(withTarge: self, action: #selector(languageButtonClicked))
        LanguageUtility.addLanguageButton(languageSelectionButton, toController: self)
        self.navigationItem.addBackButton(withTarge: self, action: #selector(backAction))
        loadTextFields();
        
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
            self.navigationItem.title = "Redeem Points".localized()
            self.messageLabel.text = "Your Save-A-Lot gift card will be mailed to the following address. If any of the information is incorrect or missing, please make changes or additions as necessary.".localized()
            self.mailingAddressLabel.text = "MAILING ADDRESS".localized()
            self.firstNameLabel.text = "FIRST NAME".localized()
            self.lastNameLabel.text = "LAST NAME".localized()
            self.addressLine1Label.text = "ADDRESS LINE 1".localized()
            self.addressLine2Label.text = "ADDRESS LINE 2".localized()
            self.cityLabel.text = "CITY".localized()
            self.stateLabel.text = "STATE".localized()
            self.zipCodeLabel.text = "ZIP CODE".localized()
            self.redeemNowButton.setTitle("REDEEM NOW".localized(), for: .normal)
            self.tableView.reloadData()
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 8
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func loadTextFields(){
        
        stateTf.tag = 100
        
        
        firstNameTF.textFieldType = AITextField.AITextFieldType.NormalTextField
        firstNameTF.updateUIAsPerTextFieldType()
        
        firstNameTF.createUnderline(withColor: APP_LINE_COLOR, padding: 0, height: 1)
        firstNameTF.placeHolderLabel = firstNameLabel
        //        mobileNumTextField.createBorder(borderColor: UIColor.red,xpos: 0)
        firstNameTF.setLeftGap(width: 0, placeHolderImage: UIImage.init())
        firstNameTF.setRightGap(width: 0, placeHolderImage: UIImage.init())
        firstNameTF.text_Color =  UIColor.black
        
        lastNameTf.textFieldType = AITextField.AITextFieldType.NormalTextField
        lastNameTf.updateUIAsPerTextFieldType()
        lastNameTf.createUnderline(withColor: APP_LINE_COLOR, padding: 0, height: 1)
        lastNameTf.placeHolderLabel = lastNameLabel
        //        mobileNumTextField.createBorder(borderColor: UIColor.red,xpos: 0)
        lastNameTf.setLeftGap(width: 0, placeHolderImage: UIImage.init())
        lastNameTf.setRightGap(width: 0, placeHolderImage: UIImage.init())
        lastNameTf.text_Color =  UIColor.black
        
        addressLine1Tf.textFieldType = AITextField.AITextFieldType.NormalTextField
        addressLine1Tf.updateUIAsPerTextFieldType()
        addressLine1Tf.createUnderline(withColor: APP_LINE_COLOR, padding: 0, height: 1)
        addressLine1Tf.placeHolderLabel = addressLine1Label
        //        mobileNumTextField.createBorder(borderColor: UIColor.red,xpos: 0)
        addressLine1Tf.setLeftGap(width: 0, placeHolderImage: UIImage.init())
        addressLine1Tf.setRightGap(width: 0, placeHolderImage: UIImage.init())
        addressLine1Tf.text_Color =  UIColor.black
        
        addressLine2Tf.textFieldType = AITextField.AITextFieldType.NormalTextField
        addressLine2Tf.updateUIAsPerTextFieldType()
        addressLine2Tf.createUnderline(withColor: APP_LINE_COLOR, padding: 0, height: 1)
        addressLine2Tf.placeHolderLabel = addressLine2Label
        //        mobileNumTextField.createBorder(borderColor: UIColor.red,xpos: 0)
        addressLine2Tf.setLeftGap(width: 0, placeHolderImage: UIImage.init())
        addressLine2Tf.setRightGap(width: 0, placeHolderImage: UIImage.init())
        addressLine2Tf.text_Color =  UIColor.black
        
       
        
        cityTf.textFieldType = AITextField.AITextFieldType.NormalTextField
        cityTf.updateUIAsPerTextFieldType()
        cityTf.createUnderline(withColor: APP_LINE_COLOR, padding: 0, height: 1)
        cityTf.placeHolderLabel = cityLabel
        //        mobileNumTextField.createBorder(borderColor: UIColor.red,xpos: 0)
        cityTf.setLeftGap(width: 0, placeHolderImage: UIImage.init())
        cityTf.setRightGap(width: 0, placeHolderImage: UIImage.init())
        cityTf.text_Color =  UIColor.black
        
        stateTf.textFieldType = AITextField.AITextFieldType.TextPickerTextField
        stateTf.updateUIAsPerTextFieldType()
        stateTf.createUnderline(withColor: APP_LINE_COLOR, padding: 0, height: 1)
        stateTf.placeHolderLabel = stateLabel
        //        mobileNumTextField.createBorder(borderColor: UIColor.red,xpos: 0)
        stateTf.setLeftGap(width: 0, placeHolderImage: UIImage.init())
        stateTf.setRightGap(width: 10, placeHolderImage:UIImage.init(named: "ic_downarrow_input")!)
        stateTf.text_Color =  UIColor.black
        
        zipCodeTf.textFieldType = AITextField.AITextFieldType.NumberTextField
        zipCodeTf.updateUIAsPerTextFieldType()
        zipCodeTf.createUnderline(withColor: APP_LINE_COLOR, padding: 0, height: 1)
        zipCodeTf.placeHolderLabel = zipCodeLabel
        //        mobileNumTextField.createBorder(borderColor: UIColor.red,xpos: 0)
        zipCodeTf.setLeftGap(width: 0, placeHolderImage: UIImage.init())
        zipCodeTf.setRightGap(width: 0, placeHolderImage: UIImage.init())
        zipCodeTf.text_Color =  UIColor.black
        
        
        firstNameTF.aiDelegate = self
        lastNameTf.aiDelegate = self
        addressLine1Tf.aiDelegate = self
        addressLine2Tf.aiDelegate = self
        stateTf.aiDelegate = self
        cityTf.aiDelegate = self
        zipCodeTf.aiDelegate = self
        
        var statesDict: NSDictionary?
        if let path = Bundle.main.path(forResource: "USStateAbbreviations", ofType: "plist") {
            statesDict = NSDictionary(contentsOfFile: path)
        }
        
        let states = statesDict?.allValues as! [String]
        let sortedStates = states.sorted { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending }
        
        statesArray = NSMutableArray()
        
        for state in sortedStates {
            statesArray?.add(state)
        }
        
        stateTf.pickerViewArray = statesArray
    }

    func updateTextFieldsUi(){
        
        firstNameTF.updateUIAsPerTextFieldType()
        lastNameTf.updateUIAsPerTextFieldType()
        addressLine1Tf.updateUIAsPerTextFieldType()
        addressLine2Tf.updateUIAsPerTextFieldType()
        cityTf.updateUIAsPerTextFieldType()
        stateTf.updateUIAsPerTextFieldType()
        zipCodeTf.updateUIAsPerTextFieldType()
        
    }

    
    // MARK: - AITextField Delegate
    
    func getSelectedIndexFromPicker(selectedIndex: NSInteger, textField: AITextField) {
        let index = selectedIndex
        //print(""Index\(index)")
        if (textField.tag == DropDownTags.states.rawValue) {
             selectedStateIndex = index
        }
    }

    func keyBoardHidden(textField: UITextField) {
        
        if textField == firstNameTF{
            lastNameTf.becomeFirstResponder()
        }
        else if textField == lastNameTf{
            addressLine1Tf.becomeFirstResponder()
        }
            
        else if textField == addressLine1Tf{
            addressLine2Tf.becomeFirstResponder()
        }
        else if textField == addressLine2Tf{
            cityTf.becomeFirstResponder()
        }
        else if textField == cityTf{
            stateTf.becomeFirstResponder()
        }
        else if textField == stateTf {
            zipCodeTf.becomeFirstResponder()
        }
        else {
            textField.resignFirstResponder()
        }
    }
    

}

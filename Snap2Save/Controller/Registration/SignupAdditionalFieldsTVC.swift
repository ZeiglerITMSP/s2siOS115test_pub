//
//  SignupAdditionalFieldsTVC.swift
//  Snap2Save
//
//  Created by Appit on 12/19/16.
//  Copyright © 2016 Appit. All rights reserved.
//

import UIKit

class SignupAdditionalFieldsTVC: UITableViewController ,UITextFieldDelegate,AITextFieldProtocol{

    
    @IBOutlet var earn200PointsLabel: UILabel!
    
    @IBOutlet var msgLabel: UILabel!
    
    @IBOutlet var userInfoLabel: UILabel!
    
    @IBOutlet var firstNameLabel: UILabel!
    
    @IBOutlet var lastNameLabel: UILabel!
    @IBOutlet var firstNameTextField: AITextField!
    
    @IBOutlet var lastNameTextField: AITextField!
    
    @IBOutlet var addressMsgLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    
    @IBOutlet var addressLine1Label: UILabel!
    
    @IBOutlet var addressLine2TextField: AITextField!
    @IBOutlet var addressLine1TextField: AITextField!
    @IBOutlet var addressLine2Label: UILabel!
    
    @IBOutlet var genderTextField: AITextField!
    @IBOutlet var genderLabel: UILabel!
    @IBOutlet var additionalInfoLabel: UILabel!
    
   
    @IBOutlet var ageGroupTextField: AITextField!
    @IBOutlet var ageGroupLabel: UILabel!
    @IBOutlet var ethnicityLabel: UILabel!
    @IBOutlet var ethnicityTextField: AITextField!

    @IBOutlet var registerButton: UIButton!
    
    @IBOutlet var referralCodeTextField: AITextField!
    @IBOutlet var referralCodeLabel: UILabel!
    @IBOutlet var groupCodeTextField: AITextField!
    @IBOutlet var groupCodeLabel: UILabel!
    
    @IBOutlet var cityLabel: UILabel!
    
    @IBOutlet var zipCodeTextField: AITextField!
    @IBOutlet var zipCodeLabel: UILabel!
    @IBOutlet var stateTextField: AITextField!
    @IBOutlet var stateLabel: UILabel!
    
    @IBOutlet var cityTextField: AITextField!
    @IBAction func registerButtonAction(_ sender: UIButton) {
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.title = "Register"
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 60
        self.navigationController?.navigationBar.isHidden = false

        let backButton = UIButton.init(type: .custom)
        backButton.frame = CGRect(x:0,y:0,width:80,height:25)
        backButton.setImage(UIImage.init(named: "ic_back"), for: .normal)
        backButton.setTitle("Back", for: .normal)
        backButton.setTitleColor(UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.7), for: .normal)
        
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 17.0)
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0)
        
        let leftBarButton = UIBarButtonItem()
        leftBarButton.customView = backButton
        self.navigationItem.leftBarButtonItem = leftBarButton
        
        let languageButton = UIButton.init(type: .system)
        languageButton.frame = CGRect(x:0,y:0,width:60,height:25)
        languageButton.setTitle("ENGLISH".localized, for: .normal)
        languageButton.setTitleColor(UIColor.white, for: .normal)
        languageButton.backgroundColor = UIColor.init(red: 232.0/255.0, green: 126.0/255.0, blue: 51.0/255.0, alpha: 1.0)
        languageButton.addTarget(self, action: #selector(languageButtonClicked), for: .touchUpInside)
        languageButton.titleLabel?.font = UIFont.systemFont(ofSize: 11.0)
        AppHelper.setRoundCornersToView(borderColor: UIColor.init(red: 232.0/255.0, green: 126.0/255.0, blue: 51.0/255.0, alpha: 1.0), view:languageButton , radius:2.0, width: 1.0)
        let rightBarButton = UIBarButtonItem()
        rightBarButton.customView = languageButton
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        let navBarBGImg = AppHelper.imageWithColor(color: APP_GRREN_COLOR)
        // super.setNavigationBarImage(image: navBarBGImg)
        self.navigationController?.navigationBar.setBackgroundImage(navBarBGImg, for: .default)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]

        loadTextFields();
    }

    func languageButtonClicked(){
        
        let languageAlert = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        let englishBtn = UIAlertAction.init(title: "English".localized, style: .default, handler:{
            (action) in
            print("Selected English")
        })
        let spanishBtn = UIAlertAction.init(title: "Spanish".localized, style: .default, handler:{
            (action) in
            print("Selected Spanish")
            
        })
        let cancelBtn = UIAlertAction.init(title: "Cancel", style: .cancel, handler:{
            (action) in
            
        })
        
        languageAlert.view.tintColor = APP_GRREN_COLOR
        languageAlert .addAction(englishBtn)
        languageAlert.addAction(spanishBtn)
        languageAlert.addAction(cancelBtn)
        
        self.present(languageAlert, animated: true, completion:nil)
        
    }
    func backButtonAction(){
        
        _ = self.navigationController?.popViewController(animated: true)
        
    }

    func loadTextFields(){
        
        AppHelper.setRoundCornersToView(borderColor: APP_ORANGE_COLOR, view: registerButton, radius: 2.0, width: 1.0)
        firstNameTextField.textFieldType = AITextField.AITextFieldType.PhoneNumberTextField
        firstNameTextField.updateUIAsPerTextFieldType()
        firstNameTextField.createUnderline(withColor: APP_LINE_COLOR, padding: 0, height: 1)
        firstNameTextField.placeHolderLabel = firstNameLabel
        //        mobileNumTextField.createBorder(borderColor: UIColor.red,xpos: 0)
        firstNameTextField.setLeftGap(width: 0, placeHolderImage: UIImage.init())
        firstNameTextField.setRightGap(width: 0, placeHolderImage: UIImage.init())
        firstNameTextField.text_Color =  UIColor.black
        
        lastNameTextField.textFieldType = AITextField.AITextFieldType.PhoneNumberTextField
        lastNameTextField.updateUIAsPerTextFieldType()
        lastNameTextField.createUnderline(withColor: APP_LINE_COLOR, padding: 0, height: 1)
        lastNameTextField.placeHolderLabel = lastNameLabel
        //        mobileNumTextField.createBorder(borderColor: UIColor.red,xpos: 0)
        lastNameTextField.setLeftGap(width: 0, placeHolderImage: UIImage.init())
        lastNameTextField.setRightGap(width: 0, placeHolderImage: UIImage.init())
        lastNameTextField.text_Color =  UIColor.black

        addressLine1TextField.textFieldType = AITextField.AITextFieldType.PhoneNumberTextField
        addressLine1TextField.updateUIAsPerTextFieldType()
        addressLine1TextField.createUnderline(withColor: APP_LINE_COLOR, padding: 0, height: 1)
        addressLine1TextField.placeHolderLabel = addressLine1Label
        //        mobileNumTextField.createBorder(borderColor: UIColor.red,xpos: 0)
        addressLine1TextField.setLeftGap(width: 0, placeHolderImage: UIImage.init())
        addressLine1TextField.setRightGap(width: 0, placeHolderImage: UIImage.init())
        addressLine1TextField.text_Color =  UIColor.black
        
        addressLine2TextField.textFieldType = AITextField.AITextFieldType.PhoneNumberTextField
        addressLine2TextField.updateUIAsPerTextFieldType()
        addressLine2TextField.createUnderline(withColor: APP_LINE_COLOR, padding: 0, height: 1)
        addressLine2TextField.placeHolderLabel = addressLine2Label
        //        mobileNumTextField.createBorder(borderColor: UIColor.red,xpos: 0)
        addressLine2TextField.setLeftGap(width: 0, placeHolderImage: UIImage.init())
        addressLine2TextField.setRightGap(width: 0, placeHolderImage: UIImage.init())
        addressLine2TextField.text_Color =  UIColor.black
        
        genderTextField.textFieldType = AITextField.AITextFieldType.TextPickerTextField
        genderTextField.updateUIAsPerTextFieldType()
        genderTextField.createUnderline(withColor: APP_LINE_COLOR, padding: 0, height: 1)
        genderTextField.placeHolderLabel = genderLabel
        //        mobileNumTextField.createBorder(borderColor: UIColor.red,xpos: 0)
        genderTextField.setLeftGap(width: 0, placeHolderImage: UIImage.init())
        genderTextField.setRightGap(width: 10, placeHolderImage: UIImage.init(named: "ic_downarrow_input")!)
        genderTextField.text_Color =  UIColor.black

        ageGroupTextField.textFieldType = AITextField.AITextFieldType.TextPickerTextField
        ageGroupTextField.updateUIAsPerTextFieldType()
        ageGroupTextField.createUnderline(withColor: APP_LINE_COLOR, padding: 0, height: 1)
        ageGroupTextField.placeHolderLabel = ageGroupLabel
        //        mobileNumTextField.createBorder(borderColor: UIColor.red,xpos: 0)
        ageGroupTextField.setLeftGap(width: 0, placeHolderImage: UIImage.init())
        ageGroupTextField.setRightGap(width:10, placeHolderImage: UIImage.init(named: "ic_downarrow_input")!)
        ageGroupTextField.text_Color =  UIColor.black

        ethnicityTextField.textFieldType = AITextField.AITextFieldType.TextPickerTextField
        ethnicityTextField.updateUIAsPerTextFieldType()
        ethnicityTextField.createUnderline(withColor: APP_LINE_COLOR, padding: 0, height: 1)
        ethnicityTextField.placeHolderLabel = ethnicityLabel
        //        mobileNumTextField.createBorder(borderColor: UIColor.red,xpos: 0)
        ethnicityTextField.setLeftGap(width: 0, placeHolderImage: UIImage.init())
        ethnicityTextField.setRightGap(width: 10, placeHolderImage:  UIImage.init(named: "ic_downarrow_input")!)
        ethnicityTextField.text_Color =  UIColor.black

        groupCodeTextField.textFieldType = AITextField.AITextFieldType.NormalTextField
        groupCodeTextField.updateUIAsPerTextFieldType()
        groupCodeTextField.createUnderline(withColor: APP_LINE_COLOR, padding: 0, height: 1)
        groupCodeTextField.placeHolderLabel = groupCodeLabel
        //        mobileNumTextField.createBorder(borderColor: UIColor.red,xpos: 0)
        groupCodeTextField.setLeftGap(width: 0, placeHolderImage: UIImage.init())
        groupCodeTextField.setRightGap(width: 0, placeHolderImage: UIImage.init())
        groupCodeTextField.text_Color =  UIColor.black

        referralCodeTextField.textFieldType = AITextField.AITextFieldType.NormalTextField
        referralCodeTextField.updateUIAsPerTextFieldType()
        referralCodeTextField.createUnderline(withColor: APP_LINE_COLOR, padding: 0, height: 1)
        referralCodeTextField.placeHolderLabel = referralCodeLabel
        //        mobileNumTextField.createBorder(borderColor: UIColor.red,xpos: 0)
        referralCodeTextField.setLeftGap(width: 0, placeHolderImage: UIImage.init())
        referralCodeTextField.setRightGap(width: 0, placeHolderImage: UIImage.init())
        referralCodeTextField.text_Color =  UIColor.black
        
        cityTextField.textFieldType = AITextField.AITextFieldType.UIPickerTextField
        cityTextField.updateUIAsPerTextFieldType()
        cityTextField.createUnderline(withColor: APP_LINE_COLOR, padding: 0, height: 1)
        cityTextField.placeHolderLabel = referralCodeLabel
        //        mobileNumTextField.createBorder(borderColor: UIColor.red,xpos: 0)
        cityTextField.setLeftGap(width: 0, placeHolderImage: UIImage.init())
        cityTextField.setRightGap(width: 0, placeHolderImage: UIImage.init())
        cityTextField.text_Color =  UIColor.black
        
        stateTextField.textFieldType = AITextField.AITextFieldType.UIPickerTextField
        stateTextField.updateUIAsPerTextFieldType()
        stateTextField.createUnderline(withColor: APP_LINE_COLOR, padding: 0, height: 1)
        stateTextField.placeHolderLabel = referralCodeLabel
        //        mobileNumTextField.createBorder(borderColor: UIColor.red,xpos: 0)
        stateTextField.setLeftGap(width: 0, placeHolderImage: UIImage.init())
        stateTextField.setRightGap(width: 10, placeHolderImage:UIImage.init(named: "ic_downarrow_input")!)
        stateTextField.text_Color =  UIColor.black

        zipCodeTextField.textFieldType = AITextField.AITextFieldType.PhoneNumberTextField
        zipCodeTextField.updateUIAsPerTextFieldType()
        zipCodeTextField.createUnderline(withColor: APP_LINE_COLOR, padding: 0, height: 1)
        zipCodeTextField.placeHolderLabel = referralCodeLabel
        //        mobileNumTextField.createBorder(borderColor: UIColor.red,xpos: 0)
        zipCodeTextField.setLeftGap(width: 0, placeHolderImage: UIImage.init())
        zipCodeTextField.setRightGap(width: 0, placeHolderImage: UIImage.init())
        zipCodeTextField.text_Color =  UIColor.black

      /*  firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        addressLine1TextField.delegate = self
        addressLine2TextField.delegate = self
        genderTextField.delegate = self
        ageGroupTextField.delegate = self
        ethnicityTextField.delegate = self
        groupCodeTextField.delegate = self
        referralCodeTextField.delegate = self*/
        
        firstNameTextField.aiDelegate = self
        lastNameTextField.aiDelegate = self
        addressLine1TextField.aiDelegate = self
        addressLine2TextField.aiDelegate = self
        genderTextField.aiDelegate = self
        ageGroupTextField.aiDelegate = self
        ethnicityTextField.aiDelegate = self
        groupCodeTextField.aiDelegate = self
        referralCodeTextField.aiDelegate = self
        stateTextField.aiDelegate = self
        cityTextField.aiDelegate = self
        zipCodeTextField.aiDelegate = self


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
        return 14
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func keyBoardHidden(textField: UITextField) {
        
    }
}

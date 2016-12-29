//
//  ChangePasswordTVC.swift
//  Snap2Save
//
//  Created by Malathi on 28/12/16.
//  Copyright © 2016 Appit. All rights reserved.
//

import UIKit
import Localize_Swift

class ChangePasswordTVC: UITableViewController,AITextFieldProtocol {

    var languageSelectionButton: UIButton!

    // outlets
    
    
    @IBOutlet var currentPasswordTextField: AIPlaceHolderTextField!
    
    @IBOutlet var newPasswordTextField: AIPlaceHolderTextField!
    
    @IBOutlet var reEnterNewPasswordTextField: AIPlaceHolderTextField!
    
    
    @IBOutlet var saveButton: UIButton!
    
    
    @IBAction func saveButtonAction(_ sender: UIButton) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        currentPasswordTextField.contentTextField.textFieldType = AITextField.AITextFieldType.PasswordTextField
        newPasswordTextField.contentTextField.textFieldType = AITextField.AITextFieldType.PasswordTextField
        reEnterNewPasswordTextField.contentTextField.textFieldType = AITextField.AITextFieldType.PasswordTextField
        
        currentPasswordTextField.contentTextField.updateUIAsPerTextFieldType()
        newPasswordTextField.contentTextField.updateUIAsPerTextFieldType()
        reEnterNewPasswordTextField.contentTextField.updateUIAsPerTextFieldType()
        
        currentPasswordTextField.contentTextField.aiDelegate = self
        newPasswordTextField.contentTextField.aiDelegate = self
        reEnterNewPasswordTextField.contentTextField.aiDelegate = self

        
        languageSelectionButton = LanguageUtility.createLanguageSelectionButton(withTarge: self, action: #selector(languageButtonClicked))
        LanguageUtility.addLanguageButton(languageSelectionButton, toController: self)
        reloadContent()
        self.navigationItem.addBackButton(withTarge: self, action: #selector(backAction))
        AppHelper.setRoundCornersToView(borderColor: APP_ORANGE_COLOR, view: saveButton, radius: 2.0, width: 1.0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        LanguageUtility.addOberverForLanguageChange(self, selector: #selector(reloadContent))
        reloadContent()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        LanguageUtility.removeObserverForLanguageChange(self)
        super.viewDidDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: -
    
    func languageButtonClicked() {
        self.showLanguageSelectionAlert()
    }
    
    func backAction(){
        
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    func reloadContent() {
        
        self.languageSelectionButton.setTitle("language.button.title".localized(), for: .normal)
        self.updateBackButtonText()
        self.title = "Change Password".localized()
        saveButton.setTitle("SAVE".localized(), for: .normal)
        currentPasswordTextField.placeholderText = "CURRENT PASSWORD".localized()
        newPasswordTextField.placeholderText = "NEW PASSWORD (MUST BE ATLEAST 6 CHARACTERS)".localized()
        reEnterNewPasswordTextField.placeholderText = "RE-ENTER NEW PASSWORD".localized()
        
    }

    func keyBoardHidden(textField: UITextField) {
        if textField == currentPasswordTextField.contentTextField{
            newPasswordTextField.contentTextField.becomeFirstResponder()
        }
        else if textField == newPasswordTextField.contentTextField{
            reEnterNewPasswordTextField.contentTextField.becomeFirstResponder()
        }
        else{
            textField.resignFirstResponder()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
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

}

//
//  EBTUserInformationTVC.swift
//  Snap2Save
//
//  Created by Appit on 12/22/16.
//  Copyright © 2016 Appit. All rights reserved.
//

import UIKit
import SwiftyJSON

class EBTUserInformationTVC: UITableViewController {

    fileprivate enum ActionType {
        
        case waitingForPageLoad
        case cardNumber
        case accept
    }
    
    // Properties
    let ebtWebView: EBTWebView = EBTWebView.shared
    fileprivate var actionType: ActionType?
    
    var questionOneDictionary = [String:String]()
    var questionTwoDictionary = [String:String]()
    var questionThreeDictionary = [String:String]()
    
    var userIdRules = ""
    var passwordRules = ""
    
    // Outlets
    
    @IBOutlet weak var nextButton: UIButton!
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var errorTitleLabel: UILabel!
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    @IBOutlet weak var userIdField: AIPlaceHolderTextField!
    @IBOutlet weak var passwordField: AIPlaceHolderTextField!
    @IBOutlet weak var ConfirmPasswordField: AIPlaceHolderTextField!
    @IBOutlet weak var emailAddressField: AIPlaceHolderTextField!
    @IBOutlet weak var confirmEmailField: AIPlaceHolderTextField!
    @IBOutlet weak var phoneNumberField: AIPlaceHolderTextField!
    @IBOutlet weak var questionOneField: AIPlaceHolderTextField!
    @IBOutlet weak var answerOneField: AIPlaceHolderTextField!
    @IBOutlet weak var questionTwoField: AIPlaceHolderTextField!
    @IBOutlet weak var answerTwoField: AIPlaceHolderTextField!
    @IBOutlet weak var questionThreeField: AIPlaceHolderTextField!
    @IBOutlet weak var answerThreeField: AIPlaceHolderTextField!
    
    
    @IBOutlet weak var nextActivityIndicator: UIActivityIndicatorView!
    
    // Actions
    
    @IBAction func nextAction(_ sender: UIButton) {
        
        self.nextActivityIndicator.startAnimating()
        self.nextButton.isEnabled = false
        
        autoFill()

    }
    @IBAction func cancelAction(_ sender: UIButton) {
        
        
    }
    
    
    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()

        // Back Action
        self.navigationItem.addBackButton(withTarge: self, action: #selector(backAction))
        
        // info Button..
        userIdField.delegate = self
        passwordField.delegate = self
        userIdField.tag = 100
        passwordField.tag = 101
        
        
        // fill questions
        questionOneField.contentTextField.setRightGap(width: 10, placeHolderImage: UIImage(named:"ic_downarrow_input")!)
        questionOneField.contentTextField.textFieldType = .TextPickerTextField

        questionTwoField.contentTextField.setRightGap(width: 10, placeHolderImage: UIImage(named:"ic_downarrow_input")!)
        questionTwoField.contentTextField.textFieldType = .TextPickerTextField
        
        questionThreeField.contentTextField.setRightGap(width: 10, placeHolderImage: UIImage(named:"ic_downarrow_input")!)
        questionThreeField.contentTextField.textFieldType = .TextPickerTextField
        
        // Automatic height
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44
        
        errorMessageLabel.text = nil
        
        ebtWebView.responder = self
        
        getQuestionOneList()
        getQuestionTwoList()
        getQuestionThreeList()
        
        getUserIdRules()
        getPasswordRules()
        
        AppHelper.setRoundCornersToView(borderColor: APP_ORANGE_COLOR, view: nextButton, radius: 2.0, width: 1.0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        ebtWebView.responder = self
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 1 {
            if (errorMessageLabel.text == nil || errorMessageLabel.text == "") {
                return 0
            }
        }
        
        return UITableViewAutomaticDimension
    }
    
    // MARK: -
    
    func backAction() {
        
        self.navigationController?.popViewController(animated: true)
//        showAlert(title: "Are you sure ?", message: "The process will be cancelled.", action: #selector(cancelProcess))
    }
    
    func cancelProcess() {
        
        // Define identifier
        let notificationName = Notification.Name("POPTOLOGIN")
        // Post notification
        NotificationCenter.default.post(name: notificationName, object: nil)
    }

    // MARK: -
    
    func getQuestionOneList() {
        
        let js = "function getQuestion1Options() { " +
            "var object = {}; " +
            
            " +$('#question1 option').each(function () {    " +
            "    object[$(this).val()] = $(this).text();    " +
            "});                                            " +
            "var jsonSerialized = JSON.stringify(object);   " +
            "return jsonSerialized                          " +
        "}                                                  " +
        "getQuestion1Options();                             "
    
        ebtWebView.webView.evaluateJavaScript(js) { (result, error) in
            if error != nil {
                print(error ?? "error nil")
            } else {
                print(result ?? "result nil")
                let stringResult = result as! String
                let trimmedText = stringResult.trimmingCharacters(in: .whitespacesAndNewlines)
                print(trimmedText)
                
                if trimmedText.characters.count > 0 {
                    
                    let json = JSON.parse(trimmedText)
                    print("json response \(json)")
                    
                    if let responseDict = json.dictionaryObject {
                        
                        self.questionOneDictionary = responseDict as! [String:String]
                        self.questionOneDictionary.removeValue(forKey: "-1")
                        let values = Array(self.questionOneDictionary.values)
                        let list = NSMutableArray(array: values)
                        self.questionOneField.contentTextField.pickerViewArray = list
                        self.questionOneField.contentTextField.updateUIAsPerTextFieldType()
                    }

                } else {
                    
                    
                }
            }
        }
        
    }
    
    func getQuestionTwoList() {
        
        let js = "function getQuestion2Options() { " +
            "var object = {}; " +
            
            " +$('#question2 option').each(function () {    " +
            "    object[$(this).val()] = $(this).text();    " +
            "});                                            " +
            "var jsonSerialized = JSON.stringify(object);   " +
            "return jsonSerialized                          " +
            "}                                                  " +
        "getQuestion2Options();                             "
        
        ebtWebView.webView.evaluateJavaScript(js) { (result, error) in
            if error != nil {
                print(error ?? "error nil")
            } else {
                print(result ?? "result nil")
                let stringResult = result as! String
                let trimmedText = stringResult.trimmingCharacters(in: .whitespacesAndNewlines)
                print(trimmedText)
                
                if trimmedText.characters.count > 0 {
                    
                    let json = JSON.parse(trimmedText)
                    print("json response \(json)")
                    
                    if let responseDict = json.dictionaryObject {
                        
                        self.questionTwoDictionary = responseDict as! [String:String]
                        self.questionTwoDictionary.removeValue(forKey: "-1")
                        let values = Array(self.questionTwoDictionary.values)
                        let list = NSMutableArray(array: values)
                        self.questionTwoField.contentTextField.pickerViewArray = list
                        self.questionTwoField.contentTextField.updateUIAsPerTextFieldType()
                    }
                    
                } else {
                    
                    
                }
            }
        }
        
    }
    
    func getQuestionThreeList() {
        
        let js = "function getQuestion3Options() { " +
            "var object = {}; " +
            
            " +$('#question3 option').each(function () {    " +
            "    object[$(this).val()] = $(this).text();    " +
            "});                                            " +
            "var jsonSerialized = JSON.stringify(object);   " +
            "return jsonSerialized                          " +
            "}                                                  " +
        "getQuestion3Options();                             "
        
        ebtWebView.webView.evaluateJavaScript(js) { (result, error) in
            if error != nil {
                print(error ?? "error nil")
            } else {
                print(result ?? "result nil")
                let stringResult = result as! String
                let trimmedText = stringResult.trimmingCharacters(in: .whitespacesAndNewlines)
                print(trimmedText)
                
                if trimmedText.characters.count > 0 {
                    
                    let json = JSON.parse(trimmedText)
                    print("json response \(json)")
                    
                    if let responseDict = json.dictionaryObject {
                        
                        self.questionThreeDictionary = responseDict as! [String:String]
                        self.questionThreeDictionary.removeValue(forKey: "-1")
                        let values = Array(self.questionThreeDictionary.values)
                        let list = NSMutableArray(array: values)
                        self.questionThreeField.contentTextField.pickerViewArray = list
                        self.questionThreeField.contentTextField.updateUIAsPerTextFieldType()
                    }
                    
                } else {
                    
                    
                }
            }
        }
        
    }
    

    
    func autoFill() {
        
        let userId = self.userIdField.contentTextField.text!
        
        let password = self.passwordField.contentTextField.text!
        let confirmPassword = self.ConfirmPasswordField.contentTextField.text!
        
        let emailAddress = self.emailAddressField.contentTextField.text!
        let confirmEmail = self.confirmEmailField.contentTextField.text!
        
        let phoneNumber = self.phoneNumberField.contentTextField.text!
        
        let answerOne = self.answerOneField.contentTextField.text!
        let answerTwo = self.answerTwoField.contentTextField.text!
        let answerThree = self.answerThreeField.contentTextField.text!
        
        
        let questionOneIndex = questionOneDictionary.getKey(forValue: self.questionOneField.contentTextField.text!)
        let questionTwoIndex = questionTwoDictionary.getKey(forValue: self.questionTwoField.contentTextField.text!)
        let questionThreeIndex = questionThreeDictionary.getKey(forValue: self.questionThreeField.contentTextField.text!)
        
        
        let jsUserId = "$('#txtUserid').val('\(userId)');"
        let jsPassword = "$('#txtPassword').val('\(password)');"
        let jsConfirmPassword = "$('#txtConfirmPassword').val('\(confirmPassword)');"
        let jsEmailAddress = "$('#txtEmail').val('\(emailAddress)');"
        let jsConfirmEmail = "$('#txtConfirmEmail').val('\(confirmEmail)');"
        let jsPhoneNumber = "$('#txtPhoneNumber').val('\(phoneNumber)');"
        
        let jsQuestionOne = "$('#question1').val('\(questionOneIndex ?? "-1")');"
        let jsQuestionTwo = "$('#question2').val('\(questionTwoIndex  ?? "-1")');"
        let jsQuestionThree = "$('#question3').val('\(questionThreeIndex ?? "-1")');"
        
        let jsAnswerOne = "$('#response1TextField1').val('\(answerOne)');"
        let jsAnswerTwo = "$('#response1TextField2').val('\(answerTwo)');"
        let jsAnswerThree = "$('#response1TextField3').val('\(answerThree)');"
        
        let jsCheckbox = "$('#chkElecCommsOpt').prop('checked', true);"
        
        let jsForm = "void($('#btnValidateUserInfo').click());"
        
        let javaScript = jsUserId + jsPassword + jsConfirmPassword + jsEmailAddress + jsConfirmEmail + jsPhoneNumber + jsQuestionOne + jsQuestionTwo + jsQuestionThree + jsAnswerOne + jsAnswerTwo + jsAnswerThree + jsCheckbox + jsForm
        
        ebtWebView.webView.evaluateJavaScript(javaScript) { (result, error) in
            if error != nil {
                print(error ?? "error nil")
                
            } else {
                print(result ?? "result nil")
                self.checkForErrorMessage()
            }
        }
    }
    
    func checkForErrorMessage() {
        
        let dobErrorCode = "$('.errorInvalidField').first().text();"
        
        ebtWebView.webView.evaluateJavaScript(dobErrorCode) { (result, error) in
            if error != nil {
                
                print(error ?? "error nil")
                
            } else {
                print(result ?? "result nil")
                let stringResult = result as! String
                let trimmed = stringResult.trimmingCharacters(in: .whitespacesAndNewlines)
                print(trimmed)
                if trimmed.characters.count > 0 {
                    // got error
                    self.nextActivityIndicator.stopAnimating()
                    self.nextButton.isEnabled = true
                    
                    self.errorMessageLabel.text = trimmed
                    self.tableView.reloadData()
                    
                } else {
                    // success
                    self.validateNextPage()
                }
            }
        }
    }
    
    func validateNextPage() {
        
        let jsLoginValidation = "$('.PageHeader').text();"
        
        let javaScript = jsLoginValidation
        
        ebtWebView.webView.evaluateJavaScript(javaScript) { (result, error) in
            
            if let result = result {
                
                let resultString = result as! String
                
                if resultString == "Confirmation" {
                    
                    self.actionType = nil
                    self.nextActivityIndicator.stopAnimating()
                    self.nextButton.isEnabled = true
                    // move to view controller
                    self.performSegue(withIdentifier: "EBTConfirmationTVC", sender: self)
                    
                } else {
                    print("page not loaded..")
                    
                }
            } else {
                print(error ?? "")
                
            }
        }
    }
    
    
    func getUserIdRules() {
        
        let dobErrorCode = "$('.prelogonInstrText:eq(2)').text();"
        
        ebtWebView.webView.evaluateJavaScript(dobErrorCode) { (result, error) in
            if error != nil {
                
                print(error ?? "error nil")
                
            } else {
                print(result ?? "result nil")
                let stringResult = result as! String
                let trimmed = stringResult.trimmingCharacters(in: .whitespacesAndNewlines)
                print(trimmed)
                if trimmed.characters.count > 0 {
                    
                    self.userIdRules = trimmed
                    
                } else {
                    
                }
            }
        }
    }

    func getPasswordRules() {
        
        let dobErrorCode = "$('.prelogonInstrText:eq(4)').text();"
        
        ebtWebView.webView.evaluateJavaScript(dobErrorCode) { (result, error) in
            if error != nil {
                
                print(error ?? "error nil")
                
            } else {
                print(result ?? "result nil")
                let stringResult = result as! String
                let trimmed = stringResult.trimmingCharacters(in: .whitespacesAndNewlines)
                print(trimmed)
                if trimmed.characters.count > 0 {
                    
                    self.passwordRules = trimmed
                    
                } else {
                    
                }
            }
        }
    }

    
}

extension EBTUserInformationTVC: AIPlaceHolderTextFieldDelegate {
    
    
    func didTapOnInfoButton(textfield: AIPlaceHolderTextField) {
    
        if textfield.tag == 100 {
            // User ID
            showMyAlert(title: "User ID Rules:", message: userIdRules)
            
        } else if textfield.tag == 101 {
            // Password
            
            showMyAlert(title: "Password Rules:", message: passwordRules)
            
        }
        
    }
    
    
    func showMyAlert(title:String, message:String) {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.left
        
        let messageText = NSMutableAttributedString(
            string: message,
            attributes: [
                NSParagraphStyleAttributeName: paragraphStyle,
                NSFontAttributeName : UIFont.preferredFont(forTextStyle: UIFontTextStyle.body),
                NSForegroundColorAttributeName : UIColor.gray
            ]
        )
        
        let alertController = UIAlertController(title: title, message: "", preferredStyle: .alert)
        alertController.setValue(messageText, forKey: "attributedMessage")
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        DispatchQueue.main.async {
            
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    
}

extension EBTUserInformationTVC: EBTWebViewDelegate {
    
    func didFinishLoadingWebView() {
        
        checkForErrorMessage()
    }
    
}



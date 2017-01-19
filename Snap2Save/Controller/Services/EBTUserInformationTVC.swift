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
        
        case userInformation
    }
    
    // Properties
    let ebtWebView: EBTWebView = EBTWebView.shared
    fileprivate var actionType: ActionType?
    
    var pageTitle = "ebt.userInformation".localized()
    
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
    @IBOutlet weak var confirmPasswordField: AIPlaceHolderTextField!
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
        self.view.endEditing(true)
        
        nextButton.isEnabled = false
        nextActivityIndicator.startAnimating()
        
        actionType = ActionType.userInformation
        
        validatePage()
    }
    
    
    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()

        emailAddressField.contentTextField.keyboardType = .emailAddress
        confirmEmailField.contentTextField.keyboardType = .emailAddress
        passwordField.contentTextField.isSecureTextEntry = true
        confirmPasswordField.contentTextField.isSecureTextEntry = true
        
        userIdField.contentTextField.returnKeyType = .next
        passwordField.contentTextField.returnKeyType = .next
        confirmPasswordField.contentTextField.returnKeyType = .next
        emailAddressField.contentTextField.returnKeyType = .next
        confirmEmailField.contentTextField.returnKeyType = .next
        phoneNumberField.contentTextField.returnKeyType = .next
        answerOneField.contentTextField.returnKeyType = .next
        answerTwoField.contentTextField.returnKeyType = .next
        answerThreeField.contentTextField.returnKeyType = .done
        
        
        userIdField.contentTextField.aiDelegate = self
        passwordField.contentTextField.aiDelegate = self
        confirmPasswordField.contentTextField.aiDelegate = self
        emailAddressField.contentTextField.aiDelegate = self
        confirmEmailField.contentTextField.aiDelegate = self
        phoneNumberField.contentTextField.aiDelegate = self
        
        questionOneField.contentTextField.aiDelegate = self
        questionTwoField.contentTextField.aiDelegate = self
        questionThreeField.contentTextField.aiDelegate = self
        
        answerOneField.contentTextField.aiDelegate = self
        answerTwoField.contentTextField.aiDelegate = self
        answerThreeField.contentTextField.aiDelegate = self
        
        
        userIdField.contentTextField.updateUIAsPerTextFieldType()
        passwordField.contentTextField.updateUIAsPerTextFieldType()
        confirmPasswordField.contentTextField.updateUIAsPerTextFieldType()
        emailAddressField.contentTextField.updateUIAsPerTextFieldType()
        confirmEmailField.contentTextField.updateUIAsPerTextFieldType()
        phoneNumberField.contentTextField.updateUIAsPerTextFieldType()
        answerOneField.contentTextField.updateUIAsPerTextFieldType()
        answerTwoField.contentTextField.updateUIAsPerTextFieldType()
        answerThreeField.contentTextField.updateUIAsPerTextFieldType()
        
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
        
        
        questionOneField.contentTextField.numberOfLinesForPicker = 2
        questionTwoField.contentTextField.numberOfLinesForPicker = 2
        questionThreeField.contentTextField.numberOfLinesForPicker = 2
        
        
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
        
        addTapGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadContent()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        ebtWebView.responder = self
        
        let webView = ebtWebView.webView!
        self.view.addSubview(webView)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - To Hide Keyboard
    
    func addTapGesture() {
        
        // Tap Gesuture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnTableView(recognizer:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    func tapOnTableView(recognizer: UITapGestureRecognizer) {
        
        self.view.endEditing(true)
    }

    func reloadContent() {
        
        DispatchQueue.main.async {
            

            self.title = "REGISTRATION".localized()
            self.pageTitle = "ebt.userInformation".localized()
            self.userIdField.placeholderText = "USER ID".localized()
            self.passwordField.placeholderText = "PASSWORD".localized()
            self.confirmPasswordField.placeholderText = "CONFIRM NEW PASSWORD".localized()
            self.emailAddressField.placeholderText = "EMAIL ADDRESS".localized()
            self.confirmEmailField.placeholderText = "CONFIRM EMAIL ADDRESS".localized()
            self.phoneNumberField.placeholderText = "PHONE NUMBER".localized()
            self.questionOneField.placeholderText = "QUESTION 1".localized()
            self.answerOneField.placeholderText = "ANSWER 1".localized()
            self.questionTwoField.placeholderText = "QUESTION 2".localized()
            self.answerTwoField.placeholderText = "ANSWER 2".localized()
            self.questionThreeField.placeholderText = "QUESTION 3".localized()
            self.answerThreeField.placeholderText = "ANSWER 3".localized()
            
            self.errorTitleLabel.text = "ebt.error.title".localized()
            
            self.nextButton.setTitle("NEXT".localized(), for: .normal)
        }
        
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
        
//        self.navigationController?.popViewController(animated: true)
        showAlert(title: "Are you sure ?", message: "The process will be cancelled.", action: #selector(cancelProcess))
    }
    
    func cancelProcess() {
        
        // Define identifier
        let notificationName = Notification.Name("POPTOLOGIN")
        // Post notification
        NotificationCenter.default.post(name: notificationName, object: nil)
    }

    func moveToNextController(identifier:String) {
        
        let vc = UIStoryboard(name: "Home", bundle: Bundle.main).instantiateViewController(withIdentifier: identifier)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension EBTUserInformationTVC {
    // MARK: Scrapping
    
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
                    
                    
                    let components = trimmed.components(separatedBy: "* ")
                    
                    var list = [String]()
                    for comp in components {
                        
                        let trimmedNew = comp.trimmingCharacters(in: .whitespacesAndNewlines)
                        if trimmedNew.characters.count > 0 {
                            
                            let final = "* " + trimmedNew
                            list.append(final)
                        }
                    }
                    
                    self.userIdRules = list.joined(separator: "\n")
                    
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
                    
                    let components = trimmed.components(separatedBy: "* ")
                    
                    var list = [String]()
                    for comp in components {
                        
                        let trimmedNew = comp.trimmingCharacters(in: .whitespacesAndNewlines)
                        if trimmedNew.characters.count > 0 {
                            
                            let final = "* " + trimmedNew
                            list.append(final)
                        }
                        
                    }
                    
                    self.passwordRules = list.joined(separator: "\n")
                    
                } else {
                    
                }
            }
        }
    }
    
    
    func getQuestionOneList() {
        
        let js = "function getQuestion1Options() { " +
            "var object = {}; " +
            
            "$('#question1 option').each(function () {    " +
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
            
            "$('#question2 option').each(function () {    " +
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
            
            "$('#question3 option').each(function () {    " +
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
    
    func validatePage() {
        
        ebtWebView.getPageHeading(completion: { result in
            
            if let pageTitle = result {
                // isCurrentPage
                if pageTitle == self.pageTitle {
                    // current page
                    if self.actionType == ActionType.userInformation {
                        self.actionType = nil
                        self.autoFill()
                    } else {
                        self.checkForErrorMessage()
                    }
                } else {
                    self.validateNextPage()
                }
            } else {
                
            }
            
        })
        
    }

    
    func autoFill() {
        
        let userId = self.userIdField.contentTextField.text!.removeWhiteSpaces()
        
        let password = self.passwordField.contentTextField.text!.removeWhiteSpaces()
        let confirmPassword = self.confirmPasswordField.contentTextField.text!.removeWhiteSpaces()
        
        let emailAddress = self.emailAddressField.contentTextField.text!.removeWhiteSpaces()
        let confirmEmail = self.confirmEmailField.contentTextField.text!.removeWhiteSpaces()
        
        let phoneNumber = self.phoneNumberField.contentTextField.text!.removeWhiteSpaces()
        
        let answerOne = self.answerOneField.contentTextField.text!.removeWhiteSpaces()
        let answerTwo = self.answerTwoField.contentTextField.text!.removeWhiteSpaces()
        let answerThree = self.answerThreeField.contentTextField.text!.removeWhiteSpaces()
        
        
        let questionOneIndex = questionOneDictionary.getKey(forValue: self.questionOneField.contentTextField.text!)
        let questionTwoIndex = questionTwoDictionary.getKey(forValue: self.questionTwoField.contentTextField.text!)
        let questionThreeIndex = questionThreeDictionary.getKey(forValue: self.questionThreeField.contentTextField.text!)
        
        print("q1 = \(questionOneIndex) q2 = \(questionTwoIndex) q3 = \(questionThreeIndex)")
        
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
        
        ebtWebView.getErrorMessage(completion: { result in
            
            if let errorMessage = result {
                if errorMessage.characters.count > 0 {
                    // error message
                    
                    // update view
                    if self.ebtWebView.isPageLoading == false {
                        self.nextButton.isEnabled = true
                        self.nextActivityIndicator.stopAnimating()
                    }
                    
                    self.errorMessageLabel.text = errorMessage
                    self.tableView.reloadData()
                    // scroll to top..
                    if self.ebtWebView.isPageLoading == false {
                        self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0 ), at: .top, animated: true)
                    }
                    
                } else {
                    
                }
            } else {
                
            }
        })
    }
    
    
    func validateNextPage() {
        
        ebtWebView.getPageHeading(completion: { result in
            
            if let pageTitle = result {
                
                if let nextVCIdentifier = EBTConstants.getEBTViewControllerName(forPageTitle: pageTitle) {
                    self.moveToNextController(identifier: nextVCIdentifier)
                } else {
                    // unknown page
                    print("UNKNOWN PAGE")
                }
                
            } else {
                // is page not loaded
                print("PAGE NOT LOADED YET..")
            }
            
        })
        
    }
    
    
    
}

extension EBTUserInformationTVC: AIPlaceHolderTextFieldDelegate {
    
    
    func didTapOnInfoButton(textfield: AIPlaceHolderTextField) {
    
        if textfield.tag == 100 {
            // User ID
            showMyAlert(title: "User ID Rules:", message: "\n" + userIdRules)
            
        } else if textfield.tag == 101 {
            // Password
            
            showMyAlert(title: "Password Rules:", message: "\n" + passwordRules)
        }
        
    }
    
    
    func showMyAlert(title:String, message:String) {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.left
        
        let messageText = NSMutableAttributedString(
            string: message,
            attributes: [
                NSParagraphStyleAttributeName: paragraphStyle,
                NSFontAttributeName : UIFont(name: "System-Light", size: 12) ?? UIFont.systemFont(ofSize: 12),
                NSForegroundColorAttributeName : UIColor.gray
            ]
        )
        
        let alertController = UIAlertController(title: title, message: "", preferredStyle: .alert)
        alertController.setValue(messageText, forKey: "attributedMessage")
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        DispatchQueue.main.async {
            
            self.present(alertController, animated: true, completion: nil)
            alertController.view.tintColor = APP_GRREN_COLOR
        }
        
        
    }
    
}

extension EBTUserInformationTVC: EBTWebViewDelegate {
    
    func didFinishLoadingWebView() {
        
        validatePage()
    }
    
}

extension EBTUserInformationTVC: AITextFieldProtocol {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == userIdField.contentTextField {
            passwordField.contentTextField.becomeFirstResponder()
        } else if textField == passwordField.contentTextField {
            confirmPasswordField.contentTextField.becomeFirstResponder()
        } else if textField == confirmPasswordField.contentTextField {
            emailAddressField.contentTextField.becomeFirstResponder()
        } else if textField == emailAddressField.contentTextField {
            confirmEmailField.contentTextField.becomeFirstResponder()
        } else if textField == confirmEmailField.contentTextField {
            phoneNumberField.contentTextField.becomeFirstResponder()
        } else if textField == phoneNumberField.contentTextField {
            questionOneField.contentTextField.becomeFirstResponder()
        } else if textField == answerOneField.contentTextField {
            questionTwoField.contentTextField.becomeFirstResponder()
        } else if textField == answerTwoField.contentTextField {
            questionThreeField.contentTextField.becomeFirstResponder()
        } else if textField == answerThreeField.contentTextField {
            textField.resignFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        
        return true
    }
    
    func getSelectedIndexFromPicker(selectedIndex: NSInteger, textField: AITextField) {
        
        if textField == questionOneField.contentTextField {
            answerOneField.contentTextField.becomeFirstResponder()
        } else if textField ==  questionTwoField.contentTextField {
            answerTwoField.contentTextField.becomeFirstResponder()
        } else if textField == questionThreeField.contentTextField {
            answerThreeField.contentTextField.becomeFirstResponder()
        }
        
    }
    
}



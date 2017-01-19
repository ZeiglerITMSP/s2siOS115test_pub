//
//  EBTDateOfBirthTVC.swift
//  Snap2Save
//
//  Created by Appit on 12/22/16.
//  Copyright © 2016 Appit. All rights reserved.
//

import UIKit
import SwiftyJSON


class EBTDateOfBirthTVC: UITableViewController {

    
    fileprivate enum ActionType {
        
        case waitingForPageLoad
        case cardNumber
        case accept
    }
    
    // Properties
    let ebtWebView: EBTWebView = EBTWebView.shared
    fileprivate var actionType: ActionType?
    
    var pageTitle = "ebt.dob".localized()
    var questions = [String]()
    
    // Outles
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dobField: AIPlaceHolderTextField!
    @IBOutlet weak var socialSecurityNumberField: AIPlaceHolderTextField!
    @IBOutlet weak var errorTitleLabel: UILabel!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var nextActivityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var nextButton: UIButton!
    
    
    // Actions
    @IBAction func nextAction(_ sender: UIButton) {
        self.view.endEditing(true)
        
        nextButton.isEnabled = false
        nextActivityIndicator.startAnimating()
        
        actionType = ActionType.cardNumber
        
        validatePage()
    }
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Back Action
        self.navigationItem.addBackButton(withTarge: self, action: #selector(backAction))
        
        // Automatic height
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44
        
        // dob
        self.dobField.contentTextField.textFieldType = .DatePickerTextField
        self.dobField.contentTextField.dateFormatString = "MM/dd/yyyy"
        self.dobField.contentTextField.updateUIAsPerTextFieldType()
        
        self.socialSecurityNumberField.contentTextField.returnKeyType = .done
        self.socialSecurityNumberField.contentTextField.aiDelegate = self
        self.socialSecurityNumberField.contentTextField.isSecureTextEntry = true
        self.socialSecurityNumberField.contentTextField.updateUIAsPerTextFieldType()
        
        ebtWebView.responder = self
        
        errorMessageLabel.text = nil
     
        AppHelper.setRoundCornersToView(borderColor: APP_ORANGE_COLOR, view: nextButton, radius: 2.0, width: 1.0)
        
        getQuestions()
        
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
            self.pageTitle = "ebt.dob".localized()
            self.dobField.placeholderText = "WHAT IS YOUR DATE OF BIRTH? (MM/DD/YYYY)".localized()
            self.socialSecurityNumberField.placeholderText = "WHAT IS YOUR SOCIAL SECURITY NUMBER?".localized()
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
        
        if indexPath.row == 2 {
            
            if questions.contains("What is your date of birth? (mm/dd/yyyy)") == false {
                return 0
            }
        }
        
        if indexPath.row == 3 {
            
            if questions.contains("What is your Social Security Number?") == false {
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

extension EBTDateOfBirthTVC {
    // MARK: Scrapping
    
    
    func getQuestions() {
        
        let js =
            
            "function questions() {    " +
                    "var my = $(\"label[for='securityAnswer']\").text(); " +
                    "return my;  " +
            "}  " +
        
            "questions();              "
            
            /*
            "function securityQuestions() {            " +
            "var list = [];                                 " +
            "var questionCount = $('.cdpMandatoryField').length;    " +
            "for (var i = 0; i < questionCount; i++) {              " +
            "    var d= $(\"label[for='securityAnswer']:eq(\"+i+\")').text().trim();   " +
            "    d = d.replace('**','');                                            " +
            "    d = d.replace('\n','');                            " +
            "    list.push(d);                                      " +
            "}                                              " +
            "var jsonSerialized = JSON.stringify(list);     " +
            
            "return jsonSerialized;                         " +
        "}                                                  " +
        "securityQuestions();                               "
            
        */
        
        /*
 
 function securityQuestions(){
             var list = [];
        var questionCount = $('.cdpMandatoryField').length;
          for (var i = 0; i < questionCount; i++) {
                 var d= $("label[for='securityAnswer']:eq("+i+")").text().trim();
                 d = d.replace('**','');
                 d = d.replace('\n',''); 
                 alert(d);
                 list.push(d);
            }
             var jsonSerialized = JSON.stringify(list);
             
       return jsonSerialized;
        }

securityQuestions();
 */
        
        
        ebtWebView.webView.evaluateJavaScript(js) { (result, error) in
            if error != nil {
                print(error ?? "error nil")
            } else {
                print(result ?? "result nil")
                let stringResult = result as! String
                let trimmedText = stringResult.trimmingCharacters(in: .whitespacesAndNewlines)
                print(trimmedText)
                
                if trimmedText.characters.count > 0 {
                    
                    let components = trimmedText.components(separatedBy: "**")
                    
                    for component in components {
                        
                        let trimmedText = component.trimmingCharacters(in: .whitespacesAndNewlines)
                        if trimmedText.characters.count > 0 {
                            self.questions.append(trimmedText)
                        }
                        
                    }
                    
                    self.tableView.reloadData()
                    
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
                    if self.actionType == ActionType.cardNumber {
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
        
        let dob = dobField.contentTextField.text!
        
        let jsDOB = "$('#txtSecurityKeyQuestionAnswer').val('\(dob)');"
        let jsForm = "void($('#btnValidateSecurityAnswer').click());"
        
        let javaScript = jsDOB + jsForm
        
        ebtWebView.webView.evaluateJavaScript(javaScript) { (result, error) in
            self.checkForErrorMessage()
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


extension EBTDateOfBirthTVC: EBTWebViewDelegate {
    
    func didFinishLoadingWebView() {
        
        validatePage()
    }
    
}


extension EBTDateOfBirthTVC: AITextFieldProtocol {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == dobField.contentTextField {
            
           // socialSecurityNumberField.contentTextField.becomeFirstResponder()
        } else if textField == socialSecurityNumberField.contentTextField {
            
            textField.resignFirstResponder()
        }
        
        return true
    }
    
}


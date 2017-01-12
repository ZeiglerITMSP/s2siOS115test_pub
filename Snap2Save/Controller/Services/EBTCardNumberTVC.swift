//
//  EBTCardNumberTVC.swift
//  Snap2Save
//
//  Created by Appit on 12/22/16.
//  Copyright © 2016 Appit. All rights reserved.
//

import UIKit

class EBTCardNumberTVC: UITableViewController {

    fileprivate enum ActionType {
        
        case waitingForPageLoad
        case cardNumber
        case accept
    }
    
    // Properties
    var errorMessage:String?
    let ebtWebView: EBTWebView = EBTWebView.shared
    
    fileprivate var actionType: ActionType?
    
    
    // Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var cardNumberField: AIPlaceHolderTextField!
    @IBOutlet weak var errorTitleLabel: UILabel!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var nextActivityIndicator: UIActivityIndicatorView!
    
    
    @IBOutlet weak var nextButton: UIButton!
    
    // MARK: - Actions
    @IBAction func nextAction(_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        nextActivityIndicator.startAnimating()
        validatePage()
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        
        self.view.endEditing(true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        errorMessageLabel.text = nil
        cardNumberField.contentTextField.aiDelegate = self
        cardNumberField.contentTextField.returnKeyType = .done
        
        // Back Action
        self.navigationItem.addBackButton(withTarge: self, action: #selector(backAction))
        
        // Automatic height
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44
        
        ebtWebView.responder = self
        
        loadSignupPage()
        
        AppHelper.setRoundCornersToView(borderColor: APP_ORANGE_COLOR, view: nextButton, radius: 2.0, width: 1.0)
        
        addTapGesture()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        ebtWebView.responder = self
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
    
    // MARK: - WebView
    
    // load webpage
    func loadSignupPage() {

        let signupUrl_en = kEBTSignupUrl
        
        let url = NSURL(string: signupUrl_en)
        let request = NSURLRequest(url: url! as URL)
        
        ebtWebView.webView.load(request as URLRequest)
    }
    
    func validatePage() {
        
        let jsLoginValidation = "$('.PageHeader').text();"
        
        let javaScript = jsLoginValidation
        
        ebtWebView.webView.evaluateJavaScript(javaScript) { (result, error) in
            
            if let result = result {
                
                let resultString = result as! String
                
                if resultString == "Identify Your Card and Accounts" {
                    
                    self.autoFill(cardNumber: self.cardNumberField.contentTextField.text!)
                } else {
                    print("page not loaded..")
                    self.actionType = ActionType.waitingForPageLoad
                }
            } else {
                print(error ?? "")
                self.actionType = ActionType.waitingForPageLoad
            }
        }
    }

    
    // MARK:- Card Number Filling
    func autoFill(cardNumber:String) {
        
        
        actionType = ActionType.cardNumber
        
        
        
        let jsCardNumber = "$('#txtCardNumber').val('\(cardNumber)');"
//        let jsSubmit = "void($('form')[1].submit());"
        let jsSubmit = "void($('#btnValidateCardNumber').click());"
        
        let javaScript =  jsCardNumber + jsSubmit
        
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
        
        let jsStatusMessage = "$('#VallidationExcpMsg').text();"
        
        ebtWebView.webView.evaluateJavaScript(jsStatusMessage) { (result, error) in
            if error != nil {
                print(error ?? "error nil")
            } else {
                print(result ?? "result nil")
                let stringResult = result as! String
                let trimmedErrorMessage = stringResult.trimmingCharacters(in: .whitespacesAndNewlines)
                
                if trimmedErrorMessage.characters.count > 0 {
                    
                    self.nextActivityIndicator.stopAnimating()
                    // handle error message
                    self.errorMessageLabel.text = trimmedErrorMessage
                    self.tableView.reloadData()
                    
                } else {
                    // no error message
                    self.checkPageHeader()
                }
            }
        }
    }
    
    
    // MARK: - Agree
    
    func checkPageHeader() {
        
        let jsPageTitle = "$('.PageHeader').text();"
        ebtWebView.webView.evaluateJavaScript(jsPageTitle) { (result, error) in
            if error != nil {
                print(error ?? "error nil")
            } else {
                print(result!)
                
                let stringResult = result as! String
                let pageTitle = stringResult.trimmingCharacters(in: .whitespacesAndNewlines)
                print(pageTitle)
                
                if pageTitle == "Online Terms and Conditions" {
                    
                    self.acceptSubmit()
                }
            }
        }
    }
    
    func acceptSubmit() {
        
        actionType = ActionType.accept
        
        // "$('#btnAcceptTandC).click();"
        let jsAcceptClick = "void($('form')[1].submit());"
//        let jsAcceptClick = "$('#btnAcceptTandC).click();"
        
        ebtWebView.webView.evaluateJavaScript(jsAcceptClick) { (result, error) in
            if error != nil {
                print(error ?? "error nil")
            } else {
                print(result ?? "result nil")
            }
        }
    }
    
    
    func validateNextPage() {
        
        let jsLoginValidation = "$('.PageHeader').text();"
        
        let javaScript = jsLoginValidation
        
        ebtWebView.webView.evaluateJavaScript(javaScript) { (result, error) in
            
            if let result = result {
                
                let resultString = result as! String
                
                if resultString == "Validate Identity" {
                    
                    self.actionType = nil
                    self.nextActivityIndicator.stopAnimating()
                    // move to view controller
                    self.performSegue(withIdentifier: "EBTDateOfBirthTVC", sender: self)

                } else {
                    print("page not loaded..")
                    self.actionType = ActionType.waitingForPageLoad
                }
            } else {
                print(error ?? "")
                self.actionType = ActionType.waitingForPageLoad
            }
        }
    }


}

extension EBTCardNumberTVC: EBTWebViewDelegate {
    
    func didFinishLoadingWebView() {
        
        if actionType == ActionType.accept {
            
            validateNextPage()
        } else if actionType == ActionType.cardNumber {
            actionType = nil
            checkForErrorMessage()
        } else if actionType == ActionType.waitingForPageLoad {
            
            validatePage()
        }
    }
    
}

extension EBTCardNumberTVC: AITextFieldProtocol {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    
}


//
//  EBTConfirmationTVC.swift
//  Snap2Save
//
//  Created by Appit on 12/22/16.
//  Copyright © 2016 Appit. All rights reserved.
//

import UIKit

class EBTConfirmationTVC: UITableViewController {

    
    fileprivate enum ActionType {
        
        case waitingForPageLoad
        case validate
        case resend
        case changeEmail
    }
    
    // Properties
    let ebtWebView: EBTWebView = EBTWebView.shared
    fileprivate var actionType: ActionType?
    
    
    // Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var errorTitleLabel: UILabel!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var validationCodeField: AIPlaceHolderTextField!
    @IBOutlet weak var validateActivityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var validateButton: UIButton!
    @IBOutlet weak var resendButton: UIButton!
    @IBOutlet weak var changeEmailButton: UIButton!
    
    
    
    
    
    // Actions
    
    @IBAction func validateAction(_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        actionType = ActionType.validate
        validateActivityIndicator.startAnimating()
//        validateButton.isEnabled = false
    
        autoFill(valdationCode: self.validationCodeField.contentTextField.text!)
    }
    
    
    @IBAction func resendAction(_ sender: Any) {
        
        self.view.endEditing(true)
    }
    
    @IBAction func changeEmailAction(_ sender: UIButton) {
        
        self.view.endEditing(true)
    }
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()

        validationCodeField.contentTextField.returnKeyType = .done
        validationCodeField.contentTextField.aiDelegate = self
        
        
        // Back Action
        self.navigationItem.addBackButton(withTarge: self, action: #selector(backAction))
        
        // Automatic height
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44
        
        errorMessageLabel.text = nil
        ebtWebView.responder = self
        
        AppHelper.setRoundCornersToView(borderColor: APP_ORANGE_COLOR, view: validateButton, radius: 2.0, width: 1.0)
        AppHelper.setRoundCornersToView(borderColor: nil, view: resendButton, radius: 2.0, width: 1.0)
        AppHelper.setRoundCornersToView(borderColor: nil, view: changeEmailButton, radius: 2.0, width: 1.0)
        
        addTapGesture()
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
    
    // MARK:- Card Number Filling
    func autoFill(valdationCode:String) {
        
        actionType = ActionType.validate
        
        let jsCardNumber = "$('#txtEmailValidationCode').val('\(valdationCode)');"
        let jsSubmit = "$('#validateEmailBtn').click();"
        
        let javaScript =  jsCardNumber + jsSubmit
        
        ebtWebView.webView.evaluateJavaScript(javaScript) { (result, error) in
            
            self.checkForErrorMessage()
//
//            if error != nil {
//                print(error ?? "error nil")
//            } else {
//                print(result ?? "result nil")
//                self.checkForErrorMessage()
//            }
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
                    
                    self.validateButton.isEnabled = true
                    self.validateActivityIndicator.stopAnimating()
                    // handle error message
                    self.errorMessageLabel.text = trimmedErrorMessage
                    self.tableView.reloadData()
                    
                } else {
                    // no error message
                    self.validateNextPage()
                }
            }
        }
    }
    
    
    
    func validateNextPage() {
        
        ebtWebView.getPageHeader(completion: { pageTitle in
            
            if pageTitle == "Verify Security Question" {
                
                self.validateButton.isEnabled = true
                self.validateActivityIndicator.stopAnimating()
                self.performSegue(withIdentifier: "EBTSecurityQuestionTVC", sender: nil)
                
            } else {
                
            }
        })
        
    }


}


extension EBTConfirmationTVC: EBTWebViewDelegate {
    
    func didFinishLoadingWebView() {
        
        checkForErrorMessage()
    }
    
}

extension EBTConfirmationTVC: AITextFieldProtocol {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
}


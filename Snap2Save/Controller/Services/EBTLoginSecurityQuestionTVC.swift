//
//  EBTLoginSecurityQuestionTVC.swift
//  Snap2Save
//
//  Created by Appit on 1/2/17.
//  Copyright © 2017 Appit. All rights reserved.
//

import UIKit

class EBTLoginSecurityQuestionTVC: UITableViewController {

    fileprivate enum ActionType {
        
        case securityQuestion
    }
    
    // Properties
    let ebtWebView: EBTWebView = EBTWebView.shared
    fileprivate var actionType: ActionType?
    
    var pageTitle = "ebt.securityQuestion".localized()
    
    // Ouetles
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var errorTitleLabel: UILabel!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var securityQuestionTitleLabel: UILabel!
    @IBOutlet weak var securityQuestionLabel: UILabel!
    
    @IBOutlet weak var securityAnswerField: AIPlaceHolderTextField!
    
    @IBOutlet weak var confirmButton: UIButton!
    
    @IBOutlet weak var confirmActivityIndicator: UIActivityIndicatorView!
    
    
    // Actions
    
    @IBAction func confirmAction(_ sender: UIButton) {
        self.view.endEditing(true)
        
        confirmButton.isEnabled = false
        confirmActivityIndicator.startAnimating()
        
        actionType = ActionType.securityQuestion
        
        validatePage()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        errorMessageLabel.text = nil
        
        securityAnswerField.contentTextField.returnKeyType = .done
        securityAnswerField.contentTextField.aiDelegate = self
        securityAnswerField.contentTextField.updateUIAsPerTextFieldType()
        
        // Back Action
        self.navigationItem.addBackButton(withTarge: self, action: #selector(backAction))
        
        // Automatic height
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44
        
        ebtWebView.responder = self
        
        validatePage()
        
        AppHelper.setRoundCornersToView(borderColor: APP_ORANGE_COLOR, view: confirmButton, radius: 2.0, width: 1.0)
        
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
        webView.sendSubview(toBack: self.view)
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
            
            if EBTUser.shared.loggedType == "1" {
                self.title = "ebt.title.login".localized()
            } else {
                self.title = "ebt.title.register".localized()
            }
            
            self.updateBackButtonText()
            
            self.pageTitle = "ebt.securityQuestion".localized()
            self.titleLabel.text = "ebt.securityQuestion.titleLabel".localized()
            self.messageLabel.text = "ebt.securityQuestion.messageLabel".localized()
            self.securityQuestionTitleLabel.text = "SECURITY QUESTION".localized()
            self.securityAnswerField.placeholderText = "SECURITY ANSWER".localized()
            self.errorTitleLabel.text = ""
            
            self.confirmButton.setTitle("CONFIRM".localized(), for: .normal)
            
            self.tableView.reloadData()
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
        
//       _ = self.navigationController?.popViewController(animated: true)
        
        showAlert(title: "Are you sure ?".localized(), message: "The process will be cancelled.".localized(), action: #selector(cancelProcess))
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

extension EBTLoginSecurityQuestionTVC {
    
    // MARK: Scrapping
    
    func validatePage() {
        
        ebtWebView.getPageHeading(completion: { result in
            
            if let pageTitle = result {
                // isCurrentPage
                if pageTitle == self.pageTitle {
                    // current page
                    if self.actionType == ActionType.securityQuestion {
                        self.actionType = nil
                        self.autoFill()
                    } else {
                        self.getSecurityQuestion()
                        self.checkForErrorMessage()
                    }
                } else {
                    self.validateNextPage()
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
    
    
    func getSecurityQuestion() {
        
        let js = "$('.cdpLeftAlignedTdLabel').first().text().trim();"
        
        ebtWebView.webView.evaluateJavaScript(js) { (result, error) in
            if error != nil {
                print(error ?? "error nil")
            } else {
                print(result ?? "result nil")
                let stringResult = result as! String
                let trimmedText = stringResult.trimmingCharacters(in: .whitespacesAndNewlines)
                print(trimmedText)
                
                if trimmedText.characters.count > 0 {
                    
                    self.securityQuestionLabel.text = trimmedText
                    self.tableView.reloadData()
                    
                } else {
                    
                }
            }
        }
    }

    
    func autoFill() {
        
        confirmButton.isEnabled = false
        confirmActivityIndicator.startAnimating()
        
        let jsSecurityAnswer = "$('#securityAnswer').val('\(self.securityAnswerField.contentTextField.text!)');"
//        let jsCheckbox = "$('#registerDeviceFlag').attr('checked');"
        let jsSubmit = "$('#okButton').click();"
        
        let javaScript = jsSecurityAnswer + jsSubmit
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
                        self.confirmButton.isEnabled = true
                        self.confirmActivityIndicator.stopAnimating()
                    }
                    
                    self.errorMessageLabel.text = errorMessage
                    self.tableView.reloadData()
                    
                } else {
//                    // no error message
//                    self.errorMessageLabel.text = nil
//                    self.tableView.reloadData()
                }
            } else {
                
            }
        })
    }


}

extension EBTLoginSecurityQuestionTVC: EBTWebViewDelegate {
    
    
    func didFinishLoadingWebView() {
        
        validatePage()
    }
    
}


extension EBTLoginSecurityQuestionTVC: AITextFieldProtocol {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    
}

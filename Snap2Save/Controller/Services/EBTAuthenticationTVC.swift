//
//  EBTAuthenticationTVC.swift
//  Snap2Save
//
//  Created by Appit on 12/22/16.
//  Copyright © 2016 Appit. All rights reserved.
//

import UIKit
import PKHUD


class EBTAuthenticationTVC: UITableViewController {
    
    fileprivate enum ActionType {
        
        case generate
        case regenerate
    }
    
    
    // Properties
    let ebtWebView: EBTWebView = EBTWebView.shared
    fileprivate var actionType: ActionType?
    
    var pageTitle = "ebt.authentication".localized()
    var isSuccessMessage = false
    
    // Outlets
    
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var regenerateButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var errorTitleLabel: UILabel!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var authenticationCodeField: AIPlaceHolderTextField!
    @IBOutlet weak var confirmActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var regenerateActivityIndicator: UIActivityIndicatorView!
    
    // Actions
    @IBAction func confirmAction(_ sender: UIButton) {
        self.view.endEditing(true)
        
        confirmButton.isEnabled = false
        confirmActivityIndicator.startAnimating()
        
        actionType = ActionType.generate
        validatePage()
    }
    
    @IBAction func regenerateAction(_ sender: UIButton) {
        self.view.endEditing(true)
        
        regenerateButton.isEnabled = false
        regenerateActivityIndicator.startAnimating()
        
        actionType = ActionType.regenerate
        validatePage()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        errorMessageLabel.text = nil
        authenticationCodeField.contentTextField.returnKeyType = .done
        authenticationCodeField.contentTextField.aiDelegate = self
        authenticationCodeField.contentTextField.updateUIAsPerTextFieldType()
        
        // Back Action
        self.navigationItem.addBackButton(withTarge: self, action: #selector(backAction))
        
        // Automatic height
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44
        
        ebtWebView.responder = self
        
        AppHelper.setRoundCornersToView(borderColor: APP_ORANGE_COLOR, view: confirmButton, radius: 2.0, width: 1.0)
        AppHelper.setRoundCornersToView(borderColor: APP_GRREN_COLOR, view: regenerateButton, radius: 2.0, width: 1.0)
        
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
        self.view.sendSubview(toBack: webView)
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

    
    func backAction() {
        
        showAlert(title: "Are you sure ?".localized(), message: "The process will be cancelled.".localized(), action: #selector(cancelProcess))
    }
    
    func cancelProcess() {
        
        // Define identifier
        let notificationName = Notification.Name("POPTOLOGIN")
        // Post notification
        NotificationCenter.default.post(name: notificationName, object: nil)
    }
    
    func showForceQuitAlert() {
        
        self.showAlert(title: nil, message: "ebt.alert.timeout.message".localized(), action: #selector(self.cancelProcess), showCancel: false)
    }
    
    func exitProcessIfPossible() {
        
        if self.ebtWebView.isPageLoading == false {
            self.showForceQuitAlert()
        }
    }
    
    func moveToNextController(identifier:String) {
        
        let vc = UIStoryboard(name: "Home", bundle: Bundle.main).instantiateViewController(withIdentifier: identifier)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func reloadContent() {
        
        DispatchQueue.main.async {
            
            self.title = "ebt.title.login".localized()
            self.updateBackButtonText()
            
            self.authenticationCodeField.placeholderText = "AUTHENTICATION CODE".localized()
            self.errorTitleLabel.text = ""
            self.errorMessageLabel.text = ""
            
            self.titleLabel.text = "ebt.authentication.titleLabel".localized()
            self.messageLabel.text = "ebt.authentication.messageLabel".localized()
            self.pageTitle = "ebt.authentication".localized()
            self.confirmButton.setTitle("CONFIRM".localized(), for: .normal)
            self.regenerateButton.setTitle("REGENERATE".localized(), for: .normal)
            
            self.tableView.reloadData()
        }
        
    }

    func updateErrorTextColor() {
        
        if isSuccessMessage {
            self.errorMessageLabel.textColor = APP_GRREN_COLOR
        } else {
            self.errorMessageLabel.textColor = UIColor.red
        }
    }
    
    // MARK: - Table view
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 1 {
            updateErrorTextColor()
            if (errorMessageLabel.text == nil || errorMessageLabel.text == "") {
                return 0
            }
        }
        
        return UITableViewAutomaticDimension
    }
    
    
}

extension EBTAuthenticationTVC {
    
    // MARK: Scrapping
    func validatePage() {
        ebtWebView.getPageHeading(completion: { result in
            if let pageTitle = result {     // isCurrentPage
                if pageTitle == self.pageTitle {    // current page
                    if self.actionType == ActionType.generate {
                        self.actionType = nil
                        self.autoFill()
                    } else if self.actionType == ActionType.regenerate {
                        self.actionType = nil
                        self.regenerate()
                    } else {
                        self.checkForSuccessMessage()
//                       self.checkForErrorMessage()
                    }
                } else {
                    self.validateNextPage()
                }
            } else {
                self.exitProcessIfPossible()
            }
            
        })
        
    }
    
    func validateNextPage() {
        ebtWebView.getPageHeading(completion: { result in
            if let pageTitle = result {
                if let nextVCIdentifier = EBTConstants.getEBTViewControllerName(forPageTitle: pageTitle) {
                    self.moveToNextController(identifier: nextVCIdentifier)
                } else {    // unknown page
                    print("UNKNOWN PAGE")
                    self.exitProcessIfPossible()
                }
            } else {        // is page not loaded
                print("PAGE NOT LOADED YET..")
                self.exitProcessIfPossible()
            }
        })
    }
    

    func autoFill() {
        let authenticationCode = authenticationCodeField.contentTextField.text!
        let jsAuthenticationCode = "$('#txtAuthenticationCode').val('\(authenticationCode)');"
        let jsSubmit = "$('#okButton').click();"
        let javaScript = jsAuthenticationCode + jsSubmit
        ebtWebView.webView.evaluateJavaScript(javaScript) { (result, error) in
            self.checkForErrorMessage()
        }
    }
    
    func regenerate() {
        let jsRegenerate = "$('#cancelBtn').click();"
        let javaScript = jsRegenerate
        ebtWebView.webView.evaluateJavaScript(javaScript) { (result, error) in
            // page have to be refresh to get message..
            // self.checkForSuccessMessage()
        }
    }
    
    func checkForErrorMessage() {
        ebtWebView.getErrorMessage(completion: { result in
            if let errorMessage = result {
                if errorMessage.characters.count > 0 {
                    // error message
                    if self.ebtWebView.isPageLoading == false {
                        // update view
                        self.confirmButton.isEnabled = true
                        self.confirmActivityIndicator.stopAnimating()
                        print("stop activity")
                    }
                    self.errorMessageLabel.text = errorMessage
                    self.isSuccessMessage = false
                    self.tableView.reloadData()
                } else { // if no error mesage
                    
                }
            } else {
                
            }
        })
    }

    
//    func checkForStatusMessage() {
//        
//        let javaScript = "$('.completionText').first().text().trim();"
//        
//        ebtWebView.webView.evaluateJavaScript(javaScript) { (result, error) in
//            
//            if let resultString = result as? String {
//                
//                let resultTrimmed = resultString.trimmingCharacters(in: .whitespacesAndNewlines)
//                
//                if resultTrimmed.characters.count > 0 {
//                    // error message
//                    
//                    // update view
//                    if self.ebtWebView.isPageLoading == false {
//                        
//                        self.regenerateButton.isEnabled = true
//                        self.regenerateActivityIndicator.stopAnimating()
//                    }
//                    
//                    self.errorMessageLabel.text = resultTrimmed
//                    self.tableView.reloadData()
//                    
//                } else {
//                    // no error message
//                }
//                
//            } else {
//                print(error ?? "")
//            }
//        }
//    }
    
    func checkForSuccessMessage() {
        ebtWebView.checkForSuccessMessage(completion: { result in
            if let errorMessage = result {
                if errorMessage.characters.count > 0 { // success message exists
                    // update view
                    if self.ebtWebView.isPageLoading == false {
                        self.regenerateButton.isEnabled = true
                        self.regenerateActivityIndicator.stopAnimating()
                    }
                    self.errorMessageLabel.text = errorMessage
                    self.isSuccessMessage = true
                    self.tableView.reloadData()
                } else {
                    self.checkForErrorMessage()
                }
            } else {
                self.checkForErrorMessage()
            }
        })
    }
    
   
}




extension EBTAuthenticationTVC: EBTWebViewDelegate {
    

    func didFinishLoadingWebView() {
        
        validatePage()
    }
    
    func didFail() {
        showForceQuitAlert()
    }
    
    func didFailProvisionalNavigation() {
        showForceQuitAlert()
    }
}


extension EBTAuthenticationTVC: AITextFieldProtocol {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    
    func aiTextField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        return AppHelper.isValid(input: string)
    }

    
}

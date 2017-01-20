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
        
//        regenerateButton.isEnabled = false
//        regenerateActivityIndicator.startAnimating()
//        
//        actionType = ActionType.regenerate
//        validatePage()
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
    
    
    func reloadContent() {
        
        DispatchQueue.main.async {
            
            self.title = "LOGIN".localized()
            self.updateBackButtonText()
            
            self.authenticationCodeField.placeholderText = "AUTHENTICATION CODE".localized()
            self.errorTitleLabel.text = ""
            
            self.pageTitle = "ebt.authentication".localized()
            self.confirmButton.setTitle("CONFIRM".localized(), for: .normal)
            self.regenerateButton.setTitle("REGENERATE".localized(), for: .normal)
            
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
    
    
}

extension EBTAuthenticationTVC {
    
    // MARK: Scrapping
    
    func validatePage() {
        
        ebtWebView.getPageHeading(completion: { result in
            
            if let pageTitle = result {
                // isCurrentPage
                if pageTitle == self.pageTitle {
                    // current page
                    
                    if self.actionType == ActionType.generate {
                        self.actionType = nil
                        self.autoFill()
                    } else if self.actionType == ActionType.regenerate {
                        self.actionType = nil
                        self.regenerate()
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
    
    
    func regenerate() {
        
        regenerateButton.isEnabled = false
        regenerateActivityIndicator.startAnimating()
        
        regenerateActivityIndicator.startAnimating()
        
        // autofill
        actionType = ActionType.regenerate
        
        let jsRegenerate = "$('#cancelBtn').click();"
        let javaScript = jsRegenerate
        
        ebtWebView.webView.evaluateJavaScript(javaScript) { (result, error) in
            
            self.checkForStatusMessage()
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

    
    func checkForStatusMessage() {
        
        let javaScript = "$('.completionText').first().text();"
        
        ebtWebView.webView.evaluateJavaScript(javaScript) { (result, error) in
            
            if let resultString = result as? String {
                
                let resultTrimmed = resultString.trimmingCharacters(in: .whitespacesAndNewlines)
                
                if resultTrimmed.characters.count > 0 {
                    // error message
                    
                    // update view
                    if self.ebtWebView.isPageLoading == false {
                        
                        self.regenerateButton.isEnabled = true
                        self.regenerateActivityIndicator.stopAnimating()
                    }
                    
                    self.errorMessageLabel.text = resultTrimmed
                    self.tableView.reloadData()
                    
                } else {
                    // no error message
                }
                
            } else {
                print(error ?? "")
            }
        }
    }
    
    
    
    
    // autofill fields
    func autoFill() {
        
        confirmButton.isEnabled = false
        confirmActivityIndicator.startAnimating()
        
        let authenticationCode = authenticationCodeField.contentTextField.text!
        
        let jsAuthenticationCode = "$('#txtAuthenticationCode').val('\(authenticationCode)');"
        let jsSubmit = "$('#okButton').click();"
        let javaScript = jsAuthenticationCode + jsSubmit

        ebtWebView.webView.evaluateJavaScript(javaScript) { (result, error) in
            
            self.checkForErrorMessage()
        }
    }

//    func checkForErrorMessage() {
//        
//        let javaScript = "$('#VallidationExcpMsg').text();"
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
//                    self.confirmButton.isEnabled = true
//                    self.confirmActivityIndicator.stopAnimating()
//                    
//                    self.errorMessageLabel.text = resultTrimmed
//                    self.tableView.reloadData()
//                    
//                } else {
//                    // no error message
//                   // self.checkForStatusMessage()
//                }
//                
//            } else {
//                print(error ?? "")
//            }
//        }
//    }
//   
    
    
   
}




extension EBTAuthenticationTVC: EBTWebViewDelegate {
    

    func didFinishLoadingWebView() {
        
        validatePage()
    }
}


extension EBTAuthenticationTVC: AITextFieldProtocol {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    
}

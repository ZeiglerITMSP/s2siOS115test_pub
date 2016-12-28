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
    
    
    // Outlets
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var authenticationCodeField: AIPlaceHolderTextField!
    @IBOutlet weak var confirmActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var regenerateActivityIndicator: UIActivityIndicatorView!
    
    // Actions
    @IBAction func confirmAction(_ sender: UIButton) {
        self.view.endEditing(true)
        
        autoFill(withAuthenticationCoe: authenticationCodeField.contentTextField.text!)
    }
    
    @IBAction func regenerateAction(_ sender: UIButton) {
        self.view.endEditing(true)
        
        self.view.endEditing(true)
        regenerate()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Back Action
        self.navigationItem.addBackButton(withTarge: self, action: #selector(backAction))
        
        // Automatic height
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44
        
        ebtWebView.responder = self

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
        
        if indexPath.row == 0 {
            if (errorMessageLabel.text == nil || errorMessageLabel.text == "") {
                return 0
            }
        }
        
        return UITableViewAutomaticDimension
    }
    
    
    // MARK: - Webview
    
    func regenerate() {
        
        regenerateActivityIndicator.startAnimating()
        
        // autofill
        actionType = ActionType.regenerate
        
        let jsRegenerate = "$('#cancelBtn').click();"
        let javaScript = jsRegenerate
        
        ebtWebView.webView.evaluateJavaScript(javaScript) { (result, error) in
            
//            self.checkForStatusMessage()
        }
        
    }
    
    func checkForStatusMessage() {
        
        regenerateActivityIndicator.stopAnimating()
        
//        let jsStatusMessage = "$('.completionText').text()"
        let jsStatusMessage = "$('.completionText').first().text()"
        
        ebtWebView.webView.evaluateJavaScript(jsStatusMessage) { (result, error) in
            if error != nil {
                print(error ?? "error nil")
            } else {
                print("status mesage ========")
                print(result ?? "result nil")
                let stringResult = result as! String
                let trimmedErrorMessage = stringResult.trimmingCharacters(in: .whitespacesAndNewlines)
                print(trimmedErrorMessage)
                
                if trimmedErrorMessage.characters.count > 0 {
                    
                    self.errorMessageLabel.text = trimmedErrorMessage
                    self.tableView.reloadData()
                    
                } else {
                    
                }
            }
        }
    }
    
    
    // autofill fields
    func autoFill(withAuthenticationCoe authenticationCode:String) {
        
        // autofill
        actionType = ActionType.generate
        
        let jsAuthenticationCode = "$('#txtAuthenticationCode').val('\(authenticationCode)');"
        let jsSubmit = "$('#okButton').click();"
        let javaScript = jsAuthenticationCode + jsSubmit

        ebtWebView.webView.evaluateJavaScript(javaScript) { (result, error) in
            
            self.checkForErrorMessage()
        }
    }

    func getPageHeader() {
        
        let jsPageTitle = "$('.PageHeader').text();"
        ebtWebView.webView.evaluateJavaScript(jsPageTitle) { (result, error) in
            if error != nil {
                print(error ?? "error nil")
            } else {
                
                print(result!)
                
                let stringResult = result as! String
                let pageTitle = stringResult.trimmingCharacters(in: .whitespacesAndNewlines)
                print(pageTitle)
                
                self.errorMessageLabel.text = pageTitle
                self.tableView.reloadData()
            }
        }
    }
    
    
    func checkForErrorMessage() {
    
        let jsErrorMessage = "$('#VallidationExcpMsg').text();"
        
        ebtWebView.webView.evaluateJavaScript(jsErrorMessage) { (result, error) in
            if error != nil {
                print(error ?? "error nil")
            } else {
                print(result ?? "result nil")
                let stringResult = result as! String
                let trimmedErrorMessage = stringResult.trimmingCharacters(in: .whitespacesAndNewlines)
                print(trimmedErrorMessage)
                
                if trimmedErrorMessage.characters.count > 0 {
                    
                    self.errorMessageLabel.text = trimmedErrorMessage
                    self.tableView.reloadData()
                    
                } else {
                
                }
            }
        }
    }

    func backAction() {
        
        showAlert(title: "Are you sure ?", message: "The process will be cancelled.", action: #selector(cancelProcess))
    }
    
    func cancelProcess() {
        
        // Define identifier
        let notificationName = Notification.Name("POPTOLOGIN")
        // Post notification
        NotificationCenter.default.post(name: notificationName, object: nil)
    }

    
}




extension EBTAuthenticationTVC: EBTWebViewDelegate {
    

    func didFinishLoadingWebView() {
        
        if actionType == .generate {
            
            //validateSubmitAction()
        } else if actionType == .regenerate {
            
            actionType = nil
            checkForStatusMessage()
        }
    }
    
}

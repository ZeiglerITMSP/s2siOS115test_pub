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
        
        case confirm
    }
    
    // Properties
    let ebtWebView: EBTWebView = EBTWebView.shared
    
    fileprivate var actionType: ActionType?
    
    // Ouetles
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var errorTitleLabel: UILabel!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var securityQuestionField: AIPlaceHolderTextField!
    @IBOutlet weak var securityAnswerField: AIPlaceHolderTextField!
    
    @IBOutlet weak var confirmButton: UIButton!
    
    @IBOutlet weak var confirmActivityIndicator: UIActivityIndicatorView!
    
    
    // Actions
    
    @IBAction func confirmAction(_ sender: UIButton) {
        
        validatePage()
        
//         performSegue(withIdentifier: "EBTDashboardTVC", sender: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        errorMessageLabel.text = nil
        
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
        
        if indexPath.row == 1 {
            if (errorMessageLabel.text == nil || errorMessageLabel.text == "") {
                return 0
            }
        }
        
        return UITableViewAutomaticDimension
    }
    
    // MARK: -
    
    func backAction() {
        
        showAlert(title: "Are you sure ?", message: "The process will be cancelled.", action: #selector(cancelProcess))
    }
    
    func cancelProcess() {
        
        // Define identifier
        let notificationName = Notification.Name("POPTOLOGIN")
        // Post notification
        NotificationCenter.default.post(name: notificationName, object: nil)
    }
    
    // MARK: - WebView
    func validatePage() {
        
        ebtWebView.getPageHeader(completion: { pageTitle in

            if pageTitle == "Verify Security Question" {
                
                self.getSecurityQuestion()
                
            } else {
                
            }
        })
        
    }
    
    func getSecurityQuestion() {
        
        let js = "$('.cdpLeftAlignedTdLabel').text();"
        
        ebtWebView.webView.evaluateJavaScript(js) { (result, error) in
            if error != nil {
                print(error ?? "error nil")
            } else {
                print(result ?? "result nil")
                let stringResult = result as! String
                let trimmedErrorMessage = stringResult.trimmingCharacters(in: .whitespacesAndNewlines)
                print(trimmedErrorMessage)
                
                if trimmedErrorMessage.characters.count > 0 {
                    
                    self.confirmActivityIndicator.stopAnimating()
                    self.errorMessageLabel.text = trimmedErrorMessage
                    self.tableView.reloadData()
                    
                } else {
                    
//                    self.confirmActivityIndicator.stopAnimating()
//                    self.performSegue(withIdentifier: "EBTDashboardTVC", sender: nil)
                }
            }
        }
    }

    
    func autoFill() {
        
        confirmButton.isEnabled = false
        confirmActivityIndicator.startAnimating()
        
        actionType = ActionType.confirm
        
//        actionType = ActionType.sumbit
        let jsSecurityAnswer = "$('#securityAnswer').val('\(self.securityAnswerField.contentTextField.text!)');"
        let jsCheckbox = "$('#registerDeviceFlag').attr('checked');"
        let jsSubmit = "$('#submit').click();"
        
        let javaScript = jsSecurityAnswer + jsCheckbox + jsSubmit
        ebtWebView.webView.evaluateJavaScript(javaScript) { (result, error) in
            
            self.checkForErrorMessage()
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
                    
                    self.confirmActivityIndicator.stopAnimating()
                    self.errorMessageLabel.text = trimmedErrorMessage
                    self.tableView.reloadData()
                    
                } else {
                    
                    self.confirmActivityIndicator.stopAnimating()
                    self.performSegue(withIdentifier: "EBTDashboardTVC", sender: nil)
                }
            }
        }
    }

    


}

extension EBTLoginSecurityQuestionTVC: EBTWebViewDelegate {
    
    
    func didFinishLoadingWebView() {
        
        if actionType == .confirm {
            
            actionType = nil
            checkForErrorMessage()
        }
        
//        else if actionType == .regenerate {
//
//            actionType = nil
//            checkForStatusMessage()
//        }
    }
    
}

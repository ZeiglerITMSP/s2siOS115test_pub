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
        
        case loadPage
        case sumbit
    }
    
    
    // Properties
    let ebtWebView: EBTWebView = EBTWebView.shared
    fileprivate var actionType: ActionType?
    
    
    // Outlets
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var authenticationCodeField: AIPlaceHolderTextField!
    
    // Actions
    @IBAction func confirmAction(_ sender: UIButton) {
        self.view.endEditing(true)
        
        autoFill(withAuthenticationCoe: authenticationCodeField.contentTextField.text!)
    }
    
    @IBAction func regenerateAction(_ sender: UIButton) {
        self.view.endEditing(true)
        
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateBackButtonText()
        
        // Automatic height
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44
        
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
    
    // autofill fields
    func autoFill(withAuthenticationCoe authenticationCode:String) {
        
        // autofill
        actionType = ActionType.sumbit
        
        let jsAuthenticationCode = "$('#txtAuthenticationCode').val('\(authenticationCode)');validateAuthenticationCode();"

        ebtWebView.webView.evaluateJavaScript(jsAuthenticationCode) { (result, error) in
            
            self.getErrorMessage()
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
    
    
    
    func getErrorMessage() {
        // $(\".errorInvalidField\").text();
        let jsErrorMessage = "$('.errorInvalidField').text();"
        
        ebtWebView.webView.evaluateJavaScript(jsErrorMessage) { (result, error) in
            if error != nil {
                print(error ?? "error nil")
            } else {
                print(result ?? "result nil")
                let stringResult = result as! String
                let trimmedErrorMessage = stringResult.trimmingCharacters(in: .whitespacesAndNewlines)
                print(trimmedErrorMessage)
                
                if trimmedErrorMessage.characters.count > 0 {
                    print("====== FAIL =======")
                    
                    self.errorMessageLabel.text = trimmedErrorMessage
                    self.tableView.reloadData()
                    
                } else {
                    print("====== SUCCESS =======")
                    
                    // self.submitForm()
                }
            }
        }
    }

}

extension EBTAuthenticationTVC: EBTWebViewDelegate {
    
    func didFail(withError message: String) {
        
        errorMessageLabel.text = message
        self.tableView.reloadData()
    }
    
    func didSuccess() {
        
        performSegue(withIdentifier: "CalenderInputVC", sender: nil)
        
    }
    
    func didFinishLoadingWebView() {
        
        // HUD.hide()
        if actionType == .sumbit {
            
            //validateSubmitAction()
        }
        
        
    }
    
}

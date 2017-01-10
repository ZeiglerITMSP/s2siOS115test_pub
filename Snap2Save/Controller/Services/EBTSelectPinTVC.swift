//
//  EBTSelectPinTVC.swift
//  Snap2Save
//
//  Created by Appit on 12/22/16.
//  Copyright © 2016 Appit. All rights reserved.
//

import UIKit

class EBTSelectPinTVC: UITableViewController {

    fileprivate enum ActionType {
        
        case submit
    }
    
    // Properties
    let ebtWebView: EBTWebView = EBTWebView.shared
    fileprivate var actionType: ActionType?
    
    
    // Outlets
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var errorTitleLabel: UILabel!
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    @IBOutlet weak var pinField: AIPlaceHolderTextField!
    @IBOutlet weak var confirmPinField: AIPlaceHolderTextField!
    
    @IBOutlet weak var nextActivityIndicator: UIActivityIndicatorView!
   
    @IBOutlet weak var currentPinActivityIndicator: UIActivityIndicatorView!
    
    // Actions
    @IBAction func nextAction(_ sender: UIButton) {
        
        autoFill()
        
//        performSegue(withIdentifier: "EBTUserInformationTVC", sender: nil)
    }
    
    @IBAction func useCurrentPinAction(_ sender: UIButton) {
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Back Action
        self.navigationItem.addBackButton(withTarge: self, action: #selector(backAction))
        
        // Automatic height
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44
        
        errorMessageLabel.text = nil
        
        ebtWebView.responder = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ebtWebView.responder = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        ebtWebView.responder = nil
        
        super.viewDidDisappear(animated)
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
        
        self.navigationController?.popViewController(animated: true)
//        showAlert(title: "Are you sure ?", message: "The process will be cancelled.", action: #selector(cancelProcess))
    }
    
    func cancelProcess() {
        
        // Define identifier
        let notificationName = Notification.Name("POPTOLOGIN")
        // Post notification
        NotificationCenter.default.post(name: notificationName, object: nil)
    }

    // MARK: - 
    
    
    func autoFill() {
        
        let newPin = self.pinField.contentTextField.text!
        let confirmPin = self.confirmPinField.contentTextField.text!
        
        let jsNewPin = "$('#txtNewPin').val('\(newPin)');"
        let jsConfirmPin = "$('#txtConfirmPin').val('\(confirmPin)');"
        
//        let jsForm = "void($('form')[1].submit());"
        let jsForm = "void($('#btnPinSetup').click());"
        
    
        
        let javaScript = jsNewPin + jsConfirmPin + jsForm
        
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
        
        let dobErrorCode = "$('.errorInvalidField').text();"
        
        ebtWebView.webView.evaluateJavaScript(dobErrorCode) { (result, error) in
            if error != nil {
                
                print(error ?? "error nil")
                
            } else {
                print(result ?? "result nil")
                let stringResult = result as! String
                let trimmed = stringResult.trimmingCharacters(in: .whitespacesAndNewlines)
                print(trimmed)
                if trimmed.characters.count > 0 {
                    // got error
                    self.nextActivityIndicator.stopAnimating()
                    
                    self.errorMessageLabel.text = trimmed
                    self.tableView.reloadData()
                    
                } else {
                    // success
                    self.validateNextPage()
                }
            }
        }
    }
    
    func validateNextPage() {
        
        let jsLoginValidation = "$('.PageHeader').text();"
        
        let javaScript = jsLoginValidation
        
        ebtWebView.webView.evaluateJavaScript(javaScript) { (result, error) in
            
            if let result = result {
                
                let resultString = result as! String
                
                if resultString == "Enter User Information" {
                    
                    self.actionType = nil
                    self.nextActivityIndicator.stopAnimating()
                    // move to view controller
                    self.performSegue(withIdentifier: "EBTUserInformationTVC", sender: self)
                    
                } else {
                    print("page not loaded..")
                    
                }
            } else {
                print(error ?? "")
                
            }
        }
    }
    
}

extension EBTSelectPinTVC: EBTWebViewDelegate {
    
    func didFinishLoadingWebView() {
        
        checkForErrorMessage()
    }
    
}


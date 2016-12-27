//
//  EBTCardNumberTVC.swift
//  Snap2Save
//
//  Created by Appit on 12/22/16.
//  Copyright © 2016 Appit. All rights reserved.
//

import UIKit

class EBTCardNumberTVC: UITableViewController {

    // Properties
    var errorMessage:String?
    let ebtWebView: EBTWebView = EBTWebView.shared
    
    
    // Outlets
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var cardNumberField: AIPlaceHolderTextField!
    @IBOutlet weak var errorTitleLabel: UILabel!
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    @IBOutlet weak var nextActivityIndicator: UIActivityIndicatorView!
    
    // Actions
    
    @IBAction func nextAction(_ sender: UIButton) {
        
//        validatePageUrl()
        
        autoFill(cardNumber: cardNumberField.contentTextField.text!)
        
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        
        
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
        
        loadSignupPage()
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
        
        showAlert(title: "Are you sure ?", message: "The registration process will be cancelled.", action: #selector(cancelProcess))
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
        
        let signupUrl_en = "https://ucard.chase.com/cardValidation_setup.action?screenName=register&page=logon"
        
        let url = NSURL(string: signupUrl_en)
        let request = NSURLRequest(url: url! as URL)
        
        ebtWebView.webView.load(request as URLRequest)
    }
    
    // validate  url
    func validatePageUrl() {
        
        let jsGetPageUrl = "window.location.href;"
        ebtWebView.webView.evaluateJavaScript(jsGetPageUrl) { (result, error) in
            
            if error != nil {
                print(error ?? "error nil")
            } else {
                print(result ?? "result nil")
                let pageUrl = result as! String
                if pageUrl == "https://ucard.chase.com/cardValidation_setup.action?screenName=register&page=logon" {
                    
//                    self.autoFill(cardNumber: self.cardNumberField.contentTextField.text!)
                    
                } else {
                    print("page not loaded")
                }
            }
        }
    }
    
    // MARK:- Card Number Filling
    func autoFill(cardNumber:String) {
        
        let jsCardNumber = "$('#txtCardNumber').val('\(cardNumber)');"
        let jsSubmit = "void($('form')[1].submit());"
        
        let javaScript = jsCardNumber + jsSubmit
        
        ebtWebView.webView.evaluateJavaScript(javaScript) { (result, error) in
            if error != nil {
                print(error ?? "error nil")
            } else {
                print(result ?? "result nil")
//                self.checkForErrorMessage()
            }
        }
    }

    func checkForErrorMessage() {
        
        let jsStatusMessage = "$('.errorInvalidField').text();"
        
        ebtWebView.webView.evaluateJavaScript(jsStatusMessage) { (result, error) in
            if error != nil {
                print(error ?? "error nil")
            } else {
                print(result ?? "result nil")
                let stringResult = result as! String
                let trimmedErrorMessage = stringResult.trimmingCharacters(in: .whitespacesAndNewlines)
                
                if trimmedErrorMessage.characters.count > 0 {
                    // handle error message
                    self.errorMessageLabel.text = trimmedErrorMessage
                    self.tableView.reloadData()
                    
                } else {
                    
                    self.performSegue(withIdentifier: "EBTDateOfBirthTVC", sender: self)
                }
            }
        }
    }
    
    
    
//    func validateCardNumberError() {
//        
//        let jsStatusMessage = "$('#VallidationExcpMsg').text();"
//        ebtWebView.evaluateJavaScript(jsStatusMessage) { (result, error) in
//            if error != nil {
//                
//                print(error ?? "error nil")
//                
//            } else {
//                print(result ?? "result nil")
//                let stringResult = result as! String
//                let trimmed = stringResult.trimmingCharacters(in: .whitespacesAndNewlines)
//                print(trimmed)
//                if trimmed.characters.count > 0 {
//                    print("====== FAIL =======")
//                    //                    self.responder?.didFail(withError: trimmed)
//                } else {
//                    print("====== SUCCESS =======")
//                    self.webView.evaluateJavaScript(self.jsSubmit) { (result, error) in
//                        if error != nil {
//                            print(error ?? "error nil")
//                        } else {
//                            print(result ?? "result nil")
//                        }
//                    }
//                    //                    self.responder?.didSuccess()
//                }
//            }
//        }
//    }


}

extension EBTCardNumberTVC: EBTWebViewDelegate {
    
    func didFinishLoadingWebView() {
        
        checkForErrorMessage()
    }
    
}


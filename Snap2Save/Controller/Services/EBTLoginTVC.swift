//
//  EBTLoginTVC.swift
//  Snap2Save
//
//  Created by Appit on 12/20/16.
//  Copyright © 2016 Appit. All rights reserved.
//

import UIKit
import PKHUD

class EBTLoginTVC: UITableViewController {
    
    fileprivate enum ActionType {
        
        case loadPage
        case sumbit
    }
    
    
    // Properties
    let ebtWebView: EBTWebView = EBTWebView.shared
    fileprivate var actionType: ActionType?
    
    let notificationName = Notification.Name("POPTOLOGIN")
    
    // Outlets
    @IBOutlet weak var userIdField: AIPlaceHolderTextField!
    @IBOutlet weak var passwordField: AIPlaceHolderTextField!
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    // Action
    @IBAction func loginAction(_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        self.performSegue(withIdentifier: "EBTAuthenticationTVC", sender: nil)
        
//        print(userIdField.contentTextField.text!)
//        print(passwordField.contentTextField.text!)
//        
//        validateLoginpageUrl()
    }
    
    @IBAction func registrationAction(_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        performSegue(withIdentifier: "EBTCardNumberTVC", sender: nil)
    }
    
    // MARK:-
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateBackButtonText()
        
        userIdField.contentTextField.textFieldType = .PhoneNumberTextField
        userIdField.contentTextField.textFieldType = .NormalTextField
        
        passwordField.contentTextField.isSecureTextEntry = true
        
        // Automatic height
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44
        
        ebtWebView.responder = self
        
        HUD.allowsInteraction = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
      //  loadLoginPage()
        // Stop listening notification
        NotificationCenter.default.removeObserver(self, name: notificationName, object: nil)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(popToLoginVC), name: notificationName, object: nil)
        
        super.viewDidDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func popToLoginVC() {
        
        _ = self.navigationController?.popToViewController(self, animated: true)
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
    
    // MARK: - WebView
    
    // load webpage
    func loadLoginPage() {
        
        let loginUrl_en = "https://ucard.chase.com/chp"
        //let loginUrl_es = "https://ucard.chase.com/locale?request_locale=es"
        let url = NSURL(string: loginUrl_en)
        let request = NSURLRequest(url: url! as URL)
        
        actionType = .loadPage
        ebtWebView.webView.load(request as URLRequest)
    }
    
    // validate loginpage url
    func validateLoginpageUrl() {
        
        let jsGetPageUrl = "window.location.href"
        ebtWebView.webView.evaluateJavaScript(jsGetPageUrl) { (result, error) in
            if error != nil {
                print(error ?? "error nil")
            } else {
                print(result ?? "result nil")
                
                let pageUrl = result as! String
                
                if pageUrl == "https://ucard.chase.com/chp" {
                    
                    self.autoFill(withUserId: self.userIdField.contentTextField.text!, password: self.passwordField.contentTextField.text!)
                } else {
                    print("page not loaded")
                }
                
            }
        }
    }
    
    // validate fields
    // autofill fields
    func autoFill(withUserId userid:String, password:String) {
        
        //$('#submit').click();
        
        // autofill
        
        actionType = ActionType.sumbit
        
        let jsUserIdPassword = "$('#userId').val('\(userid)');$('#password').val('\(password)');$('#submit').click();"
        
//        let jsUserIdPassword = "$('#userId').val('\(userid)');$('#password').val('\(password)');validateCredentials();"
      //  HUD.show(.progress)
        ebtWebView.webView.evaluateJavaScript(jsUserIdPassword) { (result, error) in
            
            self.getErrorMessage()
        }
    }
    
    // check status
    func validateSubmitAction() {
        
        let jsPageTitle = "$('.PageHeader').text();"
        ebtWebView.webView.evaluateJavaScript(jsPageTitle) { (result, error) in
            if error != nil {
                print(error ?? "error nil")
            } else {
                print(result!)
                let stringResult = result as! String
                let pageTitle = stringResult.trimmingCharacters(in: .whitespacesAndNewlines)
                print(pageTitle)
                
                if pageTitle == "We don’t recognize the computer you’re using." {
                    
//                    self.performSegue(withIdentifier: "EBTAuthenticationTVC", sender: nil)
                    
                } else {
                    // fail
                    
                }
                
            }
        }
        
    }
    
    func getErrorMessage() {
        // $(\".errorInvalidField\").text();
        let jsErrorMessage = "$('.errorTextLogin').text();"
        
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

    func submitForm() {
        
        //$('#submit').click();
        
        // autofill
        
        let jsSubmit = "$('#userId').val('\(userIdField.contentTextField.text!)');$('#password').val('\(passwordField.contentTextField.text!)');$('#submit').click();"
//        let jsSubmit = "$('#submit').click();"
//        let jsSubmit = "void($('form')[1].submit())"
        //void($('form')[1].submit())
        //  HUD.show(.progress)
        actionType = ActionType.sumbit
        ebtWebView.webView.evaluateJavaScript(jsSubmit) { (result, error) in
            
            if error != nil {
                print(error ?? "error nil")
            } else {
                print(result!)
            }
        }
    }

   
    
    // success action
    // fail action
    
    
}

extension EBTLoginTVC: EBTWebViewDelegate {
    
    func didFail(withError message: String) {
        
        errorMessageLabel.text = message
        self.tableView.reloadData()
    }
    
    func didSuccess() {
        
      //  performSegue(withIdentifier: "CalenderInputVC", sender: nil)
        
    }
    
    func didFinishLoadingWebView() {
        
       // HUD.hide()
         if actionType == .sumbit {
            
            validateSubmitAction()
        }
        
        
    }
    
}


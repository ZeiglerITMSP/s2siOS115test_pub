//
//  WebViewMaster.swift
//  EBTTracking
//
//  Created by Appit on 12/6/16.
//  Copyright © 2016 Appit. All rights reserved.
//

import UIKit
import WebKit

protocol EBTWebViewDelegate {
    
    func didFail(withError message:String)
    func didSuccess()
    func didFinishLoadingWebView()
    
}


class EBTWebView: NSObject {

    
    
    static let shared: EBTWebView = {
        let instance = EBTWebView()
        return instance
    }()
    
    enum ActionType {
        
        case none
        case cardNumber
        case dob
    }
    
    // Properties
    var webView : WKWebView!
    var actionType: ActionType = .none
    
    var responder: EBTWebViewDelegate?
    
    // javascript
    let registrationUrlString = "https://ucard.chase.com/cardValidation_setup.action?screenName=register&page=logon"
    
    let cardNumberFailUrl = "https://ucard.chase.com/cardValidation_successRedirect.action?screenName=register"
    
    let jsCardNumberAutoFill = "if ($('h1.PageHeader').html()==\"Identify Your Card and Accounts\"){ void($('#txtCardNumber').val(\"9999999999999999999\"));}"
    let jsSubmit = "void($('form')[1].submit())"
    
    let jsGetAllElements = "document.documentElement.outerHTML"
    
    let jsGetErrorCode = "$(\".errorInvalidField\").text();"
    
    // ..
    

    
    
    override init() {
        super.init()
        
        loadWebView()
    }
    
    func loadWebView() {
        
        // loading URL :
        let url = NSURL(string: registrationUrlString)
       // let request = NSURLRequest(url: url! as URL)
        
        // init and load request in webview.
        webView = WKWebView()
//        webView = WKWebView(frame: self.outerView.frame)
        webView.navigationDelegate = self
        //webView.load(request as URLRequest)
//        self.outerView.addSubview(webView)
        
    }
    
    // MARK:- Card Number Filling
    func autoFill(cardNumber:String) {
        
        actionType = ActionType.cardNumber
        let cardNumberJS = "if ($('h1.PageHeader').html()==\"Identify Your Card and Accounts\"){ void($('#txtCardNumber').val(\"\(cardNumber)\"));void($('form')[1].submit());}"
        
        webView.evaluateJavaScript(cardNumberJS) { (result, error) in
            if error != nil {
                print(result ?? "result nil")
            } else {
                print(error ?? "error nil")
            }
        }
    }
    
    
    func validateCardNumberError() {
        
        actionType = .none
        webView.evaluateJavaScript(jsGetErrorCode) { (result, error) in
            if error != nil {
                
                print(error ?? "error nil")
                
            } else {
                print(result ?? "result nil")
                let stringResult = result as! String
                let trimmed = stringResult.trimmingCharacters(in: .whitespacesAndNewlines)
                print(trimmed)
                if trimmed.characters.count > 0 {
                    print("====== FAIL =======")
                    self.responder?.didFail(withError: trimmed)
                } else {
                    print("====== SUCCESS =======")
                    self.webView.evaluateJavaScript(self.jsSubmit) { (result, error) in
                        if error != nil {
                            print(error ?? "error nil")
                        } else {
                            print(result ?? "result nil")
                        }
                    }
                    self.responder?.didSuccess()
                }
            }
        }
    }
    
    // MARK:- DOB Filling
    func autoFill(dob:String) {
        
        actionType = ActionType.dob
        // javascript:void($('#txtSecurityKeyQuestionAnswer').val("25/06/2016")); void($('form')[1].submit());
        
        let dobJS = "void($('#txtSecurityKeyQuestionAnswer').val(\"\(dob)\")); void($('form')[1].submit());"
        
        webView.evaluateJavaScript(dobJS) { (result, error) in
            if error != nil {
                print(result ?? "result nil")
            } else {
                print(error ?? "error nil")
            }
        }
    }
    
    func validateDOBError() {
        
        // javascript:void(android.errorText($("#VallidationExcpMsg").text(),$(".errorInvalidField").text()));
        let dobErrorCode = "($(\"#VallidationExcpMsg\").text(),$(\".errorInvalidField\").text())"
        
        actionType = .none
        webView.evaluateJavaScript(dobErrorCode) { (result, error) in
            if error != nil {
                
                print(error ?? "error nil")
                
            } else {
                print(result ?? "result nil")
                let stringResult = result as! String
                let trimmed = stringResult.trimmingCharacters(in: .whitespacesAndNewlines)
                print(trimmed)
                if trimmed.characters.count > 0 {
                    print("====== FAIL =======")
                    self.responder?.didFail(withError: trimmed)
                } else {
                    print("====== SUCCESS =======")
                    self.webView.evaluateJavaScript(self.jsSubmit) { (result, error) in
                        if error != nil {
                            print(error ?? "error nil")
                        } else {
                            print(result ?? "result nil")
                        }
                    }
                    self.responder?.didSuccess()
                }
            }
        }
    }
    
    
    
    
}


extension EBTWebView: WKNavigationDelegate {
    
    //MARK:- WKNavigationDelegate
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("\n -- didFail -- \n")
        print(error.localizedDescription)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print("\n -- navigationAction -- \n")
        
        print(navigationAction.request)
        
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        print("\n -- navigationResponse -- \n")
        
        print(navigationResponse.response)
        
        
        
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("\n -- didStartProvisional -- \n")
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("\n -- didFinish -- \n")
        
//        if actionType == .cardNumber {
//            validateCardNumberError()
//        } else if actionType == .dob {
//            validateDOBError()
//        }

        self.responder?.didFinishLoadingWebView()
    }
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        
        print("\n -- didReceiveServerRedirectForProvisional -- \n")
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("\n -- didCommit -- \n")
        
    }
    
    
    
}














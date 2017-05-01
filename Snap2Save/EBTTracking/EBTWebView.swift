//
//  WebViewMaster.swift
//  EBTTracking
//
//  Created by Appit on 12/6/16.
//  Copyright © 2016 Appit. All rights reserved.
//

import UIKit
import WebKit

// Ctrl + U
// class -> .
// id -> #


@objc protocol EBTWebViewDelegate {
    
    @objc optional func didFinishLoadingWebView()
    @objc optional func navigationAction() -> Bool
    
    @objc optional func didFailProvisionalNavigation()
    @objc optional func didFail()
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
    
    
    let jsSubmit = "void($('form')[1].submit())"
    let jsGetAllElements = "document.documentElement.outerHTML"
    let jsGetErrorCode = "$(\".errorInvalidField\").text().trim();"
    
    var isPageLoading = false
    
    // ..
    
    
    
    
    override init() {
        super.init()
        
        loadWebView()
    }
    
    func loadWebView() {
        
        // init and load request in webview.
        
        
        let configuration = WKWebViewConfiguration()
        let preferences = WKPreferences()
        preferences.javaScriptCanOpenWindowsAutomatically = true

        configuration.preferences = preferences
        
        webView = WKWebView(frame: CGRect.zero, configuration: configuration)
        //        webView = WKWebView()
        webView.navigationDelegate = self
        //        webView.uiDelegate = self
    }
    
    func loadEmptyPage() {
        
        webView.load(URLRequest.init(url: URL(string: "about:blank")!))
    }
    
    // Get page headline
//    func getPageHeading(completion: @escaping (String?) -> ()) {
//        
//        let jsHeading = "function getTitle() { " +
//        "var pageTitleHeader = $('.PageTitle .PageHeader').first().text(); " +
//        "var dashboardTitle = $('.PageTitle').first().text(); " +
//        "var loginButton = $('#button_logon').text(); " +
//        "var emptyString = ''; " +
//        "if(pageTitleHeader || pageTitleHeader.length>0){ " +
//         "   return pageTitleHeader.trim(); " +
//        "}else if(dashboardTitle || dashboardTitle.length>0) { " +
//         "   return dashboardTitle.trim(); " +
//        "} else if(loginButton || loginButton.length>0) { " +
//         "   return loginButton.trim(); " +
//        "} " +
//        "return emptyString; " +
//    "} " +
//    
//    "getTitle();"
//        
//        let javaScript = jsHeading
//        
//        webView.evaluateJavaScript(javaScript) { (result, error) in
//            
//            if let resultString = result as? String {
//                print(resultString)
//                let resultTrimmed = resultString.trimmingCharacters(in: .whitespacesAndNewlines)
//                completion(resultTrimmed)
//                
//            } else {
//                print(error ?? "")
//                completion(nil)
//            }
//            
//        }
//    }

    func getPageHeading(completion: @escaping (String?) -> ()) {
        
        // $($('#port_panel_02b ul li.green_bullet')[1]).children('strong').length > 0
        // if ($('#fromDateTransHistory').length && $('#toDateTransHistory').length) return 'account_transactions';
        
        // if ($($('#port_panel_02b ul li.green_bullet')[1]).children('strong').length) return 'account_transactions';
        
        
        let jsErrorMessage = "function identifyPage(){" +
            "if ($('#txtCardNumber').length && $('#btnValidateCardNumber').length) return 'sign_up_card';" +
            "if ($('#btnAcceptTandC').length && $('#btnCancelRegistration').length) return 'sign_up_terms_conditions';" +
            "if ($('#btnValidateSecurityAnswer').length && $('#txtSecurityKeyQuestionAnswer').length && $('input.birthDate').length) return 'sign_up_dob';" +
            "if ($('#txtNewPin').length && $('#txtConfirmPin').length) return 'sign_up_select_pin';" +
            "if ($('#txtConfirmEmail').length && $('select#question2').length) return 'sign_up_user_information';" +
            "if ($('#txtEmailValidationCode').length && ('#validateEmailBtn').length && $('#changeEmailBtn').length) return 'sign_up_user_confirmation';" +
            "if ($('#currentEmailLbl').length && $('#newEMailTextField').length && $('#validateEMailTextField').length) return 'sign_up_change_email';" +
            "if ($('#userId').length && $('#password').length && $('#button_logon').length) return 'login';" +
            "if ($('#txtAuthenticationCode').length && $('#okButton').length && $('#cancelBtn').length) return 'login_authorization';" +
            "if ($('#securityAnswer').length && $('#registerDeviceFlag').length && $('#okButton').length) return 'login_security_question';" +
            "if ($($('#port_panel_02b ul li.green_bullet')[1]).children('strong').length > 0) return 'account_transactions';" +
            "if ($('#subHeadercardholderSummary').length ) return 'account_dashboard';" +
            "if ($(\"#errorTable p.errorText:contains('Please try again later')\").length) return 'error';" +
            "return '';" +
            "} " +
        "identifyPage()"
        
       /* let jsErrorMessage = "(function(){" +
            "if ($('#txtCardNumber').length && $('#btnValidateCardNumber').length) return 'sign_up_card';" +
            "if ($('#btnAcceptTandC').length && $('#btnCancelRegistration').length) return 'sign_up_terms_conditions';" +
            "if ($('#btnValidateSecurityAnswer').length && $('#txtSecurityKeyQuestionAnswer').length && $('input.birthDate').length) return 'sign_up_dob';" +
            "if ($('#txtNewPin').length && $('#txtConfirmPin').length) return 'sign_up_select_pin';" +
            "if ($('#txtConfirmEmail').length && $('select#question2').length) return 'sign_up_user_information';" +
            "if ($('#txtEmailValidationCode').length && ('#validateEmailBtn').length && $('#changeEmailBtn').length) return 'sign_up_user_confirmation';" +
            "if ($('#currentEmailLbl').length && $('#newEMailTextField').length && $('#validateEMailTextField').length) return 'sign_up_change_email';" +
            "if ($('#userId').length && $('#password').length && $('#button_logon').length) return 'login';" +
            "if ($('#txtAuthenticationCode').length && $('#okButton').length && $('#cancelBtn').length) return 'login_authorization';" +
            "if ($('#securityAnswer').length && $('#registerDeviceFlag').length && $('#okButton').length) return 'login_security_question';" +
            "if ($($('#port_panel_02b ul li.green_bullet')[1]).children('strong').length) return 'account_transactions';" +
            "if ($('#subHeadercardholderSummary').length ) return 'account_dashboard';" +
            "if ($(\"#errorTable p.errorText:contains('Please try again later')\").length) return 'error';" +
        "})()"
 */
 
        
        let javaScript = jsErrorMessage
        
        webView.evaluateJavaScript(javaScript) { (result, error) in
            print("PageHeading:")
            print(result ?? "no title....")
            if let resultString = result as? String {
                let resultTrimmed = resultString.trimmingCharacters(in: .whitespacesAndNewlines)
                completion(resultTrimmed)
                
            } else {
                print(error ?? "")
                completion(nil)
            }
        }
    }
    
    
    func getErrorMessage(completion: @escaping (String?) -> ()) {
        
        let jsErrorMessage = "function getErrorMessage() { " +
            "var errorInvalidField = $('.errorInvalidField').first().text().trim(); " +
            "var errorLoginField = $('.errorTextLogin').text().trim(); " +
            "var vallidationExcpMsg = $('#VallidationExcpMsg').first().text().trim(); " +
            "var errorHeading = $('.errorText').first().text().trim(); " +
            "if(errorHeading) { " +
                "errorHeading = errorHeading.trim() + \"\\n\\n\"; " +
            "} else { " +
                "errorHeading = \"\"; " +
            "} " +
            
            "if(vallidationExcpMsg || vallidationExcpMsg.length>0){ " +
                "return errorHeading + vallidationExcpMsg.trim(); " +
            "} else if(errorInvalidField || errorInvalidField.length>0) {" +
                "return errorHeading + errorInvalidField.trim(); " +
            "} else if(errorLoginField || errorLoginField.length>0) { " +
                "return errorHeading + errorLoginField.trim(); " +
            "}" +
        "}" +
            
        "getErrorMessage();"
        
        
        let javaScript = jsErrorMessage
        
        webView.evaluateJavaScript(javaScript) { (result, error) in
            
            if let resultString = result as? String {
                let resultTrimmed = resultString.trimmingCharacters(in: .whitespacesAndNewlines)
                completion(resultTrimmed)
                
            } else {
                print(error ?? "")
                completion(nil)
            }
        }
    }
  
    
    
    func checkForSuccessMessage(completion: @escaping (String?) -> ()) {
        
        let jsSuccessMessage = "$('#actionMsg .completionText').text().trim();"
        let javaScript = jsSuccessMessage
        
        webView.evaluateJavaScript(javaScript) { (result, error) in
            
            if let resultString = result as? String {
                let resultTrimmed = resultString.trimmingCharacters(in: .whitespacesAndNewlines)
                completion(resultTrimmed)
                
            } else {
                print(error ?? "")
                completion(nil)
            }
        }
    }
    
    
    
    func getPageHeader(completion: @escaping (String?) -> ()) {
        
        let jsPageTitle = "$('.PageHeader').first().text().trim();"
        webView.evaluateJavaScript(jsPageTitle) { (result, error) in
            if error != nil {
                //print("error ?? "error nil")
                
                completion(nil)
                
            } else {
                
                let stringResult = result as! String
                let pageTitle = stringResult.trimmingCharacters(in: .whitespacesAndNewlines)
                //print("pageTitle)
                
                completion(pageTitle)
            }
        }
    }
    
    func getPageTitle(completion: @escaping (String?) -> ()) {
        
        let javaScript = "$('.PageTitle').first().text().trim();"
        webView.evaluateJavaScript(javaScript) { (result, error) in
            
            if let resultString = result as? String {
                let resultTrimmed = resultString.trimmingCharacters(in: .whitespacesAndNewlines)
                completion(resultTrimmed)
                
            } else {
                print(error ?? "")
                completion(nil)
            }
            
        }
        
    }
    
    
    
    func execute(javascript:String) {
        
        
        webView.evaluateJavaScript(javascript) { (result, error) in
            if error != nil {
                print(error ?? "error nil")
                
            } else {
                
                if let result = result {
                    let stringResult = result as? String
                    let pageTitle = stringResult?.trimmingCharacters(in: .whitespacesAndNewlines)
                    print(pageTitle ?? "nil")
                }
                
            }
        }
    }
    
    func execute(javascript:String, showResultIn textView: UITextView) {
        
        
        webView.evaluateJavaScript(javascript) { (result, error) in
            if error != nil {
                print(error ?? "error nil")
                
            } else {
                
                if let result = result {
                    let stringResult = result as? String
                    let pageTitle = stringResult?.trimmingCharacters(in: .whitespacesAndNewlines)
                    print(pageTitle ?? "nil")
                    
                    DispatchQueue.main.async {
                        textView.text = pageTitle
                    }
                }
            }
        }
    }
    
    func shouldStartDecidePolicy() -> WKNavigationActionPolicy {
        
        return WKNavigationActionPolicy.allow
    }
    
}


extension EBTWebView: WKNavigationDelegate {
    
    //MARK:- WKNavigationDelegate
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("\n -- didFail -- \n")
        self.isPageLoading = false
        print(error.localizedDescription)
        
        self.responder?.didFail?()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        
        print("\n -- didFailProvisionalNavigation -- \n")
        self.isPageLoading = false
        print(error.localizedDescription)
//        let code = (error as NSError).code
        
       // self.responder?.didFailProvisionalNavigation?()
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print("\n -- navigationAction -- \n")
        print(navigationAction.request)
        self.isPageLoading = true
        decisionHandler(.allow)
    }
    
//        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//            print("\n -- navigationAction -- \n")
//    
//            
//            
//    //        print(navigationAction.request)
//    
//            print(navigationAction.navigationType)
//            print(navigationAction.targetFrame ?? "nil")
//    
//            print(navigationAction.request.url?.absoluteString ?? "no url")
//            print(navigationAction.sourceFrame.isMainFrame)
//    
//            decisionHandler(self.shouldStartDecidePolicy())
//    
//    
    //        if navigationAction.targetFrame == nil || navigationAction.targetFrame?.isMainFrame == false {
    //
    //            decisionHandler(.cancel)
    //            return
    //        }
    //
    //        let status = self.responder?.navigationAction?()
    //        if status != nil {
    //            return decisionHandler(.allow)
    //        }
    
    //        decisionHandler(.allow)
//        }
    
    //    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
    //
    //        print("\n -- navigationResponse -- \n")
    //
    ////        print(navigationResponse.response)
    //
    //        print(navigationResponse.isForMainFrame)
    //
    ////        decisionHandler(self.shouldStartDecidePolicy())
    //
    ////
    ////        if navigationResponse.isForMainFrame {
    ////            decisionHandler(.allow)
    ////        } else {
    ////            decisionHandler(.cancel)
    ////        }
    //        decisionHandler(.allow)
    //
    //    }
    
//        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
//            print("\n -- didStartProvisional -- \n")
//    
//            self.isPageLoading = true
//        }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("\n -- didFinish -- \n")
        self.isPageLoading = false
        self.responder?.didFinishLoadingWebView?()
    }
    
    //    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
    //
    //        print("\n -- didReceiveServerRedirectForProvisional -- \n")
    //    }
    //
    //    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
    //        print("\n -- didCommit -- \n")
    //
    //    }
    //
    
    
}


//
//extension EBTWebView: WKUIDelegate {
//
//    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
//        
//        if navigationAction.targetFrame == nil {
//            webView.load(navigationAction.request)
//        }
//        return nil
//        
//    }
//    
//
//}
//









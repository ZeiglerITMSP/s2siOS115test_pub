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
    let jsGetErrorCode = "$(\".errorInvalidField\").text();"
    
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
    
    // Get page headline
    func getPageHeading(completion: @escaping (String?) -> ()) {
        
        let jsHeading = "function getPageHeader() {" +
            "var pageTitleHeader = $('.PageTitle .PageHeader').first().text();" +
            "   if (pageTitleHeader.length == 0) {" +
            "       var pageTitle = $('.PageTitle').first().text();" +
            "       if (pageTitle.length == 0) {" +
            "           var pageHeading = $('.PageHeader').first().text();" +
            "           return pageHeading;" +
            "       } else {" +
            "           return pageTitle;" +
            "       }" +
            "   } else {" +
            "       return pageTitleHeader" +
            "   }" +
            "}" +
            
        "getPageHeader();"
        
        let javaScript = jsHeading
        
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
    
    func getErrorMessage(completion: @escaping (String?) -> ()) {
        
        let jsErrorMessage = "function getErrorMessage() {" +
            "var errorInvalidField = $('.errorInvalidField').first().text();" +
            "if (errorInvalidField.length == 0) {" +
                "var vallidationExcpMsg = $('#VallidationExcpMsg').first().text();" +
                "return vallidationExcpMsg" +
            "} else {" +
                "return errorInvalidField" +
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
    
    
    
    
    func getPageHeader(completion: @escaping (String?) -> ()) {
        
        let jsPageTitle = "$('.PageHeader').first().text();"
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
        
        let javaScript = "$('.PageTitle').first().text();"
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
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print("\n -- navigationAction -- \n")
    
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









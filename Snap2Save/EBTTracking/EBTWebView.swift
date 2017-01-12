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


protocol EBTWebViewDelegate {
    
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
    
    
    let jsSubmit = "void($('form')[1].submit())"
    
    let jsGetAllElements = "document.documentElement.outerHTML"
    
    let jsGetErrorCode = "$(\".errorInvalidField\").text();"
    
    // ..
    

    
    
    override init() {
        super.init()
        
        loadWebView()
    }
    
    func loadWebView() {
       
        // init and load request in webview.
        webView = WKWebView()
        webView.navigationDelegate = self
        
    }
    
    func getPageHeader(completion: @escaping (String?) -> ()) {
        
        let jsPageTitle = "$('.PageHeader').text();"
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
        
        let jsPageTitle = "$('.PageTitle').first().text();"
        webView.evaluateJavaScript(jsPageTitle) { (result, error) in
            if error != nil {
                print(error ?? "error nil")
                
                completion(nil)
                
            } else {
                
                let stringResult = result as! String
                let pageTitle = stringResult.trimmingCharacters(in: .whitespacesAndNewlines)
                print(pageTitle)
                
                completion(pageTitle)
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
                    print(pageTitle)
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

        self.responder?.didFinishLoadingWebView()
    }
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        
        print("\n -- didReceiveServerRedirectForProvisional -- \n")
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("\n -- didCommit -- \n")
        
    }
    
    
    
}














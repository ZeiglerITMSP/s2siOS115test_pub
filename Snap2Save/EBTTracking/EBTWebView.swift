//
//  WebViewMaster.swift
//  EBTTracking
//
//  Created by Appit on 12/6/16.
//  Copyright © 2016 Appit. All rights reserved.
//

import UIKit
import WebKit

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
    
    // MARK: - Properties
    var webView : WKWebView!
    var actionType: ActionType = .none
    
    var responder: EBTWebViewDelegate?
    
    var isPageLoading = false
    
    // MARK: -
    
    override init() {
        super.init()
        
        loadWebView()
    }
    
    func loadWebView() {
        
        // webview configuration
        let configuration = WKWebViewConfiguration()
        // configuration preferences
        let preferences = WKPreferences()
        preferences.javaScriptCanOpenWindowsAutomatically = true
        configuration.preferences = preferences
        // configuration user content
        let controller = WKUserContentController()
        
        // login user script
        let loginJS = prepareUserScript(fromFile: "ebt_scrapping")
        controller.addUserScript(loginJS)
        
        // registration user script
        let registrationJS = prepareUserScript(fromFile: "ebt_registration_scrapping")
        controller.addUserScript(registrationJS)
        
        configuration.userContentController = controller
        // create webview
        webView = WKWebView(frame: CGRect.zero, configuration: configuration)
        webView.navigationDelegate = self
    }
    
    func prepareUserScript(fromFile fileName:String) -> WKUserScript {
        
        // load registration scrapping script
        let jsPath = Bundle.main.path(forResource: fileName, ofType: "js");
        var scriptSourceCode = ""
        do {
            scriptSourceCode = try String(contentsOfFile: jsPath!, encoding: String.Encoding.utf8)
        } catch _ {
        }
        
        let script = WKUserScript(source: scriptSourceCode, injectionTime: WKUserScriptInjectionTime.atDocumentStart, forMainFrameOnly: true)
        
        return script
    }
    
    func loadEmptyPage() {
        
        webView.load(URLRequest.init(url: URL(string: "about:blank")!))
    }
    

    func getPageHeading(completion: @escaping (String?) -> ()) {
        
        let jsErrorMessage = "identifyPage();"
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
        
        let javaScript = "getErrorMessage();"
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
        
        let jsSuccessMessage = "checkForSuccessMessage();"
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
        
        let jsPageTitle = "getPageHeader();"
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
        
        let javaScript = "getPageTitle();"
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

    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print("\n -- navigationAction -- \n")
        print(navigationAction.request)
        self.isPageLoading = true
        decisionHandler(.allow)
    }
 
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("\n -- didFinish -- \n")
        self.isPageLoading = false
        self.responder?.didFinishLoadingWebView?()
    }
    

    
}








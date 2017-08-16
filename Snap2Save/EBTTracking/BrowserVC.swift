//
//  BrowserVC.swift
//  Snap2Save
//
//  Created by Appit on 12/21/16.
//  Copyright © 2016 Appit. All rights reserved.
//

import UIKit

class BrowserVC: UIViewController {

    // Outles
    
    @IBOutlet weak var broswerView: UIView!
    @IBOutlet weak var queryTextView: UITextView!
    
    @IBOutlet weak var resultTextView: UITextView!
    
   
    @IBOutlet weak var urlTextfield: UITextField!
    
    @IBAction func loadUrlAction(_ sender: Any) {
        
        
        let url = NSURL(string: urlTextfield.text!)
        let request = NSURLRequest(url: url! as URL)
        
        webViewMaster.webView.load(request as URLRequest)
                
    }
    
    @IBAction func executeQueryAction(_ sender: Any) {
        
        self.view.endEditing(true)
        webViewMaster.execute(javascript: queryTextView.text, showResultIn: resultTextView)
    }
    
    
    
    @IBAction func backAction(_ sender: Any) {
        
        if webViewMaster.webView.canGoBack {
            webViewMaster.webView.goBack()
        }
    }
    
    @IBAction func frontAction(_ sender: Any) {
        
        if webViewMaster.webView.canGoForward {
            webViewMaster.webView.goForward()
        }

    }
    
    
    @IBAction func reloadAction(_ sender: Any) {
        
        webViewMaster.webView.reload()
    }
    
    @IBAction func printAction(_ sender: Any) {
        webViewMaster.webView.evaluateJavaScript("document.documentElement.outerHTML") { (result, error) in
            
            //print(result ?? "")
            //print(error ?? "")
            
            self.resultTextView.text = result as? String ?? "--"
        }
    }
    
    let webViewMaster: EBTWebView = EBTWebView.shared
    
    // MARK:-
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Web View"
        addWebView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        addWebView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func addWebView() {
        
        DispatchQueue.main.async {
            
            
            let webView = self.webViewMaster.webView!
            webView.isHidden = false
            self.broswerView.addSubview(webView)
            
//            webView.frame = self.broswerView.frame
//            print(webView)
//            print(self.broswerView)
            
//            // constraints
            webView.translatesAutoresizingMaskIntoConstraints = false
            let left = NSLayoutConstraint(item: webView, attribute: .left, relatedBy: .equal, toItem: webView.superview, attribute: .left, multiplier: 1, constant: 0)
            let right = NSLayoutConstraint(item: webView, attribute: .right, relatedBy: .equal, toItem: webView.superview, attribute: .right, multiplier: 1, constant: 0)
            let top = NSLayoutConstraint(item: webView, attribute: .top, relatedBy: .equal, toItem: webView.superview, attribute: .top, multiplier: 1, constant: 0)
            let bottom = NSLayoutConstraint(item: webView, attribute: .bottom, relatedBy: .equal, toItem: webView.superview, attribute: .bottom, multiplier: 1, constant: 0)
            webView.superview?.addConstraint(left)
            webView.superview?.addConstraint(right)
            webView.superview?.addConstraint(top)
            webView.superview?.addConstraint(bottom)
            
        }
        
    }
   
    
   
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  EBTLoginTVC.swift
//  Snap2Save
//
//  Created by Appit on 12/20/16.
//  Copyright © 2016 Appit. All rights reserved.
//

import UIKit


class EBTLoginTVC: UITableViewController {

    
    // Properties
    let ebtWebView: EBTWebView = EBTWebView.shared
    
    // Outlets
    @IBOutlet weak var userIdField: AIPlaceHolderTextField!
    @IBOutlet weak var passwordField: AIPlaceHolderTextField!
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    // Action
    @IBAction func loginAction(_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        print(userIdField.contentTextField.text!)
        print(passwordField.contentTextField.text!)
        
    }
    
    @IBAction func registrationAction(_ sender: UIButton) {
        
        self.view.endEditing(true)
        
    }
    
    // MARK:-
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userIdField.contentTextField.textFieldType = .PhoneNumberTextField
        userIdField.contentTextField.textFieldType = .NormalTextField
        
        passwordField.contentTextField.isSecureTextEntry = true
        
        // Automatic height
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44
        
        ebtWebView.responder = self
        
        loadLoginPage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            if (errorMessageLabel.text == nil) {
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
        
        ebtWebView.webView.load(request as URLRequest)
        
    }
    
    // validate fields
    // autofill fields
    // submit action
    
    // check status
    // success action
    // fail action
    

}

extension EBTLoginTVC: EBTWebViewDelegate {
    
    func didFail(withError message: String) {
        
        errorMessageLabel.text = message
        self.tableView.reloadData()
    }
    
    func didSuccess() {
        
        performSegue(withIdentifier: "CalenderInputVC", sender: nil)
        
    }
    
    func didFinishLoadingWebView() {
        
        
        
    }
    
}


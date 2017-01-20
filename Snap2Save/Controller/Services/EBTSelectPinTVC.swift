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
        
        case pin
    }
    
    // Properties
    let ebtWebView: EBTWebView = EBTWebView.shared
    fileprivate var actionType: ActionType?
    var pageTitle = "ebt.pin".localized()
    
    // Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var errorTitleLabel: UILabel!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var pinField: AIPlaceHolderTextField!
    @IBOutlet weak var confirmPinField: AIPlaceHolderTextField!
    @IBOutlet weak var nextActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var currentPinActivityIndicator: UIActivityIndicatorView!
    
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var useCurrentPinButton: UIButton!
    
    // Actions
    @IBAction func nextAction(_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        nextButton.isEnabled = false
        nextActivityIndicator.startAnimating()
        
        actionType = ActionType.pin
        
        validatePage()
        
    }
    
    @IBAction func useCurrentPinAction(_ sender: UIButton) {
        
        
    }
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        pinField.contentTextField.aiDelegate = self
        confirmPinField.contentTextField.aiDelegate = self
        
        pinField.contentTextField.returnKeyType = .next
        pinField.contentTextField.isSecureTextEntry = true
        pinField.contentTextField.updateUIAsPerTextFieldType()
        
        confirmPinField.contentTextField.returnKeyType = .done
        confirmPinField.contentTextField.isSecureTextEntry = true
        confirmPinField.contentTextField.updateUIAsPerTextFieldType()
        
        // Back Action
        self.navigationItem.addBackButton(withTarge: self, action: #selector(backAction))
        
        // Automatic height
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44
        
        errorMessageLabel.text = nil
        
        ebtWebView.responder = self
        
        AppHelper.setRoundCornersToView(borderColor: APP_ORANGE_COLOR, view: nextButton, radius: 2.0, width: 1.0)
        AppHelper.setRoundCornersToView(borderColor: APP_GRREN_COLOR, view: useCurrentPinButton, radius: 2.0, width: 1.0)
        
        addTapGesture()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadContent()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        ebtWebView.responder = self
        
        let webView = ebtWebView.webView!
        self.view.addSubview(webView)
        webView.sendSubview(toBack: self.view)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - To Hide Keyboard
    
    func addTapGesture() {
        
        // Tap Gesuture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnTableView(recognizer:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    func tapOnTableView(recognizer: UITapGestureRecognizer) {
        
        self.view.endEditing(true)
    }
    
    func reloadContent() {
        
        DispatchQueue.main.async {
            
            self.title = "REGISTRATION".localized()
            self.pageTitle = "ebt.pin".localized()
            self.pinField.placeholderText = "PIN".localized()
            self.confirmPinField.placeholderText = "CONFIRM PIN".localized()
            self.errorTitleLabel.text = ""//"ebt.error.title".localized()
            
            self.nextButton.setTitle("NEXT".localized(), for: .normal)
            self.useCurrentPinButton.setTitle("USE CURRENT PIN".localized(), for: .normal)
            
        }
        
        
    }

    func moveToNextController(identifier:String) {
        
        let vc = UIStoryboard(name: "Home", bundle: Bundle.main).instantiateViewController(withIdentifier: identifier)
        self.navigationController?.pushViewController(vc, animated: true)
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
        
//        self.navigationController?.popViewController(animated: true)
        showAlert(title: "Are you sure ?", message: "The process will be cancelled.", action: #selector(cancelProcess))
    }
    
    func cancelProcess() {
        
        // Define identifier
        let notificationName = Notification.Name("POPTOLOGIN")
        // Post notification
        NotificationCenter.default.post(name: notificationName, object: nil)
    }

}

extension EBTSelectPinTVC {
    // MARK: Scrapping
    
    func validatePage() {
        
        ebtWebView.getPageHeading(completion: { result in
            
            if let pageTitle = result {
                // isCurrentPage
                if pageTitle == self.pageTitle {
                    // current page
                    if self.actionType == ActionType.pin {
                        self.actionType = nil
                        self.autoFill()
                    } else {
                        self.checkForErrorMessage()
                    }
                } else {
                    self.validateNextPage()
                }
            } else {
                
            }
            
        })
        
    }

    
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
                
                self.nextButton.isEnabled = true
                self.nextActivityIndicator.stopAnimating()
                
            } else {
                print(result ?? "result nil")
                self.checkForErrorMessage()
            }
        }
    }
    
    func checkForErrorMessage() {
        
        ebtWebView.getErrorMessage(completion: { result in
            
            if let errorMessage = result {
                if errorMessage.characters.count > 0 {
                    // error message
                    
                    // update view
                    if self.ebtWebView.isPageLoading == false {
                        self.nextButton.isEnabled = true
                        self.nextActivityIndicator.stopAnimating()
                    }
                    
                    self.errorMessageLabel.text = errorMessage
                    self.tableView.reloadData()
                    
                } else {
                    
                }
            } else {
                
            }
        })
    }
    
    
    func validateNextPage() {
        
        ebtWebView.getPageHeading(completion: { result in
            
            if let pageTitle = result {
                
                if let nextVCIdentifier = EBTConstants.getEBTViewControllerName(forPageTitle: pageTitle) {
                    self.moveToNextController(identifier: nextVCIdentifier)
                } else {
                    // unknown page
                    print("UNKNOWN PAGE")
                }
                
            } else {
                // is page not loaded
                print("PAGE NOT LOADED YET..")
            }
            
        })
        
    }

    
}

extension EBTSelectPinTVC: EBTWebViewDelegate {
    
    func didFinishLoadingWebView() {
        
        validatePage()
    }
    
}

extension EBTSelectPinTVC: AITextFieldProtocol {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == pinField.contentTextField {
            
             confirmPinField.contentTextField.becomeFirstResponder()
        } else if textField == confirmPinField.contentTextField {
            
            textField.resignFirstResponder()
        }
        
        return true
    }
    
}

//
//  EBTCardNumberTVC.swift
//  Snap2Save
//
//  Created by Appit on 12/22/16.
//  Copyright © 2016 Appit. All rights reserved.
//

import UIKit

class EBTCardNumberTVC: UITableViewController {

    fileprivate enum ActionType {
        
        case waitingForPageLoad
        case cardNumber
        case accept
    }
    
    // Properties
    var errorMessage:String?
    let ebtWebView: EBTWebView = EBTWebView.shared
    
    fileprivate var actionType: ActionType?
    
    var pageTitle = "ebt.cardnumber".localized()
    
    // Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var cardNumberField: AIPlaceHolderTextField!
    @IBOutlet weak var errorTitleLabel: UILabel!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var nextActivityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var requiredInfoLabel: UILabel!
    
    @IBOutlet weak var nextButton: UIButton!
    
    // MARK: - Actions
    @IBAction func nextAction(_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        nextButton.isEnabled = false
        nextActivityIndicator.startAnimating()
        
        actionType = ActionType.cardNumber
        
        validatePage()

    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        
        self.view.endEditing(true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        errorMessageLabel.text = nil
        cardNumberField.contentTextField.aiDelegate = self
        cardNumberField.contentTextField.returnKeyType = .done
        cardNumberField.contentTextField.updateUIAsPerTextFieldType()
        
        // Back Action
        self.navigationItem.addBackButton(withTarge: self, action: #selector(backAction))
        
        // Automatic height
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44
        
        ebtWebView.responder = self
        
//        loadSignupPage()
        
        AppHelper.setRoundCornersToView(borderColor: APP_ORANGE_COLOR, view: nextButton, radius: 2.0, width: 1.0)
        
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
        self.view.sendSubview(toBack: webView)
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
            
            
            self.title = "ebt.title.register".localized()
            
            self.pageTitle = "ebt.cardnumber".localized()
            self.cardNumberField.placeholderText = "CARD NUMBER".localized()
            self.errorTitleLabel.text = ""
            self.requiredInfoLabel.text = "*Required information".localized()
            
            self.titleLabel.text = "ebt.cardnumber.titleLabel".localized()
            self.messageLabel.text = "ebt.cardnumber.messageLabel".localized()
            self.nextButton.setTitle("NEXT".localized(), for: .normal)
            
            self.tableView.reloadData()
        }
        
    }

    func moveToNextController(identifier:String) {
        
        let vc = UIStoryboard(name: "Home", bundle: Bundle.main).instantiateViewController(withIdentifier: identifier)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

    // MARK: - Table view
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 2 {
            if (errorMessageLabel.text == nil || errorMessageLabel.text == "") {
                return 0
            }
        }
        
        return UITableViewAutomaticDimension
    }
    
    
    // MARK: -
    
    func backAction() {
        
        showAlert(title: "Are you sure ?".localized(), message: "The process will be cancelled.".localized(), action: #selector(cancelProcess))
    }
    
    func cancelProcess() {
        
        // Define identifier
        let notificationName = Notification.Name("POPTOLOGIN")
        // Post notification
        NotificationCenter.default.post(name: notificationName, object: nil)
    }
    
    func showForceQuitAlert() {
        
        self.showAlert(title: "ebt.alert.timeout.title".localized(), message: "ebt.alert.timeout.message".localized(), action: #selector(self.cancelProcess), showCancel: false)
    }
    
}

extension EBTCardNumberTVC {
 
    // MARK: Scrapping
    
    func loadSignupPage() {

        let signupUrl_en = kEBTSignupUrl
        
        let url = NSURL(string: signupUrl_en)
        let request = NSURLRequest(url: url! as URL)
        
        ebtWebView.webView.load(request as URLRequest)
    }
    
    
    func validatePage() {
        
        ebtWebView.getPageHeading(completion: { result in
            
            if let pageTitle = result {
                // isCurrentPage
                if pageTitle == self.pageTitle {
                    // current page
                    if self.actionType == ActionType.cardNumber {
                        self.actionType = nil
                        self.autoFill()
                    } else {
                        self.checkForErrorMessage()
                    }
                } else if pageTitle == "ebt.acceptTerms".localized() {
                  
                    self.acceptSubmit()
                } else {
                    self.validateNextPage()
                }
                
            } else {
                if self.ebtWebView.isPageLoading == false {
                    self.showForceQuitAlert()
                }
            }
            
        })
        
    }
    

    func autoFill() {
        
        let cardNumber = self.cardNumberField.contentTextField.text!
        
        let jsCardNumber = "$('#txtCardNumber').val('\(cardNumber)');"
        let jsSubmit = "void($('#btnValidateCardNumber').click());"
        
        let javaScript =  jsCardNumber + jsSubmit
        
        ebtWebView.webView.evaluateJavaScript(javaScript) { (result, error) in
            if error != nil {
                print(error ?? "error nil")
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
    

    func acceptSubmit() {
        
        let jsAcceptClick = "void($('form')[1].submit());"
        
        ebtWebView.webView.evaluateJavaScript(jsAcceptClick) { (result, error) in
            if error != nil {
                print(error ?? "error nil")
            } else {
                print(result ?? "result nil")
            }
        }
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

extension EBTCardNumberTVC: EBTWebViewDelegate {
    
    func didFinishLoadingWebView() {
        
        validatePage()
    }
    
    func didFail() {
        showForceQuitAlert()
    }
    
    func didFailProvisionalNavigation() {
        showForceQuitAlert()
    }
    
}

extension EBTCardNumberTVC: AITextFieldProtocol {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    
}


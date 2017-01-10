//
//  EBTSecurityQuestionTVC.swift
//  Snap2Save
//
//  Created by Appit on 12/22/16.
//  Copyright © 2016 Appit. All rights reserved.
//

import UIKit

class EBTSecurityQuestionTVC: UITableViewController {

    fileprivate enum ActionType {
        
        case waitingForPageLoad
        case cardNumber
        case accept
    }
    
    // Properties
    let ebtWebView: EBTWebView = EBTWebView.shared
    fileprivate var actionType: ActionType?
    
    
    // Ouetles
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!

    @IBOutlet weak var errorTitleLabel: UILabel!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var securityQuestionTitleLabel: UILabel!
    @IBOutlet weak var securityQuestionLabel: UILabel!
    
    @IBOutlet weak var securityAnswerField: AIPlaceHolderTextField!
    
    @IBOutlet weak var confirmActivityIndicator: UIActivityIndicatorView!
    
    
    
    // Actions
    
    @IBAction func confirmAction(_ sender: UIButton) {
        
       // performSegue(withIdentifier: "EBTDateOfBirthTVC", sender: nil)
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Back Action
        self.navigationItem.addBackButton(withTarge: self, action: #selector(backAction))
        
        // Automatic height
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44
        
        errorMessageLabel.text = nil
        
        ebtWebView.responder = self
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        ebtWebView.responder = self
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        self.navigationController?.popViewController(animated: true)
//        showAlert(title: "Are you sure ?", message: "The process will be cancelled.", action: #selector(cancelProcess))
    }
    
    func cancelProcess() {
        
        // Define identifier
        let notificationName = Notification.Name("POPTOLOGIN")
        // Post notification
        NotificationCenter.default.post(name: notificationName, object: nil)
    }

    

}

extension EBTSecurityQuestionTVC: EBTWebViewDelegate {
    
    func didFinishLoadingWebView() {
        
//        checkForErrorMessage()
    }
    
}

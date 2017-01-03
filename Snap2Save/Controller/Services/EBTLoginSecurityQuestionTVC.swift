//
//  EBTLoginSecurityQuestionTVC.swift
//  Snap2Save
//
//  Created by Appit on 1/2/17.
//  Copyright © 2017 Appit. All rights reserved.
//

import UIKit

class EBTLoginSecurityQuestionTVC: UITableViewController {

    // Properties
    let ebtWebView: EBTWebView = EBTWebView.shared
    
    
    // Ouetles
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var errorTitleLabel: UILabel!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var securityQuestionField: AIPlaceHolderTextField!
    @IBOutlet weak var securityAnswerField: AIPlaceHolderTextField!
    
    // Actions
    
    @IBAction func confirmAction(_ sender: UIButton) {
        
         performSegue(withIdentifier: "EBTDashboardTVC", sender: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        errorMessageLabel.text = nil
        
        // Back Action
        self.navigationItem.addBackButton(withTarge: self, action: #selector(backAction))
        
        // Automatic height
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44
        
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
        
        showAlert(title: "Are you sure ?", message: "The process will be cancelled.", action: #selector(cancelProcess))
    }
    
    func cancelProcess() {
        
        // Define identifier
        let notificationName = Notification.Name("POPTOLOGIN")
        // Post notification
        NotificationCenter.default.post(name: notificationName, object: nil)
    }
    

}

extension EBTLoginSecurityQuestionTVC: EBTWebViewDelegate {
    
    
    func didFinishLoadingWebView() {
        
//        if actionType == .generate {
//            
//            //validateSubmitAction()
//        } else if actionType == .regenerate {
//            
//            actionType = nil
//            checkForStatusMessage()
//        }
    }
    
}


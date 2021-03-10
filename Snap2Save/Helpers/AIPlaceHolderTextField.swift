//
//  AIPlaceHolderTextField.swift
//  Snap2Save
//
//  Created by Appit on 12/20/16.
//  Copyright © 2016 Appit. All rights reserved.
//

import UIKit

protocol AIPlaceHolderTextFieldDelegate {
    
    func didTapOnInfoButton(textfield: AIPlaceHolderTextField)
    
}

@IBDesignable class AIPlaceHolderTextField: UIView {

    // Outlets
    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var contentTextField: AITextField!
//    @IBOutlet weak var requiredLabel: UILabel!
    
    var delegate:AIPlaceHolderTextFieldDelegate?
    
    var underlineLayer: CALayer!
    
    // Designable
    @IBInspectable var placeholderText: String = "" {
        didSet {
            
            if isRequredField {
                placeholderLabel.attributedText = placeholderText.localized().makeAsRequired()
            } else {
                placeholderLabel.text = placeholderText
            }
            
        }
    }
    
    @IBInspectable var placeholderTextField: String = "" {
        didSet {
            contentTextField.placeholder = placeholderTextField
        }
    }
    
    @IBInspectable var contentText: String = "" {
        didSet {
            contentTextField.text = contentText
        }
    }
    
    @IBInspectable var isSelected:Bool = false {
        
        didSet {
            
            refreshView()
        }
    }
    
    @IBInspectable var isRequredField:Bool = false {
        
        didSet {
            
        }
    }
    
    @IBInspectable var showInfoButton:Bool = false {
        
        didSet {
            
            infoButton.isHidden = !showInfoButton
        }
    }
    
    @IBInspectable var showUnderline:Bool = true {
        
        didSet {
            
            contentTextField.showUnderline = showUnderline
            contentTextField.updateUnderline()
        }
    }
    
    
    @IBOutlet weak var infoButton: UIButton!
    
    @IBAction func infoButtonAction(_ sender: UIButton) {
        
        self.delegate?.didTapOnInfoButton(textfield: self)
    }
    
    @IBInspectable var selectedColor: UIColor = UIColor(red: 84/255, green: 190/255, blue: 56/255, alpha: 1.0) {
        didSet {
            
            refreshView()
        }
    }

    @IBInspectable var normalColor: UIColor = UIColor(red: 104/255, green: 128/255, blue: 94/255, alpha: 0.5) {
        didSet {
            
            refreshView()
        }
    }

    
    // Our custom view from the XIB file
    var view: UIView!
    
    override init(frame: CGRect) {
        // 1. setup any properties here
        
        // 2. call super.init(frame:)
        super.init(frame: frame)
        
        // 3. Setup view from .xib file
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        // 1. setup any properties here
        
        // 2. call super.init(coder:)
        super.init(coder: aDecoder)
        
        // 3. Setup view from .xib file
        xibSetup()
    }
    
    func xibSetup() {
        view = loadViewFromNib()
        
        // use bounds not frame or it'll be offset
        view.frame = bounds
        
        // Make the view stretch with containing view
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "AIPlaceHolderTextField", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        contentTextField.placeHolderLabel = placeholderLabel
        
        contentTextField.selectedColor = selectedColor
        contentTextField.normalColor = normalColor
        
        contentTextField.updateUnderline()
        
        self.infoButton.isHidden = !showInfoButton
        
        return view
    }
    
    func refreshView() {
        
        if isSelected {
            placeholderLabel.textColor = selectedColor
        } else {
            placeholderLabel.textColor = normalColor
        }
        
    }
    
   
    
}


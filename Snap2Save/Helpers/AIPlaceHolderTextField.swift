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
    @IBOutlet weak var requiredLabel: UILabel!
    
    var delegate:AIPlaceHolderTextFieldDelegate?
    
    var underlineLayer: CALayer!
    
    // Designable
    @IBInspectable var placeholderText: String = "" {
        didSet {
            placeholderLabel.text = placeholderText
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
            
           requiredLabel.isHidden = !isRequredField
        }
    }
    
    @IBInspectable var showInfoButton:Bool = false {
        
        didSet {
            
            infoButton.isHidden = !showInfoButton
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
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "AIPlaceHolderTextField", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        contentTextField.placeHolderLabel = placeholderLabel
        contentTextField.textFieldType = AITextField.AITextFieldType.PhoneNumberTextField
        
        contentTextField.selectedColor = selectedColor
        contentTextField.normalColor = normalColor
        
        contentTextField.createUnderline(withColor: normalColor, padding: 0, height: 1)
        
        self.infoButton.isHidden = !showInfoButton
        self.requiredLabel.isHidden = !isRequredField
        
        return view
    }
    
    func refreshView() {
        
        if isSelected {
            // 84 190 56
            placeholderLabel.textColor = selectedColor
//            contentTextField.createUnderline(withColor: selectedColor, padding: 0, height: 2)
           // contentTextField.textColor = selectedColor
        } else {
            
            placeholderLabel.textColor = normalColor
//            contentTextField.createUnderline(withColor: normalColor, padding: 0, height: 2)
//            contentTextField.textColor = normalColor
        }
        
        
        
//        contentTextField.layer.borderColor = UIColor.red.cgColor
//        contentTextField.layer.borderWidth = 1
        
      //  contentTextField.createUnderline(withColor: selectedColor, padding: 0, height: 2)
        
       // createUnderline(withColor: selectedColor, padding: 6, height: 2)
    }
    
    /*
    func createUnderline(withColor color:UIColor, padding:CGFloat, height:CGFloat) {
        
        if (underlineLayer != nil) {
            underlineLayer.removeFromSuperlayer()
        }
        
        underlineLayer = CALayer()
        underlineLayer.borderColor = color.cgColor
        underlineLayer.frame = CGRect(x: padding, y: self.frame.size.height - height, width: self.frame.size.width-(2*padding), height: self.frame.size.height)
        underlineLayer.borderWidth = height
        self.contentTextField.layer.addSublayer(underlineLayer)
        self.contentTextField.layer.masksToBounds = true
        
    }
    
 */
    
    
}


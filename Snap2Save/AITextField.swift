//
//  AITextField.swift
//  AITextField
//
//  Created by Sreekanth on 19/10/16.
//  Copyright © 2016 Sreekanth. All rights reserved.
//

import UIKit

protocol AITextFieldProtocol {
    // protocol definition
    
    func keyBoardHidden(textField:UITextField)

}
class AITextField: UITextField, UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource
{
    enum AITextFieldType
    {
        case NormalTextField
        case UIPickerTextField
        case UICountryCodePickerTextField
        case DatePickerTextField
        case TimePickerTextField
        case TextPickerTextField
        case PasswordTextField
        case EmailTextField
        case PhoneNumberTextField
        
    }

    var textFieldType:AITextFieldType = AITextFieldType.NormalTextField
    var datePicker:UIDatePicker? = nil
    var picker:UIPickerView? = nil
    let dateFormatString = "MMM dd, yyyy"
    let timeFormatString = "hh:mm a"
    var selectedDate:NSDate? = nil
    var pickerViewArray:NSMutableArray? = nil
    var selectedTextInPicker:String = ""
    var aiDelegate:AITextFieldProtocol? = nil
    var selectedCountryRegion:String? = nil
    
    var underlineLayer: CALayer!
    var placeHolderLabel: UILabel?
    
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)!
        
        delegate = self
        createBorder(borderColor: UIColor.white,xpos: 10)
        
    }
    required override init(frame: CGRect)
    {
        super.init(frame: frame)
        delegate = self
        createBorder(borderColor: UIColor.white,xpos: 10)
    }
    
    func createBorder(borderColor:UIColor, xpos:CGFloat) {
        
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = borderColor.cgColor
        border.frame = CGRect(x: xpos, y: self.frame.size.height-width, width: self.frame.size.width-(2*xpos), height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
    
    
    // MARK: Underline
    func createUnderline(withColor color:UIColor, padding:CGFloat, height:CGFloat) {
        
        if (underlineLayer != nil) {
            underlineLayer.removeFromSuperlayer()
        }
        
        underlineLayer = CALayer()
        underlineLayer.borderColor = color.cgColor
        underlineLayer.frame = CGRect(x: padding, y: self.frame.size.height - height, width: self.frame.size.width-(2*padding), height: self.frame.size.height)
        underlineLayer.borderWidth = height
        self.layer.addSublayer(underlineLayer)
        self.layer.masksToBounds = true
        
        
        //..
        placeHolderLabel?.textColor = color
    }
    
    
    
    
    func setLeftGap (width:Int, placeHolderImage:UIImage)
    {
        let leftGap:UIView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: Int(self.frame.size.height)))
        leftGap.backgroundColor = UIColor.clear
        
        let imageView:UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: Int(self.frame.size.height)))
        
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        imageView.image = placeHolderImage
        
        leftGap.addSubview(imageView)
        
        self.leftView = leftGap;
        self.leftViewMode = UITextFieldViewMode.always

    }
    
    func setRightGap (width:Int, placeHolderImage:UIImage)
    {
        let rightGap:UIView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: Int(self.frame.size.height)))
        rightGap.backgroundColor = UIColor.clear
        
        let imageView:UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: Int(self.frame.size.height)))
        
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        imageView.image = placeHolderImage
        
        rightGap.addSubview(imageView)
        
        self.rightView = rightGap
        self.rightViewMode = UITextFieldViewMode.always
    }
    
    func updateUIAsPerTextFieldType() {
        
        switch textFieldType
        {
        case AITextFieldType.NormalTextField:
            break;
            
            
        case AITextFieldType.UIPickerTextField:
            setToolBar()
            break;
            
        case AITextFieldType.DatePickerTextField:
            addDatePicker()
            setToolBar()
            break;
            
        case AITextFieldType.TimePickerTextField:
            addTimePicker()
            setToolBar()
            break;
        case AITextFieldType.TextPickerTextField:
            addTextPicker()
            setToolBar()
            break;
        case AITextFieldType.UICountryCodePickerTextField:
            addTextPicker()
            setToolBar()
            break;
        case AITextFieldType.PasswordTextField:
            self.isSecureTextEntry = true
            break;
            
        case AITextFieldType.EmailTextField:
            self.keyboardType = UIKeyboardType.emailAddress
            self.autocorrectionType = UITextAutocorrectionType.no
            break;
            
        case AITextFieldType.PhoneNumberTextField:
            self.keyboardType = UIKeyboardType.phonePad
            setToolBar()
            break;
        }
        self.textColor = UIColor.white
        self.font = UIFont.systemFont(ofSize: 16)
        self.layoutIfNeeded()
    }
    func addTextPicker()
    {
        self.picker = UIPickerView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 255))
        self.picker?.delegate = self
        self.picker?.dataSource = self
        self.inputView = self.picker;
    }
    func addDatePicker()
    {
        self.datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 255))
        self.datePicker?.datePickerMode = UIDatePickerMode.date
        self.inputView = self.datePicker
    }
    func addTimePicker() {
        self.datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 255))
        self.datePicker?.datePickerMode = UIDatePickerMode.time
        self.inputView = self.datePicker
    }
    func setToolBar()
    {
        let toolBar = UIToolbar()
        toolBar.frame = CGRect(x: 0, y: 0, width:UIScreen.main.bounds.width, height: 44)
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(AITextField.doneButtonClicked))
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(AITextField.cancelButtonClicked))
        
        let flixibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        
        toolBar.items = [cancelButton,flixibleSpace,doneButton]
        
        self.inputAccessoryView = toolBar
    }
    /*
     When user click done button
     */
    func doneButtonClicked()
    {
        switch self.textFieldType {
            
        case AITextFieldType.UIPickerTextField:
            let selectedIndex:Int = self.getSelectedIndex()
            
            let selectedOption = self.pickerViewArray?.object(at: selectedIndex) as! String
            
            self.text = selectedOption
            
            break
        case AITextFieldType.DatePickerTextField:
            setDateTextWithFormatter(string: self.dateFormatString as NSString)
            
            break
        case AITextFieldType.TimePickerTextField:
            setDateTextWithFormatter(string: self.timeFormatString as NSString)
            break
        case AITextFieldType.TextPickerTextField:
            setPickerViewTexttoTextField()
            break;
        case AITextFieldType.UICountryCodePickerTextField:
            setSelectedCountryTexttoTextField()
            break;
        default:
            break
        }
        self.aiDelegate?.keyBoardHidden(textField: self)
        self.resignFirstResponder()
    }
    /*
     When user clicked cancel button.
     */
    func cancelButtonClicked()
    {
        switch self.textFieldType {
        case AITextFieldType.DatePickerTextField:
            setOldDateTextWithFormatter(string: self.dateFormatString as NSString)
            
            break
        case AITextFieldType.TimePickerTextField:
            setOldDateTextWithFormatter(string: self.timeFormatString as NSString)
            break
        case AITextFieldType.TextPickerTextField:
            setOldTexttoTextField()
            break
        default:
            break
        }
        self.resignFirstResponder()
    }
    
    func setPickerViewTexttoTextField()
    {
        let selectedOption:String = self.pickerViewArray?.object(at: (self.picker?.selectedRow(inComponent: 0))!) as! String
        self.text = selectedOption
        self.selectedTextInPicker = selectedOption
    }
    func setSelectedCountryTexttoTextField()
    {
        let selectedCountry = self.pickerViewArray?.object(at: (self.picker?.selectedRow(inComponent: 0))!) as!NSDictionary
        
        let selectedOption:String = selectedCountry["code"] as! String
        self.text = selectedOption
        self.selectedCountryRegion = selectedCountry["name"] as? String
    }
    func setOldTexttoTextField()
    {
        self.text = self.selectedTextInPicker
    }
    func setDateTextWithFormatter(string:NSString)
    {
        self.selectedDate = self.datePicker?.date as NSDate? //NSDate.init(timeIntervalSinceReferenceDate: (self.datePicker?.date.timeIntervalSince1970)!) //self.datePicker?.date as
        let date_Formatter = DateFormatter()
        date_Formatter.dateFormat = string as String!
        let dateString = date_Formatter.string(from: (self.datePicker?.date)!)
        self.text = dateString
        
        
    }
    func setOldDateTextWithFormatter(string:NSString)
    {
        if (self.selectedDate != nil)
        {
            let date_Formatter = DateFormatter()
            date_Formatter.dateFormat = string as String!
            let dateString = date_Formatter.string(from: self.selectedDate as! Date)
            self.text = dateString

        }
    }
    
    func getSelectedIndex() -> Int
    {
     
        if self.textFieldType == AITextFieldType.TextPickerTextField {
            return (self.picker?.selectedRow(inComponent: 0))!
        }
        return 100000
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("focused")
        createUnderline(withColor: .green, padding: 0, height: 2)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("lost focus")
        createUnderline(withColor: .gray, padding: 0, height: 1)
        self.aiDelegate?.keyBoardHidden(textField: self)
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return (self.pickerViewArray?.count)!
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if self.textFieldType == AITextFieldType.UICountryCodePickerTextField
        {
            let selectedOption:NSDictionary = self.pickerViewArray?.object(at: row) as! NSDictionary
            return NSAttributedString(string: selectedOption["code"] as! String, attributes: nil)
        }
        let selectedOption:NSString = self.pickerViewArray?.object(at: row) as! NSString
        return NSAttributedString(string: selectedOption as String, attributes: nil)
    }
}

//
//  AITextField.swift
//  AITextField
//
//  Created by Sreekanth on 19/10/16.
//  Copyright © 2016 Sreekanth. All rights reserved.
//

import UIKit
import Localize_Swift

@objc protocol AITextFieldProtocol {
    // protocol definition
    
    @objc optional func keyBoardHidden(textField:UITextField)
    @objc optional func textFieldShouldReturn(_ textField: UITextField) -> Bool
    @objc optional func getSelectedIndexFromPicker(selectedIndex : NSInteger,textField:AITextField)
    @objc optional func aiTextField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    
    @objc optional func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    
    @objc optional func  textFieldShouldEndEditing(_ textField: UITextField) -> Bool
}


class AITextField: UITextField {
    
    enum AITextFieldType {
        
        case NormalTextField
        case UIPickerTextField
        case UICountryCodePickerTextField
        case DatePickerTextField
        case TimePickerTextField
        case TextPickerTextField
        case PasswordTextField
        case EmailTextField
        case PhoneNumberTextField
        case NumberTextField
    }
    
    @IBInspectable var text_Color: UIColor? = UIColor.white

    var textFieldType:AITextFieldType = AITextFieldType.NormalTextField
    var datePicker:UIDatePicker? = nil
    var picker:UIPickerView? = nil
    var dateFormatString = "MMM dd, yyyy"
    let timeFormatString = "hh:mm a"
    var selectedDate:NSDate? = nil
    var pickerViewArray:NSMutableArray? = nil
    var selectedTextInPicker:String = ""
    weak var aiDelegate: AITextFieldProtocol?
    var selectedCountryRegion:String? = nil
    
    var showUnderline: Bool = true
    var underlineLayer: CALayer!
    var placeHolderLabel: UILabel?
    
    var selectedColor: UIColor = UIColor(red: 84/255, green: 190/255, blue: 56/255, alpha: 1.0)
    var normalColor: UIColor = UIColor(red: 104/255, green: 128/255, blue: 94/255, alpha: 0.5)
    
    var numberOfLinesForPicker = 1
    
    // MARK: -
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        delegate = self
    }
    required override init(frame: CGRect) {
        super.init(frame: frame)
        
        delegate = self
    }
    
    func updateUIAsPerTextFieldType() {
        
        switch textFieldType {
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
            
        case AITextFieldType.NumberTextField:
            self.keyboardType = UIKeyboardType.numberPad
            setToolBar()
            break;
        }
        self.textColor = text_Color
        // self.font = UIFont.systemFont(ofSize: 16)
        // self.layoutIfNeeded()
        self.tintColor = APP_ORANGE_COLOR
        self.placeHolderLabel?.textColor = normalColor
    }
    
    // MARK: - Style
    
    override func draw(_ rect: CGRect) {
        
        updateUnderline()
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
        
    }
    
    func updateUnderline() {
        
        if showUnderline {
            
            if isEditing {
                createUnderline(withColor: selectedColor, padding: 0, height: 1)
            } else {
                createUnderline(withColor: normalColor, padding: 0, height: 1)
            }
            
        } else {
            
            if (underlineLayer != nil) {
                underlineLayer.removeFromSuperlayer()
            }
        }
        
    }
    
    //  MARK: - Placeholder text
    func updatePlaceHolderTextColor(color: UIColor) {
        
        // placeholder text update
        placeHolderLabel?.textColor = color
        placeHolderLabel?.attributedText = placeHolderLabel?.text?.makeAstrikRequired()
    }
    
    
    
    // MARK: - Gap
    
    func setLeftGap (width:Int, placeHolderImage:UIImage)
    {
        let leftGap:UIView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: Int(self.frame.size.height)))
        leftGap.backgroundColor = UIColor.clear
        
        let imageView:UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: Int(self.frame.size.height)))
        
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        imageView.image = placeHolderImage
        
        leftGap.addSubview(imageView)
        
        self.leftView = leftGap;
        self.leftViewMode = UITextField.ViewMode.always

    }
    
    func setRightGap (width:Int, placeHolderImage:UIImage)
    {
        let rightGap:UIView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: Int(self.frame.size.height)))
        rightGap.backgroundColor = UIColor.clear
        
        let imageView:UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: Int(self.frame.size.height)))
        
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        imageView.image = placeHolderImage
        
        rightGap.addSubview(imageView)
        
        self.rightView = rightGap
        self.rightViewMode = UITextField.ViewMode.always
    }
    
    
    
    // MARK: - Add Pickers
    
    func addTextPicker()
    {
        self.picker = UIPickerView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 255))
        self.picker?.delegate = self
        self.picker?.dataSource = self
        self.inputView = self.picker;
        self.picker?.translatesAutoresizingMaskIntoConstraints = false
    }
    func addDatePicker()
    {
        self.datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 255))
        self.datePicker?.datePickerMode = UIDatePicker.Mode.date
        let currentLanguage = Localize.currentLanguage()
        self.datePicker?.locale = NSLocale.init(localeIdentifier: currentLanguage) as Locale
        self.inputView = self.datePicker
//        self.datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 255))
//        self.datePicker?.datePickerMode = UIDatePickerMode.date
//        self.inputView = self.datePicker
    }
    func addTimePicker() {
        self.datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 255))
        self.datePicker?.datePickerMode = UIDatePicker.Mode.time
        self.inputView = self.datePicker
    }
    
    
    // MARK: - ToolBar
    func setToolBar()
    {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width:UIScreen.main.bounds.width, height: 44))
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = APP_ORANGE_COLOR
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Ok".localized(), style: .done, target: self, action: #selector(AITextField.doneButtonClicked))
        let cancelButton = UIBarButtonItem(title: "Cancel".localized(), style: .done, target: self, action:  #selector(AITextField.cancelButtonClicked))

        let flixibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        
        toolBar.items = [cancelButton,flixibleSpace,doneButton]
        
        self.inputAccessoryView = toolBar
    }
    /*
     When user click done button
     */
    @objc func doneButtonClicked()
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
        
        self.aiDelegate?.keyBoardHidden?(textField: self)
//        self.resignFirstResponder()
    }
    /*/;
     When user clicked cancel button.
     */
    @objc func cancelButtonClicked()
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
        //self.text = self.text
    }
    
    // MARK: -
    
    func setPickerViewTexttoTextField()
    {
        let selectedOption:String = self.pickerViewArray?.object(at: (self.picker?.selectedRow(inComponent: 0))!) as! String
        self.text = selectedOption
        self.selectedTextInPicker = selectedOption
      //  aiDelegate?.getSelectedIndexFr©omPicker!(selectedIndex: (self.picker?.selectedRow(inComponent: 0))!)
        
        aiDelegate?.getSelectedIndexFromPicker!(selectedIndex:(self.picker?.selectedRow(inComponent: 0))! , textField: self)

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
        //self.text = self.selectedTextInPicker
    }
    func setDateTextWithFormatter(string:NSString)
    {
        self.selectedDate = self.datePicker?.date as NSDate? //NSDate.init(timeIntervalSinceReferenceDate: (self.datePicker?.date.timeIntervalSince1970)!) //self.datePicker?.date as
        let date_Formatter = DateFormatter()
        date_Formatter.dateFormat = string as String?
        let dateString = date_Formatter.string(from: (self.datePicker?.date)!)
        self.text = dateString
        
        
    }
    func setOldDateTextWithFormatter(string:NSString)
    {
        if (self.selectedDate != nil)
        {
            let date_Formatter = DateFormatter()
            date_Formatter.dateFormat = string as String?
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
}


extension AITextField: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        updateUnderline()
        updatePlaceHolderTextColor(color: selectedColor)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateUnderline()
        updatePlaceHolderTextColor(color: normalColor)
        
//        self.aiDelegate?.keyBoardHidden?(textField: self)
    }
    
    
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
     
        let status = self.aiDelegate?.textFieldShouldReturn?(textField)
        if let status = status {
            return status
        } else {
            self.aiDelegate?.keyBoardHidden?(textField: self)
            return true
        }
        
     }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let status = self.aiDelegate?.aiTextField?(textField, shouldChangeCharactersIn: range, replacementString: string)
        if let status = status {
            return status
        } else {
            return true
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let status = self.aiDelegate?.textFieldShouldBeginEditing?(textField)
        if let status = status {
            return status
        }else {
            return true
        }
    }
    
    
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        let status = self.aiDelegate?.textFieldShouldEndEditing?(textField)
        if let status = status {
            return status
        }else {
            return true
        }
    }

}

extension AITextField: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return (self.pickerViewArray?.count)!
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if self.textFieldType == AITextFieldType.UICountryCodePickerTextField {
            
            let selectedOption:NSDictionary = self.pickerViewArray?.object(at: row) as! NSDictionary
            return NSAttributedString(string: selectedOption["code"] as! String, attributes: nil)
        }
        let selectedOption:NSString = self.pickerViewArray?.object(at: row) as! NSString
        return NSAttributedString(string: selectedOption as String, attributes: nil)
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let height = UIFont.systemFont(ofSize: UIFont.systemFontSize).lineHeight * CGFloat(numberOfLinesForPicker) * UIScreen.main.scale
        
        let label = UILabel(frame: CGRect(x:0,y: 0, width:pickerView.frame.width - 14, height: height));
        
        if numberOfLinesForPicker != 1 {
            label.lineBreakMode = .byWordWrapping;
        }
        
        label.numberOfLines = 0;
        label.text = self.pickerViewArray?.object(at: row) as! String?
        label.font = UIFont.systemFont(ofSize: 24.0)
        label.textAlignment = .center
        return label;
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {

        return UIFont.systemFont(ofSize: UIFont.systemFontSize).lineHeight * CGFloat(numberOfLinesForPicker) * UIScreen.main.scale
    }
    
    
}

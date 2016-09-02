//
//  UITextField+AMSetPicker.swift
//  AMTextFieldPickerExtension
//
//  Created by Anthony Miller on 6/24/15.
//  Copyright (c) 2015 Anthony Miller. All rights reserved.
//

import UIKit

/**
 *  This extension to `UITextField` allows you to set a `UIPickerView` to the `pickerView` property to set the given `UIPickerView` as the `inputView` for the `UITextField`
 
 :discussion: Setting the `pickerView` for the text field will also set up a `UIToolbar` with a "Done" button as the text field's `inputAccessoryView`. When pressed, the "Done" button will set the text field's text from the `pickerView`'s `delegate`.
 */
public extension UITextField {
    
    private struct AssociatedKeys {
        static var DateFormatter = "am_DateFormat"
        static var ShowClearButton = "am_ShowClearButton"
        static var ClearButtonTitle = "am_ClearButtonTitle"
    }
    
    /// The `UIPickerView` for the text field. Set this to configure the `inputView` and `inputAccessoryView` for the text field.
    public var pickerView: UIPickerView? {
        get {
            return self.inputView as? UIPickerView
        }
        set {
            setInputViewToPicker(newValue)
        }
    }
    
    /// The `UIDatePicker` for the text field. Set this to configure the `inputView` and `inputAccessoryView` for the text field.
    public var datePicker: UIDatePicker? {
        get {
            return self.inputView as? UIDatePicker
        }
        set {
            setInputViewToPicker(newValue)
        }
    }
    
    private func setInputViewToPicker(picker: UIView?) {
        self.inputView = picker
        self.inputAccessoryView = picker != nil ? pickerToolbar() : nil
    }
    
    private func refreshPickerToolbar() {
        self.inputAccessoryView = hasPicker() ? pickerToolbar() : nil
    }
    
    private func hasPicker() -> Bool {
        return pickerView != nil || datePicker != nil
    }
    
    private func pickerToolbar() -> UIToolbar {
        let toolbar = UIToolbar(frame: CGRectMake(0, 0, 320, 44))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        let doneButton = createDoneButton()
        
        var toolbarItems = [flexibleSpace, doneButton]
        
        if showPickerClearButton {
            toolbarItems.insert(createClearButton(), atIndex: 0)
        }
        
        toolbar.items = toolbarItems
        
        return toolbar
    }
    
    private func createDoneButton() -> UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: .Done,
                               target: self,
                               action: #selector(UITextField.didPressPickerDoneButton(_:)))
    }
    
    private func createClearButton() -> UIBarButtonItem {
        return UIBarButtonItem(title: clearButtonTitle,
                               style: .Plain,
                               target: self,
                               action: #selector(UITextField.didPressPickerClearButton(_:)))
    }
    
    /// The `NSDateFormatter` to use to set the text field's `text` when using the `datePicker`.
    /// Defaults to a date formatter with date format: "M/d/yy".
    public var dateFormatter: NSDateFormatter {
        get {
            if let formatter = objc_getAssociatedObject(self, &AssociatedKeys.DateFormatter) as? NSDateFormatter {
                return formatter
            } else {
                let formatter = NSDateFormatter()
                formatter.dateFormat = "M/d/yy"
                objc_setAssociatedObject(self, &AssociatedKeys.DateFormatter, formatter, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return formatter
            }
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.DateFormatter, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// If set to `true` the `inputAccessoryView` toolbar will include a button to clear the text field.
    /// Defaults to `false`.
    public var showPickerClearButton: Bool {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.ShowClearButton) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.ShowClearButton, newValue as Bool, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            refreshPickerToolbar()
        }
    }
    
    /// The title to display for the clear button on the `inputAccessoryView` toolbar.
    /// Defaults to "Clear".
    public var clearButtonTitle: String {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.ClearButtonTitle) as? String ?? "Clear"
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.ClearButtonTitle, newValue as NSString, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /**
     This method is called when the "Done" button on the `inputAccessoryView` toolbar is pressed.
     
     :discussion: This method will set the text field's text with the title for the selected row in the `pickerView` in component `0` from the `pickerView`'s `delegate.
     
     - parameter sender: The "Done" button sending the action.
     */
    public func didPressPickerDoneButton(sender: AnyObject) {
        guard pickerView != nil || datePicker != nil else { return }
        
        if pickerView != nil {
            setTextFromPickerView()
            
        } else if datePicker != nil {
            setTextFromDatePicker()
        }
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.sendActionsForControlEvents(.EditingChanged)
        })
        resignFirstResponder()
    }
    
    private func setTextFromPickerView() {
        if let selectedRow = pickerView?.selectedRowInComponent(0),
            title = pickerView?.delegate?.pickerView?(pickerView!, titleForRow: selectedRow, forComponent: 0) {
            self.text = title
        }
    }
    
    private func setTextFromDatePicker() {
        if let date = datePicker?.date {
            self.text = self.dateFormatter.stringFromDate(date)
        }
    }
    
    /**
     This method is called when the clear button on the `inputAccessoryView` toolbar is pressed.
     
     :discussion: This method will set the text field's text to `nil`.
     
     - parameter sender: The clear button sending the action.
     */
    public func didPressPickerClearButton(sender: AnyObject) {
        self.text = nil
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.sendActionsForControlEvents(.EditingChanged)
        })
        resignFirstResponder()
    }
    
}
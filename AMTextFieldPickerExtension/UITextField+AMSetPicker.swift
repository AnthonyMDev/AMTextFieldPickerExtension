//
//  UITextField+AMSetPicker.swift
//  AMTextFieldPickerExtension
//
//  Created by Anthony Miller on 6/24/15.
//  Copyright (c) 2015 Anthony Miller. All rights reserved.
//

import UIKit

private enum AssociatedObjectKeys: String {
  case RowTitles = "AMTextFieldPicker_rowTitles"
}

/**
*  This extension to `UITextField` allows you to set a `UIPickerView` to the `pickerView` property to set the given `UIPickerView` as the `inputView` for the `UITextField`

  :discussion: Setting the `pickerView` for the text field will also set up a `UIToolbar` with a "Done" button as the text field's `inputAccessoryView`. When pressed, the "Done" button will set the text field's text from the `pickerView`'s `delegate`.
*/
public extension UITextField {
  
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
  
  private func pickerToolbar() -> UIToolbar {
    let toolbar = UIToolbar(frame: CGRectMake(0, 0, 320, 44))
    let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
    let doneButton = UIBarButtonItem(barButtonSystemItem: .Done,
                                     target: self,
                                     action: #selector(UITextField.didPressPickerDoneButton(_:)))
    
    toolbar.items = [flexibleSpace, doneButton]
    
    return toolbar
  }
  
  /// The formatting string to use to set the text field's `text` when using the `datePicker`.
  /// See `NSDateFormatter` for more information
  /// Defaults to "M/d/yy"
  public var dateFormat: String {
    get {
      return objc_getAssociatedObject(self, &AssociatedKeys.DateFormat) as? String ?? "M/d/yy"
    }
    set {
      objc_setAssociatedObject(self, &AssociatedKeys.DateFormat, newValue as NSString, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }
  
  private struct AssociatedKeys {
    static var DateFormat = "am_DateFormat"
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
      let formatter = NSDateFormatter()
      formatter.dateFormat = dateFormat
      self.text = formatter.stringFromDate(date)
    }
  }
  
}
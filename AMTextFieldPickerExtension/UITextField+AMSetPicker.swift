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
      self.inputView = newValue
      self.inputAccessoryView = newValue != nil ? pickerToolbar() : nil
    }
  }
  
  private func pickerToolbar() -> UIToolbar {
    let toolbar = UIToolbar()
    let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
    let doneButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "didPressPickerDoneButton:")
    toolbar.items = [flexibleSpace, doneButton]
    
    return toolbar
  }
  
  /**
  This method is called when the "Done" button on the `inputAccessoryView` toolbar is pressed.
  
  :discussion: This method will set the text field's text with the title for the selected row in the `pickerView` in component `0` from the `pickerView`'s `delegate.
  
  :param: sender The "Done" button sending the action.
  */
  public func didPressPickerDoneButton(sender: AnyObject) {
    if let selectedRow = pickerView?.selectedRowInComponent(0),
    title = pickerView?.delegate?.pickerView?(pickerView!, titleForRow: selectedRow, forComponent: 0) {
      self.text = title
      
    }
  }
  
}
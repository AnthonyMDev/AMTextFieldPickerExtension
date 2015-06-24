# AMTextFieldPickerExtension
A `UITextField` extension written in Swift that makes it easy to use a `UIPickerView` for selection.

## Installation

`AMTextFieldPickerExtension` is available through Cocoapods. Just add this line to your `Podfile`:
    pod 'AMTextFieldPickerExtension'

## Usage

`AMTextFieldPickerExtension` adds a `pickerView` property to `UITextField`. When this property is set, the `pickerView` is set to the `UITextField`'s `inputView` property. A `UIToolbar`, containing a "Done" button, is also set to the `inputAccessoryView` property.

When the "Done" button is pressed, the text field's text is set to the selected title in the `pickerView` for the first component.

## Example

First, create a `UIPickerView`. You'll need to implement the `UIPickerViewDataSource` (and optionally, `UIPickerViewDelegate`).

    let pickerView = UIPickerView
    pickerView.dataSource = self

Then, just set your `UIPickerView` to the `pickerView` property on a `UITextField`.

    myTextField.pickerView = pickerView

And you're done!

## Coming Soon:

- Support for titles using `NSAttributedString`
- Support for `UIDatePicker`
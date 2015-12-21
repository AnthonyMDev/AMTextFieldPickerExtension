//
//  AMTextFieldPickerExtensionTests.swift
//  AMTextFieldPickerExtensionTests
//
//  Created by Anthony Miller on 6/24/15.
//  Copyright (c) 2015 Anthony Miller. All rights reserved.
//

import UIKit
import XCTest
import Nimble

import AMTextFieldPickerExtension

class AMTextFieldPickerExtensionTests: XCTestCase {
  
  var sut: UITextField!
  
  /**
  *  MARK: - Test Set Up
  */
  
  override func setUp() {
    super.setUp()
    
    sut = UITextField()
  }
  
  /**
  *  MARK: Tests
  */
  
  func test__setPickerView__sets_inputViewToPicker() {
    // given
    let expected = UIPickerView()
    
    // when
    sut.pickerView = expected
    
    // then
    expect(self.sut.inputView).to(beIdenticalTo(expected))
  }
  
  func test__setPickerView__setsUpToolbar() {
    // given
    
    // when
    sut.pickerView = UIPickerView()
    
    // then
    let toolbar = self.sut.inputAccessoryView as? UIToolbar
    expect(toolbar).toNot(beNil())
    expect(toolbar?.frame.height).to(beGreaterThanOrEqualTo(44))
    expect(toolbar?.items?.count).to(equal(2))
    let doneButton = toolbar?.items?.last
    expect(doneButton?.action).to(equal("didPressPickerDoneButton:"))
    expect(doneButton?.target as? UITextField).to(beIdenticalTo(self.sut))
  }
  
  func test__setPickerView__givenNil_setsInputAccessoryViewNil() {
    // given
    sut.inputAccessoryView = UIView()
    
    // when
    sut.pickerView = nil
    
    // then
    expect(self.sut.inputAccessoryView).to(beNil())
  }
  
  func test__didPressPickerDoneButton__givenDelegate_setsTextFieldText_toPickerViewSelectedRowText() {
    // given
    let expected = "Row Title Text"
    
    let mockPicker = MockPickerView()
    let mockDelegate = MockPickerViewTitleDelegate()
    mockDelegate.mockTitle = expected
    mockPicker.delegate = mockDelegate
    
    sut.pickerView = mockPicker
    
    // when
    sut.didPressPickerDoneButton(self)
    
    // then
    expect(self.sut.text).to(equal(expected))
  }
  
  func test__didPressPickerDoneButton__resignsFirstResponder() {
    // given
    let window = UIWindow()
    window.addSubview(sut)
    
    sut.becomeFirstResponder()
    
    // when
    sut.didPressPickerDoneButton(self)
    
    // then
    expect(self.sut.isFirstResponder()).to(beFalse())
  }
  
}

class MockPickerView: UIPickerView {
  
  var mockSelectedRow: Int = 0
  
  override func selectedRowInComponent(component: Int) -> Int {
    return mockSelectedRow
  }
  
}

class MockPickerViewTitleDelegate: NSObject, UIPickerViewDelegate {
  
  var mockTitle: String = ""
  
  func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return mockTitle
  }
  
}
//
//  SignUpViewUITests.swift
//  ClinicalLab(Driver)UITests
//
//  Created by Vaibhav Rajani on 4/18/24.
//

import Foundation
import XCTest

class SignUpViewUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["-UITesting"]
        app.launch()
    }
//    
//    func testSignUpWithValidCredentials() {
//        navigateToSignUpView()
//        
//        let phoneNumberTextField = app.textFields["Enter Phone Number"]
//        phoneNumberTextField.tap()
//        phoneNumberTextField.typeText("1234567890")
//        
//        let passwordSecureFields = app.secureTextFields.matching(identifier: "Enter Password")
//        let passwordSecureField = passwordSecureFields.element(boundBy: 0)
//        passwordSecureField.tap()
//        passwordSecureField.typeText("Password123")
//        
//        let confirmPasswordSecureField = passwordSecureFields.element(boundBy: 1)
//        confirmPasswordSecureField.tap()
//        confirmPasswordSecureField.typeText("Password123")
//        
//        let signUpButton = app.buttons["Sign Up"]
//        signUpButton.tap()
//        
//    }
//    
//    func testSignUpWithInvalidCredentials() {
//        navigateToSignUpView()
//        
//        let phoneNumberTextField = app.textFields["Enter Phone Number"]
//        phoneNumberTextField.tap()
//        phoneNumberTextField.typeText("123") // Invalid phone number
//        
//        let passwordSecureFields = app.secureTextFields.matching(identifier: "Enter Password")
//        passwordSecureFields.element(boundBy: 0).tap()
//        passwordSecureFields.element(boundBy: 0).typeText("1234")
//        
//        passwordSecureFields.element(boundBy: 1).tap()
//        passwordSecureFields.element(boundBy: 1).typeText("12345") // Non-matching password
//        
//        let signUpButton = app.buttons["Sign Up"]
//        signUpButton.tap()
//        
//        let failureMessage = app.staticTexts["Passwords do not match."]
//        XCTAssertTrue(failureMessage.exists, "The error message should be displayed on sign up failure.")
//    }

}


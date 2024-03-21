//
//  SettingsViewUITests.swift
//  ClinicalLab(Driver)UITests
//
//  Created by Vaibhav Rajani on 3/21/24.
//

import XCTest

class LoginViewUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["-UITesting"]
        app.launch()
    }
    
    func testSuccessfulLoginNavigatesToRoutesView() {
        
        let phoneNumberTextField = app.textFields["Enter Phone Number"]
        phoneNumberTextField.tap()
        phoneNumberTextField.typeText("6808673216")
        
        let passwordSecureField = app.secureTextFields["Enter Password"]
        passwordSecureField.tap()
        passwordSecureField.typeText("admin")
        
        let loginButton = app.buttons["Login"]
        loginButton.tap()

    }

}


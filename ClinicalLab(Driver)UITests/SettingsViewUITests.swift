//
//  SettingsViewUITests.swift
//  ClinicalLab(Driver)UITests
//
//  Created by Vaibhav Rajani on 4/18/24.
//

import Foundation
import XCTest

class SettingsViewUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["-UITesting"]
        app.launch()
    }

    private func navigateToSettingsView() {
        // Assuming the test starts at the LoginView
        
        // Fill in login details and submit (adjust these identifiers as needed)
        let phoneNumberTextField = app.textFields["Enter Phone Number"]
        let passwordSecureField = app.secureTextFields["Enter Password"]
        let loginButton = app.buttons["Login"]
        
        phoneNumberTextField.tap()
        phoneNumberTextField.typeText("6808673216") // Use valid test credentials
        
        passwordSecureField.tap()
        passwordSecureField.typeText("admin") // Use valid test credentials
        
        loginButton.tap()

        // Wait for the transition to the RoutesView to complete
        let routesViewExists = app.otherElements["RoutesViewIdentifier"].waitForExistence(timeout: 10) // Adjust the identifier and timeout as needed
        
        if routesViewExists {
            // Now navigate to Settings from the RoutesView
            let settingsButton = app.buttons["gear"] // Use the accessibility identifier for the settings gear icon
            settingsButton.tap()
        } else {
            XCTFail("Failed to navigate to RoutesView")
        }
    }
    
    func testBiometricsToggle() {
        navigateToSettingsView()
        
        let biometricsToggle = app.switches["Use Biometrics"]
        XCTAssertTrue(biometricsToggle.exists, "Biometrics toggle should exist.")

        // Assuming the toggle is off by default, let's toggle it on
        biometricsToggle.tap() // This simulates the user enabling biometrics
        // Since we can't simulate actual biometric success/failure in UI tests,
        // this test will need to be adjusted based on mocked responses or additional UI indications of success/failure.
    }

    func testPasswordUpdateSuccess() {
        navigateToSettingsView()

        let newPasswordField = app.secureTextFields["New Password"]
        let confirmPasswordField = app.secureTextFields["Confirm Password"]
        let updateButton = app.buttons["Update Password"]

        newPasswordField.tap()
        newPasswordField.typeText("ValidPassword123")
        confirmPasswordField.tap()
        confirmPasswordField.typeText("ValidPassword123")
        updateButton.tap()

        // Verify alert is shown with successful message
        let alert = app.alerts["Password Update"].staticTexts["Password successfully updated."]
        XCTAssertTrue(alert.exists, "Success alert should be displayed when passwords match.")
    }

    func testPasswordUpdateFailure() {
        navigateToSettingsView()

        let newPasswordField = app.secureTextFields["New Password"]
        let confirmPasswordField = app.secureTextFields["Confirm Password"]
        let updateButton = app.buttons["Update Password"]

        newPasswordField.tap()
        newPasswordField.typeText("ValidPassword123")
        confirmPasswordField.tap()
        confirmPasswordField.typeText("InvalidPassword456")
        updateButton.tap()

        // Verify alert is shown with error message
        let alert = app.alerts["Password Update"].staticTexts["Passwords do not match."]
        XCTAssertTrue(alert.exists, "Failure alert should be displayed when passwords do not match.")
    }


}

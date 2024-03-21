//
//  ClinicalLab_Driver_UITestsLaunchTests.swift
//  ClinicalLab(Driver)UITests
//
//  Created by Vaibhav Rajani on 2/25/24.
//

import XCTest

final class ClinicalLab_Driver_UITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()
        
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}

//
//  LoginViewModelTests.swift
//  ClinicalLab(Driver)Tests
//
//  Created by Vaibhav Rajani on 3/21/24.
//

import Foundation
import XCTest
@testable import ClinicalLab_Driver_

class MockLoginService: LoginService {
    var loginResult: Result<LoginResponse, LoginError>

    init(loginResult: Result<LoginResponse, LoginError>) {
        self.loginResult = loginResult
    }

    override func login(phoneNumber: String, password: String, completion: @escaping (Result<LoginResponse, LoginError>) -> Void) {
        completion(loginResult)
    }
}

class LoginViewModelTests: XCTestCase {
    func testLoginSuccess() {
        let loginResponse = LoginResponse(routeNo: 187)
        let mockLoginService = MockLoginService(loginResult: .success(loginResponse))
        let viewModel = LoginViewModel(loginService: mockLoginService)

        let expectation = self.expectation(description: "Successful Login")
        var loginSuccess = false

        viewModel.onLoginSuccess = { routeNo in
            loginSuccess = true
            XCTAssertEqual(routeNo, loginResponse.routeNo)
            expectation.fulfill()
        }

        viewModel.login()

        waitForExpectations(timeout: 1) { error in
            XCTAssertTrue(viewModel.isAuthenticated)
            XCTAssertTrue(loginSuccess)
        }
    }
}

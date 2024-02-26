//
//  SignUpRequest.swift
//  ClinicalLab(Driver)
//
//  Created by Vaibhav Rajani on 2/25/24.
//

import Foundation

struct SignUpRequest: Codable {
    let phoneNumber: String
    let password: String
    let confirmPassword: String
}

//
//  SignUpview.swift
//  ClinicalLab(Driver)
//
//  Created by Vaibhav Rajani on 2/25/24.
//

import SwiftUI

struct SignUpView: View {
    @ObservedObject var viewModel: SignUpViewModel
    
    var body: some View {
        VStack {
            Image("parkway")
                .resizable()
                .frame(width: 300, height: 300)
                .padding()
            
            HStack {
                Text(Strings.phoneNumberLabel)
                    .foregroundStyle(Color.customPink)
                TextField(Strings.phoneNumberPlaceholder, text: $viewModel.phoneNumber)
            }
            .keyboardType(.numberPad)
            .padding()
            
            HStack {
                Text(Strings.passwordLabel)
                    .foregroundStyle(Color.customPink)
                SecureField(Strings.passwordPlaceholder, text: $viewModel.password)
                    .accessibility(identifier: "passwordField")
            }
            .padding()
            
            HStack {
                Text(Strings.confirmPasswordPlaceholder)
                    .foregroundStyle(Color.customPink)
                SecureField(Strings.passwordPlaceholder, text: $viewModel.confirmPassword)
                    .accessibility(identifier: "confirmPasswordField")

            }
            .padding()
            
            Button(action: {
                viewModel.signUp()
            }) {
                Text(Strings.signupButtonTitle)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.customPink)
                    .cornerRadius(8)
            }
            
            if viewModel.signUpFailed {
                Text(viewModel.failureMessage)
                    .foregroundColor(.red)
            }
        }
        .toolbarBackground(
            Color.customPink,
            for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .navigationBarTitleDisplayMode(.inline)
        .padding()
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(viewModel: SignUpViewModel(signUpService: SignUpService()))
    }
}

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
            // Logo Placeholder - Replace with actual logo
            Image(systemName: "person.fill")
                .resizable()
                .frame(width: 100, height: 100)
                .padding()
            
            TextField("Enter Phone Number", text: $viewModel.phoneNumber)
                .keyboardType(.numberPad)
                .padding()
            
            SecureField("Enter Password", text: $viewModel.password)
                .padding()
            
            SecureField("Confirm Password", text: $viewModel.confirmPassword)
                .padding()
            
            Button(action: {
                viewModel.signUp()
            }) {
                Text("Sign Up")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(8)
            }
            
            if viewModel.signUpFailed {
                Text(viewModel.failureMessage)
                    .foregroundColor(.red)
            }
        }
        .padding()
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(viewModel: SignUpViewModel(signUpService: SignUpService()))
    }
}

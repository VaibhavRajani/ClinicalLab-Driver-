//
//  LoginView.swift
//  ClinicalLab(Driver)
//
//  Created by Vaibhav Rajani on 2/25/24.
//

import Foundation
import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: LoginViewModel
    @State private var navigatingToSignUp = false
    @State private var routeNumber: Int?
    
    var body: some View {
        VStack {
            TextField("Enter Phone Number", text: $viewModel.phoneNumber)
                .keyboardType(.numberPad)
                .padding()
            
            SecureField("Enter Password", text: $viewModel.password)
                .padding()
            
            Button(action: {
                viewModel.login()
            }) {
                Text("Login")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(8)
            }
            .onAppear {
                viewModel.onLoginSuccess = { routeNo in
                    self.routeNumber = routeNo
                }
            }
            
            NavigationLink("", destination: RoutesView(viewModel: RouteViewModel(), routeNo: routeNumber ?? 0), isActive: $viewModel.isAuthenticated)

            
            if viewModel.loginFailed {
                Text("Login failed. Please try again.")
                    .foregroundColor(.red)
            }
            
            Spacer()
            NavigationLink(destination: SignUpView(viewModel: SignUpViewModel(signUpService: SignUpService())), isActive: $navigatingToSignUp) {
                Button("Don't have an account? Sign Up") {
                    navigatingToSignUp = true
                }
                .foregroundColor(Color.blue)
            }
        }
        .navigationTitle("Login")
        .padding()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: LoginViewModel(loginService: LoginService()))
    }
}


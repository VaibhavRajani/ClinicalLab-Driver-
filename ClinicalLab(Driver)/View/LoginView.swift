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
            
            Image("parkway")
                .resizable()
                .scaledToFit()
                .frame(height: 300)
                .padding(.top)
            
            HStack {
                Text("Phone No:")
                    .foregroundStyle(Color.customPink)
                TextField("Enter Phone Number", text: $viewModel.phoneNumber)
            }
            .keyboardType(.numberPad)
            .padding()
            
            HStack {
                Text("Password:")
                    .foregroundStyle(Color.customPink)
                SecureField("Enter Password", text: $viewModel.password)
            }
            .padding()
            
            Button(action: {
                viewModel.login()
            }) {
                Text("Login")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.customPink)
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
        .navigationTitle("")
        .toolbarBackground(
            Color.customPink,
            for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .navigationBarTitleDisplayMode(.inline)
        .padding()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: LoginViewModel(loginService: LoginService()))
    }
}


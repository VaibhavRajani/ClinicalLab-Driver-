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
            }
            .padding()
            
            Button(action: {
                viewModel.login()
            }) {
                Text(Strings.loginButtonTitle)
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
            .navigationDestination(isPresented: $viewModel.isAuthenticated) {
                RoutesView(viewModel: RouteViewModel(), routeNo: routeNumber ?? 0)
            }
//            
//                        NavigationLink("", destination: RoutesView(viewModel: RouteViewModel(), routeNo: routeNumber ?? 0), isActive: $viewModel.isAuthenticated)
            
            
            if viewModel.loginFailed {
                Text(Strings.loginFailedError)
                    .foregroundColor(.red)
            }
            
            Spacer()
            Button(Strings.signUpPrompt) {
                navigatingToSignUp = true
            }
            .foregroundColor(Color.blue)
            .navigationDestination(isPresented: $navigatingToSignUp) {
                SignUpView(viewModel: SignUpViewModel(signUpService: SignUpService()))
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


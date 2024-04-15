//
//  ContentView.swift
//  ClinicalLab(Driver)
//
//  Created by Vaibhav Rajani on 2/25/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack{
            LoginView(viewModel: LoginViewModel(loginService: LoginService()))
        }
    }
}

#Preview {
    ContentView()
}

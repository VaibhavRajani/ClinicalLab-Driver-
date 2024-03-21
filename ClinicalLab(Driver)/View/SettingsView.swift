//
//  SettingsView.swift
//  ClinicalLab(Driver)
//
//  Created by Vaibhav Rajani on 3/13/24.
//

import SwiftUI
import LocalAuthentication

struct SettingsView: View {
    @AppStorage("biometricsEnabled") private var biometricsEnabled = false
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        Form {
            Section(header: Text("Security")) {
                Toggle(isOn: $biometricsEnabled) {
                    Text("Use Biometrics")
                }
                .onChange(of: biometricsEnabled) { isEnabled in
                    if isEnabled {
                        authenticate()
                    }
                }
            }
            Section(header: Text("Change Password")) {
                SecureField("New Password", text: $newPassword)
                SecureField("Confirm Password", text: $confirmPassword)
                Button("Update Password") {
                    updatePassword()
                }
            }
        }
        .navigationBarTitle("Settings", displayMode: .large)
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Password Update"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    private func updatePassword() {
        guard newPassword == confirmPassword else {
            alertMessage = "Passwords do not match."
            showAlert = true
            return
        }
        
        alertMessage = "Password successfully updated."
        showAlert = true
    }
    
    private func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                success, authenticationError in
                
                DispatchQueue.main.async {
                    if success {
                        self.biometricsEnabled = true
                    } else {
                        self.biometricsEnabled = false
                    }
                }
            }
        } else {
            self.biometricsEnabled = false
        }
    }
}

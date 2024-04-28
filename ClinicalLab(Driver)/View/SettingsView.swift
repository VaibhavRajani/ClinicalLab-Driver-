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
            Section(header: Text(Strings.securityTitle)) {
                Toggle(isOn: $biometricsEnabled) {
                    Text(Strings.useBiometrics)
                }
                .onChange(of: biometricsEnabled) {
                    authenticate()
                }
            }
            Section(header: Text(Strings.changePasswordTitle)) {
                SecureField(Strings.passwordPlaceholder, text: $newPassword)
                SecureField(Strings.confirmPasswordPlaceholder, text: $confirmPassword)
                Button(Strings.changePasswordTitle) {
                    updatePassword()
                }
            }
        }
        .navigationBarTitle(Strings.settingsTitle, displayMode: .large)
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Password Update"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    private func updatePassword() {
        guard newPassword == confirmPassword else {
            alertMessage = Strings.passwordsDontMatch
            showAlert = true
            return
        }
        
        alertMessage = Strings.passwordUpdated
        showAlert = true
    }
    
    private func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = Strings.identifyYourself
            
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

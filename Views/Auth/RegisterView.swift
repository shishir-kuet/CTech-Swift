//
//  RegisterView.swift
//  CTechApp
//
//  Created by macos on 4/3/26.
//

import SwiftUI

struct RegisterView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @EnvironmentObject var authVM: AuthViewModel
    @Environment(\.dismiss) var dismiss
    @State private var showError = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Create Account").font(.largeTitle).bold()
            
            TextField("Email", text: $email)
                .textFieldStyle(.roundedBorder)
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
            
            SecureField("Password", text: $password)
                .textFieldStyle(.roundedBorder)
            
            SecureField("Confirm Password", text: $confirmPassword)
                .textFieldStyle(.roundedBorder)
            
            if let errorMessage = authVM.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }
            
            Button("Sign Up") {
                if password == confirmPassword && !email.isEmpty && !password.isEmpty {
                    authVM.register(email: email, password: password)
                } else {
                    authVM.errorMessage = "Please ensure passwords match and all fields are filled"
                    showError = true
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(email.isEmpty || password.isEmpty || confirmPassword.isEmpty)
            
            Button("Already have an account? Login") {
                dismiss()
            }
            .foregroundColor(.blue)
        }
        .padding()
    }
}

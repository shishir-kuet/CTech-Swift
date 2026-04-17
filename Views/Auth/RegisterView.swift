//
//  RegisterView.swift
//  CTechApp
//

import SwiftUI

struct RegisterView: View {
    @State private var displayName = ""
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var authVM: AuthViewModel

    var body: some View {
        VStack(spacing: 20) {
            Text("Create Account")
                .font(.largeTitle)
                .bold()

            TextField("Display Name", text: $displayName)
                .textFieldStyle(.roundedBorder)

            TextField("Email", text: $email)
                .textFieldStyle(.roundedBorder)
                .autocapitalization(.none)
                .keyboardType(.emailAddress)

            SecureField("Password", text: $password)
                .textFieldStyle(.roundedBorder)

            if let error = authVM.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
                    .multilineTextAlignment(.center)
            }

            if authVM.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            }

            Button("Sign Up") {
                authVM.register(email: email, password: password, displayName: displayName)
            }
            .buttonStyle(.borderedProminent)
            .disabled(displayName.isEmpty || email.isEmpty || password.isEmpty || authVM.isLoading)
        }
        .padding()
    }
}

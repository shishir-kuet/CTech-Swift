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
        ZStack {
            Color.white.ignoresSafeArea()
            Color.green.opacity(0.08).ignoresSafeArea()

            VStack {
                Spacer()
                VStack(spacing: 28) {
                    VStack(spacing: 8) {
                        Image(systemName: "person.crop.circle.badge.plus")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 48, height: 48)
                            .foregroundColor(Color.green)
                        Text("Create Account")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)
                        Text("Sign up to get started")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }

                    VStack(spacing: 16) {
                        HStack {
                            Image(systemName: "person")
                                .foregroundColor(.green)
                            TextField("Display Name", text: $displayName)
                        }
                        .padding(12)
                        .background(Color.green.opacity(0.07))
                        .cornerRadius(10)

                        HStack {
                            Image(systemName: "envelope")
                                .foregroundColor(.green)
                            TextField("Email", text: $email)
                                .autocapitalization(.none)
                                .keyboardType(.emailAddress)
                        }
                        .padding(12)
                        .background(Color.green.opacity(0.07))
                        .cornerRadius(10)

                        HStack {
                            Image(systemName: "lock")
                                .foregroundColor(.green)
                            SecureField("Password", text: $password)
                        }
                        .padding(12)
                        .background(Color.green.opacity(0.07))
                        .cornerRadius(10)
                    }

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

                    Button(action: {
                        authVM.register(email: email, password: password, displayName: displayName)
                    }) {
                        HStack {
                            Spacer()
                            Text("Sign Up")
                                .fontWeight(.semibold)
                                .padding(.vertical, 12)
                            Spacer()
                        }
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(color: Color.green.opacity(0.15), radius: 8, x: 0, y: 4)
                    }
                    .disabled(displayName.isEmpty || email.isEmpty || password.isEmpty || authVM.isLoading)
                }
                .padding(28)
                .background(Color.white.opacity(0.98))
                .cornerRadius(24)
                .shadow(color: Color.green.opacity(0.08), radius: 16, x: 0, y: 8)
                .padding(.horizontal, 24)
                Spacer()
            }
        }
    }
}

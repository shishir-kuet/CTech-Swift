//
//  LoginView.swift
//  CTechApp
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var authVM: AuthViewModel

    var body: some View {
        NavigationView {
            ZStack {
                // White and light green background
                Color.white.ignoresSafeArea()
                Color.green.opacity(0.08).ignoresSafeArea()

                VStack {
                    Spacer()
                    // Card
                    VStack(spacing: 28) {
                        VStack(spacing: 8) {
                            Image(systemName: "lock.shield")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 48, height: 48)
                                .foregroundColor(Color.green)
                            Text("Welcome Back")
                                .font(.system(size: 32, weight: .bold, design: .rounded))
                                .foregroundColor(.primary)
                            Text("Sign in to continue")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }

                        VStack(spacing: 16) {
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
                            authVM.login(email: email, password: password)
                        }) {
                            HStack {
                                Spacer()
                                Text("Login")
                                    .fontWeight(.semibold)
                                    .padding(.vertical, 12)
                                Spacer()
                            }
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .shadow(color: Color.green.opacity(0.15), radius: 8, x: 0, y: 4)
                        }
                        .disabled(email.isEmpty || password.isEmpty || authVM.isLoading)

                        NavigationLink(destination: RegisterView()) {
                            Text("Don't have an account? Register")
                                .font(.footnote)
                                .foregroundColor(.green)
                        }
                        .padding(.top, 4)
                    }
                    .padding(28)
                    .background(Color.white.opacity(0.98))
                    .cornerRadius(24)
                    .shadow(color: Color.green.opacity(0.08), radius: 16, x: 0, y: 8)
                    .padding(.horizontal, 24)
                    Spacer()
                }
            }
            .navigationTitle("")
            .navigationBarHidden(true)
        }
    }
}

//
//  LoginView.swift
//  CTechApp
//
//  Created by macos on 4/3/26.
//

import Foundation
import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var authVM: AuthViewModel

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Welcome Back").font(.largeTitle).bold()
                
                TextField("Email", text: $email)
                    .textFieldStyle(.roundedBorder)
                    .autocapitalization(.none)
                
                SecureField("Password", text: $password)
                    .textFieldStyle(.roundedBorder)
                
                Button("Login") {
                    authVM.login(email: email, password: password)
                }
                .buttonStyle(.borderedProminent)
                
                NavigationLink("Don't have an account? Register", destination: RegisterView())
            }
            .padding()
        }
    }
}

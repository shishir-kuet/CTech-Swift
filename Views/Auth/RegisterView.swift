//
//  RegisterView.swift
//  CTechApp
//
//  Created by macos on 4/3/26.
//

import Foundation
import SwiftUI

struct RegisterView: View {
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var authVM: AuthViewModel

    var body: some View {
        VStack(spacing: 20) {
            Text("Create Account").font(.largeTitle).bold()
            
            TextField("Email", text: $email)
                .textFieldStyle(.roundedBorder)
                .autocapitalization(.none)
            
            SecureField("Password", text: $password)
                .textFieldStyle(.roundedBorder)
            
            Button("Sign Up") {
                // You would add a signUp function in your AuthViewModel
                // authVM.register(email: email, password: password)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

//
//  HomeView.swift
//  CTechApp
//
//  Created by macos on 3/3/26.
//

import SwiftUI

struct HomeView: View {
    // Note: Make sure AuthViewModel is in your ViewModels folder
    @StateObject var authVM = AuthViewModel()
    
    var body: some View {
        Group {
            if authVM.isAuthenticated {
                // Check if the user is an admin
                if authVM.currentUser?.isAdmin == true {
                    // Match the file name in your 'Admin' folder
                    AdminDashboardView()
                } else {
                    // Match the file name in your 'Buyer' folder
                    ProductListView()
                }
            } else {
                // Match the file name in your 'Auth' folder
                LoginView()
            }
        }
        .environmentObject(authVM)
    }
}

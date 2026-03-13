//
//  HomeView.swift
//  CTechApp
//

import SwiftUI

struct HomeView: View {
    @StateObject var authVM = AuthViewModel()
    @StateObject var cartVM = CartViewModel()

    var body: some View {
        Group {
            if authVM.isAuthenticated {
                if authVM.currentUser?.isAdmin == true {
                    AdminDashboardView()
                } else {
                    ProductListView()
                }
            } else {
                LoginView()
            }
        }
        .environmentObject(authVM)
        .environmentObject(cartVM)
    }
}

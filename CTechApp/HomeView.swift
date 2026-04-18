//
//  HomeView.swift
//  CTechApp
//

import SwiftUI

struct HomeView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @StateObject var authVM = AuthViewModel()
    @StateObject var cartVM = CartViewModel()

    var body: some View {
        Group {
            if !hasSeenOnboarding {
                OnboardingView()
            } else if authVM.isAuthenticated {
                if authVM.currentUser?.isAdmin == true {
                    AdminDashboardView()
                } else {
                    UserHomeView()
                }
            } else {
                LoginView()
            }
        }
        .onAppear {
            hasSeenOnboarding = false
        }
        .environmentObject(authVM)
        .environmentObject(cartVM)
    }
}

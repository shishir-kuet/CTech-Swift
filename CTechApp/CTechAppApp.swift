//
//  CTechAppApp.swift
//  CTechApp
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        print("✅ AppDelegate - application:didFinishLaunchingWithOptions called")
        FirebaseApp.configure()
        print("✅ AppDelegate - FirebaseApp configured")
        
        // Configure UITabBar appearance
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        
        // Use a dark, vibrant blue background
        appearance.backgroundColor = UIColor(red: 0.0, green: 0.4, blue: 0.95, alpha: 1.0)
        print("✅ AppDelegate - TabBar background color set to blue")
        
        // Add border at the top of the tab bar for more definition
        let separatorAppearance = UITabBarAppearance()
        separatorAppearance.shadowImage = UIImage()
        separatorAppearance.shadowColor = UIColor(red: 0.0, green: 0.4, blue: 0.95, alpha: 0.3)
        
        // Configure normal (inactive) tab appearance - black icons
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor.black.withAlphaComponent(0.6)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.white.withAlphaComponent(0.6),
            .font: UIFont.systemFont(ofSize: 10)
        ]
        print("✅ AppDelegate - Normal tab appearance set to black icons")
        
        // Configure selected (active) tab appearance - black icons
        appearance.stackedLayoutAppearance.selected.iconColor = .black
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 10, weight: .semibold)
        ]
        print("✅ AppDelegate - Selected tab appearance set to black icons")
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        UITabBar.appearance().tintColor = .black
        
        return true
    }
}

@main
struct CTechAppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}

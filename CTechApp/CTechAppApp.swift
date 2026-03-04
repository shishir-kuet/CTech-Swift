//
//  CTechAppApp.swift
//  CTechApp
//
//  Created by macos on 3/3/26.
//

import SwiftUI
import FirebaseCore

@main
struct CTechAppApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}

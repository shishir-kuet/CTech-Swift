//
//  APIConfiguration.swift
//  CTechApp
//
//  Created by macos on 5/3/26.
//

import Foundation

enum APIMode {
    case local          // Uses local Products.json (no internet needed)
    case development    // Local development server
    case production     // Live production API
    case mockAPI        // MockAPI.io for testing
}

struct APIConfiguration {
    
    // 🔧 CHANGE THIS TO SWITCH MODES
    static let currentMode: APIMode = .development
    
    // Base URLs for different environments
    private static let baseURLs: [APIMode: String] = [
        .local: "",  // Empty = uses local JSON
        .development: "http://localhost:3000/v1",
        .production: "https://api.yourdomain.com/v1",
        .mockAPI: "https://YOUR_ID.mockapi.io/api/v1"
    ]
    
    static var baseURL: String {
        return baseURLs[currentMode] ?? ""
    }
    
    // Check if should use API or local data
    static var shouldUseAPI: Bool {
        return currentMode != .local && !baseURL.isEmpty
    }
    
    // Network timeout in seconds
    static let timeoutInterval: TimeInterval = 30
    
    // Enable debug logging
    static let enableDebugLogging: Bool = true
    
    // Retry attempts for failed requests
    static let maxRetryAttempts: Int = 3
}

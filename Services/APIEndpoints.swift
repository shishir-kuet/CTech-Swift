//
//  APIEndpoints.swift
//  CTechApp
//
//  Created by macos on 5/3/26.
//

import Foundation

struct APIEndpoints {
    
    // Base URL - Controlled by APIConfiguration
    static var baseURL: String {
        return APIConfiguration.baseURL
    }
    
    // Products endpoints
    struct Products {
        static let getAll = "\(baseURL)/products"
        static func getById(_ id: Int) -> String {
            "\(baseURL)/products/\(id)"
        }
        static func getByCategory(_ category: String) -> String {
            "\(baseURL)/products?category=\(category)"
        }
        static let create = "\(baseURL)/products"
        static func update(_ id: Int) -> String {
            "\(baseURL)/products/\(id)"
        }
        static func delete(_ id: Int) -> String {
            "\(baseURL)/products/\(id)"
        }
    }
    
    // Categories endpoints
    struct Categories {
        static let getAll = "\(baseURL)/categories"
        static func getById(_ id: String) -> String {
            "\(baseURL)/categories/\(id)"
        }
    }
    
    // Orders endpoints
    struct Orders {
        static let getAll = "\(baseURL)/orders"
        static let create = "\(baseURL)/orders"
        static func getById(_ id: String) -> String {
            "\(baseURL)/orders/\(id)"
        }
        static func getUserOrders(_ userId: String) -> String {
            "\(baseURL)/users/\(userId)/orders"
        }
    }
    
    // Search endpoint
    struct Search {
        static func search(_ query: String) -> String {
            "\(baseURL)/search?q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        }
    }
}

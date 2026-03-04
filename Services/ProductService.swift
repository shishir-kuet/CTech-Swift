//
//  ProductService.swift
//  CTechApp
//
//  Created by macos on 3/3/26.
//

import Foundation

enum ProductServiceError: Error {
    case fileNotFound
    case dataLoadingFailed
    case decodingFailed
}

class ProductService {
    
    /// Load products synchronously (simple academic version)
    func loadProducts() throws -> [Product] {
        
        // 1️⃣ Locate JSON file
        guard let url = Bundle.main.url(forResource: "Products", withExtension: "json") else {
            throw ProductServiceError.fileNotFound
        }
        
        // 2️⃣ Load data
        guard let data = try? Data(contentsOf: url) else {
            throw ProductServiceError.dataLoadingFailed
        }
        
        // 3️⃣ Decode JSON
        do {
            let products = try JSONDecoder().decode([Product].self, from: data)
            return products
        } catch {
            throw ProductServiceError.decodingFailed
        }
    }
    
    /// Async version (recommended modern Swift)
    func loadProductsAsync() async throws -> [Product] {
        return try loadProducts()
    }
}

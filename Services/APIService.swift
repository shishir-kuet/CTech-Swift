//
//  APIService.swift
//  CTechApp
//
//  Created by macos on 5/3/26.
//

import Foundation

// API Response Models
struct ProductsResponse: Codable {
    let products: [Product]
    let total: Int?
    let page: Int?
}

struct CategoryResponse: Codable {
    let categories: [Category]
}

struct CreateProductRequest: Codable {
    let name: String
    let description: String
    let price: Double
    let category: String
    let imageName: String
    let specifications: [String: String]
}

struct UpdateProductRequest: Codable {
    let name: String?
    let description: String?
    let price: Double?
    let category: String?
    let imageName: String?
    let specifications: [String: String]?
}

class APIService {
    
    static let shared = APIService()
    private let networkManager = NetworkManager.shared
    
    private init() {}
    
    // MARK: - Products API
    
    /// Fetch all products from API
    func fetchProducts() async throws -> [Product] {
        // Check if should use API or go straight to local
        guard APIConfiguration.shouldUseAPI else {
            if APIConfiguration.enableDebugLogging {
                print("📱 Using LOCAL data mode")
            }
            return try loadLocalProducts()
        }
        
        // Try API first, fallback to local JSON
        do {
            if APIConfiguration.enableDebugLogging {
                print("🌐 Fetching from API: \(APIConfiguration.currentMode)")
            }
            let response = try await networkManager.fetch(
                from: APIEndpoints.Products.getAll,
                responseType: ProductsResponse.self
            )
            if APIConfiguration.enableDebugLogging {
                print("✅ Fetched \(response.products.count) products from API")
            }
            return response.products
        } catch {
            if APIConfiguration.enableDebugLogging {
                print("⚠️ API fetch failed, using local data: \(error)")
            }
            // Fallback to local JSON
            return try loadLocalProducts()
        }
    }
    
    /// Fetch products by category
    func fetchProducts(byCategory category: String) async throws -> [Product] {
        let response = try await networkManager.fetch(
            from: APIEndpoints.Products.getByCategory(category),
            responseType: ProductsResponse.self
        )
        return response.products
    }
    
    /// Fetch single product by ID
    func fetchProduct(byId id: Int) async throws -> Product {
        return try await networkManager.fetch(
            from: APIEndpoints.Products.getById(id),
            responseType: Product.self
        )
    }
    
    /// Create new product (Admin)
    func createProduct(
        name: String,
        description: String,
        price: Double,
        category: String,
        imageName: String = "placeholder",
        specifications: [String: String] = [:]
    ) async throws -> Product {
        let request = CreateProductRequest(
            name: name,
            description: description,
            price: price,
            category: category,
            imageName: imageName,
            specifications: specifications
        )
        
        return try await networkManager.post(
            to: APIEndpoints.Products.create,
            body: request,
            responseType: Product.self
        )
    }
    
    /// Update product (Admin)
    func updateProduct(
        id: Int,
        name: String? = nil,
        description: String? = nil,
        price: Double? = nil,
        category: String? = nil,
        imageName: String? = nil,
        specifications: [String: String]? = nil
    ) async throws -> Product {
        let request = UpdateProductRequest(
            name: name,
            description: description,
            price: price,
            category: category,
            imageName: imageName,
            specifications: specifications
        )
        
        return try await networkManager.put(
            to: APIEndpoints.Products.update(id),
            body: request,
            responseType: Product.self
        )
    }
    
    /// Delete product (Admin)
    func deleteProduct(id: Int) async throws {
        try await networkManager.delete(from: APIEndpoints.Products.delete(id))
    }
    
    // MARK: - Categories API
    
    /// Fetch all categories
    func fetchCategories() async throws -> [Category] {
        let response = try await networkManager.fetch(
            from: APIEndpoints.Categories.getAll,
            responseType: CategoryResponse.self
        )
        return response.categories
    }
    
    // MARK: - Search API
    
    /// Search products
    func searchProducts(query: String) async throws -> [Product] {
        let response = try await networkManager.fetch(
            from: APIEndpoints.Search.search(query),
            responseType: ProductsResponse.self
        )
        return response.products
    }
    
    // MARK: - Local Fallback
    
    /// Load products from local JSON (fallback)
    private func loadLocalProducts() throws -> [Product] {
        guard let url = Bundle.main.url(forResource: "Products", withExtension: "json") else {
            throw ProductServiceError.fileNotFound
        }
        
        guard let data = try? Data(contentsOf: url) else {
            throw ProductServiceError.dataLoadingFailed
        }
        
        do {
            let products = try JSONDecoder().decode([Product].self, from: data)
            return products
        } catch {
            throw ProductServiceError.decodingFailed
        }
    }
}

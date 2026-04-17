//
//  ProductService.swift
//  CTechApp
//

import Foundation

enum ProductServiceError: Error {
    case fileNotFound
    case dataLoadingFailed
    case decodingFailed
}

class ProductService {

    func loadProducts() throws -> [Product] {
        guard let url = Bundle.main.url(forResource: "Products", withExtension: "json") else {
            throw ProductServiceError.fileNotFound
        }

        let data = try Data(contentsOf: url)
        do {
            return try JSONDecoder().decode([Product].self, from: data)
        } catch {
            throw ProductServiceError.decodingFailed
        }
    }

    func loadProductsAsync() async throws -> [Product] {
        return try loadProducts()
    }
}

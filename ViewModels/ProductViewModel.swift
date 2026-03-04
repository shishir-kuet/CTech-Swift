//
//  ProductViewModel.swift
//  CTechApp
//
//  Created by macos on 3/3/26.
//

import Foundation

@MainActor
class ProductViewModel: ObservableObject {
    
    @Published var products: [Product] = []
    @Published var searchText: String = ""
    @Published var errorMessage: String?
    
    private let service = ProductService()
    
    init() {
        loadProducts()
    }
    
    func loadProducts() {
        do {
            products = try service.loadProducts()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    var filteredProducts: [Product] {
        if searchText.isEmpty {
            return products
        } else {
            return products.filter {
                $0.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
}

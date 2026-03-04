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
    @Published var isLoading: Bool = false
    @Published var selectedCategory: String?
    
    private let apiService = APIService.shared
    private let localService = ProductService()
    
    init() {
        Task {
            await loadProducts()
        }
    }
    
    /// Load products from API with fallback to local JSON
    func loadProducts() async {
        isLoading = true
        errorMessage = nil
        
        do {
            // Try API first
            products = try await apiService.fetchProducts()
        } catch {
            print("API error: \(error.localizedDescription)")
            // Fallback to local JSON
            do {
                products = try localService.loadProducts()
            } catch {
                errorMessage = "Failed to load products: \(error.localizedDescription)"
            }
        }
        
        isLoading = false
    }
    
    /// Load products by category
    func loadProducts(byCategory category: String) async {
        isLoading = true
        errorMessage = nil
        selectedCategory = category
        
        do {
            products = try await apiService.fetchProducts(byCategory: category)
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    /// Search products via API
    func searchProducts() async {
        guard !searchText.isEmpty else {
            await loadProducts()
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            products = try await apiService.searchProducts(query: searchText)
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    /// Refresh products
    func refresh() async {
        await loadProducts()
    }
    
    /// Filtered products (local filtering)
    var filteredProducts: [Product] {
        if searchText.isEmpty {
            return products
        } else {
            return products.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.description.localizedCaseInsensitiveContains(searchText) ||
                $0.category.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
}

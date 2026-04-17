//
//  ProductViewModel.swift
//  CTechApp
//

import Foundation
import FirebaseFirestore

@MainActor
class ProductViewModel: ObservableObject {

    @Published var products: [Product] = []
    @Published var searchText: String = ""
    @Published var errorMessage: String?
    @Published var isLoading = false

    private let db = Firestore.firestore()
    private let service = ProductService()
    private let localProducts: [Product]

    init() {
        localProducts = (try? service.loadProducts()) ?? []
        // Show local products immediately while Firestore loads
        products = localProducts
        listenToFirestore()
    }

    func listenToFirestore() {
        isLoading = true
        db.collection("products")
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self else { return }
                self.isLoading = false

                if let error = error {
                    self.errorMessage = error.localizedDescription
                    // Keep showing local products on error
                    self.products = self.localProducts
                    return
                }

                // Parse every Firestore product
                let firestoreProducts: [Product] = snapshot?.documents.compactMap { doc -> Product? in
                    let d = doc.data()
                    guard let name = d["name"] as? String, !name.isEmpty else { return nil }
                    let productId = d["id"] as? Int ?? doc.documentID.hashValue
                    return Product(
                        id: productId,
                        firestoreId: doc.documentID,
                        name: name,
                        description: d["description"] as? String ?? "",
                        price: d["price"] as? Double ?? 0,
                        imageName: d["imageName"] as? String ?? "",
                        imageURL: d["imageURL"] as? String,
                        category: d["category"] as? String ?? "",
                        brand: d["brand"] as? String ?? "",
                        stock: d["stock"] as? Int ?? 0,
                        specifications: d["specifications"] as? [String: String] ?? [:]
                    )
                } ?? []

                // Always show ALL local JSON products + ALL Firestore products, sorted by name
                self.products = (self.localProducts + firestoreProducts)
                    .sorted { $0.name < $1.name }
            }
    }

    var filteredProducts: [Product] {
        if searchText.isEmpty { return products }
        return products.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.brand.localizedCaseInsensitiveContains(searchText) ||
            $0.category.localizedCaseInsensitiveContains(searchText)
        }
    }
}

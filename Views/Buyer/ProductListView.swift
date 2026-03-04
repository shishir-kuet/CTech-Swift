//
//  ProductListView.swift
//  CTechApp
//
//  Created by macos on 4/3/26.
//

import Foundation
import SwiftUI
import FirebaseFirestore

struct ProductListView: View {
    @State private var products = [Product]()
    
    var body: some View {
        NavigationView {
            List(products) { product in
                HStack {
                    VStack(alignment: .leading) {
                        Text(product.name).font(.headline)
                        Text("$\(product.price, specifier: "%.2f")").foregroundColor(.secondary)
                    }
                    Spacer()
                    Button("Buy Now") {
                        print("Purchasing \(product.name)")
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .navigationTitle("Shop")
            .onAppear {
                fetchProducts()
            }
        }
    }
    
    func fetchProducts() {
        Firestore.firestore().collection("products").addSnapshotListener { snap, _ in
            self.products = snap?.documents.compactMap { try? $0.data(as: Product.self) } ?? []
        }
    }
}

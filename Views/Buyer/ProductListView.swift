//
//  ProductListView.swift
//  CTechApp
//

import SwiftUI

struct ProductListView: View {
    @StateObject private var productVM = ProductViewModel()
    @EnvironmentObject var cartVM: CartViewModel
    @EnvironmentObject var authVM: AuthViewModel

    @State private var selectedCategory = "All"

    private var categories: [String] {
        let cats = productVM.products.map { $0.category }
        return ["All"] + Array(Set(cats)).sorted()
    }

    private var displayedProducts: [Product] {
        let searched = productVM.filteredProducts
        if selectedCategory == "All" { return searched }
        return searched.filter { $0.category == selectedCategory }
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                    TextField("Search products...", text: $productVM.searchText)
                }
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
                .padding(.top, 8)

                // Category filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(categories, id: \.self) { cat in
                            Button(cat) {
                                selectedCategory = cat
                            }
                            .padding(.horizontal, 14)
                            .padding(.vertical, 7)
                            .background(selectedCategory == cat ? Color.blue : Color(.systemGray5))
                            .foregroundColor(selectedCategory == cat ? .white : .primary)
                            .cornerRadius(20)
                            .font(.caption)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                }

                if let error = productVM.errorMessage {
                    Text(error).foregroundColor(.red).padding()
                }

                // Product list
                List(displayedProducts) { product in
                    NavigationLink(destination: ProductDetailView(product: product)) {
                        ProductRowView(product: product, cartVM: cartVM)
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle("CTech Shop")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink(destination: MyOrdersView()) {
                        Label("Orders", systemImage: "list.bullet.rectangle")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        NavigationLink(destination: CartView()) {
                            ZStack(alignment: .topTrailing) {
                                Image(systemName: "cart")
                                if !cartVM.cartItems.isEmpty {
                                    Text("\(cartVM.cartItems.count)")
                                        .font(.caption2)
                                        .foregroundColor(.white)
                                        .padding(4)
                                        .background(Color.red)
                                        .clipShape(Circle())
                                        .offset(x: 8, y: -8)
                                }
                            }
                        }
                        Button("Logout") { authVM.logout() }
                            .foregroundColor(.red)
                    }
                }
            }
        }
    }
}

// MARK: - Product Row
private struct ProductRowView: View {
    let product: Product
    let cartVM: CartViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(product.name)
                .font(.headline)
            Text(product.brand)
                .font(.caption)
                .foregroundColor(.secondary)
            HStack {
                Text("৳\(product.price, specifier: "%.2f")")
                    .font(.subheadline)
                    .foregroundColor(.blue)
                Spacer()
                Text("Stock: \(product.stock)")
                    .font(.caption)
                    .foregroundColor(product.stock > 0 ? .green : .red)
                Button {
                    cartVM.addToCart(product: product)
                } label: {
                    Image(systemName: "cart.badge.plus")
                }
                .buttonStyle(.borderedProminent)
                .disabled(product.stock == 0)
            }
        }
        .padding(.vertical, 4)
    }
}

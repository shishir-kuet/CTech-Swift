//
//  ProductListView.swift
//  CTechApp
//
//  Created by macos on 4/3/26.
//

import SwiftUI

struct ProductListView: View {
    @StateObject private var productVM = ProductViewModel()
    @StateObject private var cartVM = CartViewModel()
    @State private var showCart = false
    
    var body: some View {
        NavigationView {
            VStack {
                // Search bar
                TextField("Search products...", text: $productVM.searchText)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                    .onChange(of: productVM.searchText) { _ in
                        Task {
                            await productVM.searchProducts()
                        }
                    }
                
                // Error message
                if let errorMessage = productVM.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.horizontal)
                }
                
                // Loading indicator
                if productVM.isLoading {
                    ProgressView("Loading products...")
                        .padding()
                }
                
                // Product list
                List(productVM.filteredProducts) { product in
                    NavigationLink(destination: ProductDetailView(product: product)
                        .environmentObject(cartVM)) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(product.name).font(.headline)
                                Text(product.description)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .lineLimit(2)
                                Text("৳\(product.price, specifier: "%.2f")")
                                    .foregroundColor(.blue)
                                    .bold()
                            }
                            Spacer()
                            Button(action: {
                                cartVM.addToCart(product: product)
                            }) {
                                Image(systemName: "cart.badge.plus")
                                    .foregroundColor(.blue)
                            }
                            .buttonStyle(.borderless)
                        }
                    }
                }
                .listStyle(.plain)
                .refreshable {
                    await productVM.refresh()
                }
            }
            .navigationTitle("Shop")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showCart.toggle()
                    }) {
                        HStack {
                            Image(systemName: "cart")
                            if !cartVM.cartItems.isEmpty {
                                Text("\(cartVM.cartItems.count)")
                                    .font(.caption)
                                    .foregroundColor(.white)
                                    .padding(4)
                                    .background(Color.red)
                                    .clipShape(Circle())
                            }
                        }
                    }
                }
            }
            .sheet(isPresented: $showCart) {
                CartView()
                    .environmentObject(cartVM)
            }
        }
    }
}

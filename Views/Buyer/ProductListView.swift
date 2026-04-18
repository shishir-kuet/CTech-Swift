//
//  ProductListView.swift
//  CTechApp
//

import SwiftUI

struct ProductListView: View {
    @StateObject private var productVM = ProductViewModel()
    @EnvironmentObject var cartVM: CartViewModel

    @State private var selectedCategory = "All"
    @State private var selectedBrand = "All"
    @State private var minPrice: Double = 0
    @State private var maxPrice: Double = 0
    private let columns = [GridItem(.adaptive(minimum: 170), spacing: 16)]

    private var categories: [String] {
        let cats = productVM.products.map { $0.category }.filter { !$0.isEmpty }
        return ["All"] + Array(Set(cats)).sorted()
    }

    private var brands: [String] {
        let brands = productVM.products.map { $0.brand }.filter { !$0.isEmpty }
        return ["All"] + Array(Set(brands)).sorted()
    }

    private var priceBounds: ClosedRange<Double> {
        let prices = productVM.products.map { $0.price }
        let min = prices.min() ?? 0
        let max = prices.max() ?? 1000
        return min...max
    }

    private var displayedProducts: [Product] {
        let searched = productVM.filteredProducts
        return searched.filter { product in
            let categoryMatch = selectedCategory == "All" || product.category == selectedCategory
            let brandMatch = selectedBrand == "All" || product.brand == selectedBrand
            let priceMatch = product.price >= minPrice && product.price <= maxPrice
            return categoryMatch && brandMatch && priceMatch
        }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                headerView

                if let error = productVM.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }

                    ZStack {
                        Color.white.ignoresSafeArea()
                        Color.green.opacity(0.06).ignoresSafeArea()
                        VStack(spacing: 16) {
                categoryFilter

                if productVM.isLoading {
                    ProgressView()
                        .padding(.vertical, 40)
                } else if displayedProducts.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "bag.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.secondary)
                        Text("No products available")
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 40)
                } else {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(displayedProducts) { product in
                            NavigationLink(destination: ProductDetailView(product: product)) {
                                ProductCardView(product: product, cartVM: cartVM)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
        .onAppear { setPriceRange() }
        .onChange(of: productVM.products.map(\.id)) { _ in setPriceRange() }
    }

    private func setPriceRange() {
        let bounds = priceBounds
        if minPrice < bounds.lowerBound || minPrice > bounds.upperBound {
            minPrice = bounds.lowerBound
        }
        if maxPrice < bounds.lowerBound || maxPrice > bounds.upperBound {
            maxPrice = bounds.upperBound
        }
        if minPrice > maxPrice {
            minPrice = maxPrice
        }
    }

    private func resetFilters() {
        selectedBrand = "All"
        selectedCategory = "All"
        let bounds = priceBounds
        minPrice = bounds.lowerBound
        maxPrice = bounds.upperBound
        productVM.searchText = ""
    }

    private var headerView: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            TextField("Search products...", text: $productVM.searchText)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
        }
        .padding(12)
        .background(Color(.systemGray6))
        .cornerRadius(14)
        .padding(.horizontal)
    }

    private var categoryFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(categories, id: \.self) { category in
                    Button(action: { selectedCategory = category }) {
                        Text(category)
                            .font(.caption)
                            .foregroundColor(selectedCategory == category ? .white : .primary)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(selectedCategory == category ? Color.blue : Color(.systemGray5))
                            .cornerRadius(20)
                    }
                }
            }
            .padding(.horizontal)
        }
    }

    private var filterPanel: some View {
        VStack(spacing: 14) {
            HStack {
                Text("Filters")
                    .font(.headline)
                Spacer()
                Button("Reset") {
                    resetFilters()
                }
                .font(.caption)
                .foregroundColor(.blue)
            }
            .padding(.horizontal)

            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Brand")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Picker("Brand", selection: $selectedBrand) {
                        ForEach(brands, id: \.self) { Text($0).tag($0) }
                    }
                    .pickerStyle(.menu)
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text("Category")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(categories, id: \.self) { Text($0).tag($0) }
                    }
                    .pickerStyle(.menu)
                }
            }
            .padding(.horizontal)

            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("Price range")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("৳\(minPrice, specifier: "%.0f") - ৳\(maxPrice, specifier: "%.0f")")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }

                VStack(spacing: 8) {
                    HStack {
                        Text("Min")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("৳\(minPrice, specifier: "%.0f")")
                            .font(.caption2)
                            .foregroundColor(.blue)
                    }
                    Slider(value: $minPrice, in: priceBounds.lowerBound...maxPrice, step: 1)
                        .accentColor(.blue)

                    HStack {
                        Text("Max")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("৳\(maxPrice, specifier: "%.0f")")
                            .font(.caption2)
                            .foregroundColor(.blue)
                    }
                    Slider(value: $maxPrice, in: minPrice...priceBounds.upperBound, step: 1)
                        .accentColor(.blue)
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 10)
        .background(Color(.systemGray6))
        .cornerRadius(18)
        .padding(.horizontal)
    }
}

private struct ProductCardView: View {
    let product: Product
    let cartVM: CartViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Group {
                if let urlString = product.imageURL, let url = URL(string: urlString) {
                    AsyncImage(url: url) { image in
                        image.resizable().scaledToFill()
                    } placeholder: {
                        Color(.systemGray5)
                    }
                } else {
                    Image(product.imageName)
                        .resizable()
                        .scaledToFill()
                }
            }
            .frame(height: 140)
            .frame(maxWidth: .infinity)
            .clipped()
            .cornerRadius(16)

            VStack(alignment: .leading, spacing: 6) {
                Text(product.name)
                    .font(.headline)
                    .lineLimit(2)

                Text(product.brand)
                    .font(.caption)
                    .foregroundColor(.secondary)

                HStack {
                    Text("৳\(product.price, specifier: "%.2f")")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                    Spacer()
                }

                HStack {
                    Text("Stock: \(product.stock)")
                        .font(.caption2)
                        .foregroundColor(product.stock > 0 ? .green : .red)
                    Spacer()
                    Button {
                        cartVM.addToCart(product: product)
                    } label: {
                        Image(systemName: "cart.badge.plus")
                            .padding(8)
                            .background(Color.blue.opacity(0.1))
                            .clipShape(Circle())
                    }
                    .disabled(product.stock == 0)
                }
            }
        }
        .padding()
        .background(.regularMaterial)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 6)
    }
}

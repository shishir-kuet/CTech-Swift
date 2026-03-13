//
//  ProductDetailView.swift
//  CTechApp
//

import SwiftUI

struct ProductDetailView: View {
    let product: Product
    @EnvironmentObject var cartVM: CartViewModel
    @State private var addedToCart = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                // Product image
                Group {
                    if let urlString = product.imageURL, let url = URL(string: urlString) {
                        AsyncImage(url: url) { image in
                            image.resizable().scaledToFit()
                        } placeholder: {
                            Color(.systemGray5)
                        }
                    } else {
                        Image(product.imageName)
                            .resizable()
                            .scaledToFit()
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 220)
                .background(Color(.systemGray6))
                .cornerRadius(12)

                VStack(alignment: .leading, spacing: 8) {
                    Text(product.name)
                        .font(.title2)
                        .bold()

                    Text(product.brand)
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    HStack {
                        Text("৳\(product.price, specifier: "%.2f")")
                            .font(.title3)
                            .foregroundColor(.blue)
                        Spacer()
                        Label("Stock: \(product.stock)", systemImage: "shippingbox")
                            .font(.caption)
                            .foregroundColor(product.stock > 0 ? .green : .red)
                    }

                    Divider()

                    Text(product.description)
                        .font(.body)

                    Divider()

                    Text("Specifications")
                        .font(.headline)

                    ForEach(product.specifications.keys.sorted(), id: \.self) { key in
                        HStack {
                            Text(key)
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .frame(width: 140, alignment: .leading)
                            Text(product.specifications[key] ?? "")
                                .font(.caption)
                        }
                    }
                }
                .padding(.horizontal)

                Button {
                    cartVM.addToCart(product: product)
                    addedToCart = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) { addedToCart = false }
                } label: {
                    Label(addedToCart ? "Added!" : "Add to Cart",
                          systemImage: addedToCart ? "checkmark" : "cart.badge.plus")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(addedToCart ? .green : .blue)
                .disabled(product.stock == 0)
                .padding()
            }
            .padding(.top)
        }
        .navigationTitle(product.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

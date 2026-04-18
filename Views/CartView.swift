//
//  CartView.swift
//  CTechApp
//

import SwiftUI
import FirebaseFirestore

struct CartView: View {
    @EnvironmentObject var cartVM: CartViewModel
    @EnvironmentObject var authVM: AuthViewModel

    @State private var showPayment = false

    var body: some View {
        VStack(spacing: 0) {
            if cartVM.cartItems.isEmpty {
                Spacer()
                VStack(spacing: 12) {
                    Image(systemName: "cart")
                        .font(.system(size: 60))
                        .foregroundColor(.secondary)
                    Text("Your cart is empty")
                        .foregroundColor(.secondary)
                }
                Spacer()
            } else {
                List {
                    ForEach(cartVM.cartItems) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.product.name).font(.headline)
                                Text("৳\(item.product.price, specifier: "%.2f") each")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            HStack(spacing: 12) {
                                Button { cartVM.decreaseQuantity(for: item) } label: {
                                    Image(systemName: "minus.circle")
                                }
                                Text("\(item.quantity)")
                                    .frame(minWidth: 24)
                                Button { cartVM.increaseQuantity(for: item) } label: {
                                    Image(systemName: "plus.circle")
                                }
                            }
                        }
                    }
                    .onDelete { indexSet in
                        indexSet.forEach { i in
                            cartVM.removeFromCart(item: cartVM.cartItems[i])
                        }
                    }
                }
                .listStyle(.plain)

                Divider()

                VStack(spacing: 12) {
                    HStack {
                        Text("Total")
                            .font(.headline)
                        Spacer()
                        Text("৳\(cartVM.totalPrice, specifier: "%.2f")")
                            .font(.title3)
                            .foregroundColor(.blue)
                    }

                    NavigationLink(destination: PaymentView()) {
                        Text("Proceed to Payment")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(cartVM.cartItems.isEmpty)

                    Button("Clear Cart") { cartVM.clearCart() }
                        .foregroundColor(.red)
                        .font(.footnote)
                }
                .padding()
            }
        }
        .navigationTitle("Cart")
    }
}

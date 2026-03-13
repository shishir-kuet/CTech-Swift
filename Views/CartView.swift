//
//  CartView.swift
//  CTechApp
//

import SwiftUI
import FirebaseFirestore

struct CartView: View {
    @EnvironmentObject var cartVM: CartViewModel
    @EnvironmentObject var authVM: AuthViewModel

    @State private var address = ""
    @State private var isPlacingOrder = false
    @State private var orderPlaced = false
    @State private var orderError: String?

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

                    TextField("Delivery address", text: $address)
                        .textFieldStyle(.roundedBorder)

                    if let err = orderError {
                        Text(err).foregroundColor(.red).font(.caption)
                    }

                    if orderPlaced {
                        Label("Order placed successfully!", systemImage: "checkmark.circle.fill")
                            .foregroundColor(.green)
                    }

                    Button {
                        placeOrder()
                    } label: {
                        if isPlacingOrder {
                            ProgressView()
                        } else {
                            Text("Place Order").frame(maxWidth: .infinity)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(address.isEmpty || isPlacingOrder || cartVM.cartItems.isEmpty)

                    Button("Clear Cart") { cartVM.clearCart() }
                        .foregroundColor(.red)
                        .font(.footnote)
                }
                .padding()
            }
        }
        .navigationTitle("Cart")
    }

    private func placeOrder() {
        guard let user = authVM.currentUser else { return }
        isPlacingOrder = true
        orderError = nil

        let orderItems = cartVM.cartItems.map {
            OrderItem(
                productId: $0.product.id,
                productName: $0.product.name,
                price: $0.product.price,
                quantity: $0.quantity
            )
        }

        let order = Order(
            userId: user.id,
            userName: user.displayName ?? user.email,
            items: orderItems,
            totalPrice: cartVM.totalPrice,
            status: "Pending",
            address: address,
            timestamp: Date()
        )

        let itemsData = orderItems.map { item -> [String: Any] in
            ["productId": item.productId,
             "productName": item.productName,
             "price": item.price,
             "quantity": item.quantity]
        }
        let orderData: [String: Any] = [
            "userId": user.id,
            "userName": user.displayName ?? user.email,
            "items": itemsData,
            "totalPrice": cartVM.totalPrice,
            "status": "Pending",
            "address": address,
            "timestamp": Timestamp(date: Date())
        ]
        Firestore.firestore().collection("orders").addDocument(data: orderData) { error in
            DispatchQueue.main.async {
                isPlacingOrder = false
                if let error = error {
                    orderError = error.localizedDescription
                } else {
                    orderPlaced = true
                    cartVM.clearCart()
                    address = ""
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        orderPlaced = false
                    }
                }
            }
        }
    }
}

//
//  CartView.swift
//  CTechApp
//
//  Created by macos on 3/3/26.
//

import SwiftUI

struct CartView: View {
    
    @EnvironmentObject var cartVM: CartViewModel
    @EnvironmentObject var authVM: AuthViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                
                if cartVM.cartItems.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "cart")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        Text("Your cart is empty")
                            .font(.headline)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(cartVM.cartItems) { item in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(item.product.name)
                                        .font(.headline)
                                    Text("৳\(item.product.price, specifier: "%.2f")")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                HStack(spacing: 15) {
                                    Button("-") {
                                        cartVM.decreaseQuantity(for: item)
                                    }
                                    .buttonStyle(.bordered)
                                    
                                    Text("\(item.quantity)")
                                        .font(.headline)
                                        .frame(minWidth: 30)
                                    
                                    Button("+") {
                                        cartVM.increaseQuantity(for: item)
                                    }
                                    .buttonStyle(.bordered)
                                }
                            }
                        }
                        .onDelete { indexSet in
                            indexSet.forEach { index in
                                cartVM.removeFromCart(item: cartVM.cartItems[index])
                            }
                        }
                    }
                    
                    VStack(spacing: 15) {
                        
                        // Total
                        HStack {
                            Text("Total:")
                                .font(.title2)
                                .bold()
                            Spacer()
                            Text("৳\(cartVM.totalPrice, specifier: "%.2f")")
                                .font(.title2)
                                .bold()
                                .foregroundColor(.blue)
                        }
                        .padding()
                        
                        // Error message
                        if let error = cartVM.orderError {
                            Text(error)
                                .foregroundColor(.red)
                                .font(.caption)
                                .multilineTextAlignment(.center)
                        }
                        
                        // Success message
                        if cartVM.orderSuccess {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                Text("Order placed successfully!")
                                    .foregroundColor(.green)
                            }
                            .padding()
                        }
                        
                        // Checkout button
                        Button(action: {
                            Task {
                                guard let userId = authVM.currentUser?.id else { return }
                                await cartVM.placeOrder(userId: userId)
                                
                                // Dismiss after successful order
                                if cartVM.orderSuccess {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                        dismiss()
                                    }
                                }
                            }
                        }) {
                            HStack {
                                if cartVM.isProcessingOrder {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                } else {
                                    Text("Checkout")
                                        .bold()
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(cartVM.isProcessingOrder ? Color.gray : Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                        .disabled(cartVM.isProcessingOrder)
                        .padding(.horizontal)
                        
                        // Clear cart button
                        Button("Clear Cart") {
                            cartVM.clearCart()
                        }
                        .foregroundColor(.red)
                        .padding(.bottom)
                    }
                }
            }
            .navigationTitle("Cart")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

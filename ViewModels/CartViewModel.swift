//
//  CartViewModel.swift
//  CTechApp
//
//  Created by macos on 3/3/26.
//

import Foundation

class CartViewModel: ObservableObject {
    
    @Published var cartItems: [CartItem] = []
    
    func addToCart(product: Product) {
        if let index = cartItems.firstIndex(where: { $0.product.id == product.id }) {
            cartItems[index].quantity += 1
        } else {
            cartItems.append(CartItem(product: product, quantity: 1))
        }
    }
    
    func removeFromCart(item: CartItem) {
        cartItems.removeAll { $0.product.id == item.product.id }
    }
    
    func increaseQuantity(for item: CartItem) {
        if let index = cartItems.firstIndex(where: { $0.product.id == item.product.id }) {
            cartItems[index].quantity += 1
        }
    }
    
    func decreaseQuantity(for item: CartItem) {
        if let index = cartItems.firstIndex(where: { $0.product.id == item.product.id }) {
            if cartItems[index].quantity > 1 {
                cartItems[index].quantity -= 1
            }
        }
    }
    
    var totalPrice: Double {
        cartItems.reduce(0) {
            $0 + ($1.product.price * Double($1.quantity))
        }
    }
    
    func clearCart() {
        cartItems.removeAll()
    }
}

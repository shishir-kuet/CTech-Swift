//
//  CartViewModel.swift
//  CTechApp
//
//  Created by macos on 3/3/26.
//

import Foundation

class CartViewModel: ObservableObject {
    
    @Published var cartItems: [CartItem] = []
    @Published var isProcessingOrder = false
    @Published var orderError: String?
    @Published var orderSuccess = false
    
    private let orderService = OrderService.shared
    
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
    
    /// Place order via API
    func placeOrder(userId: String) async {
        isProcessingOrder = true
        orderError = nil
        orderSuccess = false
        
        // Convert cart items to order items
        let orderItems = cartItems.map { cartItem in
            OrderItem(
                productId: cartItem.product.id,
                productName: cartItem.product.name,
                quantity: cartItem.quantity,
                price: cartItem.product.price
            )
        }
        
        do {
            let order = try await orderService.createOrder(
                userId: userId,
                items: orderItems,
                totalAmount: totalPrice
            )
            
            print("Order created successfully: \(order.id)")
            
            // Clear cart after successful order
            DispatchQueue.main.async {
                self.clearCart()
                self.orderSuccess = true
            }
        } catch {
            DispatchQueue.main.async {
                self.orderError = error.localizedDescription
            }
        }
        
        isProcessingOrder = false
    }
}

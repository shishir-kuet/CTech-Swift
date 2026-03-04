//
//  Order.swift
//  CTechApp
//
//  Created by macos on 5/3/26.
//

import Foundation

struct Order: Identifiable, Codable {
    let id: String
    let userId: String
    let items: [OrderItem]
    let totalAmount: Double
    let status: OrderStatus
    let createdAt: Date
    let updatedAt: Date
    
    enum OrderStatus: String, Codable {
        case pending
        case processing
        case shipped
        case delivered
        case cancelled
    }
}

struct OrderItem: Codable {
    let productId: Int
    let productName: String
    let quantity: Int
    let price: Double
    
    var totalPrice: Double {
        price * Double(quantity)
    }
}

struct CreateOrderRequest: Codable {
    let userId: String
    let items: [OrderItem]
    let totalAmount: Double
}

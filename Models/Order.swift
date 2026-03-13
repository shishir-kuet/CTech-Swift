//
//  Order.swift
//  CTechApp
//

import Foundation
import FirebaseFirestore

struct OrderItem: Codable {
    let productId: Int
    let productName: String
    let price: Double
    let quantity: Int
}

struct Order: Identifiable, Codable {
    var id: String?
    let userId: String
    let userName: String
    let items: [OrderItem]
    let totalPrice: Double
    var status: String          // "Pending" | "Processing" | "Delivered"
    let address: String
    let timestamp: Date
}

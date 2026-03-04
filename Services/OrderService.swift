//
//  OrderService.swift
//  CTechApp
//
//  Created by macos on 5/3/26.
//

import Foundation

class OrderService {
    
    static let shared = OrderService()
    private let networkManager = NetworkManager.shared
    
    private init() {}
    
    /// Create new order
    func createOrder(
        userId: String,
        items: [OrderItem],
        totalAmount: Double
    ) async throws -> Order {
        let request = CreateOrderRequest(
            userId: userId,
            items: items,
            totalAmount: totalAmount
        )
        
        return try await networkManager.post(
            to: APIEndpoints.Orders.create,
            body: request,
            responseType: Order.self
        )
    }
    
    /// Get user's orders
    func getUserOrders(userId: String) async throws -> [Order] {
        return try await networkManager.fetch(
            from: APIEndpoints.Orders.getUserOrders(userId),
            responseType: [Order].self
        )
    }
    
    /// Get order by ID
    func getOrder(orderId: String) async throws -> Order {
        return try await networkManager.fetch(
            from: APIEndpoints.Orders.getById(orderId),
            responseType: Order.self
        )
    }
}

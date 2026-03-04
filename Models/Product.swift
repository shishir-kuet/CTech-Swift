//
//  Product.swift
//  CTechApp
//
//  Created by macos on 3/3/26.
//

import Foundation

struct Product: Identifiable, Codable {
    let id: Int
    let name: String
    let description: String
    let price: Double
    let imageName: String
    let category: String
    let specifications: [String: String]
}

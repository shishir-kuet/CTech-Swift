//
//  Product.swift
//  CTechApp
//

import Foundation

struct Product: Identifiable, Codable {
    var id: Int
    var firestoreId: String?    // set manually when loading from Firestore
    let name: String
    let description: String
    let price: Double
    let imageName: String       // local asset name
    let imageURL: String?       // remote URL (Firestore products)
    let category: String
    let brand: String
    let stock: Int
    let specifications: [String: String]

    var displayImage: String { imageURL ?? imageName }

    // Only encode/decode the fields present in JSON — firestoreId is excluded
    enum CodingKeys: String, CodingKey {
        case id, name, description, price, imageName, imageURL
        case category, brand, stock, specifications
    }
}

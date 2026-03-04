//
//  CartItem.swift
//  CTechApp
//
//  Created by macos on 3/3/26.
//

import Foundation

struct CartItem: Identifiable {
    var id: Int { product.id }
    let product: Product
    var quantity: Int
}

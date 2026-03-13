//
//  Category.swift
//  CTechApp
//
//  Created by macos on 3/3/26.
//

import Foundation

struct Category: Identifiable {
    var id: String { name }   // unique by name
    let name: String
}

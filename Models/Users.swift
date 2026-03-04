//
//  Users.swift
//  CTechApp
//
//  Created by macos on 4/3/26.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct User: Identifiable, Codable {
    var id: String
    var email: String
    var isAdmin: Bool
}

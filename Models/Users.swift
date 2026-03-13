//
//  Users.swift
//  CTechApp
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct User: Identifiable, Codable {
    var id: String
    var email: String
    var displayName: String?    // optional — may not exist in manually created Firestore docs
    var isAdmin: Bool
}

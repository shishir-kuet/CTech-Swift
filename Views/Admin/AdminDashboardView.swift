//
//  AdminDashboardView.swift
//  CTechApp
//
//  Created by macos on 4/3/26.
//

import Foundation
import SwiftUI
import FirebaseFirestore

struct AdminDashboardView: View {
    @State private var name = ""
    @State private var price = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section("Add New Product") {
                    TextField("Product Name", text: $name)
                    TextField("Price", text: $price).keyboardType(.decimalPad)
                    Button("Save to Store") {
                        saveToFirestore()
                    }
                }
            }
            .navigationTitle("Admin Panel")
        }
    }

    func saveToFirestore() {
        let db = Firestore.firestore()
        let newProduct = ["name": name, "price": Double(price) ?? 0.0] as [String : Any]
        db.collection("products").addDocument(data: newProduct)
        name = ""; price = "" // Clear fields after saving
    }
}

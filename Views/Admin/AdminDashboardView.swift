//
//  AdminDashboardView.swift
//  CTechApp
//
//  Created by macos on 4/3/26.
//

import SwiftUI
import FirebaseFirestore

struct AdminDashboardView: View {
    @State private var name = ""
    @State private var price = ""
    @State private var description = ""
    @State private var category = ""
    @State private var showSuccessAlert = false
    @EnvironmentObject var authVM: AuthViewModel
    
    var body: some View {
        NavigationView {
            Form {
                Section("Add New Product") {
                    TextField("Product Name", text: $name)
                    TextField("Description", text: $description)
                    TextField("Price (৳)", text: $price).keyboardType(.decimalPad)
                    TextField("Category", text: $category)
                    
                    Button("Save to Store") {
                        saveToFirestore()
                    }
                    .disabled(name.isEmpty || price.isEmpty)
                }
                
                Section {
                    Button("Logout", role: .destructive) {
                        authVM.logout()
                    }
                }
            }
            .navigationTitle("Admin Panel")
            .alert("Success", isPresented: $showSuccessAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Product added successfully!")
            }
        }
    }

    func saveToFirestore() {
        let db = Firestore.firestore()
        let newProduct = [
            "name": name,
            "description": description.isEmpty ? "No description" : description,
            "price": Double(price) ?? 0.0,
            "category": category.isEmpty ? "General" : category,
            "imageName": "placeholder"
        ] as [String : Any]
        
        db.collection("products").addDocument(data: newProduct) { error in
            if error == nil {
                name = ""
                price = ""
                description = ""
                category = ""
                showSuccessAlert = true
            }
        }
    }
}

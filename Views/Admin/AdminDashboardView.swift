//
//  AdminDashboardView.swift
//  CTechApp
//

import SwiftUI
import FirebaseFirestore

struct AdminDashboardView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            AdminStatsView()
                .tabItem { Label("Dashboard", systemImage: "chart.bar") }
                .tag(0)

            AdminProductsView()
                .tabItem { Label("Products", systemImage: "shippingbox") }
                .tag(1)

            AdminOrdersView()
                .tabItem { Label("Orders", systemImage: "list.bullet.rectangle") }
                .tag(2)
        }
        // Logout lives inside each tab's own NavigationView toolbar
    }
}

// MARK: - Stats
struct AdminStatsView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @State private var totalProducts = 0
    @State private var totalOrders = 0
    @State private var pendingOrders = 0

    var body: some View {
        NavigationView {
            List {
                Section("Overview") {
                    StatRow(label: "Total Products", value: totalProducts, icon: "shippingbox", color: .blue)
                    StatRow(label: "Total Orders", value: totalOrders, icon: "cart", color: .purple)
                    StatRow(label: "Pending Orders", value: pendingOrders, icon: "clock", color: .orange)
                }
            }
            .navigationTitle("Dashboard")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Logout") { authVM.logout() }
                        .foregroundColor(.red)
                }
            }
            .onAppear { fetchStats() }
        }
    }

    private func fetchStats() {
        let db = Firestore.firestore()
        db.collection("products").addSnapshotListener { snap, _ in
            totalProducts = snap?.documents.count ?? 0
        }
        db.collection("orders").addSnapshotListener { snap, _ in
            let docs = snap?.documents ?? []
            totalOrders = docs.count
            pendingOrders = docs.filter { ($0.data()["status"] as? String) == "Pending" }.count
        }
    }
}

struct StatRow: View {
    let label: String
    let value: Int
    let icon: String
    let color: Color

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 30)
            Text(label)
            Spacer()
            Text("\(value)")
                .font(.headline)
                .foregroundColor(color)
        }
    }
}

// MARK: - Products Management
struct AdminProductsView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @State private var products: [FirestoreProduct] = []
    @State private var showAddSheet = false

    var body: some View {
        NavigationView {
            List {
                ForEach(products) { product in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(product.name).font(.headline)
                        Text("\(product.brand) · \(product.category)")
                            .font(.caption).foregroundColor(.secondary)
                        HStack {
                            Text("৳\(product.price, specifier: "%.2f")")
                                .foregroundColor(.blue)
                            Spacer()
                            Text("Stock: \(product.stock)")
                                .font(.caption)
                                .foregroundColor(product.stock > 0 ? .green : .red)
                        }
                    }
                }
                .onDelete(perform: deleteProducts)
            }
            .navigationTitle("Products")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Logout") { authVM.logout() }
                        .foregroundColor(.red)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { showAddSheet = true } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddSheet) {
                AddProductSheet(isPresented: $showAddSheet)
            }
            .onAppear { fetchProducts() }
        }
    }

    private func fetchProducts() {
        Firestore.firestore().collection("products").addSnapshotListener { snap, _ in
            products = snap?.documents.compactMap { doc -> FirestoreProduct? in
                let d = doc.data()
                return FirestoreProduct(
                    id: doc.documentID,
                    name: d["name"] as? String ?? "",
                    brand: d["brand"] as? String ?? "",
                    category: d["category"] as? String ?? "",
                    price: d["price"] as? Double ?? 0,
                    stock: d["stock"] as? Int ?? 0
                )
            } ?? []
        }
    }

    private func deleteProducts(at offsets: IndexSet) {
        let db = Firestore.firestore()
        offsets.forEach { i in
            db.collection("products").document(products[i].id).delete()
        }
    }
}

struct FirestoreProduct: Identifiable {
    let id: String
    let name: String
    let brand: String
    let category: String
    let price: Double
    let stock: Int
}

// MARK: - Add Product Sheet
struct AddProductSheet: View {
    @Binding var isPresented: Bool

    @State private var name = ""
    @State private var brand = ""
    @State private var category = "CPU"
    @State private var price = ""
    @State private var stock = ""
    @State private var imageURL = ""
    @State private var description = ""
    @State private var specKey = ""
    @State private var specValue = ""
    @State private var specs: [String: String] = [:]
    @State private var isSaving = false

    let categories = ["CPU", "GPU", "RAM", "Storage", "Motherboard", "PSU", "Casing", "Cooler", "Microcontrollers", "Sensors", "Displays", "Components"]

    var body: some View {
        NavigationView {
            Form {
                Section("Product Info") {
                    TextField("Name", text: $name)
                    TextField("Brand", text: $brand)
                    Picker("Category", selection: $category) {
                        ForEach(categories, id: \.self) { Text($0) }
                    }
                    TextField("Price (BDT)", text: $price).keyboardType(.decimalPad)
                    TextField("Stock Quantity", text: $stock).keyboardType(.numberPad)
                    TextField("Image URL (optional)", text: $imageURL)
                        .autocapitalization(.none)
                    TextField("Description", text: $description)
                }

                Section("Specifications") {
                    ForEach(specs.keys.sorted(), id: \.self) { key in
                        HStack {
                            Text(key).font(.caption)
                            Spacer()
                            Text(specs[key] ?? "").font(.caption).foregroundColor(.secondary)
                        }
                    }
                    HStack {
                        TextField("Key", text: $specKey)
                        TextField("Value", text: $specValue)
                        Button {
                            if !specKey.isEmpty && !specValue.isEmpty {
                                specs[specKey] = specValue
                                specKey = ""; specValue = ""
                            }
                        } label: { Image(systemName: "plus.circle.fill") }
                    }
                }
            }
            .navigationTitle("Add Product")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { isPresented = false }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") { saveProduct() }
                        .disabled(name.isEmpty || price.isEmpty || isSaving)
                }
            }
        }
    }

    private func saveProduct() {
        isSaving = true
        var data: [String: Any] = [
            "name": name,
            "brand": brand,
            "category": category,
            "price": Double(price) ?? 0,
            "stock": Int(stock) ?? 0,
            "description": description,
            "specifications": specs
        ]
        if !imageURL.isEmpty { data["imageURL"] = imageURL }

        Firestore.firestore().collection("products").addDocument(data: data) { _ in
            isSaving = false
            isPresented = false
        }
    }
}

// MARK: - Orders Management
struct AdminOrdersView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @State private var orders: [Order] = []
    @State private var isLoading = true

    var body: some View {
        NavigationView {
            Group {
                if isLoading {
                    ProgressView("Loading orders...")
                } else if orders.isEmpty {
                    Text("No orders yet").foregroundColor(.secondary)
                } else {
                    List(orders) { order in
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text("Order #\(order.id?.prefix(6) ?? "------")")
                                    .font(.headline)
                                Spacer()
                                StatusBadge(status: order.status)
                            }

                            Text("Customer: \(order.userName)")
                                .font(.caption).foregroundColor(.secondary)

                            ForEach(order.items, id: \.productId) { item in
                                Text("• \(item.productName) × \(item.quantity)")
                                    .font(.caption).foregroundColor(.secondary)
                            }

                            Text("Total: ৳\(order.totalPrice, specifier: "%.2f")")
                                .font(.subheadline).foregroundColor(.blue)

                            Picker("Status", selection: Binding(
                                get: { order.status },
                                set: { updateStatus(order: order, newStatus: $0) }
                            )) {
                                Text("Pending").tag("Pending")
                                Text("Processing").tag("Processing")
                                Text("Delivered").tag("Delivered")
                            }
                            .pickerStyle(.segmented)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Orders")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Logout") { authVM.logout() }
                        .foregroundColor(.red)
                }
            }
            .onAppear { fetchOrders() }
        }
    }

    private func fetchOrders() {
        Firestore.firestore()
            .collection("orders")
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { snap, error in
                isLoading = false
                if let error = error {
                    print("AdminOrders fetch error: \(error.localizedDescription)")
                    return
                }
                orders = snap?.documents.compactMap { doc -> Order? in
                    let d = doc.data()
                    let rawItems = d["items"] as? [[String: Any]] ?? []
                    let items = rawItems.map { i in
                        OrderItem(
                            productId: i["productId"] as? Int ?? 0,
                            productName: i["productName"] as? String ?? "",
                            price: i["price"] as? Double ?? 0,
                            quantity: i["quantity"] as? Int ?? 0
                        )
                    }
                    let ts = (d["timestamp"] as? Timestamp)?.dateValue() ?? Date()
                    return Order(
                        id: doc.documentID,
                        userId: d["userId"] as? String ?? "",
                        userName: d["userName"] as? String ?? "",
                        items: items,
                        totalPrice: d["totalPrice"] as? Double ?? 0,
                        status: d["status"] as? String ?? "Pending",
                        address: d["address"] as? String ?? "",
                        timestamp: ts
                    )
                } ?? []
            }
    }

    private func updateStatus(order: Order, newStatus: String) {
        guard let id = order.id else { return }
        Firestore.firestore().collection("orders").document(id).updateData(["status": newStatus])
    }
}

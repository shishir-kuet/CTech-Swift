//
//  MyOrdersView.swift
//  CTechApp
//

import SwiftUI
import FirebaseFirestore

struct MyOrdersView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @State private var orders: [Order] = []
    @State private var isLoading = true

    var body: some View {
        Group {
            if isLoading {
                ProgressView("Loading orders...")
            } else if orders.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "list.bullet.rectangle")
                        .font(.system(size: 50))
                        .foregroundColor(.secondary)
                    Text("No orders yet")
                        .foregroundColor(.secondary)
                }
            } else {
                List(orders) { order in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Order #\(order.id?.prefix(6) ?? "------")")
                                .font(.headline)
                            Spacer()
                            StatusBadge(status: order.status)
                        }

                        ForEach(order.items, id: \.productId) { item in
                            Text("• \(item.productName) × \(item.quantity)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }

                        HStack {
                            Text("Total: ৳\(order.totalPrice, specifier: "%.2f")")
                                .font(.subheadline)
                                .foregroundColor(.blue)
                            Spacer()
                            Text(order.timestamp, style: .date)
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }

                        Text("Ship to: \(order.address)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .navigationTitle("My Orders")
        .onAppear { fetchOrders() }
    }

    private func fetchOrders() {
        guard let uid = authVM.currentUser?.id else {
            isLoading = false
            return
        }
        Firestore.firestore()
            .collection("orders")
            .whereField("userId", isEqualTo: uid)
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { snap, error in
                isLoading = false
                if let error = error {
                    print("MyOrders fetch error: \(error.localizedDescription)")
                    return
                }
                orders = snap?.documents.compactMap { doc -> Order? in
                    let d = doc.data()
                    // Decode items array
                    let rawItems = d["items"] as? [[String: Any]] ?? []
                    let items = rawItems.map { i in
                        OrderItem(
                            productId: i["productId"] as? Int ?? 0,
                            productName: i["productName"] as? String ?? "",
                            price: i["price"] as? Double ?? 0,
                            quantity: i["quantity"] as? Int ?? 0
                        )
                    }
                    // Firestore Timestamp → Date
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
}

struct StatusBadge: View {
    let status: String

    var color: Color {
        switch status {
        case "Pending": return .orange
        case "Processing": return .blue
        case "Delivered": return .green
        default: return .secondary
        }
    }

    var body: some View {
        Text(status)
            .font(.caption2)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(color.opacity(0.15))
            .foregroundColor(color)
            .cornerRadius(8)
    }
}

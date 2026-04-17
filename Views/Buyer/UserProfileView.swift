import SwiftUI
import FirebaseFirestore

struct UserProfileView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @State private var orderCount = 0
    @State private var isLoading = true

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                profileHeader

                quickStats

                actionLinks

                Spacer()
            }
            .padding()
        }
        .onAppear(perform: fetchOrderCount)
    }

    private var profileHeader: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Welcome back,")
                .font(.caption)
                .foregroundColor(.secondary)
            Text(authVM.currentUser?.displayName ?? "Valued Customer")
                .font(.largeTitle)
                .bold()
            Text(authVM.currentUser?.email ?? "No email available")
                .font(.subheadline)
                .foregroundColor(.secondary)

            HStack {
                Text(authVM.currentUser?.isAdmin == true ? "Admin account" : "Buyer account")
                    .font(.caption2)
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(authVM.currentUser?.isAdmin == true ? Color.blue : Color.green)
                    .cornerRadius(12)
                Spacer()
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 8)
    }

    private var quickStats: some View {
        HStack(spacing: 16) {
            statCard(title: "Orders", value: orderCount)
            statCard(title: "Saved Cards", value: 1)
            statCard(title: "Wishlist", value: 0)
        }
    }

    private func statCard(title: String, value: Int) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            Text("\(value)")
                .font(.title2)
                .bold()
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(18)
    }

    private var actionLinks: some View {
        VStack(spacing: 12) {
            NavigationLink(destination: MyOrdersView()) {
                actionRow(title: "View Orders", subtitle: "See recent purchase history", icon: "list.bullet")
            }
            NavigationLink(destination: PaymentView()) {
                actionRow(title: "Payment Methods", subtitle: "Add billing and cards", icon: "creditcard")
            }
            NavigationLink(destination: UserSettingsView()) {
                actionRow(title: "Account Settings", subtitle: "Update profile details", icon: "gearshape")
            }
        }
    }

    private func actionRow(title: String, subtitle: String, icon: String) -> some View {
        HStack {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.white)
                .frame(width: 46, height: 46)
                .background(Color.blue)
                .cornerRadius(14)
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(18)
    }

    private func fetchOrderCount() {
        guard let uid = authVM.currentUser?.id else {
            isLoading = false
            return
        }

        Firestore.firestore()
            .collection("orders")
            .whereField("userId", isEqualTo: uid)
            .getDocuments { snapshot, _ in
                isLoading = false
                orderCount = snapshot?.documents.count ?? 0
            }
    }
}

private struct UserSettingsView: View {
    var body: some View {
        Text("Account settings coming soon.")
            .foregroundColor(.secondary)
            .navigationTitle("Settings")
    }
}

import SwiftUI

struct UserHomeView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @EnvironmentObject var cartVM: CartViewModel
    
    @State private var selectedTab: Tab = .shop
    @State private var showMenu = false
    
    enum Tab: Hashable {
        case shop, orders, cart, payment, profile
        
        var label: String {
            switch self {
            case .shop: return "Shop"
            case .orders: return "Orders"
            case .cart: return "Cart"
            case .payment: return "Payment"
            case .profile: return "Profile"
            }
        }
        
        var icon: String {
            switch self {
            case .shop: return "bag"
            case .orders: return "list.bullet"
            case .cart: return "cart"
            case .payment: return "creditcard"
            case .profile: return "person.crop.circle"
            }
        }
    }
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            VStack(spacing: 0) {
                // Main content area
                Group {
                    if selectedTab == .shop {
                        NavigationStack {
                            ProductListView()
                                .navigationTitle(selectedTab.label)
                                .navigationBarTitleDisplayMode(.inline)
                                .toolbar { toolbarItems }
                        }
                    } else if selectedTab == .orders {
                        NavigationStack {
                            MyOrdersView()
                                .navigationTitle(selectedTab.label)
                                .navigationBarTitleDisplayMode(.inline)
                                .toolbar { toolbarItems }
                        }
                    } else if selectedTab == .cart {
                        NavigationStack {
                            CartView()
                                .navigationTitle(selectedTab.label)
                                .navigationBarTitleDisplayMode(.inline)
                                .toolbar { toolbarItems }
                        }
                    } else if selectedTab == .payment {
                        NavigationStack {
                            PaymentView()
                                .navigationTitle(selectedTab.label)
                                .navigationBarTitleDisplayMode(.inline)
                                .toolbar { toolbarItems }
                        }
                    } else if selectedTab == .profile {
                        NavigationStack {
                            UserProfileView()
                                .navigationTitle(selectedTab.label)
                                .navigationBarTitleDisplayMode(.inline)
                                .toolbar { toolbarItems }
                        }
                    }
                }
                
                // Custom Tab Bar with button styling
                HStack(spacing: 10) {
                    ForEach([Tab.shop, Tab.orders, Tab.cart, Tab.payment, Tab.profile], id: \.self) { tab in
                        VStack(spacing: 4) {
                            Image(systemName: tab.icon)
                                .font(.system(size: 20))
                            Text(tab.label)
                                .font(.caption2)
                                .lineLimit(1)
                        }
                        .frame(maxWidth: .infinity)
                        .foregroundColor(selectedTab == tab ? .white : .black.opacity(0.7))
                        .padding(.vertical, 10)
                        .padding(.horizontal, 8)
                        .background(selectedTab == tab ? Color(red: 0.0, green: 0.4, blue: 0.95) : Color.white.opacity(0.3))
                        .cornerRadius(10)
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                selectedTab = tab
                            }
                        }
                    }
                }
                .padding(10)
                .background(Color(red: 0.8, green: 0.9, blue: 1.0))
                .frame(height: 70)
                .cornerRadius(12)
                .padding(8)
            }
            
            if showMenu {
                Color.black.opacity(0.25)
                    .ignoresSafeArea()
                    .transition(.opacity)
                    .onTapGesture { withAnimation { showMenu = false } }
                UserSidebarMenu(selectedTab: $selectedTab, isOpen: $showMenu)
                    .transition(.move(edge: .leading))
            }
        }
    }

    @ToolbarContentBuilder
    private var toolbarItems: some ToolbarContent {
        ToolbarItemGroup(placement: .navigationBarLeading) {
            Button(action: {
                withAnimation { showMenu.toggle() }
            }) {
                Image(systemName: "line.3.horizontal")
                    .imageScale(.large)
            }
        }
        ToolbarItemGroup(placement: .navigationBarTrailing) {
            Button(action: { authVM.logout() }) {
                Image(systemName: "power")
            }
            .foregroundColor(.red)
        }
    }
}

private struct UserSidebarMenu: View {
    @Binding var selectedTab: UserHomeView.Tab
    @Binding var isOpen: Bool
    @EnvironmentObject var authVM: AuthViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(authVM.currentUser?.displayName ?? "Customer")
                        .font(.title2)
                        .bold()
                    Text(authVM.currentUser?.email ?? "no-email@example.com")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
                Button(action: { withAnimation { isOpen = false } }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.secondary)
                }
            }
            Text("Quick Actions")
                .font(.headline)
            VStack(spacing: 12) {
                sidebarButton(title: "Shop", icon: "bag", tab: .shop)
                sidebarButton(title: "My Orders", icon: "list.bullet.rectangle", tab: .orders)
                sidebarButton(title: "Cart", icon: "cart", tab: .cart)
                sidebarButton(title: "Profile", icon: "person.crop.circle", tab: .profile)
                sidebarButton(title: "Payment", icon: "creditcard", tab: .payment)
            }
            Divider()
            Text("Account")
                .font(.headline)
            Button(action: { authVM.logout() }) {
                HStack {
                    Image(systemName: "arrow.turn.up.left")
                    Text("Logout")
                }
                .foregroundColor(.red)
            }
            Spacer()
        }
        .padding(.top, 40)
        .padding(.horizontal)
        .frame(maxWidth: 280)
        .padding(.bottom, 20)
        .background(.ultraThinMaterial)
        .edgesIgnoringSafeArea(.vertical)
        .shadow(radius: 20)
    }

    @ViewBuilder
    private func sidebarButton(title: String, icon: String, tab: UserHomeView.Tab) -> some View {
        Button(action: {
            withAnimation {
                selectedTab = tab
                isOpen = false
            }
        }) {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .frame(width: 28, height: 28)
                    .foregroundColor(.blue)
                Text(title)
                    .foregroundColor(.primary)
            }
            .padding(.vertical, 12)
            .padding(.horizontal)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
        .buttonStyle(.plain)
    }
}


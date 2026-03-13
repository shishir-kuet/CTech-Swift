# CTechApp — Project Overview

## Summary

CTechApp is an iOS e-commerce application for buying electronics/tech components (e.g., Arduino, Raspberry Pi). It supports two user roles — **Buyer** and **Admin** — with Firebase-backed authentication and Firestore for live product data. Products are also seeded locally via a JSON file.

---

## Tech Stack

| Area | Technology |
|---|---|
| UI | SwiftUI |
| Auth | Firebase Authentication |
| Database | Cloud Firestore |
| Local Data | Bundled `Products.json` |
| Architecture | MVVM |
| Language | Swift |

---

## Project Structure

```
CTechApp/
├── CTechApp/
│   ├── CTechAppApp.swift       # App entry point
│   └── HomeView.swift          # Root view — routes to Login or role-based views
│
├── Models/
│   ├── Product.swift           # Product data model (Identifiable, Codable)
│   ├── Category.swift          # Category model (name-based ID)
│   ├── CartItem.swift          # Cart item wrapping Product + quantity
│   └── Users.swift             # User model with isAdmin flag (Firestore-backed)
│
├── ViewModels/
│   ├── AuthViewModel.swift     # Firebase login + user role fetching
│   ├── ProductViewModel.swift  # Loads + filters products from local JSON
│   └── CartViewModel.swift     # Cart state: add, remove, quantity, total
│
├── Services/
│   └── ProductService.swift    # Reads and decodes Products.json from app bundle
│
├── Views/
│   ├── Auth/
│   │   ├── LoginView.swift     # Email/password login form
│   │   └── RegisterView.swift  # Registration form (sign-up not yet wired up)
│   ├── Buyer/
│   │   └── ProductListView.swift  # Live product list from Firestore
│   ├── Admin/
│   │   └── AdminDashboardView.swift  # Add products to Firestore
│   ├── ProductDetailView.swift  # Product image, description, specs, Add to Cart
│   └── CartView.swift           # Cart items list with quantity controls + total
│
├── Resources/
│   └── Products.json            # Local seed data (2 products: Arduino Uno, RPi 4)
│
├── CTechAppTests/
│   └── CTechAppTests.swift      # Unit test stubs (no tests written yet)
│
└── CTechAppUITests/
    ├── CTechAppUITests.swift
    └── CTechAppUITestsLaunchTests.swift
```

---

## Architecture: MVVM

```
View  ──uses──▶  ViewModel  ──uses──▶  Service / Firebase
  │                  │
  │           @Published state
  └──observes──▶  UI updates
```

- **Views** are pure SwiftUI structs; no business logic.
- **ViewModels** are `ObservableObject` classes holding `@Published` state.
- **Services** handle data loading (local JSON).
- **Firebase** is used directly from ViewModels for auth and Firestore reads/writes.

---

## Authentication Flow

1. App launches → `HomeView` checks `authVM.isAuthenticated`
2. If not authenticated → shows `LoginView`
3. On login, Firebase Auth signs in → `fetchUserRole(uid:)` reads the user document from Firestore `users/{uid}`
4. If `isAdmin == true` → routes to `AdminDashboardView`
5. Otherwise → routes to `ProductListView`

> **Note:** `RegisterView` UI exists but the `authVM.register(...)` call is commented out — registration is not yet functional.

---

## Data Sources

### Local JSON (`Products.json`)
Used by `ProductService` + `ProductViewModel`. Contains 2 seed products:

| ID | Name | Price | Category |
|----|------|-------|----------|
| 1 | Arduino Uno | ৳650 | Microcontrollers |
| 2 | Raspberry Pi 4 | ৳22,500 | Microcontrollers |

### Firestore (`products` collection)
Used directly in `ProductListView` (live listener) and `AdminDashboardView` (writes). The Firestore schema for a product stores at minimum `name` and `price`.

---

## Key ViewModels

### `AuthViewModel`
- `login(email:password:)` — Firebase sign-in
- `fetchUserRole(uid:)` — reads `users/{uid}` from Firestore, sets `currentUser` and `isAuthenticated`

### `ProductViewModel`
- Loads products from local JSON via `ProductService` on `init()`
- `filteredProducts` — computed property that filters by `searchText`

### `CartViewModel`
- `addToCart(product:)` — adds or increments quantity
- `removeFromCart(item:)` — removes item entirely
- `increaseQuantity(for:)` / `decreaseQuantity(for:)` — quantity controls
- `totalPrice` — computed sum of all items
- `clearCart()` — empties the cart

---

## Known Gaps / TODOs

| Area | Issue |
|---|---|
| Registration | `RegisterView` UI exists but `authVM.register(...)` is not implemented |
| ProductListView | Uses Firestore directly instead of going through `ProductViewModel` — inconsistent with MVVM |
| Cart integration | `ProductListView` has a "Buy Now" button that only `print()`s — not wired to cart |
| ProductDetailView | Not linked from `ProductListView` — no `NavigationLink` to detail page |
| Search | `ProductViewModel.searchText` and `filteredProducts` exist but no search UI is present in `ProductListView` |
| Tests | Test targets exist but contain only Xcode-generated stubs — no actual tests written |
| Logout | No logout functionality implemented |
| Currency | `ProductDetailView` uses `৳` (BDT) while `ProductListView` uses `$` — inconsistent |





//// command 

Build a complete PC components buying/selling web app using HTML, CSS, and JavaScript 
with Firebase Firestore + Firebase Auth. No frameworks, single HTML file per page or 
SPA approach.

ROLES:
- Admin (hardcoded email: admin@pcstore.com)
- User (regular signup/login)

FEATURES:

[AUTH]
- Email/password login & signup
- Role-based redirect after login (admin → dashboard, user → shop)
- Logout button

[ADMIN PANEL]
- Add product form with fields: name, category (CPU/GPU/RAM/Storage/Motherboard/PSU/
  Casing/Cooler), brand, price (BDT), stock quantity, image URL, and dynamic 
  specifications (key-value pairs, e.g. "Core Count: 8", "TDP: 65W")
- View all products in a table with edit/delete
- View all orders with status update (Pending → Processing → Delivered)
- Dashboard stats: total products, total orders, pending orders

[USER SHOP]
- Browse all available components with card UI
- Search by name
- Filter by category
- Each card shows: image, name, brand, price, stock, specs accordion
- "Add to Cart" button (cart stored in localStorage)
- Cart page: view items, change quantity, remove items, place order
- Order is saved to Firestore with: userId, userName, items[], totalPrice, 
  status:"Pending", timestamp, delivery address (simple text input at checkout)
- My Orders page: user sees their own order history with status

[FIRESTORE STRUCTURE]
- /products/{productId} → all product fields + specs map
- /orders/{orderId} → userId, userName, items, total, status, address, timestamp
- /users/{userId} → email, role, displayName

[UI REQUIREMENTS]
- Clean modern dark theme with blue accents
- Responsive (mobile friendly)
- Toast notifications for actions (added to cart, order placed, etc.)
- Loading states

Use Firebase v9 modular SDK via CDN. Include Firebase config placeholder. 
Role check: after login, fetch /users/{uid} to get role, redirect accordingly. 
Admin role is set in Firestore manually or auto-assign if email === admin@pcstore.com 
on first signup.

Deliver as a single index.html file with all CSS and JS inline. Use Firebase CDN imports.

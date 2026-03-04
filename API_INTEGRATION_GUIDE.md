# CTechApp - API Integration Guide

## 📡 API Parsing Implementation

Your project now has a complete **REST API integration layer** with automatic fallback to local data.

---

## 🏗️ Architecture

### **Services Layer:**

1. **NetworkManager.swift** - Core networking with generic HTTP methods
   - GET, POST, PUT, DELETE support
   - Automatic JSON encoding/decoding
   - Error handling

2. **APIEndpoints.swift** - Centralized endpoint definitions
   - Products, Categories, Orders, Search endpoints
   - Easy to update base URL

3. **APIService.swift** - Product-specific API calls
   - Fetch products (with local fallback)
   - Search products
   - CRUD operations for products
   - Category management

4. **OrderService.swift** - Order management
   - Create orders
   - Fetch user orders
   - Track order status

---

## 🔧 Configuration

### **1. Update Base URL**

Edit `Services/APIEndpoints.swift`:

```swift
static let baseURL = "https://your-api-domain.com/v1"
```

### **2. Example API Endpoints Expected:**

```
GET    /products              → Get all products
GET    /products/:id          → Get product by ID
GET    /products?category=X   → Get products by category
POST   /products              → Create product (admin)
PUT    /products/:id          → Update product
DELETE /products/:id          → Delete product

GET    /categories            → Get all categories
GET    /search?q=query        → Search products

POST   /orders                → Create order
GET    /orders/:id            → Get order
GET    /users/:id/orders      → Get user's orders
```

---

## 📝 Expected API Response Formats

### **Products List Response:**
```json
{
  "products": [
    {
      "id": 1,
      "name": "Arduino Uno",
      "description": "Microcontroller board",
      "price": 650.0,
      "imageName": "arduino",
      "category": "Microcontrollers",
      "specifications": {
        "Voltage": "5V",
        "Digital I/O Pins": "14"
      }
    }
  ],
  "total": 10,
  "page": 1
}
```

### **Single Product Response:**
```json
{
  "id": 1,
  "name": "Arduino Uno",
  "description": "Microcontroller board",
  "price": 650.0,
  "imageName": "arduino",
  "category": "Microcontrollers",
  "specifications": {
    "Voltage": "5V"
  }
}
```

### **Create Order Request:**
```json
{
  "userId": "user123",
  "items": [
    {
      "productId": 1,
      "productName": "Arduino Uno",
      "quantity": 2,
      "price": 650.0
    }
  ],
  "totalAmount": 1300.0
}
```

---

## 🚀 Usage Examples

### **Fetch Products:**
```swift
// In ProductViewModel
await productVM.loadProducts()

// With category filter
await productVM.loadProducts(byCategory: "Microcontrollers")

// Search
productVM.searchText = "Arduino"
await productVM.searchProducts()
```

### **Place Order:**
```swift
// In CartViewModel
await cartVM.placeOrder(userId: currentUser.id)
```

### **Admin Operations:**
```swift
// Create product
let product = try await APIService.shared.createProduct(
    name: "New Product",
    description: "Description",
    price: 999.0,
    category: "Electronics"
)

// Update product
let updated = try await APIService.shared.updateProduct(
    id: 1,
    name: "Updated Name",
    price: 1099.0
)

// Delete product
try await APIService.shared.deleteProduct(id: 1)
```

---

## ✅ Features Implemented

- ✅ **Generic HTTP methods** (GET, POST, PUT, DELETE)
- ✅ **Automatic JSON parsing** with Codable
- ✅ **Error handling** with custom NetworkError
- ✅ **Fallback to local JSON** if API fails
- ✅ **Pull-to-refresh** in product list
- ✅ **Loading states** with progress indicator
- ✅ **Search functionality** via API
- ✅ **Order placement** via API
- ✅ **Category filtering**
- ✅ **Snake case ↔ Camel case** auto-conversion

---

## 🧪 Testing Without Backend

The app automatically falls back to local `Products.json` if the API is unavailable. To test:

1. Keep the default API URL (will fail)
2. App loads local products automatically
3. Replace with real API URL when ready

---

## 🔐 Authentication Headers (Optional)

To add auth tokens, modify `NetworkManager.swift`:

```swift
private func addAuthHeaders(to request: inout URLRequest) {
    // Add your auth token
    request.setValue("Bearer YOUR_TOKEN", forHTTPHeaderField: "Authorization")
}
```

---

## 📱 Ready for Production

Your app now supports:
- **REST API integration** with full CRUD operations
- **Graceful degradation** (fallback to local data)
- **Modern async/await** Swift concurrency
- **Pull-to-refresh** and loading states
- **Order management** via API

Just update the base URL in `APIEndpoints.swift` and you're ready to go! 🚀

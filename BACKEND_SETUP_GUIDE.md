# API Setup Guide - Making API Parsing Functional

## 🚀 Quick Start Options

### **Option 1: Local Development Server**

#### Using Node.js/Express:

1. **Create a simple Express server:**

```javascript
// server.js
const express = require('express');
const app = express();
const PORT = 3000;

app.use(express.json());

// Products endpoint
app.get('/v1/products', (req, res) => {
  res.json({
    products: [
      {
        id: 1,
        name: "Arduino Uno",
        description: "Microcontroller board",
        price: 650.0,
        imageName: "arduino",
        category: "Microcontrollers",
        specifications: {
          "Voltage": "5V",
          "Digital I/O Pins": "14"
        }
      }
    ],
    total: 1,
    page: 1
  });
});

// Search endpoint
app.get('/v1/search', (req, res) => {
  const query = req.query.q;
  res.json({
    products: [/* filtered products */],
    total: 0
  });
});

// Create product
app.post('/v1/products', (req, res) => {
  const newProduct = req.body;
  newProduct.id = Date.now();
  res.status(201).json(newProduct);
});

// Orders endpoint
app.post('/v1/orders', (req, res) => {
  const order = {
    id: Date.now().toString(),
    userId: req.body.userId,
    items: req.body.items,
    totalAmount: req.body.totalAmount,
    status: "pending",
    createdAt: new Date(),
    updatedAt: new Date()
  };
  res.status(201).json(order);
});

app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});
```

2. **Run the server:**
```bash
npm install express
node server.js
```

3. **Update iOS app** - Change base URL in `APIEndpoints.swift`:
```swift
// For iOS Simulator accessing localhost
static let baseURL = "http://localhost:3000/v1"

// For real device on same network
static let baseURL = "http://YOUR_COMPUTER_IP:3000/v1"
```

---

### **Option 2: Use Free API Testing Services**

#### **JSONPlaceholder / MockAPI:**

1. **Go to [mockapi.io](https://mockapi.io)** (Free)
2. **Create a project** and add resources:
   - `/products`
   - `/categories`
   - `/orders`

3. **Update base URL:**
```swift
static let baseURL = "https://YOUR_ID.mockapi.io/api/v1"
```

---

### **Option 3: Deploy Backend to Cloud**

#### **Using Firebase Cloud Functions (Free Tier):**

```javascript
// functions/index.js
const functions = require('firebase-functions');
const express = require('express');
const app = express();

app.get('/products', (req, res) => {
  // Return products from Firestore
  admin.firestore().collection('products').get()
    .then(snapshot => {
      const products = snapshot.docs.map(doc => ({
        id: doc.id,
        ...doc.data()
      }));
      res.json({ products, total: products.length });
    });
});

exports.api = functions.https.onRequest(app);
```

Deploy:
```bash
firebase deploy --only functions
```

Update base URL:
```swift
static let baseURL = "https://YOUR_PROJECT.cloudfunctions.net/api"
```

---

### **Option 4: Use Existing Free APIs**

For testing, you can temporarily use public APIs:

```swift
// In APIEndpoints.swift - for TESTING ONLY
static let baseURL = "https://fakestoreapi.com"

// Then map their structure to yours
struct FakeStoreProduct: Codable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let category: String
    let image: String
}
```

---

## ⚙️ iOS Configuration for Local Testing

### **Allow HTTP connections (for localhost):**

Add to `Info.plist`:
```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

Or for specific domain:
```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSExceptionDomains</key>
    <dict>
        <key>localhost</key>
        <dict>
            <key>NSExceptionAllowsInsecureHTTPLoads</key>
            <true/>
        </dict>
    </dict>
</dict>
```

---

## 🧪 Test Without Backend

Your app already has a **fallback mechanism**:

1. Keep invalid URL in `APIEndpoints.swift`
2. App automatically uses local `Products.json`
3. All features work offline!

---

## 📝 Minimum Required Endpoints

For basic functionality, implement these 4 endpoints:

### **1. GET /products** - Fetch products
```json
Response: {
  "products": [
    {
      "id": 1,
      "name": "Product Name",
      "description": "Description",
      "price": 100.0,
      "imageName": "image",
      "category": "Category",
      "specifications": {}
    }
  ]
}
```

### **2. GET /search?q=query** - Search products
```json
Response: { "products": [...] }
```

### **3. POST /products** - Create product (admin)
```json
Request: {
  "name": "New Product",
  "description": "Desc",
  "price": 100.0,
  "category": "Cat"
}
Response: { /* created product */ }
```

### **4. POST /orders** - Place order
```json
Request: {
  "userId": "user123",
  "items": [
    {
      "productId": 1,
      "productName": "Product",
      "quantity": 2,
      "price": 100.0
    }
  ],
  "totalAmount": 200.0
}
Response: {
  "id": "order123",
  "status": "pending",
  "createdAt": "2026-03-05T10:00:00Z"
}
```

---

## 🎯 Recommended Quick Start

**For immediate testing:**

1. **Keep current setup** (uses local Products.json automatically)
2. **OR** Use MockAPI.io:
   - Sign up at mockapi.io (2 minutes)
   - Create `/products` resource
   - Update `APIEndpoints.swift` with your URL
   - Done! ✅

**For production:**

1. Build proper backend (Node.js/Python/Go)
2. Deploy to Heroku/Railway/Vercel (all have free tiers)
3. Update base URL
4. Test with Postman first
5. Connect iOS app

---

## ✅ Current Status

Your iOS app is **READY** and will work:
- ✅ With local data (no backend needed)
- ✅ With any REST API matching the structure
- ✅ Automatic fallback if API fails
- ✅ All CRUD operations implemented

Just choose your backend option and update the URL! 🚀

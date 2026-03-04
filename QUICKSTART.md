# 🚀 Quick Start - API Parsing Setup

## What You Need to Do (Choose ONE option)

### ✅ **OPTION 1: Use Local Data (Easiest - NO SETUP)**

**Current default mode - App works immediately!**

```swift
// In APIConfiguration.swift (already set)
static let currentMode: APIMode = .local
```

✅ No backend needed  
✅ Uses Products.json from your app  
✅ All features work offline  

**Action: NOTHING - It already works!**

---

### 🖥️ **OPTION 2: Run Local Development Server (Recommended for Testing)**

**Takes 5 minutes**

#### Step 1: Install Node.js
Download from [nodejs.org](https://nodejs.org) if not installed

#### Step 2: Start the Server
```bash
cd "E:\Mobile Computing\CTech\CTechApp"
npm install
npm start
```

You'll see:
```
🚀 CTech API Server Running
Port: 3000
URL: http://localhost:3000
```

#### Step 3: Configure iOS App
```swift
// In APIConfiguration.swift - Change this line:
static let currentMode: APIMode = .development
```

#### Step 4: Test in Browser
Open: http://localhost:3000/v1/products

✅ Should see JSON with products!

#### Step 5: Run iOS App
Build and run - it will now fetch from your local server!

**For iPhone Simulator:** Works with `localhost:3000`  
**For Real iPhone:** Change to your computer's IP:
```swift
.development: "http://192.168.1.X:3000/v1"  // Replace X with your IP
```

---

### 🌐 **OPTION 3: Use Mock API (For Remote Testing)**

**Takes 3 minutes**

#### Step 1: Create Mock API
1. Go to [mockapi.io](https://mockapi.io)
2. Sign up (free)
3. Create project "CTechApp"
4. Add resource `/products` with these fields:
   - name (text)
   - description (text)
   - price (number)
   - category (text)
   - imageName (text)

#### Step 2: Get Your URL
Copy your API URL (looks like: `https://6xyz123.mockapi.io/api/v1`)

#### Step 3: Configure App
```swift
// In APIConfiguration.swift:
static let currentMode: APIMode = .mockAPI

// Update the URL:
.mockAPI: "https://YOUR_ID.mockapi.io/api/v1"
```

✅ Done! Your app now uses cloud API

---

### 🏭 **OPTION 4: Production API (For Real Deployment)**

When you have a production backend:

```swift
// In APIConfiguration.swift:
static let currentMode: APIMode = .production

// Update URL:
.production: "https://api.yourwebsite.com/v1"
```

---

## 📱 **Testing Each Feature**

### Test Products (GET):
```
http://localhost:3000/v1/products
```

### Test Search (GET):
```
http://localhost:3000/v1/search?q=arduino
```

### Test Create Product (POST):
```bash
curl -X POST http://localhost:3000/v1/products \
  -H "Content-Type: application/json" \
  -d '{
    "name": "New Product",
    "description": "Test product",
    "price": 999.0,
    "category": "Test"
  }'
```

### Test Order (POST):
```bash
curl -X POST http://localhost:3000/v1/orders \
  -H "Content-Type: application/json" \
  -d '{
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
  }'
```

---

## 🔍 **How to Know It's Working**

### In Xcode Console:
```
📱 Using LOCAL data mode          ← Local mode
🌐 Fetching from API: development  ← API mode
✅ Fetched 3 products from API     ← Success
⚠️ API fetch failed, using local   ← Fallback
```

### In Your Server Console:
```
🌐 GET: http://localhost:3000/v1/products
✅ New order created: ORD1 - Total: ৳1300
```

---

## ✅ **Current Status Summary**

| Feature | Status | Mode |
|---------|--------|------|
| View Products | ✅ Working | Local/API |
| Search Products | ✅ Working | Local/API |
| Add to Cart | ✅ Working | Always |
| Checkout/Order | ✅ Working | API mode |
| Admin Add Product | ✅ Working | API mode |
| Automatic Fallback | ✅ Working | All modes |

---

## 🎯 **Recommended Path**

1. **Start:** Use `.local` mode (current) - No setup needed ✅
2. **Test:** Run `sample-server.js` and switch to `.development`
3. **Deploy:** When ready, use `.production` with real backend

## 💡 **Key Point**

Your app is **ALREADY FULLY FUNCTIONAL** without any backend!  
API integration is **optional** for network features.

---

## ❓ **Need Help?**

- **Check console logs** for detailed info
- **Test API with browser** first (http://localhost:3000)
- **Use Postman** to test endpoints independently
- **Enable debug logging** in APIConfiguration.swift

Your API parsing is complete and ready! 🎉

// Simple Express API Server for CTech App
// Run: node sample-server.js

const express = require('express');
const app = express();
const PORT = 3000;

app.use(express.json());

// In-memory storage
let products = [
  {
    id: 1,
    name: "Arduino Uno",
    description: "Microcontroller board based on ATmega328P.",
    price: 650.0,
    imageName: "arduino",
    category: "Microcontrollers",
    specifications: {
      "Voltage": "5V",
      "Digital I/O Pins": "14",
      "Analog Input Pins": "6"
    }
  },
  {
    id: 2,
    name: "Raspberry Pi 4",
    description: "Single-board computer with quad-core processor.",
    price: 22500.0,
    imageName: "raspberrypi",
    category: "Microcontrollers",
    specifications: {
      "RAM": "4GB",
      "USB Ports": "4",
      "HDMI": "2"
    }
  },
  {
    id: 3,
    name: "ESP32 DevKit",
    description: "WiFi and Bluetooth enabled microcontroller.",
    price: 450.0,
    imageName: "esp32",
    category: "Microcontrollers",
    specifications: {
      "WiFi": "802.11 b/g/n",
      "Bluetooth": "4.2",
      "GPIO": "34"
    }
  }
];

let orders = [];
let nextProductId = 4;
let nextOrderId = 1;

// CORS middleware
app.use((req, res, next) => {
  res.header('Access-Control-Allow-Origin', '*');
  res.header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE');
  res.header('Access-Control-Allow-Headers', 'Content-Type');
  next();
});

// Home
app.get('/', (req, res) => {
  res.json({ 
    message: 'CTech API Server',
    version: '1.0.0',
    endpoints: {
      products: '/v1/products',
      search: '/v1/search?q=query',
      categories: '/v1/categories',
      orders: '/v1/orders'
    }
  });
});

// ============ PRODUCTS ENDPOINTS ============

// Get all products
app.get('/v1/products', (req, res) => {
  const { category } = req.query;
  
  let filteredProducts = products;
  if (category) {
    filteredProducts = products.filter(p => 
      p.category.toLowerCase() === category.toLowerCase()
    );
  }
  
  res.json({
    products: filteredProducts,
    total: filteredProducts.length,
    page: 1
  });
});

// Get product by ID
app.get('/v1/products/:id', (req, res) => {
  const product = products.find(p => p.id === parseInt(req.params.id));
  
  if (!product) {
    return res.status(404).json({ error: 'Product not found' });
  }
  
  res.json(product);
});

// Create product (Admin)
app.post('/v1/products', (req, res) => {
  const newProduct = {
    id: nextProductId++,
    name: req.body.name,
    description: req.body.description || '',
    price: parseFloat(req.body.price) || 0,
    imageName: req.body.imageName || 'placeholder',
    category: req.body.category || 'General',
    specifications: req.body.specifications || {}
  };
  
  products.push(newProduct);
  res.status(201).json(newProduct);
});

// Update product (Admin)
app.put('/v1/products/:id', (req, res) => {
  const index = products.findIndex(p => p.id === parseInt(req.params.id));
  
  if (index === -1) {
    return res.status(404).json({ error: 'Product not found' });
  }
  
  products[index] = {
    ...products[index],
    ...req.body,
    id: products[index].id // Keep original ID
  };
  
  res.json(products[index]);
});

// Delete product (Admin)
app.delete('/v1/products/:id', (req, res) => {
  const index = products.findIndex(p => p.id === parseInt(req.params.id));
  
  if (index === -1) {
    return res.status(404).json({ error: 'Product not found' });
  }
  
  products.splice(index, 1);
  res.status(204).send();
});

// ============ SEARCH ENDPOINT ============

app.get('/v1/search', (req, res) => {
  const query = req.query.q?.toLowerCase() || '';
  
  if (!query) {
    return res.json({ products: [], total: 0 });
  }
  
  const results = products.filter(p => 
    p.name.toLowerCase().includes(query) ||
    p.description.toLowerCase().includes(query) ||
    p.category.toLowerCase().includes(query)
  );
  
  res.json({
    products: results,
    total: results.length
  });
});

// ============ CATEGORIES ENDPOINT ============

app.get('/v1/categories', (req, res) => {
  const categories = [...new Set(products.map(p => p.category))];
  
  res.json({
    categories: categories.map(name => ({ name }))
  });
});

// ============ ORDERS ENDPOINTS ============

// Create order
app.post('/v1/orders', (req, res) => {
  const order = {
    id: `ORD${nextOrderId++}`,
    userId: req.body.userId,
    items: req.body.items,
    totalAmount: req.body.totalAmount,
    status: 'pending',
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString()
  };
  
  orders.push(order);
  
  console.log(`✅ New order created: ${order.id} - Total: ৳${order.totalAmount}`);
  
  res.status(201).json(order);
});

// Get all orders
app.get('/v1/orders', (req, res) => {
  res.json(orders);
});

// Get order by ID
app.get('/v1/orders/:id', (req, res) => {
  const order = orders.find(o => o.id === req.params.id);
  
  if (!order) {
    return res.status(404).json({ error: 'Order not found' });
  }
  
  res.json(order);
});

// Get user orders
app.get('/v1/users/:userId/orders', (req, res) => {
  const userOrders = orders.filter(o => o.userId === req.params.userId);
  res.json(userOrders);
});

// ============ START SERVER ============

app.listen(PORT, () => {
  console.log(`
╔═══════════════════════════════════════╗
║   🚀 CTech API Server Running         ║
║                                       ║
║   Port: ${PORT}                          ║
║   URL: http://localhost:${PORT}          ║
║                                       ║
║   📚 Endpoints:                       ║
║   • GET  /v1/products                 ║
║   • GET  /v1/products/:id             ║
║   • POST /v1/products                 ║
║   • GET  /v1/search?q=query           ║
║   • POST /v1/orders                   ║
║   • GET  /v1/categories               ║
║                                       ║
║   📱 Products loaded: ${products.length}              ║
╚═══════════════════════════════════════╝
  `);
});

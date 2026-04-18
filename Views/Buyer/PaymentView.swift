import SwiftUI
import FirebaseFirestore

struct PaymentView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @EnvironmentObject var cartVM: CartViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var paymentMethod = "Credit Card"
    @State private var cardholder = ""
    @State private var cardNumber = ""
    @State private var expiry = ""
    @State private var cvv = ""
    @State private var billingAddress = ""
    @State private var isProcessing = false
    @State private var paymentMessage: String?
    @State private var paymentSuccess = false

    private let methods = ["Credit Card", "Bkash", "Nagad", "Cash on Delivery"]

    var body: some View {
        Form {
            Section(header: Text("Payment Method")) {
                Picker("Method", selection: $paymentMethod) {
                    ForEach(methods, id: \.self) { Text($0) }
                }
                .pickerStyle(.segmented)
            }

            if paymentMethod == "Credit Card" {
                Section(header: Text("Card Details")) {
                    TextField("Cardholder name", text: $cardholder)
                        .textContentType(.name)
                    TextField("Card number", text: $cardNumber)
        var body: some View {
            ZStack {
                Color.white.ignoresSafeArea()
                Color.green.opacity(0.06).ignoresSafeArea()
                Form {
                    TextField("Expiry MM/YY", text: $expiry)
                        .keyboardType(.numbersAndPunctuation)
                    TextField("CVV", text: $cvv)
                        .keyboardType(.numberPad)
                }
            }

            Section(header: Text("Billing & Delivery")) {
                TextField("Billing address", text: $billingAddress)
                    .textContentType(.fullStreetAddress)
                Text("Total payable: ৳\(cartVM.totalPrice, specifier: "%.2f")")
                    .font(.headline)
            }

            Section(header: Text("Order Summary")) {
                Text("Items: \(cartVM.cartItems.count)")
                Text("Payment method: \(paymentMethod)")
                Text("Status: Pending confirmation")
                    .foregroundColor(.secondary)
            }

            Section {
                if let message = paymentMessage {
                    Text(message)
                        .foregroundColor(paymentSuccess ? .green : .red)
                        .font(.caption)
                }

                Button(action: payNow) {
                    if isProcessing {
                        HStack {
                            ProgressView()
                            Text("Processing...")
                        }
                        .frame(maxWidth: .infinity)
                    } else {
                        Text("Pay Now")
                            .frame(maxWidth: .infinity)
                    }
                }
                .disabled(!isFormComplete() || isProcessing)
            }
        }
        .navigationTitle("Checkout")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Payment Status", isPresented: $showAlert) {
            Button("OK") { if paymentSuccess { dismiss() } }
        } message: {
            Text(paymentMessage ?? "Unable to complete payment.")
        }
        .onAppear { paymentMessage = nil }
    }

    @State private var showAlert = false

    private func isFormComplete() -> Bool {
        if cartVM.cartItems.isEmpty || billingAddress.isEmpty { return false }
        if paymentMethod == "Credit Card" {
            return !cardholder.isEmpty && !cardNumber.isEmpty && !expiry.isEmpty && !cvv.isEmpty
        }
        return true
    }

    private func paymentValidationError() -> String? {
        if cartVM.cartItems.isEmpty { return "Your cart is empty." }
        if billingAddress.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return "Billing address is required."
        }
        if paymentMethod == "Credit Card" {
            if cardholder.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                return "Cardholder name is required."
            }
            if cardNumber.count < 12 {
                return "Enter a valid card number."
            }
            if expiry.count < 4 {
                return "Enter expiry month and year."
            }
            if cvv.count < 3 {
                return "Enter a valid CVV."
            }
        }
        return nil
    }

    private func payNow() {
        if let validationError = paymentValidationError() {
            paymentMessage = validationError
            paymentSuccess = false
            showAlert = true
            return
        }

        guard let currentUser = authVM.currentUser else { return }

        isProcessing = true
        paymentMessage = nil

        let itemsData = cartVM.cartItems.map { item in
            [
                "productId": item.product.id,
                "productName": item.product.name,
                "price": item.product.price,
                "quantity": item.quantity
            ] as [String: Any]
        }

        let orderData: [String: Any] = [
            "userId": currentUser.id,
            "userName": currentUser.displayName ?? currentUser.email,
            "items": itemsData,
            "totalPrice": cartVM.totalPrice,
            "status": "Pending",
            "address": billingAddress,
            "paymentMethod": paymentMethod,
            "timestamp": Timestamp(date: Date())
        ]

        let db = Firestore.firestore()
        let orderRef = db.collection("orders").document()
        orderRef.setData(orderData) { error in
            if let error = error {
                paymentMessage = error.localizedDescription
                paymentSuccess = false
                showAlert = true
                isProcessing = false
                return
            }

            let batch = db.batch()
            for item in cartVM.cartItems {
                if let firestoreId = item.product.firestoreId {
                    let productRef = db.collection("products").document(firestoreId)
                    batch.updateData(["stock": FieldValue.increment(Int64(-item.quantity))], forDocument: productRef)
                }
            }

            batch.commit { batchError in
                isProcessing = false
                if let batchError = batchError {
                    paymentMessage = "Order created, but stock update failed: \(batchError.localizedDescription)"
                    paymentSuccess = false
                } else {
                    paymentMessage = "Order placed successfully. Thank you!"
                    paymentSuccess = true
                    cartVM.clearCart()
                }
                showAlert = true
            }
        }
    }
}

//
//  CartView.swift
//  CTechApp
//
//  Created by macos on 3/3/26.
//

import Foundation
import SwiftUI

struct CartView: View {
    
    @EnvironmentObject var cartVM: CartViewModel
    
    var body: some View {
        VStack {
            
            List {
                ForEach(cartVM.cartItems) { item in
                    HStack {
                        Text(item.product.name)
                        
                        Spacer()
                        
                        Button("-") {
                            cartVM.decreaseQuantity(for: item)
                        }
                        
                        Text("\(item.quantity)")
                        
                        Button("+") {
                            cartVM.increaseQuantity(for: item)
                        }
                    }
                }
            }
            
            Text("Total: ৳\(cartVM.totalPrice, specifier: "%.2f")")
                .font(.title2)
                .padding()
            
            Button("Clear Cart") {
                cartVM.clearCart()
            }
            .foregroundColor(.red)
            .padding()
        }
        .navigationTitle("Cart")
    }
}

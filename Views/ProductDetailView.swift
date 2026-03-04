//
//  ProductDetailView.swift
//  CTechApp
//
//  Created by macos on 3/3/26.
//

import SwiftUI

struct ProductDetailView: View {
    
    let product: Product
    @EnvironmentObject var cartVM: CartViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                Image(product.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                
                Text(product.name)
                    .font(.title)
                    .bold()
                
                Text(product.description)
                    .padding()
                
                Text("Price: ৳\(product.price, specifier: "%.2f")")
                    .font(.headline)
                
                VStack(alignment: .leading) {
                    Text("Specifications")
                        .font(.headline)
                    
                    ForEach(product.specifications.keys.sorted(), id: \.self) { key in
                        Text("\(key): \(product.specifications[key] ?? "")")
                    }
                }
                
                Button("Add to Cart") {
                    cartVM.addToCart(product: product)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .padding()
        }
    }
}

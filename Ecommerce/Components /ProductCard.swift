////
////  ProductCard.swift
////  Ecommerce
////
////  Created by Mubashir PM on 12/02/26.
////
//
//import SwiftUI
//
//struct Product: Identifiable {
//    let id = UUID()
//    let imageName: String
//    let name: String
//    let price: String
//}
//
//struct ProductCard: View {
//    let product: Product
//    @State private var isFavorite = false
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 0) {
//            // Image with heart icon
//            ZStack(alignment: .topTrailing) {
//                Image(product.imageName)
//                    .resizable()
//                    .scaledToFit()
//                    .background(Color(red: 0.93, green: 0.93, blue: 0.93))
//                    .cornerRadius(15)
//                
//                // Heart button
//                Button(action: {
//                    isFavorite.toggle()
//                }) {
//                    Image(systemName: isFavorite ? "heart.fill" : "heart")
//                        .foregroundColor(isFavorite ? .red : .gray)
//                        .font(.system(size: 22))
//                        .padding(12)
//                }
//            }
//            
//            // Product name and price
//            VStack(alignment: .leading, spacing: 4) {
//                Text(product.name)
//                    .font(.system(size: 14))
//                    .fontWeight(.medium)
//                    .lineLimit(2)
//                    .padding(.top, 8)
//                
//                Text(product.price)
//                    .font(.system(size: 14))
//                    .foregroundColor(.red)
//                    .fontWeight(.semibold)
//            }
//            .padding(.horizontal, 4)
//        }
//    }
//}
//
//struct ProductListView: View {
//    let products = [
//        Product(imageName: "HomeImage1", name: "Nike Air Logo Oversized Shirt", price: "Rs. 1499"),
//        Product(imageName: "SignUpImage", name: "Minimal Classic Tee", price: "Rs. 1499"),
//        Product(imageName: "HomeImage3", name: "NY Baseball Street Tee", price: "Rs. 1499"),
//        Product(imageName: "HomeImage4", name: "Essential Black Tee", price: "Rs. 1499"),
//        Product(imageName: "signin", name: "Nike Air Logo Oversized Tee", price: "Rs. 1499"),
//        Product(imageName: "HomeImage2", name: "Nike Air Logo Oversized Shirt", price: "Rs. 1499")
//    ]
//    
//    let columns = [
//        GridItem(.flexible(), spacing: 15),
//        GridItem(.flexible(), spacing: 15)
//    ]
//    
//    var body: some View {
//        ScrollView {
//            LazyVGrid(columns: columns, spacing: 15) {
//                ForEach(Array(products.enumerated()), id: \.element.id) { index, product in
//                    ProductCard(product: product)
//                        .offset(y: index % 2 == 0 ? 0 : 30)
//                }
//            }
//            .padding(.horizontal, 15)
//            .padding(.top, 20)
//            .padding(.bottom, 50)
//        }
//        .background(Color.white)
//    }
//}
//
//#Preview {
//    ProductListView()
//}

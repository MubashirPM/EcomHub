//
//  NewArrivalsview .swift
//  Ecommerce
//
//  Created by Mubashir PM on 12/02/26.
//

import SwiftUI

struct NewArrivalsview_: View {
    @State private var searchText = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {

                VStack(spacing: 0) {
                    HStack {
                        FastionStore_()
                        Spacer()
                        NavigationLink {
                            ProfileView()
                        } label: {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.yellow)
                                .frame(width: 50, height: 50)
                        }

                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 50)

                    // Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)

                        TextField("Search Product", text: $searchText)

                        if !searchText.isEmpty {
                            Button {
                                searchText = ""
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(25)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                }
                .background(Color.custom)
                .clipShape(RoundedRectangle(cornerRadius: 30))

                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ]) {
                    ForEach(products) { product in
                        ProductCard(product: product)
                    }
                }
                .padding()
                .background(Color.white)
            }
//            .navigationBarBackButtonHidden(true)
//            .toolbar(.hidden, for: .navigationBar)
        }
        .ignoresSafeArea(edges: .top)
    }

    let products = [
        Product(imageName: "HomeImage1", name: "Nike Air Logo Oversized Shirt", price: "Rs. 1499"),
        Product(imageName: "SignUpImage", name: "Minimal Classic Tee", price: "Rs. 1499"),
        Product(imageName: "HomeImage3", name: "NY Baseball Street Tee", price: "Rs. 1499"),
        Product(imageName: "HomeImage4", name: "Essential Black Tee", price: "Rs. 1499"),
        Product(imageName: "signin", name: "Nike Air Logo Oversized Tee", price: "Rs. 1499"),
        Product(imageName: "HomeImage2", name: "Nike Air Logo Oversized Shirt", price: "Rs. 1499")
    ]
}

#Preview {
    NewArrivalsview_()
}

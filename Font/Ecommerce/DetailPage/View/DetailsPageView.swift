//
//  DetailsPageView.swift
//  Ecommerce
//
//  Created by Mubashir PM on 25/02/26.
//


import SwiftUI

struct DetailsPageView: View {
    
    @StateObject private var viewModel: ProductDetailViewModel
    @Environment(\.dismiss) var dismiss
    
    init(product: ProductDetail) {
        _viewModel = StateObject(
            wrappedValue: ProductDetailViewModel(product: product)
        )
    }

    /// Accepts a home screen Item so navigation from HomeScreenView works.
    init(product item: Item) {
        _viewModel = StateObject(
            wrappedValue: ProductDetailViewModel(product: ProductDetail(item: item))
        )
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            // Back Button
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundStyle(.black)
                        .padding()
                }
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    
                    // Product Image
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(.systemGray6))
                            .frame(height: 300)
                        
                        Image(viewModel.product.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 280)
                    }
                    
                    Text(viewModel.product.title)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("$\(viewModel.product.price)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                    
                    // Quantity
                    HStack {
                        Button {
                            viewModel.decreaseQuantity()
                        } label: {
                            Image(systemName: "minus")
                                .foregroundStyle(.black)
                        }
                        
                        Text("\(viewModel.quantity)")
                            .frame(width: 30)
                        
                        Button {
                            viewModel.increaseQuantity()
                        } label: {
                            Image(systemName: "plus")
                                .foregroundColor(.red)
                        }
                        
                        Spacer()
                    }
                    
                    // Size Selection
                    Text("Select Size")
                        .font(.subheadline)
                    
                    HStack {
                        ForEach(viewModel.sizes, id: \.self) { size in
                            Button {
                                viewModel.selectSize(size)
                            } label: {
                                Text(size)
                                    .frame(width: 30, height: 30)
                                    .foregroundStyle(.black)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 5)
                                            .stroke(
                                                viewModel.selectedSize == size
                                                ? Color.black
                                                : Color.gray.opacity(0.5),
                                                lineWidth: 2
                                            )
                                    )
                            }
                        }
                    }
                    
                    // Toggle Product Detail
                    Button {
                        withAnimation {
                            viewModel.toggleDetailSection()
                        }
                    } label: {
                        HStack {
                            Text("Product Detail")
                                .foregroundStyle(.black)
                            Spacer()
                            Image(systemName:
                                    viewModel.showProductDetail
                                  ? "chevron.down"
                                  : "chevron.up")
                            .foregroundStyle(.black)
                        }
                    }
                    
                    if viewModel.showProductDetail {
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(viewModel.product.descriptionLines,
                                    id: \.self) { line in
                                Text(line)
                                    .foregroundStyle(.gray)
                            }
                        }
                    }
                    
                    // Review
                    HStack {
                        Text("Review")
                            .font(.headline)
                        Spacer()
                        ForEach(0..<5) { _ in
                            Image(systemName: "star.fill")
                                .foregroundStyle(.red)
                        }
                    }
                    .padding(.bottom, 100)
                }
                .padding()
            }
        }
        .navigationBarBackButtonHidden(true)
        .safeAreaInset(edge: .bottom) {
            NavigationLink {
                CardView_()
            } label: {
                Text("Add To Basket")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(red: 0.7, green: 0.2, blue: 0.2))
                    .cornerRadius(15)
                    .padding()
            }
            .background(Color.white)
            .shadow(radius: 5)
        }
    }
}

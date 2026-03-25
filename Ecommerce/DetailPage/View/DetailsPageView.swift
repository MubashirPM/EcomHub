//
//  DetailsPageView.swift
//  Ecommerce
//
//  Created by Mubashir PM on 25/02/26.
//
import SwiftUI

struct DetailsPageView: View {
    
    @StateObject private var viewModel: ProductDetailViewModel
    @StateObject private var cartViewModel = CartViewModel()
    @Environment(\.dismiss) var dismiss
    @AppStorage("userId") private var userId: String = ""
    @State private var showToast = false
    @State private var toastMessage = ""

    let productId: String
    let wishlistVM: WishlistViewModel

    init(productId: String, wishlistVM: WishlistViewModel) {
        self.productId = productId
        self.wishlistVM = wishlistVM
        _viewModel = StateObject(wrappedValue: ProductDetailViewModel())
    }

    init(product homeProduct: HomeProduct, wishlistVM: WishlistViewModel) {
        self.productId = homeProduct.id
        self.wishlistVM = wishlistVM
        _viewModel = StateObject(wrappedValue: ProductDetailViewModel())
    }

    var body: some View {
        VStack(spacing: 0) {
            
            // Back Button
            
            
            ScrollView {
                if let product = viewModel.product {
                    
                    VStack(alignment: .leading, spacing: 10) {
                        
                        // Product Image
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color(.systemGray6))
                                .frame(height: 300)

                            TabView {
                                ForEach(product.imageURL, id: \.self) { url in
                                    AsyncImage(url: URL(string: url)) { phase in
                                        switch phase {
                                            
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .scaledToFit()
                                            
                                        case .failure(_):
                                            Image(systemName: "photo")
                                            
                                        default:
                                            ProgressView()
                                        }
                                    }
                                }
                            }
                            .tabViewStyle(PageTabViewStyle())
                            .frame(height: 280)
                            
                            VStack {
                                HStack {

                                    Button {
                                        dismiss()
                                    } label: {
                                        Image(systemName: "chevron.left")
                                            .font(.title2)
                                            .foregroundColor(.black)
                                            .padding(10)
                                            .background(
                                                Color.white.opacity(0.8)
                                            )
                                            .clipShape(Circle())
                                    }

                                    Spacer()

                                    Button {
                                        guard !userId.isEmpty else { return }
                                        Task {
                                            await wishlistVM.addToWishlist(
                                                userId: userId,
                                                productId: productId
                                            )
                                        }
                                    } label: {
                                        Image(systemName: wishlistVM.isFavorite(productId: productId) ? "heart.fill" : "heart")
                                            .font(.title2)
                                            .foregroundColor(.black)
                                            .padding(10)
                                            .background(
                                                Color.white.opacity(0.8)
                                            )
                                            .clipShape(Circle())
                                    }
                                    .buttonStyle(.plain)
                                }
                                .padding(.horizontal, 20)
                                .padding(.top, 10)

                                Spacer()
                            }
                        }
                        Text(product.title)
                            .font(.title2)
                            .fontWeight(.bold)

                        Text("Rs.\(product.price)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(Color.custom)

                        // Quantity
                        HStack {

                            Button {
                                viewModel.decreaseQuantity()
                            } label: {
                                Image(systemName: "minus")
                                    .font(.title2)
                                    .foregroundStyle(.black)
                            }

                            Text("\(viewModel.quantity)")
                                .font(.title2)
                                .frame(width: 40)
                                .bold()

                            Button {
                                viewModel.increaseQuantity()
                            } label: {
                                Image(systemName: "plus")
                                    .font(.title2)
                                    .foregroundColor(Color.custom)
                                    .bold()
                            }

                            Spacer()

                            Button {
                                
                                
                                if let product = viewModel.product {

                                    let userId = UserDefaults.standard.string(
                                        forKey: "userId"
                                    ) ?? ""
                                    
                                    print("ProductId:", product.id)
                                    print("UserId:", userId)

                                    Task {
                                        await cartViewModel.addToCart(
                                                       userId: userId,
                                                       productId: product.id,
                                                       quantity: viewModel.quantity
                                                   )
                                    }
                                }
                                
                                toastMessage = "Item added to cart"

                                withAnimation {
                                    showToast = true
                                }

                                DispatchQueue.main
                                    .asyncAfter(deadline: .now() + 2) {
                                        withAnimation {
                                            showToast = false
                                        }
                                    }

                            } label: {

                                HStack(spacing: 6) {
                                    Image(systemName: "cart")
                                    Text("Add to Cart")
                                }
                                .foregroundColor(.white)
                                .padding(.horizontal,16)
                                .padding(.vertical,10)
                                .background(Color.custom)
                                .cornerRadius(8)
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
                                    .bold()

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
                                ForEach(
                                    product.descriptionLines,
                                    id: \.self
                                ) { line in
                                    Text(line)
                                        .foregroundStyle(.gray)
                                }
                            }
                        }

                        HStack {
                            Text("Review")
                                .font(.headline)

                            Spacer()

                            ForEach(0..<5) { index in
                                Image(
                                    systemName: index < viewModel.selectedRating ? "star.fill" : "star"
                                )
                                .foregroundStyle(.red)
                                .onTapGesture {
                                    let rating = index + 1
                                    viewModel.selectedRating = rating
                                }
                            }
                        }

                        HStack (spacing: 10) {

                            TextField(
                                "Write your review...",
                                text: $viewModel.reviewComment
                            )
                            .textFieldStyle(RoundedBorderTextFieldStyle())

                            Button {

                                let email = UserDefaults.standard.string(
                                    forKey: "userEmail"
                                ) ?? ""

                                Task {
                                    await viewModel.addReview(
                                        email: email,
                                        productId: productId,
                                        rating: viewModel.selectedRating,
                                        comment: viewModel.reviewComment
                                    )
                                    await viewModel.fetchProduct(id: productId)
                                        
                                    // Reset UI
                                    viewModel.selectedRating = 0
                                    viewModel.reviewComment = ""
                                }

                            } label: {
                                Text("Submit")
                                    .foregroundColor(.white)
                                    .padding(.horizontal,16)
                                    .padding(.vertical,10)
                                    .background(Color.custom)
                                    .cornerRadius(8)
                                
                             
                            }

                        }
                        .padding(.top, 10)
                        
                        if let product = viewModel.product,
                           let reviews = product.reviews,
                           !reviews.isEmpty {

                            Text("Customer Reviews")
                                .font(.headline)
                                .padding(.top, 20)
                                .padding(.leading,5)

                            ScrollView(.horizontal, showsIndicators: false) {

                                HStack(spacing: 12) {

                                    ForEach(reviews) { review in

                                        VStack(
                                            alignment: .leading,
                                            spacing: 6
                                        ) {

                                            Text(review.userName)
                                                .font(.subheadline)
                                                .fontWeight(.bold)

                                            HStack {
                                                ForEach(0..<5) { index in
                                                    Image(
                                                        systemName: index < review.rating ? "star.fill" : "star"
                                                    )
                                                    .foregroundColor(.red)
                                                }
                                            }

                                            Text(review.comment)
                                                .foregroundColor(.gray)
                                                .font(.subheadline)
                                        }
                                        .padding()
                                        .frame(width: 200) // card width
                                        .background(Color(.systemGray6))
                                        .cornerRadius(10)
                                    }

                                }
                                .padding(.leading,5)
                            }
                        }
                    }
                    .padding()
                    
                } else {
                    ProgressView()
                        .padding(.top, 200)
                }
            }
            .task {
                await viewModel.fetchProduct(id: productId)
            }
        }
        .navigationBarBackButtonHidden(true)
        .safeAreaInset(edge: .bottom) {
            Button {
               
            } label: {
                Text("Buy Now")
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
        .overlay(alignment : .top) {
            if showToast {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.white)
                    Text(toastMessage)
                        .foregroundStyle(.white)
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                .padding()
                .background(Color.custom)
                .cornerRadius(12)
                .padding(.horizontal,20)
                .padding(.top,50)
                .shadow(radius: 5)
                .transition(.move(edge: .top).combined(with:.opacity))
            }
        }
    }
}
  

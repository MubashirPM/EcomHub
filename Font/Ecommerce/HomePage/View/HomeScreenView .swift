
//
//  HomeScreenView .swift
//  Ecommerce
//
//  Created by Mubashir PM on 12/02/26.
//

import SwiftUI

struct HomeScreenView_: View {
    
    @StateObject private var viewModel = HomeViewModel()
    @Binding var selectedTab: Int
    
    var body: some View {
        
        ZStack(alignment: .bottom) {
            
            Color(.custom)
                .ignoresSafeArea()
            
            VStack(spacing: 5) {
                
                // MARK: Header + Search
                VStack(spacing: 0) {

                    HStack {
                        FastionStore_()
                            .font(.title3)

                        Spacer()

                        Button {
                            selectedTab = 1
                        } label: {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.yellow)
                                .frame(width: 50, height: 50)
                        }
                    }
                    .padding(.horizontal, 20)

                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)

                        TextField("Search Item",
                                  text: $viewModel.searchText)
                            .foregroundColor(.black)

                        if !viewModel.searchText.isEmpty {
                            Button {
                                viewModel.searchText = ""
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

                .padding(.top, -10)
                
                // Content
                ScrollView {
                    
                    VStack(spacing: 20) {
                        
                        VStack(alignment: .leading) {
                            Text("Welcome to,")
                                .font(.custom("Pacifico-Regular", size: 28))
                            
                            HStack(spacing: 8) {
                                Text("Our")
                                Text("Fashion")
                                    .foregroundColor(Color.custom
                                    )
                                Text("Store")
                                    .foregroundColor(.gray)
                            }
                            .font(.custom("Pacifico-Regular", size: 28))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                        //                         New Arrivals Banner
                        ZStack(alignment: .leading) {
                            
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.black)
                                .frame(height: 130)   // reduced from 180
                            
                            VStack(alignment: .leading, spacing: 6) {
                                
                                Text("NEW ARRIVALS 👕")
                                    .font(.headline)   // smaller than title2
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                
                                Text("Latest styles in Shirts & T-Shirts")
                                    .font(.caption)    // smaller
                                    .foregroundColor(.white.opacity(0.8))
                                
                                NavigationLink(
                                    destination: NewArrivalsview_()
                                ) {
                                    Text("Shop Now")
                                        .font(
                                            .caption2
                                        )   // smaller button text
                                        .fontWeight(.semibold)
                                        .foregroundColor(.black)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(Color.white)
                                        .cornerRadius(15)
                                }
                                .padding(.top, 4)
                            }
                            .padding(.leading, 20)
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 15)

                        
                        if viewModel.filteredItems.isEmpty {
                            
                            Text("No Items Found")
                                .font(.headline)
                                .padding(.top, 50)
                            
                        } else {
                            
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 20) {
                                
                                ForEach(viewModel.filteredItems) { item in
                                    NavigationLink(
                                        destination: DetailsPageView(product: item)
                                    ){
                                        ItemCard(item: item)
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                        
                        Spacer(minLength: 100)
                    }
                }
                .background(Color.white)
                .clipShape(
                    .rect(
                        topLeadingRadius: 30,
                        bottomLeadingRadius: 0,
                        bottomTrailingRadius: 0,
                        topTrailingRadius: 30
                    )
                )
            }
        }
        .ignoresSafeArea(edges: .bottom)
    }
}
import SwiftUI

struct ItemCard: View {
    
    let item: Item
    
    var body: some View {
        VStack(spacing: 10) {
            Image(item.imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 120)
            
            Text(item.name)
                .font(.caption)
                .bold()
                .foregroundStyle(.black)
                .multilineTextAlignment(.center)
            
            Text(item.price)
                .font(.headline)
                .foregroundColor(.red)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}

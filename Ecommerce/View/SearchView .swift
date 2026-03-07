//
//  SearchView .swift
//  Ecommerce
//
//  Created by Mubashir PM on 13/02/26.
//

//import SwiftUI
//
//struct SearchView_: View {
//    
//    @State private var searchTextState: String
//    let searchText: String
//    
//    init(searchText: String) {
//        self.searchText = searchText
//        _searchTextState = State(initialValue: searchText)
//    }
//    
//    var body: some View {
//        VStack(spacing: 0) {
//            
//            // Search Bar
//            HStack {
//                Image(systemName: "magnifyingglass")
//                    .foregroundStyle(.gray)
//                
//                TextField("Search Store", text: $searchTextState)
//                    .foregroundStyle(.black)
//                
//                if !searchTextState.isEmpty {
//                    Button {
//                        searchTextState = ""
//                    } label: {
//                        Image(systemName: "xmark.circle.fill")
//                            .foregroundColor(.gray)
//                    }
//                }
//            }
//            .padding()
//            .background(Color(red: 0.95, green: 0.95, blue: 0.95))
//            .cornerRadius(10)
//            .padding(.horizontal, 20)
//            .padding(.top, 20)
//            .padding(.bottom, 20)
//            
//            // Product List
//            ProductListView(searchText: searchTextState)
//        }
//        .background(Color.white)
//    }
//}

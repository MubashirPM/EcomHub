//
//  FavouriteView.swift
//  Ecommerce
//
//  Created by Mubashir PM on 14/02/26.
//

import SwiftUI

struct FavouriteView: View {
    var body: some View {
        VStack {
            Text("My Favorites")
                .font(.headline)
            Text("Your saved product for quick shopping")
            
            ScrollView {
                ProductListView()
            }
            
        }
    }
}

#Preview {
    FavouriteView()
}

//
//  OrderErrorView.swift
//  Ecommerce
//
//  Created by Mubashir PM on 16/02/26.
//

import SwiftUI

struct OrderErrorView: View {
    var body: some View {
        ZStack {
            Color(.systemGray6)
                .ignoresSafeArea()
            
            VStack(spacing: 25) {
                Spacer()
                
                Image("ErrorImage")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 220,height: 220)
                
                Text("Oops! Order Failed")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("Something Went terribly wrong")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                Button {
                    ""
                } label: {
                    Text("Please Try Again")
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.custom)
                        .cornerRadius(25)
                }
                .padding(.horizontal,40)
                
                Button {
                    
                } label: {
                    Text("Back to Home")
                        .foregroundStyle(.black)
                        .fontWeight(.medium)
                }

            }
        }
    }
}

#Preview {
    OrderErrorView()
}

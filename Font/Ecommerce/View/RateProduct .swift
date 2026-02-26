//
//  RateProduct .swift
//  Ecommerce
//
//  Created by Mubashir PM on 17/02/26.
//

import SwiftUI

struct RateProduct_: View {
    
    @State private var comment = ""
    @Environment(\.dismiss) var dismiss
    var body: some View {
        ZStack {
            Color(.systemGray6)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.title3)
                            .foregroundStyle(.black)
                    }

                    
                    Spacer()
                     
                    Text("Rate Your Experience")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Image(systemName: "xmark")
                        .opacity(0)
                    
                }
                .padding()
                
                Text("Tap the starts to rate your order")
                    .foregroundStyle(.gray)
                
                HStack(alignment: .top,spacing: 30) {
                    VStack(alignment: .leading,spacing: 8) {
                        Text("4.5")
                            .font(.system(size: 40,weight: .bold))
                        
                        HStack {
                            ForEach(0..<5){ index in
                                Image(systemName: index < 4 ? "star.fill" : "star")
                                    .foregroundStyle(.red)
                            }
                        }
                        Text("120 reviews")
                            .foregroundStyle(.gray)
                            .font(.subheadline)
                    }
                    VStack(spacing: 10) {
                        RatingBar(star: 5, percentage: 0.4)
                        RatingBar(star: 4, percentage: 0.3)
                        RatingBar(star: 3, percentage: 0.15)
                        RatingBar(star: 2, percentage: 0.1)
                        RatingBar(star: 1, percentage: 0.05)
 
                    }
                }
                TextEditor(text: $comment)
                    .frame(height: 120)
                    .padding(10)
                    .background(Color.green.opacity(0.15))
                    .cornerRadius(15)
                    .padding(.horizontal)
                
                Spacer()
                
                Button {
                    ""
                } label: {
                    Text("Submit")
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.custom)
                        .cornerRadius(25)
                }
                .padding(.horizontal)

                Spacer()
            }
        }
    }
}

#Preview {
    RateProduct_()
}
struct RatingBar: View {
    
    var star: Int
    var percentage: Double   // 0.0 - 1.0
    
    var body: some View {
        
        HStack {
            Text("\(star)")
            
            ZStack(alignment: .leading) {
                
                Capsule()
                    .fill(Color.green.opacity(0.3))
                    .frame(width: 150, height: 8)
                
                Capsule()
                    .fill(Color.red)
                    .frame(width: 150 * percentage, height: 8)
            }
            
            Text("\(Int(percentage * 100))%")
                .foregroundColor(.red)
        }
    }
}

//
//  OrderAcceptView.swift
//  Ecommerce
//
//  Created by Mubashir PM on 16/02/26.
//

import SwiftUI

struct OrderAcceptView: View {
    var body: some View {
        ZStack {
            Color(.systemGray6)
                .ignoresSafeArea()
            
            VStack(spacing: 25) {
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(Color.red.opacity(0.5),lineWidth: 4)
                        .frame(width: 170,height: 170)
                    
                    Circle()
                        .fill(Color.custom)
                        .frame(width: 150,height: 150)
                    
                    Image(systemName: "checkmark")
                        .font(.system(size: 55,weight: .bold))
                        .foregroundStyle(.white)
                    
                    Circle()
                        .fill(Color.red)
                        .frame(width: 12,height: 12)
                        .offset(x: -40, y: -95)
                    
                    Circle()
                        .fill(Color.orange)
                        .frame(width: 10, height: 10)
                        .offset(x: 50, y: -80)
                                       
                    Circle()
                        .stroke(Color.purple, lineWidth: 2)
                        .frame(width: 14, height: 14)
                        .offset(x: 80, y: 0)
                                       
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 14, height: 14)
                        .offset(x: 30, y: 95)
                                       
                    Circle()
                        .stroke(Color.red, lineWidth: 1.5)
                        .frame(width: 16, height: 16)
                        .offset(x: -60, y: 80)
                }
                
                Text("Your Order has been\nacceppted")
                    .font(.title2)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                Text("Your items has been placed and is on its way to being processed")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal,30)
                
                Spacer()
                
                Button {
                    print("Track Order tapped")
                } label: {
                    Text("Track Order")
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.custom)
                        .cornerRadius(20)
                }
                .padding(.horizontal,40)
                
                NavigationLink {
                    CustomTabBar()
                } label: {
                    Text("Back to home")
                        .foregroundStyle(.black)
                        .fontWeight(.medium)
                }

                  
                }
            }
        }
    }
#Preview {
    OrderAcceptView()
}

//
//  ExploreView.swift
//  Ecommerce
//
//  Created by Mubashir PM on 13/02/26.
//

import SwiftUI

struct ExploreView: View {
    
    @State private var SearchText = ""
    
    var body: some View {
        VStack{
            Text("Find Products")
                .font(.headline)
                .fontWeight(.bold)
                .padding(.top,20)
                .padding(.bottom,15)
                
            
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.gray)
                
                TextField("Search Store", text: $SearchText)
                    .foregroundStyle(.black)
                if !SearchText.isEmpty {
                    Button(action: {
                        SearchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
                            
            }
            .padding()
            .background(Color(red: 0.95, green: 0.95, blue: 0.95))
            .cornerRadius(10)
            .padding(.horizontal, 20) 
            .padding(.bottom, 20)
            
            ScrollView {
                VStack(spacing: 15) {
                    HStack(spacing: 15) {
                        VStack(spacing: 12) {
                            Image(systemName: "tshirt")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 80)
                                .foregroundStyle(.black)
                            Text("Casual")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundStyle(.black)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical,30)
                        .background(Color(red: 0.9, green: 0.98, blue: 0.9))
                        .cornerRadius(20)
                                                
                        
                        VStack(spacing: 12) {
                            Image(systemName: "button.programmable.square")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 80)
                                .foregroundColor(.black)
                            Text("Shirt")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundStyle(.black)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 30)
                        .background(Color(red: 1.0, green: 0.95, blue: 0.9))
                        .cornerRadius(20)
                    }
                    HStack(spacing: 15) {
                        // Tee's
                        VStack(spacing: 12) {
                            Image(systemName: "tshirt.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 80)
                                .foregroundColor(.black)
                                               
                            Text("Tee's")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.black)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 30)
                        .background(Color(red: 1.0, green: 0.95, blue: 0.95))
                        .cornerRadius(20)
                                           
                        // Wedding Wear
                        VStack(spacing: 12) {
                            Image(systemName: "person.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 80)
                                .foregroundColor(.black)
                                               
                            Text("Wedding Wear")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.black)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 30)
                        .background(Color(red: 0.95, green: 0.93, blue: 1.0))
                        .cornerRadius(20)
                    }
                                       
                    // Row 3
                    HStack(spacing: 15) {
                        // Formals
                        VStack(spacing: 12) {
                            Image(systemName: "briefcase")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 80)
                                .foregroundColor(.black)
                                               
                            Text("Formals")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.black)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 30)
                        .background(Color(red: 1.0, green: 0.98, blue: 0.9))
                        .cornerRadius(20)
                                           
                        // Pant's
                        VStack(spacing: 12) {
                            Image(systemName: "rectangle.portrait")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 80)
                                .foregroundColor(.black)
                                               
                            Text("Pant's")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.black)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 30)
                        .background(Color(red: 0.93, green: 0.95, blue: 1.0))
                        .cornerRadius(20)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 100)
            }
        }
        .background(Color.white)
        
    }
}

                  
#Preview {
    ExploreView()
}


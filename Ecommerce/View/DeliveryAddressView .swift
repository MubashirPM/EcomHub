//
//  DeliveryAddressView .swift
//  Ecommerce
//
//  Created by Mubashir PM on 18/02/26.
//
import SwiftUI

struct DeliveryAddressView: View {
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemGray6)
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    
                    // Address Cards
                    AddressCard(
                        tag: "Default",
                        title: "Home",
                        address: "123 Maple Street, Apt 4B,\nAnytown, CA 91234",
                        isDefault: true
                    )
                    
                    AddressCard(
                        tag: nil,
                        title: "Work",
                        address: "456 Oak Avenue, Suite 200,\nAnytown, CA 91234",
                        isDefault: false
                    )
                    
                    Spacer()
                }
                
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 16)
//                .padding(.top, 16)
                
                // Floating Add Button
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {}) {
                            Image(systemName: "plus")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 56, height: 56)
                                .background(Color.red)
                                .cornerRadius(14)
                                .shadow(radius: 4)
                        }
                        .padding(.trailing, 24)
                        .padding(.bottom, 24)
                    }
                }
            }
            .navigationTitle("Delivery address")
            .navigationBarTitleDisplayMode(.inline)
//            .toolbar {
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Image(systemName: "chevron.left")
//                        .foregroundColor(.black)
//                }
//            }
        }
    }
}

struct AddressCard: View {
    
    var tag: String?
    var title: String
    var address: String
    var isDefault: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            if let tag = tag {
                Text(tag)
                    .font(.subheadline)
                    .foregroundColor(.red)
            }
            
            Text(title)
                .font(.headline)
                .fontWeight(.bold)
            
            Text(address)
                .font(.subheadline)
                .foregroundColor(.red)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemGray5))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    DeliveryAddressView()
}

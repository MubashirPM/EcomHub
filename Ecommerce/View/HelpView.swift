//
//  HelpView.swift
//  Ecommerce
//
//  Created by Mubashir PM on 18/02/26.
//

import SwiftUI

struct HelpView: View {
    @Environment(\.dismiss) var dismiss
    @State private var expandedItem: Int? = 0
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // FAQ Section
                    VStack(spacing: 12) {
                        FAQItem(
                            question: "How do I use a promo code?",
                            answer: "To use a promo code, enter the code in the 'Promo Code' field during checkout. The discount will be applied to your order total.",
                            isExpanded: expandedItem == 0,
                            onTap: { expandedItem = expandedItem == 0 ? nil : 0 }
                        )
                        
                        FAQItem(
                            question: "Why isn't my promo code working?",
                            answer: "",
                            isExpanded: expandedItem == 1,
                            onTap: { expandedItem = expandedItem == 1 ? nil : 1 }
                        )
                        
                        FAQItem(
                            question: "Can I use multiple promo codes?",
                            answer: "",
                            isExpanded: expandedItem == 2,
                            onTap: { expandedItem = expandedItem == 2 ? nil : 2 }
                        )
                        
                        FAQItem(
                            question: "How do I get a promo code?",
                            answer: "",
                            isExpanded: expandedItem == 3,
                            onTap: { expandedItem = expandedItem == 3 ? nil : 3 }
                        )
                        
                        FAQItem(
                            question: "What are the terms and conditions for promo codes?",
                            answer: "",
                            isExpanded: expandedItem == 4,
                            onTap: { expandedItem = expandedItem == 4 ? nil : 4 }
                        )
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 20)
                    
                    // Contact Us Section
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Contact us")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.black)
                            .padding(.horizontal, 16)
                            .padding(.top, 24)
                        
                        VStack(spacing: 16) {
                            ContactItem(
                                icon: "message",
                                title: "Contact support",
                                subtitle: "Chat, call, or email",
                                iconBackground: Color(red: 0.85, green: 0.95, blue: 0.93)
                            )
                            
                            ContactItem(
                                icon: "shippingbox",
                                title: "Report an issue",
                                subtitle: "Report order or delivery issues",
                                iconBackground: Color(red: 0.85, green: 0.95, blue: 0.93)
                            )
                            
                            ContactItem(
                                icon: "person.2",
                                title: "Community forums",
                                subtitle: "Get help from the community",
                                iconBackground: Color(red: 0.85, green: 0.95, blue: 0.93)
                            )
                        }
                        .padding(.horizontal, 16)
                    }
                    
                    Spacer(minLength: 40)
                }
            }
            .background(Color(red: 0.97, green: 0.97, blue: 0.97))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Button(action: {
//                        dismiss()
//                    }) {
//                        Image(systemName: "arrow.left")
//                            .foregroundColor(.black)
//                            .font(.system(size: 20))
//                    }
//                }
                
                ToolbarItem(placement: .principal) {
                    Text("Help")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.black)
                }
            }
        }
    }
}

struct FAQItem: View {
    let question: String
    let answer: String
    let isExpanded: Bool
    let onTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: onTap) {
                HStack {
                    Text(question)
                        .font(.system(size: 16))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .foregroundColor(.black)
                        .font(.system(size: 14))
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                        .animation(.easeInOut(duration: 0.2), value: isExpanded)
                }
                .padding(16)
            }
            
            if isExpanded && !answer.isEmpty {
                Text(answer)
                    .font(.system(size: 15))
                    .foregroundColor(Color(red: 0.7, green: 0.25, blue: 0.25))
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                    .padding(.top, 4)
            }
        }
        .background(Color.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
    }
}

struct ContactItem: View {
    let icon: String
    let title: String
    let subtitle: String
    let iconBackground: Color
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(iconBackground)
                    .frame(width: 48, height: 48)
                
                Image(systemName: icon)
                    .foregroundColor(.black)
                    .font(.system(size: 22))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(.black)
                
                Text(subtitle)
                    .font(.system(size: 14))
                    .foregroundColor(Color(red: 0.7, green: 0.25, blue: 0.25))
            }
            
            Spacer()
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
    }
}

#Preview {
    HelpView()
}

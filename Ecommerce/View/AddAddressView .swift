//
//  AddAddressView .swift
//  Ecommerce
//
//  Created by Mubashir PM on 18/02/26.
//

import SwiftUI

struct AddAddressView_: View {
    @State private var streetAddress = ""
      @State private var city = ""
      @State private var state = ""
      @State private var zipCode = ""
      @State private var notes = ""
      @Environment(\.dismiss) var dismiss
      
      var body: some View {
          NavigationView {
              VStack(spacing: 0) {
                  // Header
                  ZStack {
                      Text("Add Address")
                          .font(.headline)
                          .foregroundColor(.black)
                      
                      HStack {
                          Button(action: {
                              dismiss()
                          }) {
                              Image(systemName: "xmark")
                                  .foregroundColor(.black)
                                  .font(.system(size: 20))
                          }
                          Spacer()
                      }
                      .padding(.horizontal)
                  }
                  .padding(.vertical, 16)
                  
                  // Form Content
                  ScrollView {
                      VStack(alignment: .leading, spacing: 20) {
                          // Street Address
                          VStack(alignment: .leading, spacing: 8) {
                              Text("Street Address")
                                  .font(.system(size: 15))
                                  .foregroundColor(.black)
                              
                              TextField("", text: $streetAddress)
                                  .padding()
                                  .background(Color(red: 0.85, green: 0.95, blue: 0.93))
                                  .foregroundColor(Color(red: 0.8, green: 0.3, blue: 0.3))
                                  .cornerRadius(8)
                          }
                          
                          // City
                          VStack(alignment: .leading, spacing: 8) {
                              Text("City")
                                  .font(.system(size: 15))
                                  .foregroundColor(.black)
                              
                              TextField("", text: $city)
                                  .padding()
                                  .background(Color(red: 0.85, green: 0.95, blue: 0.93))
                                  .foregroundColor(Color(red: 0.8, green: 0.3, blue: 0.3))
                                  .cornerRadius(8)
                          }
                          
                          // State
                          VStack(alignment: .leading, spacing: 8) {
                              Text("State")
                                  .font(.system(size: 15))
                                  .foregroundColor(.black)
                              
                              TextField("", text: $state)
                                  .padding()
                                  .background(Color(red: 0.85, green: 0.95, blue: 0.93))
                                  .foregroundColor(Color(red: 0.8, green: 0.3, blue: 0.3))
                                  .cornerRadius(8)
                          }
                          
                          // Zip Code
                          VStack(alignment: .leading, spacing: 8) {
                              Text("Zip Code")
                                  .font(.system(size: 15))
                                  .foregroundColor(.black)
                              
                              TextField("", text: $zipCode)
                                  .padding()
                                  .background(Color(red: 0.85, green: 0.95, blue: 0.93))
                                  .foregroundColor(Color(red: 0.8, green: 0.3, blue: 0.3))
                                  .cornerRadius(8)
                                  .keyboardType(.numberPad)
                          }
                          
                          // Notes
                          VStack(alignment: .leading, spacing: 8) {
                              Text("Notes (optional)")
                                  .font(.system(size: 15))
                                  .foregroundColor(.black)
                              
                              TextEditor(text: $notes)
                                  .frame(height: 150)
                                  .padding(8)
                                  .background(Color(red: 0.85, green: 0.95, blue: 0.93))
                                  .cornerRadius(8)
                                  .scrollContentBackground(.hidden)
                          }
                      }
                      .padding(.horizontal, 20)
                      .padding(.top, 20)
                  }
                  
                  // Save Button
                  Button(action: {
                      // Save action
                  }) {
                      Text("Save Address")
                          .font(.system(size: 17, weight: .semibold))
                          .foregroundColor(.white)
                          .frame(maxWidth: .infinity)
                          .padding(.vertical, 16)
                          .background(Color(red: 0.7, green: 0.25, blue: 0.25))
                          .cornerRadius(8)
                  }
                  .padding(.horizontal, 20)
                  .padding(.vertical, 20)
              }
              .background(Color.white)
          }
          .navigationBarHidden(true)
      }
  }

#Preview {
    AddAddressView_()
}

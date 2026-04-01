//
//  WelcomePage.swift
//  Ecommerce
//
//  Created by Mubashir PM on 10/02/26.
//

import SwiftUI

struct WelcomePage: View {
    

    private let leadingPadding: CGFloat = 60
    @State private var goToSignIn = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background image
                Image("welcomePage")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                // Full screen dark overlay
                Color.black.opacity(0.35)
                    .ignoresSafeArea()

                VStack {
                    // MARK: - Title
                    HStack {
                        FastionStore_()
                        Spacer()
                    }
                    .padding(.leading, leadingPadding)
                    .padding(.top, 80)

                    Spacer()

                    // MARK: - Bottom overlay section
                    VStack(spacing: 20) {
                        FeatureRow(icon: "leaf.fill", title: "Organic Threads")
                        FeatureRow(icon: "star.fill", title: "Premium Quality")
                        FeatureRow(icon: "truck.box.fill", title: "Fast Delivery")
                        FeatureRow(
                            icon: "arrow.uturn.backward",
                            title: "Easy Refund and return"
                        )
                        FeatureRow(icon: "lock.fill", title: "Secure and safe")

                        Text("Welcome to our Store")
                            
                            .foregroundStyle(.white)
                            .font(.title2)
                            .bold()
                        
                        VStack {
                            Text("Get your grocery in as fast as")
                                .foregroundStyle(.white)
                            Text("one hours")
                                .foregroundStyle(.white)
                            
                            Button {
                                goToSignIn = true
                            } label: {
                                Text("Get Started")
                                        .foregroundColor(.black)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.white)
                                        .cornerRadius(70)
                            }
                            .padding(.horizontal, 20)
                            .navigationDestination(isPresented: $goToSignIn) {
                                SignInView()
                                    .navigationBarBackButtonHidden(true)
                                    .toolbar(.hidden, for: .navigationBar)
                                    }
                        }
                    }
                    .padding(.top, 28)
                    .padding(.horizontal, leadingPadding)
                    .padding(.bottom,40)
                    .frame(maxWidth: .infinity)
//                    .frame(height: UIScreen.main.bounds.height * 0.45)
                    .background(Color.black.opacity(0.4))
                    .clipShape(TopRoundedShape(radius: 130))
                    .ignoresSafeArea(edges: .bottom)
                }
                .frame(maxHeight: .infinity, alignment: .bottom)
                .ignoresSafeArea(edges: .bottom)
            }
        }
    }
        }

#Preview {
    WelcomePage()
        .environmentObject(AuthViewModel())
}

struct FeatureRow: View {
    let icon: String
    let title: String

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .foregroundColor(.red)
                .font(.system(size: 18))
                .frame(width: 24, alignment: .center)

            Text(title)
                .foregroundColor(.white)
                .font(.system(size: 16, weight: .medium))

        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

//
//  ContentView.swift
//  Ecommerce
//
//  Created by Mubashir PM on 09/02/26.
//

import SwiftUI

struct onboardingView: View {
    var body: some View {
        ZStack {
            Image("onboarding")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
         FastionStore_()
        }
    }
}


#Preview {
    onboardingView()
}

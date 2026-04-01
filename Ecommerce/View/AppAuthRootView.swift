//
//  AppAuthRootView.swift
//  Ecommerce
//

import SwiftUI

/// Chooses main app vs welcome flow from `AuthViewModel` after validating the JWT on launch.
struct AppAuthRootView: View {

    @EnvironmentObject private var authViewModel: AuthViewModel

    var body: some View {
        Group {
            if authViewModel.isBootstrapping {
                ZStack {
                    Color.custom
                        .ignoresSafeArea()
                    ProgressView()
                        .scaleEffect(1.2)
                }
            } else if authViewModel.isLoggedIn {
                CustomTabBar()
            } else {
                WelcomePage()
            }
        }
        .task {
            await authViewModel.validateUser()
        }
    }
}

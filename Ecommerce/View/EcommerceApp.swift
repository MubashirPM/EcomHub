
//
//  EcommerceApp.swift
//  Ecommerce
//
//  Created by Mubashir PM on 09/02/26.
//

import SwiftUI

@main
struct EcommerceApp: App {

    @StateObject private var authViewModel = AuthViewModel()

    var body: some Scene {
        WindowGroup {
            AppAuthRootView()
                .environmentObject(authViewModel)
        }
    }
}

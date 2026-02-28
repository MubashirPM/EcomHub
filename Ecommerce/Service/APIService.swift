//
//  APIService.swift
//  Ecommerce
//
//  Created by Mubashir PM on 26/02/26.
//

import Foundation

enum AppConfig {
    static var baseURL: String {
        "https://ucraft.adwaith.space/api"
    }
}

enum EndPoints {
    // Auth EndPoints
    static let signIn = "/login"
    static let signUp = "/signup"
    
    // GoogleLogin
    static let google = "/auth/google/callback"
    
    // HomeEndPoints
    static let Home = "home"
}


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
    static let imageBaseURL = "https://ucraft.adwaith.space/uploads/product-images/"
}

enum EndPoints {
    // Auth EndPoints
    static let signIn = "/login"
    static let signUp = "/signup"
    
    // GoogleLogin
    static let google = "/auth/google"
    
    // HomeEndPoints
    static let Home = "/home"
    
    // OTP EndPoints
    static let Otp = "/verifyOTP"
    
    // New Arrivals
    static let newArrivals = "/new-arrivals"
    
    // Featured
    static let featured = "/featured"
    
    // Search
    static let search = "/search-products"
    
    // Details
    static func productDetails(id: String) -> String {
        return "/product/\(id)"
    }
    
    static let explore = "/explore"
   
    static let addReview = "/addReview"
}


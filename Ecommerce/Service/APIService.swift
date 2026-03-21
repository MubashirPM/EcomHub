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
    static let profileImageBaseURL = "https://ucraft.adwaith.space/uploads/profile/"
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
    
    static let addToCart = "/cart/add"

    static let removeFromCart = "/cart/remove"

    static func getCart(userId: String) -> String {
            "/cart/\(userId)"
        }
    
    static func getWishlist(userId: String) -> String {
        return "/wishlist/\(userId)"
    }

    static let addToWishlist = "/wishlist/add"

    static let removeFromWishlist = "/wishlist/remove"

    static func getProfile(userId: String) -> String {
        "/profile/\(userId)"
    }

    static func getAddress(userId: String) -> String {
        "/address/\(userId)"
    }

    static func addAddress(userId: String) -> String {
        "/address/add/\(userId)"
    }
}


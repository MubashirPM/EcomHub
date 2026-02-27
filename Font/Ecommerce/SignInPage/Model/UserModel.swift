//
//  UserModel.swift
//  Ecommerce
//
//  Created by Mubashir PM on 25/02/26.
//

import Foundation

struct User: Codable {
    let id: String
    let fullName: String
    let email: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case fullName
        case email
    }
}

struct LoginResponse: Decodable {
    let success: Bool
    let message: String
    let redirect: String?
    let user: User?
    let type: String?
    let code: String?
}

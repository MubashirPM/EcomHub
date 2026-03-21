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
    let role : String
    let profileImage: String?
       let phone: String?
}

struct LoginResponse: Decodable {
    let success: Bool
    let message: String
    let redirect: String?
    let user: User?
    let type: String?
    let code: String?
}

struct GoogleLoginResponse: Codable {
    let token: String
    let user: User
}

/// Auth response user payload. Supports both "_id" and "id" from backend.
struct AuthUserPayload: Codable {
    let id: String?
    let fullName: String?
    let email: String?
    let role: String?

    enum CodingKeys: String, CodingKey {
        case fullName
        case email
        case role
        case id
        case underscoreId = "_id"
        case userId = "user_id"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        fullName = try container.decodeIfPresent(String.self, forKey: .fullName)
        email = try container.decodeIfPresent(String.self, forKey: .email)
        role = try container.decodeIfPresent(String.self, forKey: .role)
        id = try container.decodeIfPresent(String.self, forKey: .underscoreId)
            ?? container.decodeIfPresent(String.self, forKey: .id)
            ?? container.decodeIfPresent(String.self, forKey: .userId)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .underscoreId)
        try container.encodeIfPresent(fullName, forKey: .fullName)
        try container.encodeIfPresent(email, forKey: .email)
        try container.encodeIfPresent(role, forKey: .role)
    }
}

struct AuthResponse: Codable {
    let success: Bool?
    let message: String?
    let user: AuthUserPayload?
}

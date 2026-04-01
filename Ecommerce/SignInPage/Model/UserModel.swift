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
    /// Present when the backend issues JWT / session tokens after login.
    let accessToken: String?
    let refreshToken: String?

    enum CodingKeys: String, CodingKey {
        case success
        case message
        case redirect
        case user
        case type
        case code
        case accessToken
        case refreshToken
        case access_token
        case refresh_token
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        success = try c.decode(Bool.self, forKey: .success)
        message = try c.decode(String.self, forKey: .message)
        redirect = try c.decodeIfPresent(String.self, forKey: .redirect)
        user = try c.decodeIfPresent(User.self, forKey: .user)
        type = try c.decodeIfPresent(String.self, forKey: .type)
        code = try c.decodeIfPresent(String.self, forKey: .code)

        let accessFromCamel = try c.decodeIfPresent(String.self, forKey: .accessToken)
        let accessFromSnake = try c.decodeIfPresent(String.self, forKey: .access_token)
        accessToken = accessFromCamel ?? accessFromSnake

        let refreshFromCamel = try c.decodeIfPresent(String.self, forKey: .refreshToken)
        let refreshFromSnake = try c.decodeIfPresent(String.self, forKey: .refresh_token)
        refreshToken = refreshFromCamel ?? refreshFromSnake
    }
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
        let idFromUnderscore = try container.decodeIfPresent(String.self, forKey: .underscoreId)
        let idFromId = try container.decodeIfPresent(String.self, forKey: .id)
        let idFromUserId = try container.decodeIfPresent(String.self, forKey: .userId)
        id = idFromUnderscore ?? idFromId ?? idFromUserId
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


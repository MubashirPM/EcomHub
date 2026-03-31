//
//  ProfileResponse.swift
//  Ecommerce
//

import Foundation

struct ProfileResponse: Codable {
    let success: Bool
    let message: String
    let user: ProfileUser
}

/// Body for `POST /profile/edit/{userId}` (`Content-Type: application/json`).
struct ProfileEditRequest: Encodable {
    let fullName: String
    let phone: String
    let profileImage: String
}

struct ProfileUser: Codable, Equatable {
    let id: String
    let fullName: String
    let phone: String?
    let email: String
    let status: String?
    let role: String?
    let profileImage: String?
    let referralCode: String?
    let walletBalance: Double?
    let points: Int?
    let createdAt: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case fullName
        case phone
        case email
        case status
        case role
        case profileImage
        case referralCode
        case walletBalance
        case points
        case createdAt
        case updatedAt
    }
}

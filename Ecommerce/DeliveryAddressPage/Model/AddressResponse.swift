//
//  AddressResponse.swift
//  Ecommerce
//
//  Model for GET /address/{userId} response.
//

import Foundation

struct AddressResponse: Codable {
    let success: Bool
    let message: String?
    let address: UserAddressContainer?
}

struct UserAddressContainer: Codable {
    let id: String
    let userId: String?
    let addressList: [AddressItem]
    let createdAt: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case userId
        case addressList = "address"
        case createdAt
        case updatedAt
    }
}

struct AddressItem: Codable, Identifiable {
    let id: String
    let addressType: String?
    let fullName: String?
    let phone: Int?
    let secPhone: Int?
    let houseName: String?
    let city: String?
    let state: String?
    let pincode: Int?
    let landMark: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case addressType
        case fullName
        case phone
        case secPhone
        case houseName
        case city
        case state
        case pincode
        case landMark
    }

    /// Title for the card (e.g. "Home" from addressType or fullName).
    var title: String {
        if let type = addressType, !type.isEmpty {
            return type.prefix(1).uppercased() + type.dropFirst().lowercased()
        }
        return fullName ?? "Address"
    }

    /// Full address string for display.
    var displayAddress: String {
        let parts = [houseName, city, state, pincode.map { String($0) }, landMark]
            .compactMap { $0 }
            .filter { !$0.isEmpty }
        return parts.joined(separator: ", ")
    }

    /// Show "Default" tag for home type.
    var defaultTag: String? {
        addressType?.lowercased() == "home" ? "Default" : nil
    }
}

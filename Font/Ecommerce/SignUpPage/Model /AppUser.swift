//
//  AppUser.swift
//  Ecommerce
//
//  Created by Mubashir PM on 25/02/26.
//

import Foundation

struct AppUser: Identifiable, Codable {
    let id: UUID
    let fullName: String
    let email: String
}

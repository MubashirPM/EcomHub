//
//  OTPVerifyResponse.swift
//  Ecommerce
//
//  Created by Mubashir PM on 02/03/26.
//

import Foundation

struct OTPVerifyResponse : Decodable {
    let success : Bool?
    let message : String?
    let error: String?
}

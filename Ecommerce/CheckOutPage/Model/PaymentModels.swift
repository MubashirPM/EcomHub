//
//  PaymentModels.swift
//  Ecommerce
//

import Foundation

/// Payload nested under `buyNowProduct` for POST `/payment/create-order`.
struct BuyNowProductPayload: Codable, Equatable {
    let productId: String
    let quantity: Int
}

/// Backend recalculates totals from the cart, or from buy-now when `isBuyNow` is sent.
struct CreateOrderRequest: Encodable {
    let userId: String
    private let buyNowProduct: BuyNowProductPayload?

    /// Cart checkout: only `userId` is encoded.
    init(userId: String) {
        self.userId = userId
        self.buyNowProduct = nil
    }

    /// Buy now: encodes `userId`, `isBuyNow: true`, and `buyNowProduct`.
    init(userId: String, buyNowProduct: BuyNowProductPayload) {
        self.userId = userId
        self.buyNowProduct = buyNowProduct
    }

    private enum CodingKeys: String, CodingKey {
        case userId
        case isBuyNow
        case buyNowProduct
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(userId, forKey: .userId)
        if let buyNowProduct {
            try container.encode(true, forKey: .isBuyNow)
            try container.encode(buyNowProduct, forKey: .buyNowProduct)
        }
    }
}

/// `{ "success": true, "razorpayOrder": { "id", "amount" (paise) }, "amount": totalRupees }`
struct RazorpayOrderPayload: Decodable {
    let id: String
    let amount: Int

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(String.self, forKey: .id)
        if let intAmount = try? c.decode(Int.self, forKey: .amount) {
            amount = intAmount
        } else if let doubleAmount = try? c.decode(Double.self, forKey: .amount) {
            amount = Int(doubleAmount.rounded())
        } else {
            throw DecodingError.dataCorruptedError(forKey: .amount, in: c, debugDescription: "Invalid amount.")
        }
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case amount
    }
}

struct CreateOrderResponse: Decodable {
    let success: Bool?
    let razorpayOrder: RazorpayOrderPayload

    /// Root `amount` from API: payable total in **rupees** (subtotal + tax + shipping − discount).
    let totalRupeesFromServer: Int?

    enum CodingKeys: String, CodingKey {
        case success
        case razorpayOrder
        case totalRupeesFromServer = "amount"
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        success = try c.decodeIfPresent(Bool.self, forKey: .success)
        razorpayOrder = try c.decode(RazorpayOrderPayload.self, forKey: .razorpayOrder)
        if let r = try? c.decodeIfPresent(Int.self, forKey: .totalRupeesFromServer) {
            totalRupeesFromServer = r
        } else if let d = try? c.decodeIfPresent(Double.self, forKey: .totalRupeesFromServer) {
            totalRupeesFromServer = Int(d.rounded())
        } else {
            totalRupeesFromServer = nil
        }
    }

    var orderId: String { razorpayOrder.id }

    /// Amount in **paise** for Razorpay checkout `amount` option.
    var amount: Int { razorpayOrder.amount }

    /// Payable total in rupees for UI (prefers server field, else derived from paise).
    var payableTotalRupees: Int {
        if let r = totalRupeesFromServer, r > 0 { return r }
        return max(1, razorpayOrder.amount / 100)
    }
}

struct VerifyPaymentResponse: Decodable {
    let success: Bool?
    let message: String?
}

struct RazorpaySuccessPayload {
    let razorpayPaymentId: String
    let razorpayOrderId: String
    let razorpaySignature: String
}

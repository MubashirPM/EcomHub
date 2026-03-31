//
//  OrderModels.swift
//  Ecommerce
//

import Foundation

// MARK: - List response

struct UserOrdersResponse: Codable {
    let success: Bool
    let orders: [UserOrder]?
    let pagination: OrderPagination?
    let message: String?
}

struct OrderPagination: Codable {
    let currentPage: Int
    let totalPages: Int
    let totalOrders: Int
    let hasNextPage: Bool
    let hasPrevPage: Bool
    let limit: Int
}

// MARK: - Detail response

struct UserOrderDetailResponse: Codable {
    let success: Bool
    let order: UserOrder?
    let message: String?
}

// MARK: - Cancel / return

struct OrderActionResponse: Codable {
    let success: Bool
    let message: String?
}

// MARK: - Which actions apply (matches common e‑commerce + your status names)

enum OrderStatusPolicy {

    /// Cancel before the order is in transit or finished.
    static func canCancel(forStatus status: String?) -> Bool {
        let normalized = Self.normalized(status)
        guard !normalized.isEmpty else { return false }
        let blocked: [String] = [
            "shipped",
            "out for delivery",
            "delivered",
            "canceled",
            "cancelled",
            "return requested",
            "returned"
        ]
        return !blocked.contains { $0.caseInsensitiveCompare(normalized) == .orderedSame }
    }

    /// Return request after delivery.
    static func canRequestReturn(forStatus status: String?) -> Bool {
        let normalized = Self.normalized(status)
        guard !normalized.isEmpty else { return false }
        return "delivered".caseInsensitiveCompare(normalized) == .orderedSame
    }

    private static func normalized(_ status: String?) -> String {
        (status ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

// MARK: - Order

struct UserOrder: Codable, Identifiable, Hashable {
    let id: String
    let userId: String?
    let status: String?
    let orderDate: Date?
    let updatedAt: Date?
    let items: [UserOrderLineItem]?
    let totalAmount: Double?
    /// Some schemas expose order total as `total` instead of `totalAmount`.
    let total: Double?
    let formattedOrderDate: String?
    let formattedUpdatedAt: String?
    let statusTimeline: [OrderStatusTimelineStep]?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case userId, status, orderDate, updatedAt, items, totalAmount, total
        case formattedOrderDate, formattedUpdatedAt, statusTimeline
    }

    func summaryLineItemText() -> String {
        guard let items, !items.isEmpty else {
            return OrderCopy.summaryEmpty
        }
        let parts = items.compactMap { line -> String? in
            let name = line.resolvedProductName
            guard let qty = line.quantity, qty > 0 else {
                return name
            }
            return "\(name) × \(qty)"
        }
        return parts.isEmpty ? OrderCopy.summaryEmpty : parts.joined(separator: ", ")
    }

    func displayTotalFormatted() -> String {
        if let totalAmount, totalAmount > 0 {
            return Self.formatINR(totalAmount)
        }
        if let total, total > 0 {
            return Self.formatINR(total)
        }
        let sum = items?.reduce(0.0) { partial, line in
            let unit = line.resolvedUnitPrice
            let qty = Double(line.quantity ?? 0)
            return partial + unit * qty
        } ?? 0
        guard sum > 0 else { return "—" }
        return Self.formatINR(sum)
    }

    static func formatINR(_ value: Double) -> String {
        inrFormatter.string(from: NSNumber(value: value)) ?? "₹\(value)"
    }

    func displayStatusLabel() -> String {
        guard let status, !status.isEmpty else {
            return OrderCopy.statusUnknown
        }
        return status
    }

    private static let inrFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.currencyCode = "INR"
        f.locale = Locale(identifier: "en_IN")
        return f
    }()
}

// MARK: - Line item

struct UserOrderLineItem: Codable, Hashable {
    let productId: OrderProductPayload?
    let quantity: Int?
    let price: Double?
    let salePrice: Double?

    enum CodingKeys: String, CodingKey {
        case productId, quantity, price, salePrice
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        quantity = try container.decodeIfPresent(Int.self, forKey: .quantity)
        price = try container.decodeIfPresent(Double.self, forKey: .price)
        salePrice = try container.decodeIfPresent(Double.self, forKey: .salePrice)
        if let payload = try? container.decode(OrderProductPayload.self, forKey: .productId) {
            productId = payload
        } else {
            _ = try? container.decode(String.self, forKey: .productId)
            productId = nil
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(productId, forKey: .productId)
        try container.encodeIfPresent(quantity, forKey: .quantity)
        try container.encodeIfPresent(price, forKey: .price)
        try container.encodeIfPresent(salePrice, forKey: .salePrice)
    }

    var resolvedProductName: String {
        productId?.productName ?? OrderCopy.unnamedProduct
    }

    var resolvedUnitPrice: Double {
        if let price, price > 0 { return price }
        if let salePrice, salePrice > 0 { return salePrice }
        return productId?.salePrice ?? 0
    }

    var imageFilenames: [String] {
        productId?.imageFilenames ?? []
    }
}

/// Populated `productId` object or minimal fields when shape differs.
struct OrderProductPayload: Codable, Hashable {
    let id: String?
    let productName: String?
    let salePrice: Double?
    let description: String?
    let images: [String]?
    let productImage: [String]?
    let category: OrderCategoryPayload?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case productName, salePrice, description, images, productImage, category
    }

    var imageFilenames: [String] {
        if let imgs = images, !imgs.isEmpty { return imgs }
        return productImage ?? []
    }
}

struct OrderCategoryPayload: Codable, Hashable {
    let categoryName: String?
}

// MARK: - Timeline

struct OrderStatusTimelineStep: Codable, Hashable {
    let status: String
    let date: Date?
    let completed: Bool?
}

// MARK: - Copy

enum OrderCopy {
    static let summaryEmpty = "No line items"
    static let statusUnknown = "Status pending"
    static let unnamedProduct = "Product"
    static let loadFailed = "Could not load orders"
    static let detailNavTitle = "Order details"
    static let sectionTimeline = "Status"
    static let sectionItems = "Items"
    static let signInHint = "Sign in to see your orders"
    static let emptyOrders = "No orders yet"
    static let loadMore = "Load more"
    static let retry = "Retry"
    static let sectionActions = "Actions"
    static let cancelOrder = "Cancel order"
    static let requestReturn = "Request return"
    static let cancelConfirmTitle = "Cancel this order?"
    static let cancelConfirmMessage = "We will notify you when the cancellation is processed."
    static let returnConfirmTitle = "Request a return?"
    static let returnConfirmMessage = "You can track return status from your orders list."
    static let confirmAction = "Confirm"
    static let dismissAction = "Not now"
    static let mutationFailed = "Something went wrong. Please try again."
}

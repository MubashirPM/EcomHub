//
//  OrdersViewModel.swift
//  Ecommerce
//

import Foundation
import SwiftUI
import Combine

@MainActor
final class OrdersViewModel: ObservableObject {

    @Published private(set) var orders: [UserOrder] = []
    @Published private(set) var pagination: OrderPagination?
    @Published var isLoading = false
    @Published var isLoadingMore = false
    @Published var errorMessage: String?

    private var currentPage = 1
    private let pageLimit = 10

    private static let iso8601Fractional: ISO8601DateFormatter = {
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return f
    }()

    private static let iso8601Plain: ISO8601DateFormatter = {
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withInternetDateTime]
        return f
    }()

    static func jsonDecoderForOrders() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let string = try container.decode(String.self)
            if let date = iso8601Fractional.date(from: string) {
                return date
            }
            if let date = iso8601Plain.date(from: string) {
                return date
            }
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date: \(string)")
        }
        return decoder
    }

    func fetchOrders(userId: String, reset: Bool) async {
        guard !userId.isEmpty else {
            orders = []
            pagination = nil
            errorMessage = nil
            return
        }

        if reset {
            currentPage = 1
        }

        isLoading = true
        errorMessage = nil

        defer { isLoading = false }

        do {
            let url = try Self.buildOrdersURL(userId: userId, page: currentPage, limit: pageLimit, status: nil)
            let (data, response) = try await URLSession.shared.data(from: url)
            try ordersValidateHTTPResponse(data: data, response: response)

            let decoded = try Self.jsonDecoderForOrders().decode(UserOrdersResponse.self, from: data)
            guard decoded.success else {
                errorMessage = decoded.message ?? OrderCopy.loadFailed
                return
            }
            orders = decoded.orders ?? []
            pagination = decoded.pagination
        } catch {
            orders = []
            pagination = nil
            errorMessage = (error as? LocalizedError)?.errorDescription ?? OrderCopy.loadFailed
        }
    }

    func loadMore(userId: String) async {
        guard !userId.isEmpty,
              let pagination,
              pagination.hasNextPage,
              !isLoadingMore,
              !isLoading else { return }

        isLoadingMore = true
        defer { isLoadingMore = false }

        let nextPage = currentPage + 1

        do {
            let url = try Self.buildOrdersURL(userId: userId, page: nextPage, limit: pageLimit, status: nil)
            let (data, response) = try await URLSession.shared.data(from: url)
            try ordersValidateHTTPResponse(data: data, response: response)

            let decoded = try Self.jsonDecoderForOrders().decode(UserOrdersResponse.self, from: data)
            guard decoded.success else { return }

            let newItems = decoded.orders ?? []
            if !newItems.isEmpty {
                orders.append(contentsOf: newItems)
                currentPage = nextPage
                self.pagination = decoded.pagination
            }
        } catch {
            errorMessage = (error as? LocalizedError)?.errorDescription ?? OrderCopy.loadFailed
        }
    }

    private static func buildOrdersURL(userId: String, page: Int, limit: Int, status: String?) throws -> URL {
        var components = URLComponents(string: AppConfig.baseURL + EndPoints.userOrders)
        var items = [
            URLQueryItem(name: "userId", value: userId),
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "limit", value: "\(limit)")
        ]
        if let status, !status.isEmpty {
            items.append(URLQueryItem(name: "status", value: status))
        }
        components?.queryItems = items
        guard let url = components?.url else {
            throw URLError(.badURL)
        }
        return url
    }

}

// MARK: - Order detail fetcher (used by detail view)

enum OrderDetailLoader {
    static func fetch(userId: String, orderId: String) async throws -> UserOrder {
        var components = URLComponents(string: AppConfig.baseURL + EndPoints.orderDetails)
        components?.queryItems = [
            URLQueryItem(name: "userId", value: userId),
            URLQueryItem(name: "orderId", value: orderId)
        ]
        guard let url = components?.url else {
            throw URLError(.badURL)
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        try ordersValidateHTTPResponse(data: data, response: response)
        let decoded = try OrdersViewModel.jsonDecoderForOrders().decode(UserOrderDetailResponse.self, from: data)
        guard decoded.success, let order = decoded.order else {
            throw OrdersAPIError.serverMessage(decoded.message ?? OrderCopy.loadFailed)
        }
        return order
    }
}

private struct APIErrorEnvelope: Codable {
    let success: Bool?
    let message: String?
}

enum OrdersAPIError: LocalizedError {
    case serverMessage(String)
    case httpStatus(Int)

    var errorDescription: String? {
        switch self {
        case .serverMessage(let message):
            return message
        case .httpStatus(let code):
            return "Request failed (\(code))"
        }
    }
}

fileprivate func ordersValidateHTTPResponse(data: Data, response: URLResponse) throws {
    guard let http = response as? HTTPURLResponse else { return }
    guard (200 ... 299).contains(http.statusCode) else {
        if let body = try? JSONDecoder().decode(APIErrorEnvelope.self, from: data),
           let msg = body.message {
            throw OrdersAPIError.serverMessage(msg)
        }
        throw OrdersAPIError.httpStatus(http.statusCode)
    }
}

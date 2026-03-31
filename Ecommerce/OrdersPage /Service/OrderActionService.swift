//
//  OrderActionService.swift
//  Ecommerce
//

import Foundation

enum OrderActionServiceError: LocalizedError {
    case invalidURL
    case serverMessage(String)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return OrderCopy.mutationFailed
        case .serverMessage(let message):
            return message
        }
    }
}

enum OrderActionService {

    static func cancelOrder(userId: String, orderId: String) async throws -> String? {
        try await post(path: EndPoints.orderCancel, userId: userId, orderId: orderId)
    }

    static func requestReturn(userId: String, orderId: String) async throws -> String? {
        try await post(path: EndPoints.orderReturn, userId: userId, orderId: orderId)
    }

    private static func post(path: String, userId: String, orderId: String) async throws -> String? {
        guard let url = URL(string: AppConfig.baseURL + path) else {
            throw OrderActionServiceError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let payload: [String: Any] = [
            "userId": userId,
            "orderId": orderId
        ]
        request.httpBody = try JSONSerialization.data(withJSONObject: payload)

        let (data, response) = try await URLSession.shared.data(for: request)
        let decoded = try? JSONDecoder().decode(OrderActionResponse.self, from: data)

        guard let http = response as? HTTPURLResponse else {
            throw OrderActionServiceError.serverMessage(OrderCopy.mutationFailed)
        }

        if (200 ... 299).contains(http.statusCode) {
            if let decoded, !decoded.success {
                throw OrderActionServiceError.serverMessage(decoded.message ?? OrderCopy.mutationFailed)
            }
            return decoded?.message
        }

        let message = decoded?.message ?? String(data: data, encoding: .utf8) ?? OrderCopy.mutationFailed
        throw OrderActionServiceError.serverMessage(message)
    }
}

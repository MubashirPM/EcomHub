//
//  AuthenticatedAPIClient.swift
//  Ecommerce
//
//  URLSession-based requests with `Authorization: Bearer <accessToken>`.
//  Does not attach refreshToken. On 401, signs the user out (refresh flow not implemented yet).
//

import Foundation

enum AuthenticatedAPIClient {

    enum APIError: LocalizedError {
        case unauthorized
        case invalidResponse

        var errorDescription: String? {
            switch self {
            case .unauthorized:
                return "Session expired. Please sign in again."
            case .invalidResponse:
                return "Invalid server response."
            }
        }
    }

    /// Performs the request, adding Bearer auth when an access token exists.
    /// - Note: Only `accessToken` is sent. `refreshToken` is never added to headers.
    static func data(for request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        var req = request
        if let token = AuthTokenStore.accessToken, !token.isEmpty {
            req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        let (data, response) = try await URLSession.shared.data(for: req)
        guard let http = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        if http.statusCode == 401 {
            AuthSession.signOut()
            throw APIError.unauthorized
        }

        return (data, http)
    }

    static func get(url: URL) async throws -> (Data, HTTPURLResponse) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return try await data(for: request)
    }
}

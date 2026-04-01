//
//  AuthService.swift
//  Ecommerce
//
//  Validates the session with GET /home + Bearer token (no refresh flow).
//

import Foundation

enum AuthService {

    enum FetchHomeError: LocalizedError {
        case invalidURL
        case invalidResponse
        case httpStatus(Int)

        var errorDescription: String? {
            switch self {
            case .invalidURL:
                return "Invalid URL."
            case .invalidResponse:
                return "Invalid server response."
            case .httpStatus(let code):
                return "Request failed (HTTP \(code))."
            }
        }
    }

    /// Calls `GET /api/home` with `Authorization: Bearer <accessToken>`.
    /// - Returns: `true` if HTTP 200, `false` if HTTP 401.
    /// - Throws: Network errors or non-200/401 HTTP status.
    static func fetchHome() async throws -> Bool {
        guard let token = AuthTokenStore.getAccessToken(), !token.isEmpty else {
            return false
        }

        guard let url = URL(string: AppConfig.baseURL + EndPoints.Home) else {
            throw FetchHomeError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let (_, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse else {
            throw FetchHomeError.invalidResponse
        }

        switch http.statusCode {
        case 200:
            return true
        case 401:
            return false
        default:
            throw FetchHomeError.httpStatus(http.statusCode)
        }
    }
}

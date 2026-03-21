//
//  AddAddressViewModel.swift
//  Ecommerce
//

import Foundation
import Combine

@MainActor
class AddAddressViewModel: ObservableObject {

    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var didSucceed = false

    func addAddress(
        userId: String,
        addressType: String,
        fullName: String,
        phone: String,
        houseName: String,
        city: String,
        state: String,
        pincode: String,
        landMark: String
    ) async {
        guard !userId.isEmpty else {
            errorMessage = "Please sign in to add an address"
            return
        }
        guard let url = URL(string: AppConfig.baseURL + EndPoints.addAddress(userId: userId)) else {
            errorMessage = "Invalid URL"
            return
        }

        isLoading = true
        errorMessage = nil

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "userId": userId,
            "user_id": userId,
            "addressType": addressType,
            "fullName": fullName,
            "phone": phone,
            "houseName": houseName,
            "city": city,
            "state": state,
            "pincode": pincode,
            "landMark": landMark
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                errorMessage = "Invalid response"
                isLoading = false
                return
            }
            if (200...299).contains(httpResponse.statusCode) {
                didSucceed = true
            } else {
                errorMessage = "Could not save address. Please try again."
            }
        } catch {
            errorMessage = "Could not save address. Please try again."
        }
        isLoading = false
    }
}

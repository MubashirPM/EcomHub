//
//  DeliveryAddressViewModel.swift
//  Ecommerce
//

import Foundation
import Combine

@MainActor
class DeliveryAddressViewModel: ObservableObject {

    @Published var addresses: [AddressItem] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var deletingAddressId: String?

    func fetchAddresses(userId: String) async {
        guard !userId.isEmpty else {
            addresses = []
            errorMessage = nil
            return
        }
        guard let url = URL(string: AppConfig.baseURL + EndPoints.getAddress(userId: userId)) else {
            errorMessage = "Invalid URL"
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let response = try decoder.decode(AddressResponse.self, from: data)
            addresses = response.address?.addressList ?? []
        } catch {
            self.addresses = []
            errorMessage = "Could not load addresses"
        }

        isLoading = false
    }

    /// Removes one address via `POST /address/delete/:userId` (body includes address id).
    func deleteAddress(userId: String, addressId: String) async {
        guard !userId.isEmpty, !addressId.isEmpty else { return }
        guard let url = URL(string: AppConfig.baseURL + EndPoints.deleteAddress(userId: userId)) else {
            errorMessage = "Invalid URL"
            return
        }

        deletingAddressId = addressId
        errorMessage = nil

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: Any] = [
            "addressId": addressId,
            "_id": addressId
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                errorMessage = "Invalid response"
                deletingAddressId = nil
                return
            }
            if (200...299).contains(httpResponse.statusCode) {
                addresses.removeAll { $0.id == addressId }
                if UserDefaults.standard.string(forKey: "selectedAddressId") == addressId {
                    UserDefaults.standard.set("", forKey: "selectedAddressId")
                }
            } else if let obj = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                      let msg = obj["message"] as? String, !msg.isEmpty {
                errorMessage = msg
            } else {
                errorMessage = "Could not delete address."
            }
        } catch {
            errorMessage = "Could not delete address."
        }

        deletingAddressId = nil
    }
}

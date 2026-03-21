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
}

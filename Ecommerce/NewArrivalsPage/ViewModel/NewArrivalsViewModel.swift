//
//  NewArrivalsViewModel.swift
//  Ecommerce
//
//

import Foundation
import SwiftUI
import Combine

class NewArrivalsViewModel: ObservableObject {

    @Published var products: [HomeProduct] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    var filteredProducts: [HomeProduct] {
        if searchText.isEmpty { return products }
        return products.filter {
            $0.productName.lowercased().contains(searchText.lowercased())
        }
    }

    @Published var searchText: String = ""

    func fetchNewArrivals() {
        let urlString = AppConfig.baseURL + EndPoints.newArrivals
        guard let url = URL(string: urlString) else {
            errorMessage = "Invalid URL"
            return
        }

        isLoading = true
        errorMessage = nil

        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
            }

            if let error = error {
                DispatchQueue.main.async {
                    self?.errorMessage = error.localizedDescription
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    self?.errorMessage = "No data received"
                }
                return
            }

            do {
                let decoded = try JSONDecoder().decode(NewArrivalsResponse.self, from: data)
                DispatchQueue.main.async {
                    self?.products = decoded.data
                }
            } catch {
                DispatchQueue.main.async {
                    self?.errorMessage = error.localizedDescription
                }
            }
        }.resume()
    }
}

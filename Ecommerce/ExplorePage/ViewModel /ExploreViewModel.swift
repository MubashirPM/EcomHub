//
//  ExploreViewModel.swift
//  Ecommerce
//
//  Created by Mubashir PM on 10/03/26.
//


import Foundation
import SwiftUI
import Combine

class ExploreViewModel: ObservableObject {

    @Published var products: [HomeProduct] = []
    @Published var isLoading = false

    private var page = 1
    private let limit = 11

    func fetchExploreProducts() {

        guard let url = URL(string: "https://ucraft.adwaith.space/api/explore?page=\(page)&limit=\(limit)") else { return }

        isLoading = true

        URLSession.shared.dataTask(with: url) { data, response, error in

            DispatchQueue.main.async {

                self.isLoading = false

                guard let data = data else { return }

                do {

                    let decoded = try JSONDecoder().decode(ExploreResponse.self, from: data)

                    self.products.append(contentsOf: decoded.data)

                } catch {
                    print("Decoding Error:", error)
                }
            }

        }.resume()
    }

    func loadMoreProducts(currentItem: HomeProduct) {

        guard let lastItem = products.last else { return }

        if currentItem.id == lastItem.id {

            page += 1

            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.fetchExploreProducts()
            }
        }
    }
}

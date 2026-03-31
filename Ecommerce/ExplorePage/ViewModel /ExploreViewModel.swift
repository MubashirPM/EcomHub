//
//  ExploreViewModel.swift
//  Ecommerce
//

import Foundation
import SwiftUI
import Combine

@MainActor
final class ExploreViewModel: ObservableObject {

    @Published private(set) var products: [HomeProduct] = []
    @Published private(set) var isLoading = false
    @Published private(set) var hasMorePages = true

    private var nextPage = 1
    private let pageSize = 6
    private var isFetching = false

    /// Minimum time the bottom `ProgressView` stays visible when loading the next page (parallel with the API).
    private let paginationLoadingMinimumDisplay: Duration = .seconds(4)

    /// First visit: load page 1. Does not clear data if products already exist (e.g. returning to the tab).
    func loadIfEmpty() async {
        guard products.isEmpty else { return }
        await fetchNextPage(minimumLoadingDisplay: nil)
    }

    /// When the user reaches the last row of the **full** list (not client-filtered search results).
    func loadMoreIfNeeded(currentItem: HomeProduct) async {
        guard hasMorePages, !isFetching else { return }
        guard let last = products.last, last.id == currentItem.id else { return }
        await fetchNextPage(minimumLoadingDisplay: paginationLoadingMinimumDisplay)
    }

    private func fetchNextPage(minimumLoadingDisplay: Duration?) async {
        guard !isFetching else { return }
        guard hasMorePages else { return }

        isFetching = true
        isLoading = true

        let page = nextPage

        let newItems: [HomeProduct]
        do {
            if let minDisplay = minimumLoadingDisplay {
                async let fetched = requestExplorePage(page: page)
                async let minimumWait: Void = try await Task.sleep(for: minDisplay)
                newItems = try await fetched
                try await minimumWait
            } else {
                newItems = try await requestExplorePage(page: page)
            }
        } catch {
            print("Explore fetch error:", error)
            isFetching = false
            isLoading = false
            return
        }

        let existingIds = Set(products.map(\.id))
        let uniqueNew = newItems.filter { !existingIds.contains($0.id) }
        products.append(contentsOf: uniqueNew)

        if newItems.count < pageSize {
            hasMorePages = false
        } else {
            hasMorePages = true
            nextPage = page + 1
        }

        isFetching = false
        isLoading = false
    }

    private func requestExplorePage(page: Int) async throws -> [HomeProduct] {
        var components = URLComponents(string: AppConfig.baseURL + EndPoints.explore)
        components?.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "limit", value: "\(pageSize)")
        ]
        guard let url = components?.url else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)
        guard let http = response as? HTTPURLResponse,
              (200 ... 299).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }

        let decoded = try JSONDecoder().decode(ExploreResponse.self, from: data)
        return decoded.data
    }
}

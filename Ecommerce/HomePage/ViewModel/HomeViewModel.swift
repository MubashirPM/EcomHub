import Foundation
import SwiftUI
import Combine

class HomeViewModel: ObservableObject {

    @Published var searchText: String = ""

    @Published var trending: [HomeProduct] = []
    @Published var newArrivals: [HomeProduct] = []
    @Published var featured: [HomeProduct] = []

    @Published var isLoading = false
    @Published var errorMessage: String?

    var filteredNewArrivals: [HomeProduct] {
        if searchText.isEmpty { return newArrivals }
        return newArrivals.filter { $0.productName.lowercased().contains(searchText.lowercased()) }
    }

    var filteredTrending: [HomeProduct] {
        if searchText.isEmpty { return trending }
        return trending.filter { $0.productName.lowercased().contains(searchText.lowercased()) }
    }

    var filteredFeatured: [HomeProduct] {
        if searchText.isEmpty { return featured }
        return featured.filter { $0.productName.lowercased().contains(searchText.lowercased()) }
    }

    func fetchHomeData() {
        Task {
            await fetchHomeDataAsync()
        }
    }

    private func fetchHomeDataAsync() async {
        let urlString = AppConfig.baseURL + EndPoints.Home
        guard let url = URL(string: urlString) else {
            await MainActor.run { errorMessage = "Invalid URL" }
            return
        }

        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }

        do {
            let (data, http) = try await AuthenticatedAPIClient.get(url: url)
            guard (200 ... 299).contains(http.statusCode) else {
                await MainActor.run {
                    errorMessage = "Could not load home."
                    isLoading = false
                }
                return
            }

            let decodedResponse = try JSONDecoder().decode(HomeResponse.self, from: data)
            await MainActor.run {
                trending = decodedResponse.data.trending
                newArrivals = decodedResponse.data.newArrivals
                featured = decodedResponse.data.featuredCollection
                isLoading = false
            }
        } catch AuthenticatedAPIClient.APIError.unauthorized {
            await MainActor.run {
                errorMessage = AuthenticatedAPIClient.APIError.unauthorized.errorDescription
                isLoading = false
            }
        } catch {
            await MainActor.run {
                errorMessage = error.localizedDescription
                isLoading = false
            }
        }
    }
}

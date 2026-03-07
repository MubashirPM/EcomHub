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
        
        let urlString = AppConfig.baseURL + EndPoints.Home
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        print("Calling API:", urlString)
        
        isLoading = true
        errorMessage = nil
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            DispatchQueue.main.async {
                self.isLoading = false
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Status Code:", httpResponse.statusCode)
            }
            
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                }
                print("Network Error:", error)
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            print("RAW RESPONSE:")
            print(String(data: data, encoding: .utf8) ?? "No response string")
            
            do {
                let decodedResponse = try JSONDecoder().decode(HomeResponse.self, from: data)
                
                DispatchQueue.main.async {
                    self.trending = decodedResponse.data.trending
                    self.newArrivals = decodedResponse.data.newArrivals
                    self.featured = decodedResponse.data.featuredCollection
                }
                
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                }
                print("Decoding Error:", error)
            }
            
        }.resume()
    }
}

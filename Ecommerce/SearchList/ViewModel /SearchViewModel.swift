////
////  SearchViewModel.swift
////  Ecommerce
////
////  Created by Mubashir PM on 03/03/26.
////
//
//
//import SwiftUI
//import Foundation
//import Combine
//
//import SwiftUI
//
//@MainActor
//class SearchViewModel: ObservableObject {
//    
//    @Published var products: [SearchProduct] = []
//    @Published var isLoading = false
//    @Published var errorMessage: String?
//    @Published var searchText: String = ""
//    
//    // Pagination
//    @Published var page: Int = 1
//    @Published var hasMoreData: Bool = true
//    
//    private var debounceTask: Task<Void, Never>?
//    
//    // MARK: - Live Search With Debounce
//    func onSearchTextChanged() {
//        
//        debounceTask?.cancel()
//        
//        debounceTask = Task {
//            try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 sec delay
//            
//            if !Task.isCancelled {
//                page = 1
//                products.removeAll()
//                await search(query: searchText)
//            }
//        }
//    }
//    
//    // MARK: - Main Search Function
//    func search(query: String) async {
//        
//        guard !query.isEmpty else {
//            products.removeAll()
//            return
//        }
//        
//        isLoading = true
//        errorMessage = nil
//        
//        do {
//            let result = try await searchProducts(query: query, page: page)
//            
//            if page == 1 {
//                products = result
//            } else {
//                products.append(contentsOf: result)
//            }
//            
//            hasMoreData = !result.isEmpty
//            
//        } catch {
//            errorMessage = error.localizedDescription
//        }
//        
//        isLoading = false
//    }
//    
//    // MARK: - Load More (Pagination)
//    func loadMoreIfNeeded(currentItem: SearchProduct) async {
//        
//        guard let lastItem = products.last else { return }
//        
//        if currentItem.id == lastItem.id && hasMoreData && !isLoading {
//            page += 1
//            await search(query: searchText)
//        }
//    }
//    
//    // MARK: - API Call Inside ViewModel
//    private func searchProducts(query: String, page: Int) async throws -> [SearchProduct] {
//        
//        guard let url = URL(string: AppConfig.baseURL + EndPoints.search) else {
//            throw URLError(.badURL)
//        }
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        // 🔐 Add Bearer Token if needed
//        if let token = UserDefaults.standard.string(forKey: "authToken") {
//            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//        }
//        
//        let body = [
//            "query": query,
//            "page": page
//        ] as [String : Any]
//        
//        request.httpBody = try JSONSerialization.data(withJSONObject: body)
//        
//        let (data, response) = try await URLSession.shared.data(for: request)
//        
//        guard let httpResponse = response as? HTTPURLResponse,
//              200...299 ~= httpResponse.statusCode else {
//            throw URLError(.badServerResponse)
//        }
//        
//        let decoded = try JSONDecoder().decode(SearchResponse.self, from: data)
//        return decoded.data
//    }
//}

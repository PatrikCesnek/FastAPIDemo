//
//  PostListViewModel.swift
//  FastAPIDemo
//
//  Created by Patrik Cesnek on 07/12/2025.
//

import Foundation
import Combine

@MainActor
@Observable
final class PostListViewModel {
    var posts: [Post] = []
    var isLoading = false
    var errorMessage: String?

    func loadPosts() async {
        isLoading = true
        errorMessage = nil
        do {
            let results = try await APIService.shared.fetchPosts()
            posts = results
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}

//
//  PostDetailViewModel.swift
//  FastAPIDemo
//
//  Created by Patrik Cesnek on 07/12/2025.
//

import Foundation

@MainActor
@Observable
final class PostDetailViewModel {
    var post: Post?
    var isLoading = false
    var errorMessage: String?

    func load(postId: Int) async {
        isLoading = true
        errorMessage = nil
        do {
            let p = try await APIService.shared.fetchPost(id: postId)
            post = p
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}

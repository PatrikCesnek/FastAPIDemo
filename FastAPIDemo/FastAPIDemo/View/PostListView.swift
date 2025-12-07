//
//  PostListView.swift
//  FastAPIDemo
//
//  Created by Patrik Cesnek on 07/12/2025.
//

import SwiftUI

struct PostListView: View {
    @State private var vm = PostListViewModel()

    var body: some View {
        NavigationStack {
            Group {
                if vm.isLoading {
                    ProgressView("Loading posts…")
                } else if let err = vm.errorMessage {
                    VStack(spacing: 8) {
                        Text("Error: \(err)").foregroundColor(.red)
                        Button("Retry") {
                            Task { await vm.loadPosts() }
                        }
                    }
                } else {
                    List(vm.posts) { post in
                        NavigationLink(value: post.id) {
                            PostRowView(post: post)
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Posts")
            .task {
                await vm.loadPosts()
            }
            .navigationDestination(for: Int.self) { id in
                PostDetailView(postId: id)
            }
        }
    }
}

#Preview {
    PostListView()
}

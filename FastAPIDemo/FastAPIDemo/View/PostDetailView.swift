//
//  PostDetailView.swift
//  FastAPIDemo
//
//  Created by Patrik Cesnek on 07/12/2025.
//

import SwiftUI

struct PostDetailView: View {
    @State private var vm = PostDetailViewModel()
    let postId: Int

    var body: some View {
        Group {
            if vm.isLoading {
                ProgressView()
                    .navigationTitle("Loading...")
            } else if let post = vm.post {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        Text(post.title)
                            .font(.title2)
                            .bold()
                        Text(post.body)
                            .font(.body)
                    }
                    .padding()
                }
                .navigationTitle("Post \(post.id)")
            } else if let error = vm.errorMessage {
                Text("Error: \(error)")
                    .foregroundColor(.red)
                    .padding()
            } else {
                Text("No data")
                    .padding()
            }
        }
        .task {
            await vm.load(postId: postId)
        }
    }
}


#Preview {
    PostDetailView(postId: 1)
}

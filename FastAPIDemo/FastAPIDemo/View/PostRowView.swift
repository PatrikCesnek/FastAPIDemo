//
//  PostRowView.swift
//  FastAPIDemo
//
//  Created by Patrik Cesnek on 07/12/2025.
//

import SwiftUI

struct PostRowView: View {
    private let post: Post

    init(post: Post) {
        self.post = post
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(post.title)
                .font(.headline)
                .lineLimit(2)
            Text(post.body)
                .font(.subheadline)
                .lineLimit(2)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    PostRowView(post: Post(userId: 1, id: 1, title: "Title", body: "Random text"))
}

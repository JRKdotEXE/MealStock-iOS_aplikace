//
//  TestPostList.swift
//  MealStock
//
//  Created by Jiří on 09.11.2024.
//

import SwiftUI

struct TestPostList: View {
    @ObservedObject var postViewModel = PostViewModel()
    var body: some View {
        VStack {
        List(postViewModel.posts) { post in
            VStack(alignment: .leading) {
                Text("By: \(post.username)")
                    .font(.headline.bold())
                Text(post.title)
                    .font(.title2.bold())
                Text(post.content)
                    .font(.subheadline)
                // Text(Date.now(), style: .time)
                //   .font(.caption)
            }
        }}
        .onAppear {
            postViewModel.fetchPosts()
        }
    }
}

#Preview {
    TestPostList()
}

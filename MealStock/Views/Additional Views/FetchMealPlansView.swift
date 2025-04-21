//
//  FetchMealPlansView.swift
//  MealStock
//
//  Created by Jiří on 20.11.2024.
//
import SwiftUI

struct FetchMealPlansView: View {
    @ObservedObject var postViewModel = PostViewModel()
    var body: some View {
        NavigationStack {
        ScrollView {
            VStack {
                ForEach(postViewModel.posts.filter { $0.typ == .mealPlan}) { post in
                    NavigationLink {
                        mealPlanDetailView(for: post)
                    } label: {
                        mealPlanPostView(for: post)
                    }
                }
                
            }
        } }
        .onAppear {
            postViewModel.fetchPosts()
        }
    }
    
    
    
    private func mealPlanDetailView(for post: Post) -> MealPlanPostDetail {
        MealPlanPostDetail(
            name: post.title,
            userName: post.username,
            imageName: post.imageUrl ?? "",
            description: post.content,
            mealPlan: post.mealPlan ?? MealPlan(name: "", weeks: [], days: [], description: "", cuisine: [], dailyMeals: nil),
            timestamp: post.timestamp,
            postId: post.id,
            imageUrl: post.imageUrl
        )
    }
    
    private func mealPlanPostView(for post: Post) -> MealPlanPostView {
        MealPlanPostView(
            username: post.username,
            name: post.title,
            img: post.imageUrl ?? "",
            mealPlan: post.mealPlan ?? MealPlan(name: "", weeks: [], days: [], description: "", cuisine: [], dailyMeals: nil),
            timestamp: post.timestamp,
            postViewModel: PostViewModel(),
            postId: post.id
        )
    }
}

#Preview {
    FetchMealPlansView()
}

//
//  FetchRecipesView.swift
//  MealStock
//
//  Created by Jiří on 23.10.2024.
//
import SwiftUI

struct FetchRecipesView: View {
    @ObservedObject var viewModel = PostViewModel()
    
    var body: some View {
        NavigationStack {
        ScrollView {
            VStack {
                postedRecipesList
            }
        } }
        .onAppear {
            viewModel.fetchPosts()
        }
    }
    
    private var postedRecipesList: some View {
        ForEach(viewModel.posts.filter { $0.typ == .recipe }) { post in
            NavigationLink {
                recipeDetailView(for: post)
            } label: {
                recipePostView(for: post)
            }
        }
    }
    
    private func recipeDetailView(for post: Post) -> RecipePostDetail {
        RecipePostDetail(
            name: post.title,
            userName: post.username,
            description: post.content,
            instructions: post.recipe?.instructions ?? [],
            ingredients: post.recipe?.ingredients ?? [],
            recipe: post.recipe ?? Recipe(
                id: "",
                name: "",
                description: "",
                author: "",
                ingredients: [],
                category: .any,
                instructions: [],
                calories: 1,
                protein: 1,
                carbs: 1,
                fat: 1
            ),
            postViewModel: viewModel,
            timestamp: post.timestamp,
            postId: post.id,
            imageUrl: post.imageUrl,
            calories: post.recipe?.calories ?? 0,
            protein: post.recipe?.protein ?? 0,
            carbs: post.recipe?.carbs ?? 0,
            fat: post.recipe?.fat ?? 0,
            tags: post.tags
        )
    }
    
    private func recipePostView(for post: Post) -> Recipe_PostView {
        Recipe_PostView(
            username: post.username,
            mealname: post.title,
            img: post.imageUrl ?? "",
            recipe: post.recipe ?? Recipe(
                id: post.id,
                name: post.title,
                description: post.content,
                author: post.username,
                ingredients: post.recipe?.ingredients ?? [],
                category: .any,
                instructions: post.recipe?.instructions ?? [],
                calories: post.recipe?.calories ?? 0,
                protein: post.recipe?.protein ?? 0,
                carbs: post.recipe?.carbs ?? 0,
                fat: post.recipe?.fat ?? 0
            ),
            timestamp: post.timestamp,
            postViewModel: viewModel,
            postId: post.id
        )
    }
}


#Preview {
        FetchRecipesView()
    
    
}

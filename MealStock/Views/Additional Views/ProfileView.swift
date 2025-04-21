//
//  ProfileView.swift
//  MealStock
//
//  Created by Jiří on 24.07.2024.
//
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth
struct ProfileView: View {
    var username: String
    @StateObject private var userViewModel = UserViewModel()
    @State private var user: User?
    @State private var posts: [Post] = []
    @EnvironmentObject private var appController: AppController
    @StateObject private var postViewModel: PostViewModel = PostViewModel()
    @State private var hasPosts: Bool = false
    
    var body: some View {
            ScrollView {
                Section {
                    VStack {
                        Spacer().frame(height: 50)
                        
                        CircleImageView()
                        
                        Text("\(username)")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundStyle(Color(hex: "4e652a"))
                            .padding(.top, 20)
                        
                        Text("Lorem ipsum dolor sit amet consectetur. Id ipsum ornare ut metus. Nec amet amet amet sit. Pellentesque arcu odio consequat integer nulla ultrices. Risus gravida placerat sed tortor vel nulla nibh.")
                            .font(.body)
                            .fontWeight(.medium)
                            .foregroundStyle(Color(hex: "4e652a"))
                            .multilineTextAlignment(.center)
                            .padding()
                        
                        Spacer().frame(height: 20)
                        
                        HStack(spacing: 40) {
                            NavigationLink(destination: FollowingView()) {
                                Text("Following\n999")
                                    .foregroundStyle(Color(hex: "4e652a"))
                            }
                            
                            NavigationLink(destination: FollowersView()) {
                                Text("Followers\n999")
                                    .foregroundStyle(Color(hex: "4e652a"))
                            }
                            
                            Button {
                                
                                
                            } label: {
                                ZStack {
                                    Rectangle()
                                        .foregroundStyle(.clear)
                                        .frame(width: 95, height: 50)
                                        .background(Color(red: 0.81, green: 0.83, blue: 0.7))
                                        .cornerRadius(10)
                                    Text("Follow")
                                        .fontWeight(.bold)
                                        .font(.system(size: 20))
                                        .multilineTextAlignment(.center)
                                        .foregroundStyle(Color("accentbrown"))
                                        .frame(width: 79, height: 41, alignment: .center)
                                }
                            }
                        }
                    }
                }
                Section("Posts") {
                    if postViewModel.posts.isEmpty {
                        Text("Loading posts...")
                    } else if postViewModel.posts.filter({ $0.username == username }).isEmpty {
                        Text("There are no posts yet.")
                            .foregroundStyle(.darkgreen)
                    } else {
                        LazyVStack(spacing: 15) {
                            ForEach(postViewModel.posts.filter { $0.username == username }) { post in
                                if post.typ == .mealPlan {
                                    NavigationLink {
                                        mealPlanDetailView(for: post)
                                    } label: {
                                        mealPlanPostView(for: post)
                                    }
                                } else if post.typ == .recipe {
                                    NavigationLink {
                                        recipeDetailView(for: post)
                                    } label: {
                                        recipePostView(for: post)
                                    }
                                }
                            }
                        }
                    }
                }
                .background(Color("mainerColor").edgesIgnoringSafeArea(.all))
                .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .principal) {
                                Text("\(username)")
                                    .foregroundStyle(Color("darkgreen"))
                                    .font(.title)
                                    .fontWeight(.bold)
                            }
                        }
                .navigationBarColor(backgroundColor: .main, titleColor: .darkgreen)
                .background(Color("mainerColor"))
            }
            .onAppear {
                postViewModel.fetchPosts()
                userViewModel.fetchUsers()
            }
            .background(Color("mainerColor").edgesIgnoringSafeArea(.all))
        
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
            postViewModel: postViewModel,
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
            postViewModel: postViewModel,
            postId: post.id
        )
    }
    
    private func mealPlanDetailView(for post: Post) -> MealPlanPostDetail {
        MealPlanPostDetail(name: post.title,
            userName: post.username,
            imageName: post.imageUrl ?? "",
            description: post.content,
            mealPlan: post.mealPlan ?? MealPlan(name: "", weeks: [], days: [], description: "", cuisine: [], dailyMeals: nil),
            timestamp: post.timestamp,
            postId: post.id)
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
    NavigationStack {
        ProfileView(username: "daviddvorak")
    }
    
}

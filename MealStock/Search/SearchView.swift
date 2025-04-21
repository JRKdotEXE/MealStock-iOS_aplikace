//
//  Searching.swift
//  MealStock_koncept-v1
//
//  Created by Jiří on 01.04.2024.
//
import SwiftUI

struct SearchView: View {
    @State var searchText: String = ""
    @StateObject private var postsLookupViewModel: PostLookupViewModel = PostLookupViewModel()
    @StateObject private var tagViewModel: TagViewModel = TagViewModel()
    
    var body: some View {
        let keywordBinding = Binding<String>(
            get: {
                searchText
            },
            set: {
                searchText = $0
                postsLookupViewModel.fetchPosts(from: searchText)
            }
        )
        
        ZStack {
            Color("mainerColor").ignoresSafeArea()
            
            VStack(spacing: 20) {
                ZStack {
                    Rectangle()
                        .foregroundColor(Color("PickerMain").opacity(0.3))
                    HStack {
                        Image(systemName: "magnifyingglass")
                        TextField("Search by tag", text: keywordBinding)
                            .autocapitalization(.none)
                            
                        if !searchText.isEmpty {
                            Button {
                                searchText = ""
                                postsLookupViewModel.queriedPosts = []
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding(.horizontal, 13)
                }
                .frame(height: 40)
                .cornerRadius(13)
                .padding(.horizontal)
                
                Button {
                    postsLookupViewModel.fetchPosts(from: searchText)
                } label: {
                    Text("Search")
                        .greenButton()
                        .frame(maxWidth: .infinity)
                }
                .padding(.horizontal, 10)
                
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(tagViewModel.queriedTags, id: \.self) { i in
                            Button {
                                searchText = i
                            } label: {
                                Text("\(i)")
                                    .brownButton(height: 30)
                            }
                            
                        }
                    }
                }
                .padding(.horizontal)
                
                ScrollView {
                    if !postsLookupViewModel.queriedPosts.isEmpty {
                    ForEach(postsLookupViewModel.queriedPosts, id: \.id) { post in
                        
                            if post.typ == .recipe {
                                NavigationLink {
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
                                        postViewModel: PostViewModel(),
                                        timestamp: post.timestamp,
                                        postId: post.id,
                                        imageUrl: post.imageUrl,
                                        calories: post.recipe?.calories ?? 0,
                                        protein: post.recipe?.protein ?? 0,
                                        carbs: post.recipe?.carbs ?? 0,
                                        fat: post.recipe?.fat ?? 0,
                                        tags: post.tags
                                    )
                                } label: {
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
                                        postViewModel: PostViewModel(),
                                        postId: post.id
                                    )
                                }
                            } else if post.typ == .mealPlan {
                                NavigationLink {
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
                                } label: {
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
                        }
                    } else {
                        Text("Search for something...")
                            .foregroundStyle(.darkergreen)
                    }
                }
            }
            .onAppear {
                tagViewModel.fetchAllTags()
            }
            .padding(.top, 20)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Search")
                        .foregroundStyle(Color("darkgreen"))
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }
            }
            .navigationBarColor(backgroundColor: .main, titleColor: .darkgreen)
        }
    }
}



#Preview {
    NavigationStack {
        SearchView()
    }
}


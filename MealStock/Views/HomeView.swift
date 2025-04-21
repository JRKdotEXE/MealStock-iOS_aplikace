//
//  MealStockHomeView.swift
//  MealStock_koncept-v1
//
//  Created by Jiří on 28.12.2023.
//
import SwiftUI
import SwiftData
import FirebaseFirestore

struct HomeView: View {
    init() {
        UITabBar.appearance().backgroundColor = UIColor(named: "mainColor")
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.brown]
    }
    
    @EnvironmentObject private var appController: AppController
    @ObservedObject var postViewModel = PostViewModel()
    @ObservedObject var userViewModel = UserViewModel()
    
    @Query private var shoppingLists: [ItemList]
    @Environment(\.modelContext) private var modelContext
    
    var currentShoppingList: ItemList {
        if let existingList = shoppingLists.first {
            return existingList
        } else {
            let newList = ItemList(name: "Shopping list", 
                                 reminder: [])
            modelContext.insert(newList)
            return newList
        }
    }
    @State private var showingAlert: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack() {
                    Text("Hey, \(appController.username.isEmpty ? "Guest" : appController.username)!")
                        .padding(.top)
                        .font(Font.custom("Arial", size: 37).weight(.black))
                        .foregroundStyle(Color("darkgreen"))
                    
                    Text("MealStock helps you cook delicious meals and meet your health and diet goals.")
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.darkgreen)
                        .fontWeight(.semibold)
                        .padding(.horizontal)
                    
                    HStack {
                        NavigationLink {
                            ShopListView(reminderList: currentShoppingList)
                        } label: {
                            VStack {
                                Text(.init(systemName: "cart.fill"))
                                    .padding(.horizontal)
                                    .brownButton()
                                Text("Shopping List")
                                    .foregroundStyle(.darkergreen)
                                    .fontWeight(.semibold)
                            }
                        }
                        .padding([.leading, .trailing, .top], 10)
                    }
                    
                    Section(header: HStack(spacing: 15) {
                        Text("Current meal plan")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundStyle(.darkgreen)
                            .padding(.leading)
                            
                        Spacer()
                        Button("\(Image(systemName: "trash.fill"))", role: .destructive, action: {
                            showingAlert.toggle()
                        })
                        .alert("Remove current meal plan?", isPresented: $showingAlert) {
                            Button("Remove", role: .destructive) {
                                appController.saveCurrentMealPlanPost("")
                                appController.currentUser?.currentMealPlanPostId = ""
                                appController.currentMealPlanPost = nil
                            }
                        }
                        .padding(.trailing)
                    }.padding(.top, 10)) {
                        if let currentMealPlanPost = appController.currentMealPlanPost {
                            NavigationLink(destination: MealPlanPostDetail(
                                name: currentMealPlanPost.title,
                                userName: currentMealPlanPost.username,
                                imageName: currentMealPlanPost.imageUrl ?? "",
                                description: currentMealPlanPost.content,
                                mealPlan: currentMealPlanPost.mealPlan ?? MealPlan(name: "", weeks: [], days: [], description: "", cuisine: [], dailyMeals: nil),
                                timestamp: currentMealPlanPost.timestamp,
                                postId: currentMealPlanPost.id
                            )) {
                                MealPlanPostView(
                                    username: currentMealPlanPost.username,
                                    name: currentMealPlanPost.title,
                                    img: currentMealPlanPost.imageUrl ?? "",
                                    mealPlan: currentMealPlanPost.mealPlan ?? MealPlan(name: "", weeks: [], days: [], description: "", cuisine: [], dailyMeals: nil),
                                    timestamp: currentMealPlanPost.timestamp,
                                    postViewModel: postViewModel,
                                    postId: currentMealPlanPost.id
                                )
                            }
                        } else {
                            Text("You have not selected any meal plan yet.")
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.darkgreen)
                        }
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Menu {
                            NavigationLink("Test user profile", destination: ProfileView(username: appController.username))
                            NavigationLink("Test Fetching Recipes", destination: FetchRecipesView())
                            NavigationLink("Test Fetching Meal Plans", destination: FetchMealPlansView())
                            
                        } label: {
                            Image(systemName: "questionmark")
                                .font(.system(.title))
                                .scaleEffect(0.8)
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Home")
                        .foregroundStyle(Color("darkergreen"))
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }
            }
            .navigationBarColor(backgroundColor: .main, titleColor: .darkgreen)
            .background(Color("mainerColor"))
            .refreshable {
                Task {
                    await appController.fetchCurrentMealPlanPost()
                }
            }
        }
        .onAppear {
            Task {
                await appController.fetchCurrentMealPlanPost()
            }
        }
        .navigationBarColor(backgroundColor: .main, titleColor: .darkgreen)
        .background(Color("mainerColor"))
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
    HomeView().environmentObject(AppController())
        .modelContainer(for: [ListIem.self], inMemory: true)
}

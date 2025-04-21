import SwiftUI
import FirebaseAuth

struct RecipesView: View {
    @State private var selectedSegment = 0
    @StateObject var viewModel = PostViewModel()
    @State private var isPresentingAddRecipeView = false
    @EnvironmentObject private var appController: AppController
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 15) {
                    addButton
                    
                    SegmentedControlView(
                        selected: $selectedSegment,
                        segments: [
                            Segment(id: 0, segmentName: "Posted"),
                            Segment(id: 1, segmentName: "Favorites")
                        ]
                    )
                    
                    if selectedSegment == 0 {
                        postedRecipesList
                    } else {
                        favoriteRecipesList
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Recipes")
                            .foregroundStyle(Color("darkgreen"))
                            .font(.largeTitle)
                            .fontWeight(.bold)
                    }
                }
                .navigationBarColor(backgroundColor: .main, titleColor: .darkgreen)
                .background(Color("mainerColor"))
            }
            .background(Color("mainerColor"))
            .refreshable {
                
            }
            .onAppear {
                viewModel.fetchPosts()
            }
        }
    }
    
    private var addButton: some View {
        Button {
            isPresentingAddRecipeView.toggle()
        } label: {
            Text("Add")
                .frame(maxWidth: 350/2)
                .greenButton()
                .padding(.top)
        }
        .sheet(isPresented: $isPresentingAddRecipeView) {
            AddRecipeView()
        }
    }
    
    private var postedRecipesList: some View {
        ForEach(viewModel.posts.filter { $0.typ == .recipe && $0.username == appController.username }) { post in
            NavigationLink {
                recipeDetailView(for: post)
            } label: {
                recipePostView(for: post)
            }
        }
    }
    
    private var favoriteRecipesList: some View {
        ForEach(viewModel.getLikedPosts(type: .recipe)) { post in
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
    NavigationView {
        RecipesView().environmentObject(AppController())
    }
}

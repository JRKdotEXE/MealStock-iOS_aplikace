import SwiftUI
import FirebaseAuth

struct AccountView: View {
    @State var isPresenting: Bool = false
    @EnvironmentObject private var appController: AppController
    @ObservedObject private var userViewModel: UserViewModel = UserViewModel()
    @StateObject private var postViewModel: PostViewModel = PostViewModel()
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    Spacer().frame(height: 25)
                    
                    DefaultProfilePicture()
                    
                    Text(" \(appController.username.isEmpty ? "Guest" : appController.username)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(.darkergreen)
                        .padding(.top, 5)
                        
                    Text(appController.currentUser?.userBio ?? "")
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundStyle(.darkergreen)
                        .multilineTextAlignment(.center)
                        .padding(.all, 5)
                        .padding(.horizontal, 5)
                    
                    Spacer().frame(height: 10) 
                    
                    Spacer().frame(height: 10)
                    
                  //  HStack(spacing: 40) {
                  //      NavigationLink(destination: FollowingView()) {
                  //          Text("Following\n\(appController.currentUser?.following.count ?? 0)")
                  //              .foregroundStyle(.darkergreen)
                  //      }
                  //
                  //      NavigationLink(destination: FollowersView()) {
                  //          Text("Followers\n\(appController.currentUser?.following.count ?? 0)")
                  //              .foregroundStyle(.darkergreen)
                  //      }
                  //  }
                  //  Spacer()
                    Section(header:
                                HStack {
                        Text("Your Posts:")
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundStyle(.darkergreen)
                            .padding()
                    }
                    ) {
                        if postViewModel.posts.filter({ $0.username == appController.username }).isEmpty {
                            Text("No posts here")
                                .font(.body)
                                .foregroundStyle(.gray)
                                .padding()
                        } else {
                            ForEach(postViewModel.posts.filter({ $0.username == appController.username })) { post in
                                if post.typ == .mealPlan && post.username == appController.username {
                                    NavigationLink(destination: mealPlanDetailView(for: post)) {
                                        mealPlanPostView(for: post)
                                    }
                                } else if post.typ == .recipe && post.username == appController.username {
                                    NavigationLink(destination: recipeDetailView(for: post)) {
                                        recipePostView(for: post)
                                    }
                                }
                            }
                        }
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Menu {
                            NavigationLink("Settings", destination: SettingsView())
                            
                            Button("Log out", role: .destructive, action: {
                                do {
                                    try appController.signOut()
                                } catch {
                                    print(error.localizedDescription)
                                }
                            })
                            
                        } label: {
                            Image(systemName: "ellipsis")
                                .font(.system(.title))
                                .rotationEffect(.init(degrees: 90))
                                .scaleEffect(0.8)
                        }
                    }
                }
                .background(Color("mainerColor").edgesIgnoringSafeArea(.all))
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Profile")
                            .foregroundStyle(Color("darkgreen"))
                            .font(.largeTitle)
                            .fontWeight(.bold)
                    }
                }
                .navigationBarColor(backgroundColor: .main, titleColor: .darkgreen)
                .background(Color("mainerColor"))
            }
            .background(Color("mainerColor"))
            .refreshable {}
            .onAppear {
                postViewModel.fetchPosts()
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

struct CircleImageView: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(Color(hex: "5e7933"))
                .frame(width: 100, height: 100)
            Circle()
                .fill(Color(hex: "d9d9d9"))
                .frame(width: 98, height: 98)
        }
    }
}

struct DefaultProfilePicture: View {
    var size: CGFloat? = 100
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.main)
                .frame(width: size, height: size)
            Image(systemName: "person.crop.circle")
                .font(.system(size: (size ?? 50) - 1))
                .foregroundStyle(Color(hex: "5e7933"))
        }
        
            
    }
}

struct FollowingView: View {
    var body: some View {
        Text("Following Screen")
    }
}

struct FollowersView: View {
    var body: some View {
        Text("Followers Screen")
    }
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)

        self.init(
            .sRGB,
            red: Double((rgb & 0xFF0000) >> 16) / 255.0,
            green: Double((rgb & 0x00FF00) >> 8) / 255.0,
            blue: Double(rgb & 0x0000FF) / 255.0
        )
    }
}

struct CotentView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView().environmentObject(AppController())
        MainTabView().environmentObject(AppController())
    }
}

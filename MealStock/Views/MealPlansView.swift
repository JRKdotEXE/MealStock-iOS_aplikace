import SwiftUI

struct MealPlansView: View {
    @State private var count = 2
    @State private var selectedSegment = 0
    @State private var isPresentingAddRecipeView = false
    @StateObject var viewModel = PostViewModel()
    @EnvironmentObject private var appController: AppController
    init() {
        UITabBar.appearance().backgroundColor = UIColor(named: "mainColor")
    }
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 15) {
                    Button {
                        isPresentingAddRecipeView.toggle()
                    } label: {
                        Text("Add")
                            .frame(maxWidth: 350/2)
                            .greenButton()
                            .padding(.top)
                    }
                    .sheet(isPresented: $isPresentingAddRecipeView) {
                        AddMealPlanView()
                    }
                    
                    SegmentedControlView(
                        selected: $selectedSegment,
                        segments: [
                            Segment(id: 0, segmentName: "Posted"),
                            Segment(id: 1, segmentName: "Saved")
                        ]
                    )
                    
                    if selectedSegment == 0 {
                        postedMealPlansList
                    } else {
                        favoriteMealPlansList
                    }
                }
            }
            
            .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            Text("Meal plans")
                                .foregroundStyle(Color("darkgreen"))
                                .font(.largeTitle)
                                .fontWeight(.bold)
                        }
                    }
            .navigationBarColor(backgroundColor: .main, titleColor: .darkgreen)
            .background(Color("mainerColor"))
            .refreshable {}
            .onAppear {
                viewModel.fetchPosts()
            }
        }
    }
    
    private var postedMealPlansList: some View {
        ForEach(viewModel.posts.filter { $0.typ == .mealPlan && $0.username == appController.username }) { post in
            NavigationLink {
                mealPlanDetailView(for: post)
            } label: {
                mealPlanPostView(for: post)
            }
        }
    }
    
    private var favoriteMealPlansList: some View {
        ForEach(viewModel.getLikedPosts(type: .mealPlan)) { post in
            NavigationLink {
                mealPlanDetailView(for: post)
            } label: {
                mealPlanPostView(for: post)
            }
        }
    }
    
    private func mealPlanDetailView(for post: Post) -> MealPlanPostDetail {
        MealPlanPostDetail(name: post.title,
                           userName: post.username,
                           imageName: post.imageUrl ?? "",
                           description: post.content,
                           mealPlan: post.mealPlan ?? MealPlan(name: "", weeks: [], days: [], description: "", cuisine: [], dailyMeals: nil),
                           postViewModel: viewModel,
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
struct RecNavLink<Destination: View>: View {
    var linkto: Destination
    var text: String
    
    init(linkto: Destination, text: String) {
        self.linkto = linkto
        self.text = text
    }
    
    var body: some View {
        NavigationLink(destination: linkto) {
            Text(verbatim: text)
                .frame(width: 200*0.75, height: 70)
                .background(Color(red: 0.81, green: 0.83, blue: 0.7))
                .foregroundStyle(Color("accentbrown"))
                .font(.system(size: 15, weight: .bold))
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}

#Preview {
    MealPlansView().environmentObject(AppController())
}

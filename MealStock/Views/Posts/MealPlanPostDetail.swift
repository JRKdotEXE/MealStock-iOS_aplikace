//
//  MealPlanPostDetail.swift
//  MealStock
//
//  Created by Jiří on 28.07.2024.
//
import SwiftUI
import FirebaseAuth

struct MealPlanPostDetail: View {
    @State private var isFavorite: Bool = false
    var name: String
    var userName: String
    var imageName: String
    @State var likes: Int = 0
    var description: String
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @EnvironmentObject private var appController: AppController
    var mealPlan: MealPlan
    @State private var input = ""
    @State private var comments: [Comment] = [.placeholder]
    
    @ObservedObject var postViewModel: PostViewModel = PostViewModel()
    
    @State var timestamp: Date
    var formattedTimestamp: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: timestamp)
    }
    @State private var showingAlert = false
    
    
    let postId: String

    
    var imageUrl: String?
    
    @State var weeksCount: Int = 1
    
    @ObservedObject var userViewModel: UserViewModel = UserViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 15) {
                    headerSection
                    
                    AsyncImage(url: URL(string: imageUrl ?? "")) { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: .infinity)
                            .clipped()
                    } placeholder: {
                        ZStack {
                            Rectangle()
                                .fill(.lightergray)
                                .frame(height: 350)
                                .frame(maxWidth: .infinity)
                                .clipShape(.rect(cornerRadius: 10))
                            ProgressView()
                        }
                    }
                    
                    HStack() {
                        Spacer()
                        Text(formattedTimestamp)
                            .font(.subheadline)
                        Spacer()
                        likeViewSaveCounts
                        Spacer()
                    }
                    .foregroundStyle(.gray)
                    
                    actionButtons
                    
                    profileLink
                    
                    descriptionSection
                    
                    VStack(alignment: .leading, spacing: 15) {
                        ForEach(mealPlan.days.indices, id: \.self) { index in
                            NavigationLink(destination: DaysInMealPlanView(dayName: mealPlan.days[index].name, meals: mealPlan.days[index].recipes)) {
                                Text(mealPlan.days[index].name)
                                    .font(.headline)
                                    .tint(.accentbrown)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(8)
                            .shadow(radius: 2)
                        }
                    }
                    .padding()
                }
                .padding([.top, .bottom], 15)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarColor(backgroundColor: .main, titleColor: .darkgreen)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button("Save as your current meal plan", action: {
                            appController.saveCurrentMealPlanPost(postId)
                            showingAlert = true
                        })
                       // Button("Share", action: {})
                      //  Button("Delete", role: .destructive, action: {})
                    } label: {
                        Image(systemName: "ellipsis")
                            .font(.system(.title))
                            .rotationEffect(.init(degrees: 90))
                            .scaleEffect(0.8)
                    }
                }
            }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Saved as your current meal plan"), message: Text("This meal plan was saved as your current meal plan. You can access it from your home page."), dismissButton: .default(Text("Got it!")))
            }
            .toolbarBackground(Color("mainColor"), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .background(Color("2mainer"))
        
        .onAppear {
            isFavorite = postViewModel.checkIfPostLiked(postId: postId)
            postViewModel.listenToPostLikes(postId: postId)
            if let post = postViewModel.posts.first(where: { $0.id == postId }) {
                likes = post.likes
            }
            postViewModel.fetchPosts()
            postViewModel.fetchComments(postId: postId) { fetchedComments in
                comments = fetchedComments
            }
        }
        .refreshable {
            postViewModel.listenToPostLikes(postId: postId)
            if let post = postViewModel.posts.first(where: { $0.id == postId }) {
                likes = post.likes
            }
        }
    }
    }
    private var headerSection: some View {
        HStack {
            Text(mealPlan.name)
.font(.custom("HelveticaNeue-Medium", size: 25))
                    .fontWeight(.bold)
                    .foregroundStyle(.accentbrown)
                    .padding(.leading)
                Spacer()
            }
        }
        
        private var actionButtons: some View {
            HStack {
                Spacer()
                Button(action: {
                    guard let userId = Auth.auth().currentUser?.uid else { return }
                    postViewModel.toggleLike(postId: postId, userId: userId)
                    isFavorite.toggle()
                }) {
                    Image(systemName: isFavorite ? "bookmark.fill" : "bookmark")
                        .font(.system(size: 35))
                        .padding(.trailing)
                }
                Spacer()
                NavigationLink(destination: commentsSection) {
                    Image(systemName: "text.bubble")
                        .font(.system(size: 35))
                        .padding(.trailing)
                }
                Spacer()
               // Button(action: {
               //
               // }) {
               //     Image(systemName: "square.and.arrow.up")
               //         .font(.system(size: 35))
               //         .padding(.trailing)
               // }
               // Spacer()
            }
            .padding([.top, .bottom], 10)
        }
        
        private var likeViewSaveCounts: some View {
            HStack {
                Text("\(likes)")
                Image(systemName: "bookmark")
                Spacer().frame(width: 15)
            } .multilineTextAlignment(.center)
                .font(.system(size: 17))
                .foregroundStyle(Color.gray)
                .padding(.leading)
        }
        
        private var profileLink: some View {
            NavigationLink(destination: ProfileView(username: userName)) {
                HStack {
                    DefaultProfilePicture(size: 40)
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                    VStack(alignment: .leading) {
                        Text(userName)
                            .fontWeight(.bold)
                            .foregroundStyle(.accentbrown)
                    }
                }
            }
        }
        
        private var descriptionSection: some View {
            VStack(alignment: .leading, spacing: 10) {
                Text("Description")
                    .font(.headline)
                    .foregroundStyle(.accentbrown)
                    .padding(.horizontal)
                
                Text(mealPlan.description ?? "")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .foregroundStyle(.accentbrown)
            }
        }
        
        private var weekListSection: some View {
            VStack(alignment: .leading) {
            Section(header:
                        HStack {
                Text("Weeks")
                    .font(.headline)
                    .foregroundStyle(.accentbrown)
                    .padding(.leading, 35)
            }
            ) {
                LazyVStack(alignment: .leading, spacing: 15) {
                    ForEach(mealPlan.weeks.indices, id: \.self) { index in
                        let week = mealPlan.weeks[index]
                        NavigationLink(destination: WeekView(name: "Week \(index + 1)", week: week)) {
                            Text("Week \(index + 1)")
                                .font(.headline)
                                .tint(.accentbrown)
                                .padding(.vertical, 10)
                                .frame(maxWidth: .infinity)
                                .background(Color.white)
                                .cornerRadius(8)
                                .shadow(radius: 2)
                        }
                    }
                }
                .padding()
            }
        }
            }
        
    private var commentsSection: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    Section(header:
                                HStack {
                        Text("Comments")
                            .font(.headline)
                            .foregroundStyle(.primary)
                            .padding(.leading, 35)
                        Spacer()
                    }) {
                        VStack {
                            TextField("Describe yourself", text: $input, axis: .vertical)
                                .textFieldStyle(.roundedBorder)
                                .lineLimit(3, reservesSpace: true)
                                .padding(.horizontal, 30)
                            
                            HStack {
                                Spacer()
                                Button(action: {
                                    guard !input.isEmpty else { return }
                                    postViewModel.addComment(
                                        postId: postId,
                                        content: input,
                                        author: userName
                                    )
                                    input = ""
                                }, label: {
                                    Text("Post")
                                        .brownButton(height: 50)
                                })
                                .padding(.horizontal, 30)
                            }
                            
                            ForEach(comments) { comment in
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text(comment.author)
                                            .font(.headline)
                                            .padding(.leading)
                                        Spacer()
                                    }
                                    
                                    Text(comment.content)
                                        .padding(.leading)
                                }
                                .padding(.vertical, 10)
                                .frame(maxWidth: .infinity)
                                .background(Color.white)
                                .cornerRadius(8)
                                .shadow(radius: 2)
                            }
                            .padding(30)
                        }
                    }
                    Spacer()
                }
            }
            .refreshable {
                postViewModel.fetchComments(postId: postId) { fetchedComments in
                    comments = fetchedComments
                }
            }
            .onAppear {
                postViewModel.fetchComments(postId: postId) { fetchedComments in
                    comments = fetchedComments
                }
            }
        }
    }
    }

    struct MealView: View {
        var meal: Recipe
        
        var body: some View {
            VStack(alignment: .leading, spacing: 5) {
                NavigationLink(destination: RecipeFromMealPlanView(recipe: meal)) {
                    Text(meal.name)
                        .font(.headline)
                        .tint(.accentbrown)
                }
            }
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(8)
            .shadow(radius: 2)
        }
    }

struct WeekView: View {
    var name: String = "Week"
    var week: Week
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    ForEach(week.days.indices, id: \.self) { index in
                        let day = week.days[index]
                        NavigationLink(destination: DaysInMealPlanView(dayName: day.name, meals: day.recipes)) {
                            Text(day.name)
                                .font(.headline)
                                .tint(.accentbrown)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(radius: 2)
                    }
                }
                .padding()
                .toolbarBackground(Color("mainColor"), for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text(name)
                            .foregroundStyle(.darkgreen)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                    }
                }
            }
            .background(Color("2mainer"))
        }
    }
}

extension MealPlanPostDetail {
    static var placeholder: Self {
        Self(
            name: "Healthy meals",
            userName: "ItalianChef22",
            imageName: "Spaghetti carbonara",
            description: "desc",
            mealPlan: .sampleMealPlan,
            timestamp: Date(), postId: UUID().uuidString
        )
    }

    static var placeholder2: Self {
        Self(name: "Healthier Meals", userName: "TheNutritionist", imageName: "Spaghetti carbonara", description: "The best meal plan ever for your health and well-being.", mealPlan: MealPlan.sampleMealPlan, timestamp: Date(), postId: UUID().uuidString)
    }
}

#Preview {
    NavigationStack {
        MealPlanPostDetail(
            name: "Meal Plan Name",
            userName: "ItalianChef22",
            imageName: "Spaghetti carbonara",
            description: "This is just a placeholder recipe. This is just a placeholder recipe. This is just a placeholder recipe. This is just a placeholder recipe. This is just a placeholder recipe. This is just a placeholder recipe. This is just a placeholder recipe. This is just a placeholder recipe. ",
            mealPlan: .mealPlanWithDays,
            timestamp: Date(),
            postId: UUID().uuidString,
            imageUrl: "https://www.themealdb.com/images/media/meals/1525872624.jpg",
            weeksCount: 2
        )
        
    }
}

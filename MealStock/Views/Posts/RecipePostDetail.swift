//
//  PostView.swift
//  MealStock_koncept-v1
//
//  Created by Jiří on 14.05.2024.
//
import SwiftUI
import SwiftData
import FirebaseAuth

struct RecipePostDetail: View {
    @State private var liked: Bool = false
    var name: String
    var userName: String
    var imageName: String = ""
    @State var likes: Int = 0
    var description: String
    var views: Int = 0
    var instructions: [String]
    var ingredients: [Ingredient] = []

    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @EnvironmentObject private var appController: AppController
    var recipe: Recipe
    @State private var input = ""
    @State private var comments: [Comment] = [.placeholder]
    @ObservedObject var postViewModel: PostViewModel = PostViewModel()
    let timestamp: Date
    var formattedTimestamp: String {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .short
            return formatter.string(from: timestamp)
    }
    @State private var showIngredientsAdded: Bool = false
    
    let postId: String
    
    var imageUrl: String? = nil //https://picsum.photos/200
    var calories: Int
    var protein: Int
    var carbs: Int
    var fat: Int
    var tags: [String] = []
    
    @Query private var shoppingLists: [ItemList]
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
            ScrollView {
                VStack(spacing: 15) {
                  //  if showIngredientsAdded {
                  //      VStack(spacing: 5)  {
                  //          HStack {
                  //              Text("Ingredients Added to your Shopping list")
                  //              Text(.init(systemName: "cart.fill"))
                  //          }
                  //          Button() {
                  //
                  //              showIngredientsAdded = false
                  //          } label: {
                  //              Image(systemName: "xmark")
                  //          }
                  //      }
                  //
                  //  }
                    
                    HStack {
                        Text(name)
                            .font(.custom("HelveticaNeue-Medium", size: 25))
                            .fontWeight(.bold)
                            .foregroundStyle(.darkergreen)
                            .padding(.leading)
                        Spacer()
                    }
                    
                        AsyncImage(url: URL(string: imageUrl ?? "")) { image in
                            image.resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity)
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
                        HStack {
                            Text("\(likes)")
                            Image(systemName: "star")
                        } .multilineTextAlignment(.center)
                            .font(.system(size: 17))
                            .foregroundStyle(Color.gray)
                            .padding(.leading)
                        Spacer()
                    }
                    .foregroundStyle(.gray)
                    
                    HStack {
                        Spacer()
                        Button(action: {
                            guard let userId = Auth.auth().currentUser?.uid else { return }
                            postViewModel.toggleLike(postId: postId, userId: userId)
                            liked.toggle()
                        }) {
                            Image(systemName: liked ? "star.fill" : "star")
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
                    }
                    .padding([.top, .bottom], 10)

                    
                    NavigationLink(destination: ProfileView(username: userName)) {
                        HStack {
                            DefaultProfilePicture(size: 40)
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                            VStack(alignment: .leading) {
                                Text(userName)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.darkgreen)
                            }
                        }
                    }
                    .padding(.vertical)
                    
                    VStack(alignment: .center, spacing: 10) {
                        Text("Description")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        Text(description)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                        
                        HStack {
                            Text("\(calories) calories")
                            Text("\(protein)g of protein")//FIX THE UNIT
                        }
                        .fontWeight(.semibold)
                        
                        HStack {
                            Text("\(fat)g of fat") //FIX THE UNIT
                            Text("\(carbs)g of carbs")//FIX THE UNIT
                        }
                        .fontWeight(.semibold)
                        
                        Text("Tags: \(tags.joined(separator: ", "))")
                    }
                    .foregroundStyle(.darkergreen)
                    
                    Text("Ingredients")
                        .font(.headline)
                        .foregroundStyle(.darkergreen)
                        .padding(.leading)
                    
                    LazyVStack(alignment: .center, spacing: 5) {
                        ForEach(ingredients, id: \.self) { ingredient in
                            Text("• \(Int(ingredient.quantity)) \(ingredient.unit == .none ? "pcs" : String(describing: ingredient.unit)) of \(ingredient.name)")
                                .foregroundStyle(.darkergreen)
                                .padding(.leading)
                        }
                    }
                    .padding(.leading, 10)

                    Text("Instructions")
                        .font(.headline)
                        .foregroundStyle(.darkergreen)
                        .padding([.top, .leading])
                    
                    LazyVStack(alignment: .center, spacing: 10) {
                        ForEach(instructions, id: \.self) { instruction in
                            Text("• \(instruction)")
                                .padding(.leading)
                                .foregroundStyle(.darkergreen)
                        }
                    }
                    .padding(.leading, 10)
                }
                .padding([.top, .bottom], 15)
            }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("")
                    .font(.largeTitle)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                  //  Button("Ingredients to 🛒", action: {
                  //      showIngredientsAdded = true
                  //  })
                    Button("Share", action: {})
                    Button("Delete", role: .destructive, action: {})
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.system(.title))
                        .rotationEffect(.init(degrees: 90))
                        .scaleEffect(0.8)
                }
            }
        }
        .toolbarBackground(Color("mainColor"), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .background(Color("mainerColor"))
        .onAppear {
            liked = postViewModel.checkIfPostLiked(postId: postId)
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
    
    private var commentsSection: some View {
        NavigationStack {
            VStack {
                Section(header: HStack {
                    Text("Comments")
                        .font(.headline)
                        .foregroundStyle(.primary)
                        .padding(.leading, 35)
                    Spacer()
                }) {
                    VStack {
                        TextField("Add a comment...", text: $input, axis: .vertical)
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
                                    author: appController.currentUser?.username ?? ""
                                )
                                input = ""
                            }, label: {
                                Text("Post")
                                    .brownButton(height: 50)
                            })
                            .padding(.horizontal, 30)
                        }
                        
                        ForEach(comments) { comment in
                            CommentView(comment: comment)
                        }
                        .padding(30)
                    }
                }
                Spacer()
            }
            .onAppear {
                postViewModel.fetchComments(postId: postId) { fetchedComments in
                    comments = fetchedComments
                }
            }
        }
    }
}

extension RecipePostDetail {
    static var placeholder: Self {
        Self(
            name: "Spaghetti Carbonara",
            userName: "ItalianChef22",
            imageName: "Spaghetti carbonara",
            description: "This is my favorite spaghetti carbonara recipe! It's simple, delicious, and perfect for a weeknight dinner. It's also easy to customize to suit your taste preferences. Enjoy!  ",
            views: 7777,
            instructions: [
                "Cook the spaghetti: Bring a large pot of salted water to a boil. Add the spaghetti and cook according to the package instructions until al dente.",
                "Prepare the sauce: While the spaghetti is cooking, heat a drizzle of olive oil in a large skillet over medium heat. Add the diced pancetta or guanciale and cook until golden and crispy, about 5-7 minutes. Remove the skillet from the heat and set aside.",
                "Prepare the egg mixture: In a mixing bowl, whisk together the eggs, grated Pecorino Romano cheese, and grated Parmigiano-Reggiano cheese until well combined. Season with freshly ground black pepper to taste.",
                "Combine everything: Once the spaghetti is cooked, drain it, reserving about 1 cup of the pasta cooking water. Add the hot spaghetti to the skillet with the pancetta and toss well.",
                "Add the egg mixture: Remove the skillet from heat and quickly toss with the egg and cheese mixture. Add reserved pasta water if needed."
            ],
            ingredients: [
                Ingredient(name: "Spaghetti", quantity: 1, unit: .none)
            ],
            recipe: Recipe(id: "", name: "", description: "", author: "", ingredients: [], category: .any, instructions: [], calories: 1, protein: 1, carbs: 1, fat: 1),
            postViewModel: PostViewModel(),
            timestamp: Date(),
            postId: "1",
            calories: 1,
            protein: 1,
            carbs: 1,
            fat: 1,
            tags: ["Italian", "Spaghetti", "Pasta", "Dinner"]
        )
    }
    
    static var placeholder2: Self {
        Self(name: "Fish and chips",
             userName: "BritishLad",
             imageName: "Fish and chips",
             description: "This is a great recipe for fish and chips. It's easy to make and tastes great!",
             views: 57,
             instructions: [
            "Instructions go here",
            "first: ",
            "second: ",
            "third: "
             ], ingredients: [Ingredient(name: "oil", quantity: 2, unit: .tsp), Ingredient(name: "fish", quantity: 1, unit: .none)], recipe: Recipe(id: "", name: "", description: "", author: "", ingredients: [], category: .any, instructions: [], calories: 1, protein: 1, carbs: 1, fat: 1), postViewModel: PostViewModel(),
             timestamp: Date(), postId: "2",
             imageUrl: "https://picsum.photos/200",
             calories: 1,
             protein: 1,
             carbs: 1,
             fat: 1,
             tags: ["British", "Fish", "Chips", "Dinner"]
        )
    }
}

#Preview {
    NavigationStack {
        RecipePostDetail.placeholder2
    }
}

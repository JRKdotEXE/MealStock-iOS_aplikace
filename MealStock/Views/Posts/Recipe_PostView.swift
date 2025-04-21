//
//  MealStockRecipePostView.swift
//  MealStock_koncept-v1
//
//  Created by Jiří on 04.01.2024.
//
import SwiftUI
import FirebaseAuth

struct Recipe_PostView: View {
    var username: String
    var mealname: String
    var img: String
    var recipe: Recipe
    var timestamp: Date
    @ObservedObject var postViewModel: PostViewModel
    let postId: String
    
    @State private var isFavorite: Bool = false
    @State private var isSaved = false
    
    var formattedTimestamp: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter.string(from: timestamp)
    }
    
    var body: some View {
        VStack {
            Text("Recipe")
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.darkgreen)
                .padding(.top, 5)
            
            AsyncImage(url: URL(string: img)) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 328, height: 200)
                        .clipped()
                        .cornerRadius(10)
                } placeholder: {
                    ZStack {
                        Rectangle()
                            .fill(.lightergray)
                            .frame(width: 328, height: 200)
                            .clipShape(.rect(cornerRadius: 10))
                        ProgressView()
                    }
                }
            VStack(alignment: .leading, spacing: 5) {
                
                Text(recipe.name)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(.darkgreen)
                    .padding(.leading, 5)
                HStack {
                    Text(recipe.author)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.darkgreen)
                        .padding(.leading, 5)
                    Spacer()
                    Text(formattedTimestamp)
                        .font(.system(size: 14, weight: .light))
                        .foregroundStyle(.darkgreen)
                        .padding(.trailing, 25)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 20)
            
            HStack(spacing: 50) {
                Button(action: {
                    guard let userId = Auth.auth().currentUser?.uid else { return }
                    postViewModel.toggleLike(postId: postId, userId: userId)
                    isFavorite.toggle()
                }) {
                    Image(systemName: isFavorite ? "star.fill" : "star")
                        .foregroundStyle(.darkgreen)
                        .frame(width: 64, height: 38)
                        .background(Color(red: 248/255, green: 237/255, blue: 208/255))
                        .cornerRadius(6)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(.darkgreen)
                        )
                }
                
                Menu {
                    Button("Delete", role: .destructive, action: {
                    })
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundStyle(.darkgreen)
                        .frame(width: 64, height: 38)
                        .background(Color(red: 248/255, green: 237/255, blue: 208/255))
                        .cornerRadius(6)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(.darkgreen, lineWidth: 1)
                        )
                }
            }.padding(.bottom)
        }
        .background(Color(red: 241/255, green: 216/255, blue: 156/255))
        .cornerRadius(10)
        .frame(maxWidth: 370)
        .padding([.bottom], 10)
        .padding(.top, 5)
        .padding(.horizontal, 10)
        .onAppear {
            isFavorite = postViewModel.checkIfPostLiked(postId: postId)
            postViewModel.listenToPostLikes(postId: postId)
        }
    }
}
extension Recipe_PostView {
    static var placeholder: Self {
        Recipe_PostView(
            username: "BritishLad",
            mealname: "Fish and chips",
            img: "https://picsum.photos/200",
            recipe: Recipe(
                name: "Fish and chips",
                description: "Description of the meal goes here ... and here ... and here ... \n",
                author: "BritishLad",
                ingredients: [],
                category: .any,
                instructions: [],
                calories: 0, protein: 0, carbs: 0, fat: 0
            ),
            timestamp: Date(),
            postViewModel: PostViewModel(),
            postId: "postId1"
        )
    }
    
    static var placeholder2: Self {
        Recipe_PostView(
            username: "ItalianChef22",
            mealname: "Spaghetti carbonara",
            img: "https://picsum.photos/200",
            recipe: Recipe(
                name: "Spaghetti carbonara",
                description: "Description of the meal goes",
                author: "ItalianChef22",
                ingredients: [],
                category: .dinner,
                instructions: [],
                calories: 0, protein: 0, carbs: 0, fat: 0
            ),
            timestamp: Date(),
            postViewModel: PostViewModel(),
            postId: "postId2"
        )
    }
}
struct CornerRadiusStyle: ViewModifier {
    var radius: CGFloat
    var corners: UIRectCorner
    
    func body(content: Content) -> some View {
        content.clipShape(RoundedCornerR(radius: radius, corners: corners))
    }
}

struct RoundedCornerR: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCornerR(radius: radius, corners: corners))
    }
}

struct Recipe_PostView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            NavigationStack {
                NavigationLink(destination: RecipePostDetail.placeholder2) {
                    Recipe_PostView.placeholder
                }
                
                NavigationLink(destination: RecipePostDetail.placeholder) {
                    Recipe_PostView.placeholder2
                }
            }
        }
    }
}



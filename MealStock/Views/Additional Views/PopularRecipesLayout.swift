import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift


struct PopularRecipesLayout: View {
    @ObservedObject var postViewModel = PostViewModel()

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                Text("Today’s Popular recipes")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(.darkgreen)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 5)
                    .offset(x: 11.50, y: 11.50)
                
                ScrollView(.horizontal) {
                    VStack {
                        LazyHStack(spacing: 18) {
                            ForEach(postViewModel.posts) { post in
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
                                    } label: {
                                        SmallerSizedPost(image: post.imageUrl ?? "", title: post.title)
                                    }
                                }
                            }.padding(.vertical, 10)
                        }
                        
                        .padding(.horizontal, 18)
                        
                    }
                }
                Spacer()
            }
            .background(Color(red: 248/255, green: 237/255, blue: 208/255))
            .cornerRadius(10)
            .frame(maxWidth: .infinity, maxHeight: 251)
            .clipped()
            .padding(.horizontal, 15)
        }
        .onAppear {
            postViewModel.fetchPosts()
        }
    }
    }

struct SmallerSizedPost: View {
    var image: String?
    var title: String
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(red: 237/255, green: 217/255, blue: 164/255))
                .frame(width: 215, height: 176)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.darkgreen, lineWidth: 1)
                )
            
            VStack {
                AsyncImage(url: URL(string: image ?? "")) { img in
                        img.resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 183, height: 104)
                            .clipped()
                            .clipShape(
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                            )
                    } placeholder: {
                        ZStack {
                            Rectangle()
                                .fill(.lightergray)
                                .frame(width: 183, height: 104)
                                .clipShape(.rect(cornerRadius: 10))
                            ProgressView()
                        }
                    }
                    .padding(.top, 8)
                
                Spacer()
                
                Text(title)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(.darkgreen)
                    .frame(height: 20)
                    .padding(.horizontal)
                
                Spacer()
            }
            .frame(width: 215, height: 176)
        }
    }
}

#Preview {
    NavigationStack {
            PopularRecipesLayout()
    }
}

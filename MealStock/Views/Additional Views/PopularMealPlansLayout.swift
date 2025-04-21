//
//  PopularMealPlansLayout.swift
//  MealStock
//
//  Created by Jiří on 22.08.2024.
//
import SwiftUI

struct PopularMealPlansLayout: View {
    @ObservedObject var postViewModel = PostViewModel()
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                Text("Today’s Meal Plans")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(.accentbrown)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 5)
                    .offset(x: 11.50, y: 11.50)
                ScrollView(.horizontal) {
                    VStack {
                        LazyHStack(spacing: 18) {
                            ForEach(postViewModel.posts) { post in
                                if post.typ == .mealPlan {
                                    NavigationLink {
                                        MealPlanPostDetail(
                                            name: post.title,
                                            userName: post.username,
                                            imageName: "Spaghetti carbonara",
                                            likes: 77,
                                            description: post.content,
                                            mealPlan: .sampleMealPlan,
                                            timestamp: post.timestamp,
                                            postId: post.id
                                        )
                                    } label: {
                                        SmallerSizedMealPlanPost(image: "Spaghetti carbonara", title: post.title)
                                    }
                                }
                            }.padding(.vertical, 10)
                        }
                        
                        .padding(.horizontal, 18)
                        
                    }
                }
                Spacer()
            }
            .background(Color("lightergreen"))
            .cornerRadius(10)
            .frame(width: 372, height: 251)
            .clipped()
            .padding()
        }
        .onAppear {
            postViewModel.fetchPosts()
        }
    }
    }

struct SmallerSizedMealPlanPost: View {
    @State var image: String = "Fish and chips"
    @State var title: String = "Fish and chips"
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.lightgreen)
                .frame(width: 215, height: 176)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.accentbrown, lineWidth: 1)
                )
            
            VStack {
                Image(image)
                    .resizable()
                    .frame(width: 183, height: 104)
                    .clipped()
                    .clipShape(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.accentbrown, lineWidth: 1)
                    )
                    .padding(.top, 8)
                
                Spacer()
                
                Text(title)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(.accentbrown)
                    .frame(height: 20)
                
                Spacer()
            }
            .frame(width: 215, height: 176)
            
            Circle()
                .fill(Color(red: 0.85, green: 0.85, blue: 0.85, opacity: 1.00))
                .frame(width: 48, height: 44)
                .overlay(
                    Circle()
                        .stroke(Color.accentbrown, lineWidth: 1)
                )
                .position(x: 167, y: 113)
        }
    }
}

#Preview {
    PopularMealPlansLayout()
}

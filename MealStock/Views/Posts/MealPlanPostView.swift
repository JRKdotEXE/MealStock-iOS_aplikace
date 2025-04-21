//
//  MealPlanPostView.swift
//  MealStock
//
//  Created by Jiří on 26.07.2024.
//
import SwiftUI
import FirebaseAuth

extension MealPlanPostView {
    static var placeholder: Self {
        MealPlanPostView(username: "username", name: "Meal Plan", img: "https://picsum.photos/200", mealPlan: .sampleMealPlan, timestamp: Date(), postViewModel: PostViewModel(),  postId: "postId1")
    }
}

struct MealPlanPostView: View {
    @State public var username: String
    @State public var name: String
    @State public var img: String
    @State var mealPlan: MealPlan
    @State var timestamp: Date
    @StateObject var postViewModel: PostViewModel
    @EnvironmentObject private var appController: AppController
    var postId: String
    
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
            Text("Meal plan")
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.accentbrown)
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
            
            VStack(alignment: .leading) {
                Text(mealPlan.name)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(.accentbrown)
                    .padding(.leading, 5)
                HStack {
                    Text(username)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.accentbrown)
                        .padding(.leading, 5)
                    Spacer()
                    Text(formattedTimestamp)
                        .font(.system(size: 14, weight: .light))
                        .foregroundStyle(.accentbrown)
                        .padding(.trailing, 25)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 20)
            
            HStack(spacing: 50) {
                Menu {
                    Button("Delete", role: .destructive, action: {
                    })
                    Button("Save as your current meal plan", action: {
                        appController.saveCurrentMealPlanPost(postId)
                    })
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundStyle(.accentbrown)
                        .frame(width: 64, height: 38)
                        .background(Color(red: 248/255, green: 237/255, blue: 208/255))
                        .cornerRadius(6)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(.accentbrown, lineWidth: 1)
                        )
                }
            }.padding(.bottom)
        }
        .background(.lightgreen)
        .cornerRadius(10)
        .frame(maxWidth: 370)
        .padding([.bottom], 10)
        .padding(.top, 5)
        .padding(.horizontal, 10)
    }
}



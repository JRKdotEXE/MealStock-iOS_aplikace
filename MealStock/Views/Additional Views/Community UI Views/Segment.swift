//
//  Segment.swift
//  MealStock
//
//  Created by Jiří on 20.07.2024.
//
import SwiftUI

struct Segment: Identifiable {
    var id: Int
    var segmentName: String
}

struct SegmentedControlView: View {
    
    @Binding var selected: Int
    var segments: [Segment]
    
    var body: some View {
        HStack {
            ForEach(segments) { segment in
                Button(action: {
                    withAnimation {
                        self.selected = segment.id
                    }
                }) {
                    Text(segment.segmentName)
                        .padding(.horizontal, 10)
                        .font(.custom("HelveticaNeue-Medium", size: 20))
                        .foregroundStyle(.darkgreen)
                        .background(self.selected == segment.id ? .pickerMain : Color.clear)
                        .cornerRadius(5)
                    
                }
                .frame(maxWidth: .infinity, maxHeight: 50)
            }
        }
        .background(Color.mainer)
        .clipShape(Capsule())
    }
}

struct SegmentsSocials: View {
    @State private var selectedView = 0
    @State private var selectedTheme = "All"
    let themes = ["All", "Meal plans", "Recipes"]
    
    var body: some View {
        VStack {
            SegmentedControlView(selected: $selectedView, segments: [
                Segment(id: 0, segmentName: "Following"),
                Segment(id: 1, segmentName: "Discover"),
                Segment(id: 2, segmentName: "Forum")
            ])
            .padding(.all, 5)

            switch selectedView {
            case 0:
                ScrollView {
                    VStack(spacing: 10) {
                        FollowingProfiles()
                        
                        HStack(spacing: 5) {
                            Text("Filter")
                                .font(.headline)
                                .foregroundStyle(.darkergreen)
                            
                            Picker("Appearance", selection: $selectedTheme) {
                                ForEach(themes, id: \.self) {
                                    Text($0)
                                }
                            }
                            .pickerStyle(.menu)
                            .foregroundStyle(.accentbrown)
                            
                        }.frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(.trailing)

                        if selectedTheme == "Recipes" {
                            FetchRecipesView()
                        } else if selectedTheme == "Meal plans" {
                            NavigationLink(destination: MealPlanPostDetail.placeholder) {
                                MealPlanPostView.placeholder
                            }
                            FetchMealPlansView()
                        } else if selectedTheme == "All" {
                            NavigationLink(destination: MealPlanPostDetail.placeholder) {
                                MealPlanPostView.placeholder
                                }
                            
                            NavigationLink(destination: MealPlanPostDetail.placeholder) {
                                MealPlanPostView.placeholder
                                }
                            
                            FetchRecipesView()
                            
                            }
                        }
                    }
            case 1:
                ScrollView {
                    VStack(spacing: 10) {
                        PopularRecipesLayout()
                        
                        HStack(spacing: 5) {
                            Text("Filter")
                                .font(.headline)
                                .foregroundStyle(.darkergreen)
                            
                            Picker("Appearance", selection: $selectedTheme) {
                                ForEach(themes, id: \.self) {
                                    Text($0)
                                }
                            }
                            .pickerStyle(.menu)
                            .foregroundStyle(.accentbrown)
                            
                        }.frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(.trailing)
                        
                        if selectedTheme == "Recipes" {
                            FetchRecipesView()
                                
                            
                        } else if selectedTheme == "Meal plans" {
                            NavigationLink(destination: MealPlanPostDetail.placeholder) {
                                VStack {
                                    MealPlanPostView.placeholder
                                    FetchMealPlansView()
                                }
                            }
                        } else if selectedTheme == "All" {
                            ForEach(0..<2, id: \.self) { _ in
                                NavigationLink(destination: RecipePostDetail.placeholder) {
                                    Recipe_PostView.placeholder
                                }
                            }
                            
                            NavigationLink(destination: MealPlanPostDetail.placeholder) {
                                MealPlanPostView.placeholder
                            }
                            
                            FetchRecipesView()
                            }
                    }
                }
                
            case 2:
                ScrollView {
                    VStack(spacing: 25) {
                        ForEach(0..<2, id: \.self) { _ in
                            ForumPostCell(profilePic: "postImage2_3115", titleText: "Lorem Ipsum dolor sit amet", desc: "Lorem Ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.")
                                .padding(.horizontal, 15)
                        }
                    }
                }
                
            default:
                Text("Nothing here")
            }
        }
    }
}

struct Segments_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SegmentsSocials()
        }
    }
}

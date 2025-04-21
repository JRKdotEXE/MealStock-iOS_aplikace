//
//  MealStockSocialView.swift
//  MealStock_koncept-v1
//
//  Created by Jiří on 25.10.2023.
//
import SwiftUI

struct CommunityView: View {
    @State private var searchText = ""
    @State private var isPresentingAddRecipeView = false
    @EnvironmentObject private var appController: AppController
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 15) {
                    NavigationLink {
                        SearchView()
                    } label: {
                        Label(title: {
                            Text("Search")
                                
                        }, icon: {
                            Image(systemName: "magnifyingglass")
                        })
                        .frame(maxWidth: .infinity)
                        .greenButton()
                        .padding(.horizontal)
                        .font(.headline)
                    }

                    SegmentsSocials()
                }
                .padding(.vertical)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Community")
                        .foregroundStyle(Color("darkgreen"))
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }
            }
            .navigationBarColor(backgroundColor: .main, titleColor: .darkgreen)
            .background(Color("mainerColor"))
            .refreshable {}
        }
    }
}

#Preview {
    CommunityView().environmentObject(AppController())
}

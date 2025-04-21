//
//  ContentView.swift
//  MealStock_koncept-v1
//
//  Created by Jiří on 25.10.2023.
//
import SwiftUI

struct MainTabView: View {
    @EnvironmentObject private var appController: AppController
    @StateObject private var postViewModel = PostViewModel()
    @Environment(\.colorScheme) var colorScheme
    
    init() {
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(named: "mainColor")
            appearance.stackedLayoutAppearance.normal.iconColor = UIColor(named: "darkgreen")
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "darkgreen") ?? .black]
            appearance.stackedLayoutAppearance.selected.iconColor = UIColor(named: "clickedgreen")
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "clickedgreen") ?? .black]
            
            UITabBar.appearance().scrollEdgeAppearance = appearance
            UITabBar.appearance().standardAppearance = appearance
        } else {
            UITabBar.appearance().barTintColor = UIColor(named: "mainColor")
            UITabBar.appearance().tintColor = UIColor(named: "clickedgreen")
            UITabBar.appearance().unselectedItemTintColor = UIColor(named: "darkgreen")
        }
        
        let navAppearance = UINavigationBarAppearance()
        navAppearance.configureWithOpaqueBackground()
        navAppearance.backgroundColor = UIColor(named: "mainColor")
        navAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        navAppearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        UINavigationBar.appearance().standardAppearance = navAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navAppearance
        UINavigationBar.appearance().tintColor = .red
    }
    
    var body: some View {
        TabView {
            HomeView()
                .environmentObject(postViewModel)
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            
            CommunityView()
                .environmentObject(postViewModel)
                .tabItem {
                    Image(systemName: "person.bubble")
                    Text("Community")
                }
            
            RecipesView()
                .environmentObject(postViewModel)
                .tabItem {
                    Image(systemName: "book.pages")
                    Text("Recipes")
                }
            
            MealPlansView()
                .environmentObject(postViewModel)
                .tabItem {
                    Image(systemName: "calendar.circle.fill")
                    Text("Meal plans")
                }
            
            AccountView()
                .environmentObject(postViewModel)
                .tabItem {
                    Image(systemName: "person.circle.fill")
                    Text("Profile")
                }
        }
        .ignoresSafeArea()
        .tint(Color.darkergreen)
    }
}

#Preview {
    MainTabView().environmentObject(AppController())
}

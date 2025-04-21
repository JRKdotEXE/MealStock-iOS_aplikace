//
//  MealStock_koncept_v1App.swift
//  MealStock_koncept-v1
//
//  Created by Jiří on 25.10.2023.
//
import SwiftUI
import Firebase
import SwiftData


@main
struct MealStock: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var appController = AppController()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: [ItemList.self, ListIem.self])
                .environmentObject(appController)
        }
    }
}

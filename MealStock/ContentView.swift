//
//  ContentView.swift
//  MealStock_koncept-v1
//
//  Created by Jiří on 05.05.2024.
//
import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var appController: AppController

    var body: some View {
        Group {
            switch appController.authState {
            case .undefined:
                AuthLoadingView()
            case .notAuthenticated:
                AuthView()
            case .authenticated:
                MainTabView()
            }
        }.environmentObject(AppController())
    }
}


#Preview {
    ContentView().environmentObject(AppController())
}

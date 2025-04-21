//
//  Searching.swift
//  MealStock_koncept-v1
//
//  Created by Jiří on 01.04.2024.
//
import SwiftUI

struct SearchView: View {
    var body: some View {
        ZStack {
            Color("mainerColor")
                .ignoresSafeArea()
            VStack {
                Text("Sobler")
            }
            .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            Text("Search")
                                .foregroundStyle(Color("darkgreen"))
                                .font(.largeTitle)
                                .fontWeight(.bold)
                        }
                    }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SearchView()
        }
    }
}

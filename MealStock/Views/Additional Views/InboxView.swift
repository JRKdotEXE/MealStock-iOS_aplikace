//
//  ActivitiesView.swift
//  MealStock
//
//  Created by Jiří on 25.08.2024.
//
import SwiftUI

struct InboxView: View {
    var body: some View {
       // NavigationStack {
        ScrollView {
            VStack() {
                ForEach(1...7, id: \.self) { instruction in
                    InboxCell(profilePic: "postImage2_3115", titleText: "Text here", desc: "Lorem ipsum dolor sit amet, consectetupiscing elit. Quisque at mauris cursus, imperdiet erat ut, mlis dui.")
                        .padding(.horizontal, 5)
                        .frame(height: 122)
                        .frame(maxWidth: .infinity)
                }
                .background(.mainer)
            }
            
            
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Activity")
                        .foregroundStyle(Color("darkgreen"))
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }
            }
            .navigationBarTitleDisplayMode(.automatic)
            .toolbarBackground(Color("mainColor"), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
        .background(.mainer)
        .refreshable {
                       print("refreshed")
                    }
    }
}

#Preview {
    NavigationStack {
        InboxView()
    }
}

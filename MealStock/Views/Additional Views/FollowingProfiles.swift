//
//  FollowingProfiles.swift
//  MealStock
//
//  Created by Jiří on 23.07.2024.
//
import SwiftUI

struct FollowingProfiles: View {
    let items = 1...20

        let rows = [
            GridItem(.fixed(50))
        ]

    var body: some View {
        ZStack {
                VStack {
                    Text("Following")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(.darkgreen)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading)
                    ScrollView(.horizontal) {
                    LazyHGrid(rows: rows, alignment: .center) {
                        ForEach(items, id: \.self) { item in
                            NavigationLink(destination: AccountView(), label: {
                                VStack {
                                    DefaultProfilePicture(size: 55)
                                }
                            })
                        }
                        
                    }
                    .roundedCorner(20, corners: .allCorners)
                }.padding(.horizontal)
            }
        }
        .frame(height: 130)
        .background(.main)
        .roundedCorner(20, corners: .allCorners)
        .padding()
    }
}

#Preview {
    FollowingProfiles()
}

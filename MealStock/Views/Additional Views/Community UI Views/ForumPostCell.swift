//
//  ForumPostCell.swift
//  MealStock
//
//  Created by Jiří on 10.09.2024.
//
import SwiftUI

struct ForumPostCell: View {
    @State var profilePic: String = "postImage2_3115"
    @State var author: String = "User"
    @State var titleText: String = "..."
    @State var desc: String = "..."
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Author")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.darkgreen)
                .padding(.leading)
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(titleText)
                        .multilineTextAlignment(.leading)
                        .font(.system(size: 16, weight: .black))
                        .foregroundStyle(.darkgreen)
                    
                    Text(desc)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(.darkgreen)
                        .lineLimit(2)
                }
            }
            .padding(.horizontal)
            
            HStack {
                Spacer()
                Button(action: {
                    
                }) {
                    Image(systemName: ("star"))
                        .font(.system(size: 25))
                        .padding(.horizontal)
                }
                Button(action: {
                }) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 25))
                        .padding(.horizontal)
                }
                Button(action: {
                }) {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 25))
                        .padding(.horizontal)
                }
                Spacer()
            }
            .padding(5)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 175)
            .background(Color.main)
            .clipShape(.rect(cornerRadius: 10))
        }
}

#Preview {
    ForumPostCell(profilePic: "postImage2_3115", titleText: "This is your first forum post!", desc: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque at mauris cursus, imperdiet erat ut, mollis dui.")
}

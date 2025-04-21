//
//  InboxCell.swift
//  MealStock
//
//  Created by Jiří on 09.09.2024.
//
import SwiftUI

struct InboxCell: View {
    @State private var showConfirmationDialog = false
    @State var profilePic: String
    @State var titleText: String
    @State var desc: String
    
    var body: some View {
            HStack {
                Image(profilePic)
                    .resizable()
                    .frame(width: 65, height: 65)
                    .foregroundStyle(.lightergray)
                    .clipShape(Circle())
                    .padding(.leading)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(titleText)
                        .font(.system(size: 16, weight: .black))
                        .foregroundStyle(.darkgreen)
                        .lineLimit(1)
                    
                    Text(desc)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(.darkgreen)
                        .lineLimit(2)
                }
                
                Spacer()
                
                Button(action: {
                    // Action to delete the notification
                    showConfirmationDialog.toggle()
                }) {
                    Image(systemName: "trash.fill")
                        .resizable()
                        .frame(width: 22, height: 25)
                        .foregroundStyle(Color.darkgreen)
                        .padding(.trailing, 15)
                }
                .confirmationDialog("Are you sure you want to delete this post?", isPresented: $showConfirmationDialog, titleVisibility: .visible) {
                    Button("Delete", role: .destructive, action: {
                        
                    })
                }
            }
            .frame(maxWidth: .infinity, maxHeight: 102)
            .background(Color.main)
            .cornerRadius(10)
            .padding(.horizontal, 10)
        }
}

#Preview {
    InboxCell(profilePic: "postImage2_3115", titleText: "Text here", desc: "Lorem ipsum dolor sit amet, consectetupiscing elit. Quisque at mauris cursus, imperdiet erat ut, mlis dui.")
}

//
//  CommentsView.swift
//  MealStock
//
//  Created by Jiří on 26.02.2025.
//
import SwiftUI

struct CommentsView: View {
    private var postId: String = ""
    @State private var input: String = ""
    @State private var comments: [Comment] = [.placeholder]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 25) {
                    Text("komentáře")
                    commentsSection
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            Text("Comments")
                                .foregroundStyle(Color("darkgreen"))
                                .font(.largeTitle)
                                .fontWeight(.bold)
                        }
                    }
            .navigationBarColor(backgroundColor: .main, titleColor: .darkgreen)
            .background(Color("mainerColor"))
            .refreshable {
                
            }
        }
    }
    
    private var commentsSection: some View {
        NavigationStack {
            VStack {
                Section(header:
                            HStack {
                    Text("Comments")
                        .font(.headline)
                        .foregroundStyle(.primary)
                        .padding(.leading, 35)
                    Spacer()
                }) {
                    VStack {
                        TextField("Describe yourself", text: $input, axis: .vertical)
                            .textFieldStyle(.roundedBorder)
                            .lineLimit(3, reservesSpace: true)
                            .padding(.horizontal, 30)
                        
                        HStack {
                            Spacer()
                            Button(action: {

                            }, label: {
                                Text("Post")
                                    .brownButton(height: 50)
                            })
                            .padding(.horizontal, 30)
                        }
                        
                        ForEach(comments) { comment in
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(comment.author)
                                        .font(.headline)
                                        .padding(.leading)
                                    Spacer()
                                }
                                
                                Text(comment.content)
                                    .padding(.leading)
                            }
                            .padding(.vertical, 10)
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(8)
                            .shadow(radius: 2)
                        }
                        .padding(30)
                    }
                }
                Spacer()
            }
        }
    }
}

#Preview {
    CommentsView()
}

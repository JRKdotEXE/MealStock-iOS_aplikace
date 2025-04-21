//
//  Post.swift
//  MealStock
//
//  Created by Jiří on 03.10.2024.
//
import Foundation

struct Post: Identifiable, Codable {
    var id: String
    var title: String
    var content: String
    var username: String
    var timestamp: Date
    var typ: PostType
    var likes: Int = 0
    var likedBy: [String] = []
    var imageUrl: String?
    var recipe: Recipe?
    var mealPlan: MealPlan?
    var tags: [String]
    var comments: [Comment] = []
    var keyWords: [String] {
        self.title.generateStringSequence()
    }
    
    init(id: String = UUID().uuidString, title: String, content: String, username: String, timestamp: Date, type: PostType, imageUrl: String? = nil, recipe: Recipe? = nil, mealPlan: MealPlan? = nil, tags: [String] = []) {
        self.id = id
        self.title = title
        self.content = content
        self.username = username
        self.timestamp = timestamp
        self.typ = type
        self.imageUrl = imageUrl
        self.recipe = recipe
        self.mealPlan = mealPlan
        self.tags = tags
    }
}

extension Post {
    static let testPost = Post(
        title: "Lorem ipsum",
        content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
        username: "Jamie Harris",
        timestamp: Date(),
        type: .recipe
    )
}


enum PostType: Codable, CaseIterable {
    case mealPlan, recipe, forumPost
}

//
//  Comment.swift
//  MealStock
//
//  Created by Jiří on 30.08.2024.
//
import Foundation

struct Comment: Identifiable, Codable {
    var id: String
    var content: String
    var author: String
    var timestamp: Date = Date()
    
    init(id: String = UUID().uuidString, content: String, author: String) {
        self.id = id
        self.content = content
        self.author = author
    }
}


extension Comment {
    static var placeholder: Self { .init(id: UUID().uuidString, content: "Wow! That's a great post!", author: "John Doe") }
}

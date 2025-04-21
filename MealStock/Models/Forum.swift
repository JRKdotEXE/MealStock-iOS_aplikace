//
//  ForumPost.swift
//  MealStock
//
//  Created by Jiří on 21.09.2024.
//
import Foundation

struct Forum: Identifiable, Codable {
    var id: UUID = UUID()
    var author: String
    var title: String
    var content: String
}

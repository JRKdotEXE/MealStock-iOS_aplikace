//
//  ShoppingList.swift
//  MealStock
//
//  Created by Jiří on 22.11.2024.
//
import Foundation
import SwiftData

@Model
final class ShoppingList {
    var id: UUID = UUID()
    var name: String
    var iconName: String
    @Relationship(deleteRule: .cascade) var items = [ShoppingItem]()
    
    init(name: String = "", iconName: String = "list.bullet", items: [ShoppingItem] = [ShoppingItem]()) {
        self.name = name
        self.iconName = iconName
        self.items = items
    }
}

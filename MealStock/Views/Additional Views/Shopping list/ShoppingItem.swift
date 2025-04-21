//
//  ShoppingItem.swift
//  MealStock
//
//  Created by Jiří on 22.11.2024.
//
import SwiftData
import Foundation

@Model
class ShoppingItem {
    var name: String
    var quantity: Double
    var unit: String

    init(name: String, quantity: Double, unit: String) {
        self.name = name
        self.quantity = quantity
        self.unit = unit
    }
}

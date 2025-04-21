//
//  Recipe.swift
//  MealStock_koncept-v1
//
//  Created by Jiří on 29.03.2024.
//
import Foundation

struct Recipe: Identifiable, Codable {
    var id: String = UUID().uuidString
    var name: String
    var description: String
    var author: String
    var ingredients: [Ingredient]
    var category: Category
    var instructions: [String]
    var calories: Int
    var protein: Int
    var carbs: Int
    var fat: Int
    
    enum Category: String, CaseIterable, Codable {
        case breakfast = "Breakfast"
        case lunch = "Lunch"
        case dinner = "Dinner"
        case dessert = "Dessert"
        case snack = "Snack"
        case any = "Any"
    }
}

enum Unit: String, CaseIterable, Codable, Identifiable {
    case oz = "Ounces"
    case g = "Grams"
    case cups = "Cups"
    case tbsp = "Tablespoons"
    case tsp = "Teaspoons"
    case ml = "Milliliters"
    case none = "None"
    var singularName: String { String(rawValue.dropLast()) }
    var id: String { rawValue }
}

struct Ingredient: Hashable, Codable {
    var name: String
    var quantity: Double
    var unit: Unit
    
    var description: String {
        let formattedQuantity = String(format: "%g", quantity)
        switch unit {
        case .none:
            let formattedName = quantity == 1 ? name : "\(name)s"
            return "\(formattedQuantity) \(formattedName)"
        default:
            if quantity == 1 {
                return "1 \(unit.singularName) \(name)"
            } else {
                return "\(formattedQuantity) \(unit.rawValue) \(name)"
            }
        }
    }
}

extension Recipe {
    static let placeholder = Recipe(name: "", description: "", author: "", ingredients: [], category: .any, instructions: [], calories: 0, protein: 0, carbs: 0, fat: 0)
    
    static let pancakes = Recipe(
        name: "Pancakes",
        description: "Fluffy breakfast pancakes.",
        author: "John Doe",
        ingredients: [
            Ingredient(name: "Flour", quantity: 200, unit: .g),
            Ingredient(name: "Milk", quantity: 300, unit: .ml),
            Ingredient(name: "Egg", quantity: 2, unit: .none),
            Ingredient(name: "Sugar", quantity: 50, unit: .g),
            Ingredient(name: "Butter", quantity: 20, unit: .g)
        ],
        category: .breakfast,
        instructions: [
            "Mix all ingredients in a bowl.",
            "Heat a pan and grease with butter.",
            "Pour batter into the pan and cook until golden brown on both sides."
        ],
        calories: 350,
        protein: 10,
        carbs: 45,
        fat: 15
    )

    static let grilledChickenSalad = Recipe(
        name: "Grilled Chicken Salad",
        description: "A healthy lunch option.",
        author: "Jane Smith",
        ingredients: [
            Ingredient(name: "Chicken Breast", quantity: 200, unit: .g),
            Ingredient(name: "Lettuce", quantity: 100, unit: .g),
            Ingredient(name: "Tomato", quantity: 1, unit: .none),
            Ingredient(name: "Cucumber", quantity: 0.5, unit: .none),
            Ingredient(name: "Olive Oil", quantity: 2, unit: .tbsp)
        ],
        category: .lunch,
        instructions: [
            "Grill the chicken until fully cooked.",
            "Chop the vegetables and mix them in a bowl.",
            "Slice the grilled chicken and place it on top of the salad.",
            "Drizzle with olive oil and serve."
        ],
        calories: 400,
        protein: 35,
        carbs: 10,
        fat: 20
    )

    static let spaghettiBolognese = Recipe(
        name: "Spaghetti Bolognese",
        description: "A classic Italian dinner.",
        author: "Chef Luigi",
        ingredients: [
            Ingredient(name: "Spaghetti", quantity: 100, unit: .g),
            Ingredient(name: "Ground Beef", quantity: 200, unit: .g),
            Ingredient(name: "Tomato Sauce", quantity: 150, unit: .ml),
            Ingredient(name: "Onion", quantity: 1, unit: .none),
            Ingredient(name: "Garlic", quantity: 2, unit: .none)
        ],
        category: .dinner,
        instructions: [
            "Cook spaghetti according to package instructions.",
            "Sauté onion and garlic in a pan.",
            "Add ground beef and cook until browned.",
            "Mix in tomato sauce and simmer.",
            "Serve the sauce over the spaghetti."
        ],
        calories: 600,
        protein: 30,
        carbs: 75,
        fat: 20
    )

    static let chocolateCake = Recipe(
        name: "Chocolate Cake",
        description: "Rich and moist chocolate cake.",
        author: "Mary Baker",
        ingredients: [
            Ingredient(name: "Flour", quantity: 250, unit: .g),
            Ingredient(name: "Cocoa Powder", quantity: 50, unit: .g),
            Ingredient(name: "Sugar", quantity: 200, unit: .g),
            Ingredient(name: "Butter", quantity: 100, unit: .g),
            Ingredient(name: "Egg", quantity: 3, unit: .none)
        ],
        category: .dessert,
        instructions: [
            "Preheat oven to 180°C.",
            "Mix dry ingredients in one bowl and wet ingredients in another.",
            "Combine both mixtures and pour into a greased baking pan.",
            "Bake for 30-35 minutes or until a toothpick comes out clean."
        ],
        calories: 450,
        protein: 6,
        carbs: 55,
        fat: 20
    )

    static let smoothieBowl = Recipe(
        name: "Smoothie Bowl",
        description: "A refreshing and nutritious snack.",
        author: "Health Guru",
        ingredients: [
            Ingredient(name: "Frozen Berries", quantity: 150, unit: .g),
            Ingredient(name: "Banana", quantity: 1, unit: .none),
            Ingredient(name: "Greek Yogurt", quantity: 100, unit: .g),
            Ingredient(name: "Granola", quantity: 30, unit: .g),
            Ingredient(name: "Honey", quantity: 1, unit: .tbsp)
        ],
        category: .snack,
        instructions: [
            "Blend frozen berries, banana, and yogurt until smooth.",
            "Pour into a bowl and top with granola and honey.",
            "Serve immediately."
        ],
        calories: 250,
        protein: 8,
        carbs: 40,
        fat: 5
    )

    static let avocadoToast = Recipe(
        name: "Avocado Toast",
        description: "A quick and healthy breakfast option.",
        author: "Quick Chef",
        ingredients: [
            Ingredient(name: "Bread Slice", quantity: 2, unit: .none),
            Ingredient(name: "Avocado", quantity: 1, unit: .none),
            Ingredient(name: "Salt", quantity: 0.5, unit: .tsp),
            Ingredient(name: "Lemon Juice", quantity: 1, unit: .tsp)
        ],
        category: .breakfast,
        instructions: [
            "Toast the bread slices.",
            "Mash the avocado and mix with salt and lemon juice.",
            "Spread the avocado mixture on the toasted bread.",
            "Serve immediately."
        ],
        calories: 200,
        protein: 4,
        carbs: 25,
        fat: 10
    )

    static let vegetableStirFry = Recipe(
        name: "Vegetable Stir Fry",
        description: "A quick and easy dinner option.",
        author: "Vegan Chef",
        ingredients: [
            Ingredient(name: "Mixed Vegetables", quantity: 300, unit: .g),
            Ingredient(name: "Soy Sauce", quantity: 2, unit: .tbsp),
            Ingredient(name: "Garlic", quantity: 1, unit: .none),
            Ingredient(name: "Olive Oil", quantity: 1, unit: .tbsp)
        ],
        category: .dinner,
        instructions: [
            "Heat olive oil in a pan.",
            "Add garlic and sauté until fragrant.",
            "Add mixed vegetables and stir fry for 5-7 minutes.",
            "Add soy sauce and mix well before serving."
        ],
        calories: 180,
        protein: 5,
        carbs: 20,
        fat: 8
    )

    static let berryParfait = Recipe(
        name: "Berry Parfait",
        description: "A light and sweet dessert.",
        author: "Dessert Lover",
        ingredients: [
            Ingredient(name: "Greek Yogurt", quantity: 200, unit: .g),
            Ingredient(name: "Granola", quantity: 50, unit: .g),
            Ingredient(name: "Mixed Berries", quantity: 100, unit: .g),
            Ingredient(name: "Honey", quantity: 1, unit: .tbsp)
        ],
        category: .dessert,
        instructions: [
            "Layer yogurt, granola, and berries in a glass.",
            "Drizzle honey on top.",
            "Repeat layers and serve chilled."
        ],
        calories: 300,
        protein: 10,
        carbs: 40,
        fat: 8
    )

    static let proteinShake = Recipe(
        name: "Protein Shake",
        description: "A post-workout protein boost.",
        author: "Fitness Guru",
        ingredients: [
            Ingredient(name: "Protein Powder", quantity: 25, unit: .g),
            Ingredient(name: "Milk", quantity: 250, unit: .ml),
            Ingredient(name: "Banana", quantity: 1, unit: .none),
            Ingredient(name: "Peanut Butter", quantity: 1, unit: .tbsp)
        ],
        category: .snack,
        instructions: [
            "Combine all ingredients in a blender.",
            "Blend until smooth.",
            "Serve immediately."
        ],
        calories: 350,
        protein: 25,
        carbs: 30,
        fat: 10
    )

    static let tomatoSoup = Recipe(
        name: "Tomato Soup",
        description: "A warm and comforting soup.",
        author: "Soup Master",
        ingredients: [
            Ingredient(name: "Tomatoes", quantity: 500, unit: .g),
            Ingredient(name: "Onion", quantity: 1, unit: .none),
            Ingredient(name: "Garlic", quantity: 2, unit: .none),
            Ingredient(name: "Vegetable Broth", quantity: 500, unit: .ml),
            Ingredient(name: "Olive Oil", quantity: 1, unit: .tbsp)
        ],
        category: .lunch,
        instructions: [
            "Heat olive oil in a pot and sauté onion and garlic.",
            "Add tomatoes and cook until soft.",
            "Pour in vegetable broth and simmer for 15 minutes.",
            "Blend the soup until smooth and serve warm."
        ],
        calories: 200,
        protein: 5,
        carbs: 30,
        fat: 5
    )
}

//
//  MealPlan.swift
//  MealStock_koncept-v1
//
//  Created by Jiří on 02.07.2024.
//
import Foundation

struct MealPlan: Identifiable, Codable {
    var id: String = UUID().uuidString
    var name: String
    var weeks: [Week]
    
    var days: [Day]
    var description: String?
    var tags: [String]?
    var counter: Int
    var dailyMeals: Int?
    
    init(name: String, weeks: [Week] = [], days: [Day] = [], description: String? = "", cuisine: [String]? = [], dailyMeals: Int? = nil) {
        self.name = name
        self.weeks = weeks
        self.days = days
        self.description = description
        self.tags = cuisine
        self.counter = weeks.count
        self.dailyMeals = dailyMeals
    }
}

extension MealPlan {
    static var mealPlanWithDays: MealPlan {
        
        MealPlan(
            name: "Healthy Meal Plan",
            days: [
                Day(name: "Day 1", recipes: [
                    Recipe.spaghettiBolognese,
                    Recipe.grilledChickenSalad,
                    Recipe.proteinShake
                ]),
                Day(name: "Day 2", recipes: [
                    Recipe.spaghettiBolognese,
                    Recipe.grilledChickenSalad,
                    Recipe.proteinShake
                ]),
                Day(name: "Day 3", recipes: [
                    Recipe.spaghettiBolognese,
                    Recipe.grilledChickenSalad,
                    Recipe.proteinShake
                ]),
                Day(name: "Day 4", recipes: [
                    Recipe.spaghettiBolognese,
                    Recipe.grilledChickenSalad,
                    Recipe.proteinShake
                ]),
                Day(name: "Day 5", recipes: [
                    Recipe.spaghettiBolognese,
                    Recipe.grilledChickenSalad,
                    Recipe.proteinShake
                ]),
                Day(name: "Day 6", recipes: [
                    Recipe.spaghettiBolognese,
                    Recipe.grilledChickenSalad,
                    Recipe.proteinShake
                ]),
                Day(name: "Day 7", recipes: [
                    Recipe.spaghettiBolognese,
                    Recipe.grilledChickenSalad,
                    Recipe.proteinShake
                ])
            ],
            description: "Description of the meal plan. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam auctor quam id massa faucibus dignissim. Nullam eget metus id nisl malesuada condimentum. Nam viverra fringilla erat, ut fermentum nunc feugiat eu.",
            cuisine: ["Healthy", "Modern"]
        )
    }
    
    static var sampleMealPlan: MealPlan {
        MealPlan(
            name: "Healthy Meal Plan 2",
            weeks: [
            Week(
                day1: Day(name: "Day 1", recipes: [
                Recipe(
                name: "Toast and Eggs",
                description: "First meal of the week",
                author: "John Doe",
                ingredients: [
                    Ingredient(name: "Toast", quantity: 2, unit: .none),
                    Ingredient(name: "Eggs", quantity: 2, unit: .none)
                ],
                category: .breakfast,
                instructions: ["Toast the bread", "Beat the eggs", "Add the toast and eggs to a pan", "Cook until golden brown", "Serve hot", "Enjoy!"],
                calories: 0, protein: 0, carbs: 0, fat: 0
            ),
                Recipe(
                name: "Pasta Primaveral",
                description: "Second meal of the week",
                author: "ItalianChef",
                ingredients: [
                    Ingredient(name: "Pasta", quantity: 150, unit: .g),
                    Ingredient(name: "Tomatoes", quantity: 2, unit: .none),
                    Ingredient(name: "Basil", quantity: 1, unit: .none),
                    Ingredient(name: "Parmesan", quantity: 20, unit: .g),
                    Ingredient(name: "Olive Oil", quantity: 5, unit: .g)
                ],
                category: .any,
                instructions: ["Cook the pasta", "Add the tomatoes, basil, and parmesan", "Mix well", "Add the olive oil", "Cook until the sauce is thick", "Serve hot", "Enjoy!"],
                calories: 0, protein: 0, carbs: 0, fat: 0
            ),
                Recipe.spaghettiBolognese
                ]),
                day2: Day(name: "Day 2", recipes: [
                    Recipe.pancakes,
                    Recipe.grilledChickenSalad,
                    Recipe.spaghettiBolognese
                ]),
                day3: Day(name: "Day 3", recipes: [
                    Recipe.chocolateCake,
                    Recipe.smoothieBowl,
                    Recipe.avocadoToast
                ]),
                day4: Day(name: "Day 4", recipes: [
                    Recipe.vegetableStirFry,
                    Recipe.berryParfait,
                    Recipe.proteinShake
                ]),
                day5: Day(name: "Day 5", recipes: [
                    Recipe.tomatoSoup,
                    Recipe.proteinShake,
                    Recipe.avocadoToast
                ]),
                day6: Day(name: "Day 6", recipes: [
                    Recipe.grilledChickenSalad,
                    Recipe.chocolateCake,
                    Recipe.spaghettiBolognese
                ]),
                day7: Day(name: "Day 7", recipes: [
                    Recipe.spaghettiBolognese,
                    Recipe.grilledChickenSalad,
                    Recipe.pancakes
                ]))],
            description: "This is a sample meal plan for the week. It includes a variety of meals that are easy to prepare and delicious.",
            cuisine: ["Mediterranean", "Vegetarian"],
            dailyMeals: 3
        )

    }
}

struct Day: Codable {
    var name: String
    var recipes: [Recipe]
}

struct Week: Codable {
    var day1: Day
    var day2: Day?
    var day3: Day?
    var day4: Day?
    var day5: Day?
    var day6: Day?
    var day7: Day?
}

extension Week {
    var days: [Day] {
        return [day1, day2, day3, day4, day5, day6, day7].compactMap { $0 }
    }
}

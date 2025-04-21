//
//  FetchMealDBRecipes.swift
//  MealStock
//
//  Created by Jiří on 08.02.2025.
//
import SwiftUI

// Import required models and views
import FirebaseFirestore
import FirebaseFirestoreSwift

struct RecipeFromAPI: Codable {
    var id: Int
    var title: String
    var ingredients: [String]
    var instructions: [String]
    var cuisine: String
    var image: String?
    var calories: Int?
    var protein: Int?
    var carbs: Int?
    var fat: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title = "name"
        case ingredients
        case instructions
        case cuisine
        case image
        case calories
        case protein
        case carbs
        case fat
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        
        if let ingredientsString = try? container.decode(String.self, forKey: .ingredients) {
            ingredients = ingredientsString.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        } else {
            ingredients = try container.decode([String].self, forKey: .ingredients)
        }
        
        if let instructionsString = try? container.decode(String.self, forKey: .instructions) {
            instructions = instructionsString.components(separatedBy: "\n")
        } else {
            instructions = try container.decode([String].self, forKey: .instructions)
        }
        
        cuisine = try container.decode(String.self, forKey: .cuisine)
        image = try container.decodeIfPresent(String.self, forKey: .image)
        calories = try container.decodeIfPresent(Int.self, forKey: .calories)
        protein = try container.decodeIfPresent(Int.self, forKey: .protein)
        carbs = try container.decodeIfPresent(Int.self, forKey: .carbs)
        fat = try container.decodeIfPresent(Int.self, forKey: .fat)
    }
}

// Update the APIResponse structure
struct APIResponse: Codable {
    let recipes: [RecipeFromAPI]
    let total: Int
    let skip: Int
    let limit: Int
    
    // Remove the CodingKeys since they match exactly
    
    // Add custom init to handle the root structure
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        recipes = try container.decode([RecipeFromAPI].self, forKey: .recipes)
        total = try container.decode(Int.self, forKey: .total)
        skip = try container.decode(Int.self, forKey: .skip)
        limit = try container.decode(Int.self, forKey: .limit)
    }
}

struct FetchAPIRecipes: View {
    @State private var recipes = [RecipeFromAPI]()
    @State private var isLoading = false
    @State private var errorMessage: String?
    @StateObject private var postViewModel = PostViewModel()
    
    func fetchRecipes() {
        isLoading = true
        guard let url = URL(string: "https://dummyjson.com/recipes") else {
            errorMessage = "Invalid URL"
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            isLoading = false
            
            if let error = error {
                errorMessage = error.localizedDescription
                return
            }
            
            guard let data = data else {
                errorMessage = "No data received"
                return
            }
            
            // Print raw JSON for debugging
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Raw JSON:", jsonString)
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedResponse = try decoder.decode(APIResponse.self, from: data)
                DispatchQueue.main.async {
                    self.recipes = decodedResponse.recipes
                }
            } catch let DecodingError.dataCorrupted(context) {
                print("Data corrupted:", context)
                errorMessage = "Data corrupted: \(context)"
            } catch let DecodingError.keyNotFound(key, context) {
                print("Key not found:", key, "context:", context)
                errorMessage = "Key '\(key.stringValue)' not found"
            } catch let DecodingError.typeMismatch(type, context) {
                print("Type mismatch:", type, "context:", context)
                errorMessage = "Type mismatch for \(type)"
            } catch let DecodingError.valueNotFound(type, context) {
                print("Value not found:", type, "context:", context)
                errorMessage = "Value not found for \(type)"
            } catch {
                print("Error:", error)
                errorMessage = error.localizedDescription
            }
        }.resume()
    }
    
    private func convertToRecipe(_ apiRecipe: RecipeFromAPI) -> Recipe {
        Recipe(
            id: String(apiRecipe.id),
            name: apiRecipe.title,
            description: apiRecipe.instructions.joined(separator: "\n"),
            author: "API Recipe",
            ingredients: apiRecipe.ingredients.map { 
                Ingredient(name: $0, quantity: 1, unit: .none)
            },
            category: .any,
            instructions: apiRecipe.instructions,
            calories: apiRecipe.calories ?? 0,
            protein: apiRecipe.protein ?? 0,
            carbs: apiRecipe.carbs ?? 0,
            fat: apiRecipe.fat ?? 0
        )
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    if isLoading {
                        ProgressView()
                    } else {
                        ForEach(recipes, id: \.id) { recipe in
                            NavigationLink {
                                RecipePostDetail(
                                    name: recipe.title,
                                    userName: "API Recipe",
                                    description: recipe.instructions.joined(separator: "\n"),
                                    instructions: recipe.instructions,
                                    ingredients: recipe.ingredients.map {
                                        Ingredient(name: $0, quantity: 1, unit: .none)
                                    },
                                    recipe: convertToRecipe(recipe),
                                    postViewModel: postViewModel,
                                    timestamp: Date(),
                                    postId: String(recipe.id),
                                    imageUrl: recipe.image,
                                    calories: recipe.calories ?? 0,
                                    protein: recipe.protein ?? 0,
                                    carbs: recipe.carbs ?? 0,
                                    fat: recipe.fat ?? 0
                                )
                            } label: {
                                Recipe_PostView(
                                    username: "API Recipe",
                                    mealname: recipe.title,
                                    img: recipe.image ?? "",
                                    recipe: convertToRecipe(recipe),
                                    timestamp: Date(),
                                    postViewModel: postViewModel,
                                    postId: String(recipe.id)
                                )
                            }
                        }
                    }
                }
            }
            .navigationTitle("Recipes from DummyJSON")
            .alert("Error", isPresented: Binding(
                get: { errorMessage != nil },
                set: { if !$0 { errorMessage = nil } }
            )) {
                Button("OK") { errorMessage = nil }
            } message: {
                Text(errorMessage ?? "Unknown error")
            }
        }
        .onAppear {
            if recipes.isEmpty {
                fetchRecipes()
            }
        }
    }
}

#Preview {
    FetchAPIRecipes()
}

//
//  RecipeFromMealPlanView.swift
//  MealStock
//
//  Created by Jiří on 21.12.2024.
//
import SwiftUI

struct RecipeFromMealPlanView: View {
    var recipe: Recipe
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    //HeaderView(recipeName: recipe.name)
                    Text(recipe.name)
                        
                        .font(.custom("HelveticaNeue-Medium", size: 25))
                        .foregroundStyle(.darkergreen)
                        .padding([.top, .horizontal])
                    DescriptionView(description: recipe.description)
                    
                    IngredientsView(ingredients: recipe.ingredients)
                    
                    InstructionsView(instructions: recipe.instructions)
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Menu {
                            Button("Save", action: {})
                        } label: {
                            Image(systemName: "ellipsis")
                                .font(.system(.title))
                                .rotationEffect(.init(degrees: 90))
                                .scaleEffect(0.8)
                        }
                    }
                }
                .toolbarBackground(Color("mainColor"), for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .background(Color("mainerColor").edgesIgnoringSafeArea(.all))
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("")
                            .foregroundStyle(.darkgreen)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                    }
                }
                .background(Color("mainerColor"))
            }
            .background(Color("mainerColor"))
        }
        .background(Color("mainerColor"))
    }
}

struct HeaderView: View {
    var recipeName: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(recipeName)
                .font(.custom("HelveticaNeue-Medium", size: 25))
                .foregroundStyle(.darkergreen)
                .padding(.leading)
        }
        .padding([.top, .bottom], 10)
    }
}


#Preview {
    RecipeFromMealPlanView(recipe: Recipe(id: UUID().uuidString, name: "Test", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", author: "Test", ingredients: [Ingredient(name: "Test 1", quantity: 1, unit: .cups), Ingredient(name: "Test 2", quantity: 1, unit: .g), Ingredient(name: "Test 3", quantity: 1, unit: .none)], category: .any, instructions: ["Test", "Test", "Test"], calories: 0, protein: 0, carbs: 0, fat: 0))
}

struct IngredientsView: View {
    var ingredients: [Ingredient]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Ingredients")
                .font(.headline)
                .padding(.leading)
            
            LazyVStack(alignment: .leading, spacing: 5) {
                ForEach(ingredients, id: \.self) { ingredient in
                    HStack {
                        Text("• \(Int(ingredient.quantity)) \(ingredient.unit == .none ? "pcs" : String(describing: ingredient.unit)) of \(ingredient.name)")
                    }
                    .padding(.leading)
                }
            }
            .padding(.leading, 10)
        }
        .foregroundStyle(.darkergreen)
    }
}


struct DescriptionView: View {
    var description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Description")
                .font(.headline)
                .padding([.top, .leading])
            
            Text(description)
                    .foregroundStyle(.darkergreen)
                    .padding([.horizontal], 10)
        }
        .foregroundStyle(.darkergreen)
    }
}

struct InstructionsView: View {
    var instructions: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Instructions")
                .font(.headline)
                .padding([.top, .leading])
            
            LazyVStack(alignment: .leading, spacing: 10) {
                ForEach(instructions, id: \.self) { instruction in
                    Text(instruction)
                        .padding(.leading)
                        .foregroundStyle(.darkergreen)
                }
            }
            .padding(.leading, 10)
        }
        .foregroundStyle(.darkergreen)
    }
}

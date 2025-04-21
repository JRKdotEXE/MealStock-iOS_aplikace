//
//  AddRecipeToMealPlanView.swift
//  MealStock
//
//  Created by Jiří on 10.02.2025.
//
import SwiftUI

struct AddRecipeToMealPlanView: View {
    @State private var content = ""
    @State private var title = ""
    @State private var ingredients = ""
    @State private var ingredientsCount: Int = 0
    @State private var instructionsCount: Int = 0
    @State private var contents: [String] = []
    @State private var ingredientsArray: [String] = Array(repeating: "", count: 3)
    @State var finalIngredients: [Ingredient] = []
    @Environment(\.dismiss) var dismiss
    @State var calories: Int = 0
    @State var protein: Int = 0
    @State var carbs: Int = 0
    @State var fat: Int = 0
    private let numberFormatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            return formatter
    }()
    
    @Binding var meal: Recipe
    
    @State private var showingAlert: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Button {
                    if title == "" {
                        showingAlert = true
                    } else {
                        meal = Recipe(name: title, description: content, author: "", ingredients: finalIngredients, category: .any, instructions: contents, calories: calories, protein: protein, carbs: carbs, fat: fat)
                        dismiss()
                    }
                } label: {
                    Text("Add Your Recipe")
                        .font(.title2)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("accentbrown"))
                        .cornerRadius(8)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                        .foregroundStyle(.white)
                        .padding()
                }
                .alert("Something's missing in your recipe!", isPresented: $showingAlert) {
                    Button("OK", role: .cancel) { }
                }
                
                Form {
                    Section("Title") {
                        TextField("Title", text: $title)
                    }
                    
                    Section("Description") {
                        TextEditor(text: $content)
                            .multilineTextAlignment(.leading)
                            .lineLimit(3)
                    }
                    
                    Section("Ingredients") {
                        Button {
                            ingredientsCount += 1
                            finalIngredients.append(Ingredient(name: "", quantity: 0, unit: .none))
                        } label: {
                            Text("Add Ingredient")
                        }
                        ForEach(0..<ingredientsCount, id: \.self) { index in
                            IngredientsField(index: index, text: $finalIngredients[index].name, quantity: $finalIngredients[index].quantity, unit: $finalIngredients[index].unit)
                        }
                    }
                    
                    Section("Instructions") {
                        Button {
                            instructionsCount += 1
                            contents.append("")
                        } label: {
                            Text("Add Step")
                        }
                        ForEach(0..<instructionsCount, id: \.self) { index in
                            TextField("\(index + 1). step", text: $contents[index])
                        }
                    }
                    
                    Section("Calories") {
                        HStack {
                            TextField(title, value: $calories, formatter: numberFormatter)
                                .keyboardType(.decimalPad)
                            Text("kcal")
                                .foregroundStyle(.secondary)
                        }
                    }
                        
                    Section("Protein") {
                        NumericInputField(title: "Protein", value: $protein, formatter: numberFormatter)
                    }
                    
                    Section("Carbs") {
                        NumericInputField(title: "Carbs", value: $carbs, formatter: numberFormatter)
                    }
                    
                    Section("Fat") {
                        NumericInputField(title: "Fat", value: $fat, formatter: numberFormatter)
                    }
                }
                .scrollContentBackground(.hidden)
                .background(Color.mainer)
                
            }
            .background(Color.mainer)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarTitleDisplayMode(.automatic)
        }
    }
}

#Preview {
    
    AddMealPlanView()
        .environmentObject(AppController())
}

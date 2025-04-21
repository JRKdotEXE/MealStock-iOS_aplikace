//
//  MealsInMealPlanView.swift
//  MealStock
//
//  Created by Jiří on 11.01.2025.
//
import SwiftUI

struct DaysInMealPlanView: View {
    @State var dayName: String
    @State var meals: [Recipe]
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    Text("\(meals.count) meals")
                        .font(.custom("HelveticaNeue-Medium", size: 25))
                        .foregroundStyle(.darkergreen)
                        .padding([.top, .horizontal])

                    LazyVStack(alignment: .leading, spacing: 15) {
                        ForEach(meals) { index in
                            if index.name != "" {
                                MealView(meal: index)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("mainerColor"))
                .toolbarBackground(Color("mainColor"), for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text(dayName)
                            .foregroundStyle(.darkgreen)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                    }
                }
            }
            .background(.mainer)
        }
        
    }
}

#Preview {
    DaysInMealPlanView(
        dayName: "Monday",
        meals: [
            Recipe(
                name: "Toast and Eggs",
                description: "First meal of the week",
                author: "John Doe",
                ingredients: [
                    Ingredient(name: "Toast", quantity: 2, unit: .none),
                    Ingredient(name: "Eggs", quantity: 2, unit: .none)
                ],
                category: .breakfast,
                instructions: [
                    "Toast the bread",
                    "Beat the eggs",
                    "Add the toast and eggs to a pan",
                    "Cook until golden brown",
                    "Serve hot",
                    "Enjoy!"
                ],
                calories: 0,
                protein: 0,
                carbs: 0,
                fat: 0
            ),
            Recipe.berryParfait,
            Recipe.avocadoToast
        ]
    )
}

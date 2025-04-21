//
//  MealsForMealPlan.swift
//  MealStock
//
//  Created by Jiří on 27.08.2024.
//
import SwiftUI

struct MealsForMealPlan: View {
    var meallist: [String]
    
    var body: some View {
        Section {
            List(meallist, id: \.self) { instruction in
                NavigationLink {
                    Text("ActivitiesView placeholder")
                } label: {
                    Text(instruction)
                        .padding(.top)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        MealsForMealPlan(meallist: ["Blueberry porridge", "Chicken and rice", "Strawberry smoothie", "Beef mince with mashed potatoes"])
    }
}

//
//  MealsList.swift
//  MealStock
//
//  Created by Jiří on 24.09.2024.
//
import SwiftUI

struct MealList: View {
    var meals: [String] = ["food", "drink", "snack"]
    var body: some View {
        ZStack {
            Color(hex: "F8EDD0")
            VStack {
                Text("Meal List")
                    .font(.title)
                    .foregroundStyle(.darkgreen)
                    .padding([.horizontal])
                ForEach(meals, id: \.self) { color in
                    MealItem(item: color)
                        .padding(.horizontal, 10)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 327)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.accentbrown, lineWidth: 1)
        )
        .padding(.horizontal)
    }
}

#Preview {
    MealList()
}

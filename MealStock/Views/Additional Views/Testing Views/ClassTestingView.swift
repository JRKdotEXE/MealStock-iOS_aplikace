//
//  ClassTestingView.swift
//  MealStock
//
//  Created by Jiří on 09.11.2024.
//
import SwiftUI

struct ClassTestingView: View {
    // Assuming MealPlan is a class or struct and sampleMealPlan is a static instance
    var body: some View {
        Text("\(MealPlan.sampleMealPlan.counter)")
    }
}

#Preview {
    ClassTestingView()
}

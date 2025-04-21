//
//  RoundedRectangleView.swift
//  MealStock
//
//  Created by Jiří on 19.12.2024.
//
import SwiftUI

struct SmallerPicPlaceholder: View {
    var body: some View {
        
        RoundedRectangle(cornerRadius: 10)
            .fill(Color(red: 0.85, green: 0.85, blue: 0.85, opacity: 1.00))
            .frame(width: 183, height: 104)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(.darkgreen))
            )
            .padding(.top, 8)
    }
}

#Preview {
    SmallerPicPlaceholder()
}

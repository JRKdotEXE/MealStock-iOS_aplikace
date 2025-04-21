//
//  GreenButtonViewModifier.swift
//  MealStock
//
//  Created by Jiří on 16.08.2024.
//
import SwiftUI

struct GreenButtonViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 20, weight: .bold))
            .foregroundStyle(Color("accentbrown"))
            .padding(.horizontal, 10)
            .frame(height: 70)
            .background(Color(red: 0.81, green: 0.83, blue: 0.7))
            .clipShape(.rect(cornerRadius: 10))
    }
}

extension View {
    func greenButton() -> some View {
        modifier(GreenButtonViewModifier())
    }
}

struct GreenButtonView: View {
    var body: some View {
        Text("Green Button")
            .greenButton()
    }
}

#Preview {
        GreenButtonView()
}



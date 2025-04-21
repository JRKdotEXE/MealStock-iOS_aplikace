//
//  BrownButton.swift
//  MealStock
//
//  Created by Jiří on 25.07.2024.
//
import SwiftUI

struct BrownButton: ViewModifier {
    var height: CGFloat = 70
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: 20, weight: .bold))
            .foregroundStyle(.darkgreen)
            .padding([.leading, .trailing], 10)
            .frame(height: height)
            .background(Color(red: 0.9, green: 0.8, blue: 0.51))
            .clipShape(.rect(cornerRadius: 10))
    }
}

extension View {
    func brownButton(height: CGFloat = 70) -> some View {
        modifier(BrownButton(height: height))
    }
}

struct BrownButtonView: View {
    var body: some View {
        Text("Brown Button")
            .brownButton(height: 30)
    }
}

#Preview {
    BrownButtonView()
}

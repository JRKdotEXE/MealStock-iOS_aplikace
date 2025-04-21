//
//  AuthLoadingView.swift
//  MealStock
//
//  Created by Jiří on 15.12.2024.
//
import SwiftUI

struct AuthLoadingView: View {
    @State private var isAnimating: Bool = false
    var body: some View {
        NavigationStack {
            ZStack {
                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .scaleEffect(isAnimating ? 0.6 : 0.4)
                    .onAppear() {
                        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                            isAnimating = true
                        }
                    }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
            .background(.mainer)
        }
        
    }
}

#Preview {
    AuthLoadingView()
}

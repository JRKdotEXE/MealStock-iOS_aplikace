//
//  GreenButton.swift
//  MealStock
//
//  Created by Jiří on 17.07.2024.
//

import SwiftUI

struct GreenButton<Destination: View>: View {
    var linkto: Destination
    var text: String
    
    init(linkto: Destination, text: String) {
        self.linkto = linkto
        self.text = text
    }
    
    var body: some View {
        NavigationLink(destination: linkto) {
            ZStack {
                Rectangle()
                    .foregroundStyle(.clear)
                    .frame(width: 95, height: 50)
                    .background(Color(red: 0.81, green: 0.83, blue: 0.7))
                    .clipShape(.rect(cornerRadius: 10))
                Text(text)
                    .fontWeight(.bold)
                    .font(.system(size: 15))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color("accentbrown"))
                    .frame(width: 79, height: 41, alignment: .center)
            }
        }
    }
}


#Preview {
    GreenButton(linkto: AddRecipeView(), text: "Button")
}


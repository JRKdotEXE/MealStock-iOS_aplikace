//
//  ShoppingListCell.swift
//  MealStock
//
//  Created by Jiří on 21.09.2024.
//
import SwiftUI

struct MealItem: View {
    @State private var isChecked: Bool = false
    @State var item: String
    @State var amount: Int = 100
    
    @State var unit: Unit = .g
    
    var body: some View {
        Button {
            isChecked.toggle()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color(red: 237/255, green: 217/255, blue: 164/255))
                    .frame(width: 364, height: 50)
                
                HStack {
                    Text(item)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(Color(red: 78/255, green: 101/255, blue: 42/255))
                        .padding(.leading, 20)
                    
                    Spacer()
                    
                    Text("Amount: \(amount) \(unit)")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(Color(red: 78/255, green: 101/255, blue: 42/255))
                    
                    Spacer()
                    
                    ZStack {
                        
                    Circle()
                        .strokeBorder(Color.black, lineWidth: 1)
                        .background(Circle().fill(Color(red: 231/255, green: 203/255, blue: 130/255)))
                        .frame(width: 25, height: 25)
                        .padding(.trailing, 20)
                    
                        if isChecked {
                            Image(systemName: "checkmark")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: 20, maxHeight: 20)
                                .padding(.trailing)
                        }
                    }
                    
                }
                .frame(maxWidth: .infinity, maxHeight: 50)
                .padding()
            }
        }
        }
}

#Preview {
    MealItem(item: "Salmon")
}

/**
 
 Image(systemName: isChecked ? "checkmark.square.fill" : "square")
                         .resizable()
                         .scaledToFit()
                         .frame(maxWidth: 20, maxHeight: 20)
 
 */

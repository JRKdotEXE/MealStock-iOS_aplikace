//
//  ContainerPost.swift
//
//  Created by codia-figma
//

import SwiftUI

struct ContainerPost: View {
    @State public var imageEllipsePath: String = "imageEllipse_33015"
    @State public var imageGroupPath: String = "imageGroup_33013"
    @State public var textMealPlanNameText: String = "Meal plan name"
    var body: some View {
        ZStack(alignment: .topLeading) {
            Rectangle()
                .fill(Color(red: 0.85, green: 0.85, blue: 0.85, opacity: 1.00))
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(red: 0.41, green: 0.36, blue: 0.21, opacity: 1.00), lineWidth: 1))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .frame(width: 360, height: 104)
                .offset(x: 16, y: 17)
            Image(imageEllipsePath)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 48, height: 44, alignment: .topLeading)
                .offset(x: 315, y: 105)
            Image(imageGroupPath)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 111.787, height: 22.389, alignment: .topLeading)
                .offset(x: 140, y: 175)
                HStack {
                    Spacer()
                        Text(textMealPlanNameText)
                            .foregroundColor(Color(red: 0.41, green: 0.36, blue: 0.21, opacity: 1.00))
                            .font(.custom("Inter-Bold", size: 20))
                            .lineLimit(1)
                            .frame(alignment: .center)
                            .multilineTextAlignment(.center)
                    Spacer()
                }
                .offset(y: 141)
        }
        .frame(width: 392, height: 255, alignment: .topLeading)
        .background(Color(red: 0.81, green: 0.83, blue: 0.70, opacity: 1.00))
        .clipped()
    }
}

struct ContainerPost_Previews: PreviewProvider {
    static var previews: some View {
        ContainerPost()
    }
}

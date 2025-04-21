//
//  ContainerMealplanPost.swift
//
//  Created by codia-figma
//

import SwiftUI

struct ContainerMealplanPost: View {
    @State public var imageEllipsePath: String = "imageEllipse_33015"
    @State public var imageGroupPath: String = "imageGroup_33013"
    @State public var textMealPlanNameText: String = "Meal plan name"
    var body: some View {
        ZStack(alignment: .topLeading) {
            ContainerPost(
                imageEllipsePath: imageEllipsePath,
                imageGroupPath: imageGroupPath,
                textMealPlanNameText: textMealPlanNameText)
                .frame(width: 392, height: 255)
        }
        .frame(width: 392, height: 255, alignment: .topLeading)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .clipped()
    }
}

struct ContainerMealplanPost_Previews: PreviewProvider {
    static var previews: some View {
        ContainerMealplanPost()
    }
}

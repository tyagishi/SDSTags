//
//  TagTokenView.swift
//
//  Created by : Tomoaki Yagishita on 2024/09/29
//  © 2024  SmallDeskSoftware
//

import SwiftUI

//public struct TagTokenView: View {
//    let text: String
//    
//    let cornerRadius = 3.0
//    let lineWidth = 0.5
//    let colorMap: ((String) -> Color)?
//
//    public init(_ text: String, colorMap: ((String) -> Color)? = nil) {
//        self.text = text
//        self.colorMap = colorMap
//    }
//    
//    public var body: some View {
//        Text(text)
//            .padding(.horizontal, 2)
//            .padding(.vertical, 1)
//            .background(bgColor.opacity(0.3))
//            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
//            .overlay(
//                RoundedRectangle(cornerRadius: cornerRadius)
//                    .stroke(bgColor, lineWidth: lineWidth)
//            )
//    }
//    
//    var bgColor: Color {
//        colorMap?(text) ?? .blue
//    }
//}

struct Tag: TagProtocol {
    var id: String { displayName }
    var displayName: String
}

#Preview {
    TagTokenView<Tag>(Tag(displayName: "Hello"))
}

public struct TagTokenView<T>: View where T: TagProtocol {
    let tag: T
    
    let cornerRadius = 3.0
    let lineWidth = 0.5
    
    let iconMap: ((T) -> (AnyView)?)?
    let colorMap: ((T) -> Color)?

    public init(_ tag: T, iconMap: ((T) -> AnyView?)? = nil, colorMap: ((T) -> Color)? = nil) {
        self.tag = tag
        self.iconMap = iconMap ?? { _ in nil }
        self.colorMap = colorMap
    }
    
    public var body: some View {
        HStack(spacing: 0) {
            iconMap?(tag)
            Text(tag.displayName)
        }
        .padding(.horizontal, 2)
        .padding(.vertical, 1)
        .background(bgColor.opacity(0.3))
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(bgColor, lineWidth: lineWidth)
        )
    }
    
    var bgColor: Color {
        colorMap?(tag) ?? .blue
    }
}

//
//  TagTokenView.swift
//
//  Created by : Tomoaki Yagishita on 2024/09/29
//  © 2024  SmallDeskSoftware
//

import SwiftUI

public struct TagTokenView: View {
    let text: String
    
    let cornerRadius = 3.0
    let lineWidth = 0.5
    let colorMap: ((String) -> Color)?

    public init(_ text: String, colorMap: ((String) -> Color)? = nil) {
        self.text = text
        self.colorMap = colorMap
    }
    
    public var body: some View {
        Text(text)
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
        colorMap?(text) ?? .blue
    }
}

#Preview {
    TagTokenView("Hello")
}

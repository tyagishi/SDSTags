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
    
    public init(_ text: String) {
        self.text = text
    }
    
    public var body: some View {
        Text(text)
            .padding(.horizontal, 2)
            .padding(.vertical, 1)
            .background(.blue.opacity(0.3))
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(.cyan, lineWidth: lineWidth)
            )
    }
}

#Preview {
    TagTokenView("Hello")
}

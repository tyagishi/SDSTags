//
//  SwiftUIView.swift
//
//  Created by : Tomoaki Yagishita on 2024/04/11
//  © 2024  SmallDeskSoftware
//

import SwiftUI

public struct TagView<T: Taggable & ObservableObject>: View {
    @ObservedObject var element: T
    
    let cornerRadius = 3.0
    let lineWidth = 0.5
    
    public init(element: T) {
        self.element = element
    }
    
    public var body: some View {
        // TODO: should be able to custom shape stype
        HStack {
            ForEach(element.tags.map({$0})) { tag in
                Text(tag.displayName)
                    .padding(.horizontal, 2)
                    .padding(.vertical, 1)
                    .background(.blue.opacity(0.3))
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(.blue, lineWidth: lineWidth)
                    )
            }
        }
    }
}

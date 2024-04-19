//
//  SwiftUIView.swift
//
//  Created by : Tomoaki Yagishita on 2024/04/11
//  © 2024  SmallDeskSoftware
//

import SwiftUI

public struct TagView<T: Taggable>: View {
    let element: T
    let getter: EditableTagGet<T>?
    
    let cornerRadius = 3.0
    let lineWidth = 0.5
    
    public init(element: T, getter: EditableTagGet<T>? = nil) {
        self.element = element
        self.getter = getter
    }
    
    public var body: some View {
        // TODO: should be able to custom shape stype
        HStack {
            ForEach(Array(tagsFrom(element: element))) { tag in
                Text(tag.displayName)
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
    }
    
    func tagsFrom(element: T) -> [T.TagType] {
        if let getter = getter {
            return getter(element)
        }
        return element.displayTags
    }
}

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
    let colorMap: ((String) -> Color)?

    public init(element: T, getter: EditableTagGet<T>? = nil, colorMap: ((String) -> Color)? = nil) {
        self.element = element
        self.getter = getter
        self.colorMap = colorMap
    }

    public var body: some View {
        // TODO: should be able to custom shape stype
        HStack {
            ForEach(Array(tagsFrom(element: element)).sorted(by: { $0.displayName < $1.displayName })) { tag in
                TagTokenView(tag.displayName, colorMap: colorMap)
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

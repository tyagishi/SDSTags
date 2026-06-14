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
    let iconMap: ((T.TagType) -> (AnyView)?)?
    let colorMap: ((T.TagType) -> Color)?

    public init(element: T, getter: EditableTagGet<T>? = nil, iconMap: ((T.TagType) -> AnyView?)? = nil, colorMap: ((T.TagType) -> Color)? = nil) {
        self.element = element
        self.getter = getter
        self.iconMap = iconMap
        self.colorMap = colorMap
    }

    public var body: some View {
        // TODO: should be able to custom shape stype
        HStack {
            ForEach(Array(tags(from: element)).sorted(by: { $0.displayName < $1.displayName })) { tag in
                TagTokenView(tag, iconMap: iconMap, colorMap: colorMap)
            }
        }
    }
    
    func tags(from element: T) -> [T.TagType] {
        if let getter = getter {
            return getter(element)
        }
        return element.displayTags
    }
}

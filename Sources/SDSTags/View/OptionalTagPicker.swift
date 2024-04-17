//
//  TagPicker.swift
//
//  Created by : Tomoaki Yagishita on 2024/04/17
//  © 2024  SmallDeskSoftware
//

import SwiftUI

public struct OptionalTagPicker<T: TagProtocol>: View {
    @Binding var selectedID: T.ID?
    let selectableTags: [T]
    
    public init(selection: Binding<T.ID?>,
                selectableTags: [T]) {
        self.selectableTags = selectableTags
        self._selectedID = Binding(projectedValue: selection)
    }
    
    public var body: some View {
        Picker(selection: $selectedID, content: {
            Text("-").tag(Optional<T.ID>.none)
            ForEach(selectableTags) { tag in
                Text(tag.displayName).tag(Optional.some(tag.id))
            }
        }, label: { Text("Tag") })
    }
}


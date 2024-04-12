//
//  EditableTagView.swift
//
//  Created by : Tomoaki Yagishita on 2024/04/11
//  © 2024  SmallDeskSoftware
//

import SwiftUI

public struct EditableTagView<T: Taggable & ObservableObject>: View {
    @ObservedObject var element: T
    let selectableTags: [T.TagType]
//    @Binding var value: String
    let alignment: Alignment
    @State private var underEditing = false {
        didSet { if underEditing { fieldFocus = true } }
    }
    @FocusState private var fieldFocus: Bool
    let editClick: Int
    //let placeholder: String
    let editIcon: Image
    
    public init(element: T, selectableTags: [T.TagType],
                //value: Binding<String>,
                //placeholder: String = "",
                editIcon: Image = Image(systemName: "pencil"),
                editClick: Int = 1, alignment: Alignment = .leading) {
        self.element = element
        self.selectableTags = selectableTags
        //self._value = value
        //self.placeholder = placeholder
        self.editIcon = editIcon
        self.alignment = alignment
        self.editClick = editClick
    }
    
    public var body: some View {
        HStack {
            if underEditing {
                TagField(element: element, selectableTags: selectableTags)
                    .focused($fieldFocus)
                    .onSubmit { underEditing.toggle() }
            } else {
                TagView(element: element)
//                Text(value)
                    .frame(maxWidth: .infinity, alignment: alignment)
                    .contentShape(Rectangle())
                    .onTapGesture(count: editClick, perform: { underEditing.toggle() })
            }
            Button(action: { underEditing.toggle()}, label: { editIcon })
        }
        .onChange(of: fieldFocus) { _ in
            if !fieldFocus { underEditing = false }
        }
    }
}

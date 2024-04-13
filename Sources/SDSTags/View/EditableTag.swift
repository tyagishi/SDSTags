//
//  EditableTagView.swift
//
//  Created by : Tomoaki Yagishita on 2024/04/11
//  © 2024  SmallDeskSoftware
//

import SwiftUI
import Combine
import NotificationCenter
import OSLog

let editableTagFocusLooseRequestNotification = Notification.Name("EditableTagFocusLooseRequestNotification")

extension OSLog {
    fileprivate static var log = Logger(subsystem: "com.smalldesksoftware.sdstags", category: "EditableTag")
    //fileprivate static var log = Logger(.disabled)
}

public struct EditableTag<T: Taggable & ObservableObject>: View {
    @ObservedObject var element: T
    let selectableTags: [T.TagType]
    let alignment: Alignment
    @State private var underEditing = false {
        didSet { if underEditing { fieldFocus = true } }
    }
    @FocusState private var fieldFocus: Bool
    let editClick: Int
    let placeholder: String?
    let editIcon: Image
    
    public init(element: T, selectableTags: [T.TagType],
                //value: Binding<String>,
                placeholder: String? = nil,
                editIcon: Image = Image(systemName: "pencil"),
                editClick: Int = 1, alignment: Alignment = .leading) {
        self.element = element
        self.selectableTags = selectableTags
        //self._value = value
        self.placeholder = placeholder
        self.editIcon = editIcon
        self.alignment = alignment
        self.editClick = editClick
    }
    
    public var body: some View {
        HStack {
            if underEditing {
                TagField(element: element, selectableTags: selectableTags, placeholder: placeholder)
                    .focused($fieldFocus)
                    .onSubmit { underEditing.toggle(); print("toggle") } // never called
            } else {
                TagView(element: element)
                //                Text(value)
                    .frame(maxWidth: .infinity, alignment: alignment)
                    .contentShape(Rectangle())
                    .onTapGesture(count: editClick, perform: { underEditing.toggle() })
            }
            Button(action: { underEditing.toggle() }, label: { editIcon })
        }
        .onChange(of: fieldFocus) {
            if !fieldFocus { underEditing = false }
        }
        .onReceive(NotificationCenter.default.publisher(for: editableTagFocusLooseRequestNotification)) { notification in
            OSLog.log.debug("onReceive")
            underEditing = false
            fieldFocus = false
        }
//        .onReceive(NotificationCenter.publisher.
//        .overlay {
//            if !underEditing,
//               element.tags.isEmpty,
//               let placeholder = placeholder {
//                Text(placeholder).opacity(0.5).frame(maxWidth: .infinity, alignment: alignment)
//            }
//        }
    }
}

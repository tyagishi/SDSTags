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
    //fileprivate static var log = Logger(subsystem: "com.smalldesksoftware.sdstags", category: "EditableTag")
    fileprivate static var log = Logger(.disabled)
}

public typealias EditableTagGet<E: Taggable> = (E) -> [E.TagType]
public typealias EditableTagGetSet<E: Taggable> = (getter: (E) -> [E.TagType], setter: (E, Set<E.TagType>) -> Void)

public struct EditableTag<T: Taggable & ObservableObject>: View {
    @ObservedObject var element: T
    let getSet: EditableTagGetSet<T>?
    let selectableTags: [T.TagType]
    let alignment: Alignment
    let editClick: Int
    let placeholder: String?
    let editIcon: Image

    @State private var underEditing = false {
        didSet { if underEditing { fieldFocus = true } }
    }
    @FocusState private var fieldFocus: Bool

    public init(element: T,
                getSet: EditableTagGetSet<T>? = nil,
                selectableTags: [T.TagType],
                placeholder: String? = nil,
                editIcon: Image = Image(systemName: "pencil"),
                editClick: Int = 1, alignment: Alignment = .leading) {
        self.element = element
        self.getSet = getSet
        self.selectableTags = selectableTags
        self.placeholder = placeholder
        self.editIcon = editIcon
        self.alignment = alignment
        self.editClick = editClick
    }
    
    public var body: some View {
        HStack {
            if underEditing {
                TagField(element: element, getSet: getSet, selectableTags: selectableTags, placeholder: placeholder)
                    .focused($fieldFocus)
                    .onSubmit { underEditing.toggle(); print("toggle") } // never called
            } else {
                let getter = (getSet == nil) ? nil : getSet!.getter
                TagView(element: element, getter: getter)
                    .frame(maxWidth: .infinity, alignment: alignment)
                    .contentShape(Rectangle())
                    .onTapGesture(count: editClick, perform: { underEditing.toggle() })
            }
            if editClick < Int.max {
                Button(action: { underEditing.toggle() }, label: { editIcon })
            }
        }
        .onChange(of: fieldFocus) {
            if !fieldFocus { underEditing = false }
        }
        .onReceive(NotificationCenter.default.publisher(for: editableTagFocusLooseRequestNotification)) { _ in
            OSLog.log.debug("onReceive")
            underEditing = false
            fieldFocus = false
        }
//        .overlay {
//            if !underEditing,
//               element.tags.isEmpty,
//               let placeholder = placeholder {
//                Text(placeholder).opacity(0.5).frame(maxWidth: .infinity, alignment: alignment)
//            }
//        }
    }
}

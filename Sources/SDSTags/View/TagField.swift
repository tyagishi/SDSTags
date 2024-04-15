//
//  File.swift
//
//  Created by : Tomoaki Yagishita on 2024/04/10
//  © 2024  SmallDeskSoftware
//

import Foundation
import SwiftUI
import Combine
import OSLog

extension OSLog {
    //fileprivate static var log = Logger(subsystem: "com.smalldesksoftware.sdstags", category: "TagField")
    fileprivate static var log = Logger(.disabled)
}

#if os(macOS)
public struct TagField<E: Taggable>: NSViewRepresentable {
    public typealias NSViewType = NSTokenField
    let element: E
    let tagFieldDelegate: TagFieldDelegate<E>
    let placeholder: String?
    var cancellable: AnyCancellable? = nil

    public init(element: E,
                getSet: EditableTagGetSet<E>?,
                selectableTags: [E.TagType], placeholder: String? = nil) {
        OSLog.log.debug(#function)
        self.element = element
        self.tagFieldDelegate = TagFieldDelegate(selectableTags: selectableTags, getSet: getSet)
        self.placeholder = placeholder
    }

    public func makeNSView(context: Context) -> NSTokenField {
        OSLog.log.debug(#function)
        let tokenField = NSTokenField()
        tagFieldDelegate.taggableElement = element
        tokenField.objectValue = element.refTags.map({ $0.displayName })
        tokenField.delegate = tagFieldDelegate
//        tokenField.placeholderString = placeholder
        return tokenField
    }
    
    public func updateNSView(_ tokenField: NSTokenField, context: Context) {
        // OSLog.log.debug(#function)
        tagFieldDelegate.taggableElement = element
        tokenField.objectValue = element.refTags.map({ $0.displayName })
        tokenField.delegate = tagFieldDelegate
//        tokenField.placeholderString = placeholder
    }
}
#else
struct TagField<T: TagProtocol>: View {
//    let element: any Taggable
//    let selectableTags: [any TagProtocol]

    init(element: any Taggable, selectableTags: Set<T>) {
//        element = element
    }
    var body: some View {
        fatalError("not implemented yet")
        TextField("Tags", text: .constant("Tag1, Tag2"))
    }
}
#endif

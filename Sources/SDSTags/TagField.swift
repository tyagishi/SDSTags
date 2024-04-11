//
//  File.swift
//
//  Created by : Tomoaki Yagishita on 2024/04/10
//  © 2024  SmallDeskSoftware
//

import Foundation
import SwiftUI
import OSLog

extension OSLog {
    fileprivate static var log = Logger(subsystem: "com.smalldesksoftware.sdstags", category: "TagField")
}

#if os(macOS)
public struct TagField<E: Taggable>: NSViewRepresentable {
    public typealias NSViewType = NSTokenField
    let element: E
    let tagFieldDelegate: TagFieldDelegate<E>
    
    public init(element: E, selectableTags: [E.TagType]) {
        // OSLog.log.debug(#function)
        self.element = element
        self.tagFieldDelegate = TagFieldDelegate(selectableTags: selectableTags)
    }

    public func makeNSView(context: Context) -> NSTokenField {
        // OSLog.log.debug(#function)
        let tokenField = NSTokenField()
        tagFieldDelegate.taggableElement = element
        tokenField.delegate = tagFieldDelegate
        return tokenField
    }
    
    public func updateNSView(_ tokenField: NSTokenField, context: Context) {
        // OSLog.log.debug(#function)
        tagFieldDelegate.taggableElement = element
        tokenField.delegate = tagFieldDelegate
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
        TextField("Tags", text: .constant("Tag1, Tag2"))
    }
}
#endif

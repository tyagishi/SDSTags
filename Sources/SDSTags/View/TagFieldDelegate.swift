//
//  File.swift
//
//  Created by : Tomoaki Yagishita on 2024/04/11
//  © 2024  SmallDeskSoftware
//

import Foundation
import Combine
import SwiftUI
import OSLog

extension OSLog {
    // fileprivate static var log = Logger(subsystem: "com.smalldesksoftware.sdstags", category: "TagFieldDelegate")
    fileprivate static var log = Logger(.disabled)
}

#if os(macOS)
// DesignNote: representObject is String (not any TagProtocol)
public class TagFieldDelegate<E: Taggable>: NSObject, NSTokenFieldDelegate {
    public var taggableElement: E? = nil
    let selectableTags: [E.TagType] // Note: not Set because order in array will be reflected to display order (basically)

    let getSet: EditableTagGetSet<E>?

    let noCompletionString = "No Completion"
    
    // TODO: maybe need to send difference or before/after
    public let needsUpdate: PassthroughSubject<Bool,Never> = PassthroughSubject()

    public init(selectableTags: [E.TagType],
                getSet: EditableTagGetSet<E>? ) {
        self.selectableTags = selectableTags
        self.getSet = getSet
        super.init()
    }
    
    func tagsFrom(element: E) -> [E.TagType] {
        if let getSet = getSet {
            return getSet.getter(element)
        }
        return element.displayTags
    }
    
    public func controlTextDidChange(_ obj: Notification) {
        OSLog.log.debug(#function)
        guard let tokenField = obj.object as? NSTokenField,
              let stringArray = tokenField.objectValue as? [String] else { return }
        guard let taggableElement else { fatalError("set taggableElement first") }

        // TODO: need to know which chars are actually typed, which chars are complemented?

        let oldTagStrArray = tagsFrom(element: taggableElement).map({ $0.displayName })

        if !oldTagStrArray.sameContents(stringArray) {
            tokenField.backgroundColor = .selectedTextBackgroundColor
        } else {
            tokenField.backgroundColor = .textBackgroundColor
        }
    }

    public func controlTextDidEndEditing(_ obj: Notification) {
        OSLog.log.debug("controlTextDidEndEditing \(obj)")
        guard let tokenField = obj.object as? NSTokenField,
              let stringArray = tokenField.objectValue as? [String] else { return }
        let refTags = stringArray.compactMap({ selectableTags.firstTag(name: $0) })

        guard let taggableElement = taggableElement else { fatalError("set taggableElement first") }
        let oldTagStrArray = tagsFrom(element: taggableElement).map({ $0.displayName })
        
        if !oldTagStrArray.sameContents(stringArray) {
            updateElement(Set(refTags))
        }
        tokenField.backgroundColor = .textBackgroundColor
        let notification = Notification(name: editableTagFocusLooseRequestNotification)
        NotificationCenter.default.post(notification)
    }
    
    public func tokenField(_ tokenField: NSTokenField, displayStringForRepresentedObject representedObject: Any) -> String? {
        OSLog.log.debug(#function)
        if let string = representedObject as? String { OSLog.log.debug("return \(string)"); return string }
        OSLog.log.debug("return nil")
        return nil
    }
    
    func updateElement(_ refTags: Set<E.TagType>) {
        guard var taggableElement = taggableElement else { fatalError("set taggableElement first") }
        needsUpdate.send(true)
        if let getSet = getSet {
            getSet.setter(taggableElement, refTags)
        } else {
            taggableElement.refTags = refTags
        }
    }

    public func tokenField(_ tokenField: NSTokenField, completionsForSubstring substring: String,
                           indexOfToken tokenIndex: Int, indexOfSelectedItem selectedIndex: UnsafeMutablePointer<Int>?) -> [Any]? {
        OSLog.log.debug(#function)
        guard let strings = tokenField.objectValue as? [String] else { return [] }

        let restTagNames = selectableTags.map({ $0.displayName }).filter({ !strings.contains($0) })

        // MARK: may need to be controlled from outside (like case sensitive?, checking prefix is too much?, need to hide unrelated?, ...)
        var prio0: [String] = []
        var prio1: [String] = []
        var prio2: [String] = []
        var prio3: [String] = []
        for name in restTagNames {
            if name.hasPrefix(substring) { prio0.append(name)
            } else if name.capitalized.hasPrefix(substring.capitalized) { prio1.append(name)
            } else if name.contains(substring) { prio2.append(name)
            } else { prio3.append(name)}
        }

        prio0.sort()
        prio1.sort()
        prio2.sort()
        prio3.sort()

        let completion = prio0 + prio1 + prio2 + prio3
        
        var selectionIndex = -1
        let prefixMatches = completion.filter({ $0.hasPrefix(substring) })
        if prefixMatches.count == 1,
           let index = completion.firstIndex(where: { $0.hasPrefix(substring) }) {
            selectionIndex = index
        }
        selectedIndex?.pointee = selectionIndex
        
        guard !completion.isEmpty else { return [noCompletionString] }
        return completion
    }
    
    public func tokenField(_ tokenField: NSTokenField, editingStringForRepresentedObject representedObject: Any) -> String? {
        OSLog.log.debug(#function)
        if let repre = representedObject as? String? { return repre }
        return nil
    }
    
    public func tokenField(_ tokenField: NSTokenField, shouldAdd tokens: [Any], at index: Int) -> [Any] {
        guard let strings = tokens as? [String] else { return tokens }
        return strings.filter({ $0 != noCompletionString })
    }
}
#endif

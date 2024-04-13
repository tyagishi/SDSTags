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
    fileprivate static var log = Logger(subsystem: "com.smalldesksoftware.sdstags", category: "TagFieldDelegate")
}

#if os(macOS)
// DesignNote: representObject is String (not any TagProtocol)
public class TagFieldDelegate<E: Taggable>: NSObject, NSTokenFieldDelegate {
    public var taggableElement: E? = nil
    let selectableTags: [E.TagType] // Note: not Set because order in array will be reflected to display order (basically)
    
    let noCompletionString = "No Completion"
    
    // TODO: maybe need to send difference or before/after
    public let needsUpdate: PassthroughSubject<Bool,Never> = PassthroughSubject()
    
    public init(selectableTags: [E.TagType]) {
        self.selectableTags = selectableTags
        super.init()
    }

    public func controlTextDidChange(_ obj: Notification) {
        OSLog.log.debug(#function)
        guard let tokenField = obj.object as? NSTokenField,
              let stringArray = tokenField.objectValue as? [String] else { return }
        guard let taggableElement else { fatalError("set taggableElement first") }

        // TODO: need to know which chars are actually typed, which chars are complemented?
        
        let oldTagStrArray = taggableElement.tags.map({ $0.displayName })

        if !oldTagStrArray.sameContents(stringArray) {
            tokenField.backgroundColor = .selectedTextBackgroundColor
        } else {
            tokenField.backgroundColor = .textBackgroundColor
        }
    }

    public func controlTextDidEndEditing(_ obj: Notification) {
        OSLog.log.debug("controlTextDidChange \(obj)")
        guard let tokenField = obj.object as? NSTokenField,
              let stringArray = tokenField.objectValue as? [String] else { return }
        let tags = stringArray.compactMap({ selectableTags.firstTag(name: $0) })

        guard let taggableElement = taggableElement else { fatalError("set taggableElement first") }
        let oldTagStrArray = taggableElement.tags.map({ $0.displayName })
        
        if !oldTagStrArray.sameContents(stringArray) {
            updateElement(Set(tags))
        }
        tokenField.backgroundColor = .textBackgroundColor
        let notification = Notification(name: editableTagFocusLooseRequestNotification)
        NotificationCenter.default.post(notification)
    }
    
    func updateElement(_ tags: Set<E.TagType>) {
        guard var taggableElement = taggableElement else { fatalError("set taggableElement first") }
        needsUpdate.send(true)
        taggableElement.tags = tags
    }

    public func tokenField(_ tokenField: NSTokenField, completionsForSubstring substring: String,
                           indexOfToken tokenIndex: Int, indexOfSelectedItem selectedIndex: UnsafeMutablePointer<Int>?) -> [Any]? {
        OSLog.log.debug(#function)
        guard let strings = tokenField.objectValue as? [String] else { return [] }

        let restTagNames = selectableTags.map({ $0.displayName }).filter({ !strings.contains($0) })

        // MARK: may need to be controlled from outside (like case sensitive?, checking prefix is too much?, need to hide unrelated?, ...)
        var prio1: [String] = []
        var prio2: [String] = []
        var prio3: [String] = []
        for name in restTagNames {
            if name.hasSuffix(substring) { prio1.append(name)
            } else if name.contains(substring) { prio2.append(name)
            } else { prio3.append(name)}
        }
        
        prio1.sort()
        prio2.sort()
        prio3.sort()

        let completion = prio1 + prio2 + prio3
        
        guard !completion.isEmpty else { return [noCompletionString] }
        return completion
    }
    
    public func tokenField(_ tokenField: NSTokenField, editingStringForRepresentedObject representedObject: Any) -> String? {
        if let repre = representedObject as? String? { return repre }
        return nil
    }
    
    public func tokenField(_ tokenField: NSTokenField, shouldAdd tokens: [Any], at index: Int) -> [Any] {
        guard let strings = tokens as? [String] else { return tokens }
        return strings.filter({ $0 != noCompletionString })
    }
}
#endif

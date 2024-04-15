//
//  File.swift
//
//  Created by : Tomoaki Yagishita on 2024/04/10
//  © 2024  SmallDeskSoftware
//

import Foundation

public protocol Taggable<TagType> where TagType: TagProtocol {
    associatedtype TagType

    var refTags: Set<TagType> { get set }
    var displayTags: [TagType] { get }
}

public extension Taggable {
    var displayTags: [TagType] {
        Array(refTags)
    }

    func hasTag(_ tag: TagType) -> Bool {
        refTags.contains(where: { $0.id == tag.id })
    }

    var tagsString: String {
        refTags.tagsString()
    }
}

public protocol TagProtocol: Identifiable, Hashable {
    var displayName: String { get }
}

// MARK: convenient method for Collection<Taggable>
extension Collection where Element: Taggable {
    public func tagFilter(tag: Element.TagType) -> [Element] {
        filter({ $0.hasTag(tag) })
    }
}

// MARK: convenient method for Collection<TagProtocol>
extension Collection where Element: TagProtocol {
    public func firstTag(name: String) -> Element? {
        first(where: { $0.displayName == name })
    }
    public func tagsString(_ separator: String = ",") -> String {
        map({ $0.displayName }).joined(separator: separator)
    }
    public func tagFrom(strings: [String]) -> [Element] {
        strings.compactMap({ self.firstTag(name: $0) })
    }
}

// MARK: convenient method for [String]
extension Array where Element == String {
    public func containString(_ elem: String) -> Bool {
        return first(where: { $0 == elem }) != nil
    }
    
    public func sameContents(_ another: [Element]) -> Bool {
        return self.sorted().elementsEqual(another.sorted())
    }
}

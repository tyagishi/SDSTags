//
//  Taggable.swift
//  SDSTags
//
//  Created by Tomoaki Yagishita on 2026/06/14.
//

import Foundation

public protocol Taggable<TagType> where TagType: TagProtocol {
    associatedtype TagType

    var refTags: Set<TagType> { get }
    func addTag(_ addTag: TagType)
    func removeTag(_ removeTag: TagType)
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
    
    func addTags(_ addTags: any Collection<TagType>) {
        for tag in addTags where !refTags.contains(tag) {
            addTag(tag)
        }
    }
    func removeTags(_ removeTags: any Collection<TagType>) {
        for tag in removeTags where refTags.contains(tag) {
            removeTag(tag)
        }
    }
    func updateTags(_ newTags: any Collection<TagType>) {
        let newSetTags = Set(newTags)
        let toBeAdded = newSetTags.subtracting(refTags)
        let toBeRemoved = refTags.subtracting(newSetTags)
        removeTags(toBeRemoved)
        addTags(toBeAdded)
    }
}

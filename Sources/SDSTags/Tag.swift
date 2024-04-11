//
//  File.swift
//
//  Created by : Tomoaki Yagishita on 2024/04/10
//  © 2024  SmallDeskSoftware
//

import Foundation

public protocol Taggable {
    var tags: [any TagProtocol] { get set }
}

public protocol TagProtocol: Identifiable, Hashable {
    var displayName: String { get }
}

public protocol TagList {
    var tags: [any TagProtocol] { get set }
    var displayNames: [String] { get }
}

// MARK: convenient method for [any TagProtocol]
extension Collection where Element: TagProtocol {
    func firstTag(name: String) -> (any TagProtocol)? {
        first(where: { $0.displayName == name })
    }
}

// MARK: convenient method for [String]
extension Array where Element == String {
    func containString(_ elem: String) -> Bool {
        return first(where: { $0 == elem }) != nil
    }
    
    func sameContents(_ another: [Element]) -> Bool {
        return self.sorted().elementsEqual(another.sorted())
    }
}


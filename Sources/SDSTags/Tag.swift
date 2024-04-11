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

//extension Collection where Element == any TagProtocol {
//    func contain
//}

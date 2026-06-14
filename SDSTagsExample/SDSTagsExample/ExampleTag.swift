//
//  Tag.swift
//  SDSTagsExample
//
//  Created by Tomoaki Yagishita on 2026/06/14.
//

import SwiftUI
import SDSTags
import OSLog
import SDSCustomView
import Combine

struct ExampleTag: TagProtocol, Hashable {
    let id: UUID = UUID()
    var displayName: String
    
    init(_ name: String) {
        displayName = name
    }
}
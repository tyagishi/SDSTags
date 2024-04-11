//
//  SwiftUIView.swift
//
//  Created by : Tomoaki Yagishita on 2024/04/11
//  © 2024  SmallDeskSoftware
//

import SwiftUI

struct TagView<T: Taggable>: View {
    let element: T
    
    init(element: T) {
        self.element = element
    }
    
    var body: some View {
        VStack {
            Text("Not implemented")
            Text(element.tagsString)
        }
    }
}

//#Preview {
//    Tag(element: <#T##any Taggable#>)
//}

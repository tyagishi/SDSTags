//
//  ContentView.swift
//
//  Created by : Tomoaki Yagishita on 2024/04/10
//  © 2024  SmallDeskSoftware
//

import SwiftUI
import SDSTags
import OSLog
import SDSNSUIBridge
import SDSView
import SDSCustomView
import Combine

let tags: [Tag] = [ Tag("SoftDrink"), Tag("Water"), Tag("Coffee"), Tag("BlackTea"), Tag("GreenTea"),  Tag("Beer") ]

struct ContentView: View {
    @State var items: [TaggableItem] = []
    @StateObject var item: TaggableItem = TaggableItem(title: "Order", tags: [])
    @State private var changeState = false
    @State private var index = 1
    var body: some View {
        VStack {
            HStack {
                EditableText(value: $item.title)
                //Text("Item title: \(item.title) tags:")
                //TagField(element: item, selectableTags: tags)
                EditableTag(element: item, selectableTags: tags, placeholder: "Order")
            }
            TagView(element: item)
            List($items) { $item in
                HStack {
                    EditableText(value: $item.title)
                        .indirectEdit()
                    EditableTag(element: item, selectableTags: tags)
                }
            }
            .scrollContentBackground(.hidden)
            Button(action: {
                let customerName = "Customer\(index)"
                index += 1
                items.append(TaggableItem(title: customerName, tags: []))
            }, label: {
                Text("add new")
            })
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

extension OSLog {
    fileprivate static var log = Logger(subsystem: "com.smalldesksoftware.sdstags", category: "tagfield")
}

struct Tag: TagProtocol, Hashable {
    let id: UUID = UUID()
    var displayName: String
    
    init(_ name: String) {
        displayName = name
    }
}


class TaggableItem: Taggable, Identifiable, ObservableObject {
    typealias TagType = Tag
    var id: String { self.title }
    @Published var tags: Set<TagType>
    
    @Published var title: String
    
    init(title: String, tags: Set<TagType>) {
        self.title = title
        self.tags = tags
    }
}



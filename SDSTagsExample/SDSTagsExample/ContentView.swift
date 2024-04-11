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
import Combine

let tags: [Tag] = [ Tag("Tokyo"), Tag("Nagoya"), Tag("Yokohama"), Tag("Toyama") ]

struct ContentView: View {
    @State var items: [TaggableItem] = []
    @StateObject var item: TaggableItem = TaggableItem(title: "Taggable", tags: [])
    @State private var changeState = false
    var body: some View {
        VStack {
            Text("Item title: \(item.title) tags: \(item.tagsString)")
                .frame(maxWidth: .infinity, alignment: .leading)
            HStack {
                Text("Tags:")
                TagField(element: item, selectableTags: tags)
            }
            
            
            List(items) { item in
                HStack {
                    Text(item.title)
                    
                }
            }
            Button(action: {
                let title = String(Int(Date().timeIntervalSinceReferenceDate))
                guard items.first(where: { $0.id == title }) == nil else { return }
                items.append(TaggableItem(title: title, tags: []))
            }, label: {
                Text("add new")
            })
            
            
//            ScrollTextView(text: .constant("Hello world!"),
//                           textViewFactory: textViewFactory,
//                           textViewUpdate: textViewUpdate)
            
        }
        .padding()
    }
    
    func textViewFactory() -> (NSUITextView, NSUIScrollView) {
        let scrollView = NSUIScrollView()
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = false
        
        let textView = NSUITextView(frame: .zero)
        textView.autoresizingMask = [.height, .width]
        scrollView.documentView = textView
        return (textView, scrollView)
    }
    
    func textViewUpdate(_ textView: NSUITextView,_ scrollView: NSUIScrollView, _ text: String) {
        return
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



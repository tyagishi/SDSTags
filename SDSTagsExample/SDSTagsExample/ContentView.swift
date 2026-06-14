//
//  ContentView.swift
//
//  Created by : Tomoaki Yagishita on 2024/04/10
//  © 2024  SmallDeskSoftware
//

import SwiftUI
import SDSTags
import OSLog
import SDSCustomView
import Combine

let prefixTags: [ExampleTag] = [ ExampleTag("01SoftDrink"), ExampleTag("01Water"), ExampleTag("02Coffee"), ExampleTag("02BlackTea"), ExampleTag("02GreenTea"),  ExampleTag("03Beer") ]

let prefixMap: [String: (name: String, color: Color)] = ["01": ("waterbottole", Color.blue),
                                                         "02": ("cup.and.saucer", Color.purple),
                                                         "03": ("mug", Color.red)]

struct ContentView: View {
    
    @State private var taggableElement = TaggableItem(title: "Item", tags: Set(prefixTags))

    var body: some View {
        VStack {
            GroupBox("TagTokenViews", content: {
                ForEach(prefixTags) { tag in
                    TagTokenView(tag, iconMap: { tag in
                        return iconMap(tag)
                    }, colorMap: { tag in
                        prefixColor(tag.displayName, prefixMap)
                    })
                }
            })
            GroupBox("TagView from TaggableElement", content: {
                TagView(element: taggableElement,
                        iconMap: { tag in
                    iconMap(tag)
                }, colorMap: { tag in prefixColor(tag.displayName, prefixMap) })
            })
        }
    }
    
    func prefixColor(_ string: String,_ colorMap: [String: (name: String, color: Color)]) -> Color {
        for pre in colorMap.keys {
            if string.hasPrefix(pre) { return colorMap[pre]?.color ?? .blue }
        }
        return .blue
    }
    
    func iconMap<T: TagProtocol>(_ tag: T) -> AnyView {
        if tag.displayName.contains("Tea") ||
            tag.displayName.contains("Coffee") { return AnyView(Image(systemName: "cup.and.saucer")) }
        if tag.displayName.contains("Beer") { return AnyView(Image(systemName: "mug")) }
        if tag.displayName.contains("Water") { return AnyView(Image(systemName: "waterbottle")) }
        return AnyView(Image(systemName: "wineglass"))
    }
}


struct TextFieldWithSuggestionsView: View {
    @State var items: [TaggableItem] = []
    @StateObject var item: TaggableItem = TaggableItem(title: "Order", tags: [])
    @State private var changeState = false
    @State private var index = 1
    
    @State private var selectedTagIDs: Set<ExampleTag.ID> = []
    
    @State private var fieldText: String = "Hello"

    var body: some View {
        VStack {
            MyContentView()
//            if #available(macOS 15, *) {
//                TextFieldWithSuggestions($fieldText, suggestions: { _ in
//                    ["Hello", "World", "Hallo"]
//                }, trigger: { trigValue in
//                    print(trigValue)
//                    if trigValue != "a" { return false }
//                    return true
//                }, handler: { (prev, new) in
//                    print("prev: \(prev) new: \(new)")
//                    return new
//                })
//            }
            TagTokenField(selectedTokenIDs: $selectedTagIDs, tags: prefixTags)
            TagTokenView(prefixTags[0])
            HStack {
                EditableText(value: $item.title)
                //Text("Item title: \(item.title) tags:")
                //TagField(element: item, selectableTags: prefixTags)
                EditableTag(element: item, selectableTags: prefixTags, placeholder: "Order")
            }
            Group {
                HStack {
                    Text("Current Tags: ")
                    TagView(element: item)
                }
            }
            List($items) { $item in
                HStack {
                    EditableText(value: $item.title)
                        .indirectEdit()
                    EditableTag(element: item, selectableTags: prefixTags)
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
    fileprivate static var log = Logger(subsystem: "com.smalldesksoftware.sdstags", category: "exampleApp")
}

class TaggableItem: Taggable, Identifiable, ObservableObject {
    typealias TagType = ExampleTag
    var id: String { self.title }
    @Published var refTags: Set<TagType>
    
    @Published var title: String
    
    init(title: String, tags: Set<TagType>) {
        self.title = title
        self.refTags = tags
    }
    
    func addTag(_ addTag: ExampleTag) {
        refTags.insert(addTag)
    }
    
    func removeTag(_ removeTag: ExampleTag) {
        refTags.remove(removeTag)
    }
}


// Holds one uniquely identifiable movie.
struct Movie: Identifiable {
    var id = UUID()
    var name: String
    var genre: String
}

// Holds one token that we want the user to filter by. This *must* conform to Identifiable.
struct Token: Identifiable {
    var id: String { name }
    var name: String
}

struct MyContentView: View {
    // Whatever text the user has typed so far.
    @State private var searchText = ""

    // All possible tokens we want to show to the user.
    let allTokens = [Token(name: "Action"), Token(name: "Comedy"), Token(name: "Drama"), Token(name: "Family"), Token(name: "Sci-Fi")]

    // The list of tokens the user currently has selected.
    @State private var currentTokens = [Token]()

    // The list of tokens we want to show to the user right now. Activates token selection only when searchText starts with #.
    var suggestedTokens: [Token] {
        if searchText.starts(with: "#") {
            return allTokens
        } else {
            return []
        }
    }

    // Some data to show and filter by.
    let movies = [
        Movie(name: "Avatar", genre: "Sci-Fi"),
        Movie(name: "Inception", genre: "Sci-Fi"),
        Movie(name: "Love Actually", genre: "Comedy"),
        Movie(name: "Paddington", genre: "Family")
    ]

    // The real work: filter all the movies based on search text or tokens.
    var searchResults: [Movie] {
        // trim whitespace
        let trimmedSearchText = searchText.trimmingCharacters(in: .whitespaces)

        return movies.filter { movie in
            if searchText.isEmpty == false {
                // If we have search text, make sure this item matches.
                if movie.name.localizedCaseInsensitiveContains(trimmedSearchText) == false {
                    return false
                }
            }

            if currentTokens.isEmpty == false {
                // If we have search tokens, loop through them all to make sure one of them matches our movie.
                for token in currentTokens {
                    if token.name.localizedCaseInsensitiveContains(movie.genre) {
                        return true
                    }
                }

                // This movie does *not* match any of our tokens, so it shouldn't be sent back.
                return false
            }

            // If we're still here then the movie should be included.
            return true
        }
    }

    var body: some View {
        NavigationStack {
            List(searchResults) { movie in
                Text(movie.name)
            }
            .navigationTitle("Movies+")
            .searchable(text: $searchText, tokens: $currentTokens, suggestedTokens: .constant(suggestedTokens), prompt: Text("Type to filter, or use # for tags")) { token in
                Text(token.name)
            }
        }
    }
}

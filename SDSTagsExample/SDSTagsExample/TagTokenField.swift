//
//  TagTokenField.swift
//  SDSTags
//
//  Created by Tomoaki Yagishita on 2025/07/24.
//

import SwiftUI
import SDSTags
import SDSMacros

struct OwnTag: Identifiable, TagProtocol {
    var id: UUID = UUID()
    let name: String
    
    init(_ name: String) {
        self.name = name
    }
    
    var displayName: String { name }
}

struct TagTokenField<Tag: TagProtocol>: View {
    @Binding var selectedTokenIDs: Set<Tag.ID>
    @State var cursorTokenID: Tag.ID? = nil
    
    @FocusState var fieldFocus: Bool
    
    enum TokenFocusIndex: Equatable, Hashable, CustomStringConvertible {
        case index(Int)
        var description: String {
            if case .index(let value) = self {
                return "index\(value)"
            }
            return "strange state"
        }
    }
    
    @FocusState var tokenFocus: TokenFocusIndex?
    
    let tags: [Tag]
    var body: some View {
        HStack {
            ForEach(tags) { tag in
                let index = tags.firstIndex(of: tag)!
                Text(tag.displayName)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .overlay {
                        RoundedRectangle(cornerRadius: 5).stroke(selectedTokenIDs.contains(tag.id) ? .red : .clear,
                                                                 lineWidth: 3)
                    }
                    .background {
                        RoundedRectangle(cornerRadius: 5).fill(.gray.opacity(0.2))
                    }
                    .onTapGesture {
                        if selectedTokenIDs.contains(tag.id) { selectedTokenIDs.remove(tag.id)
                        } else { selectedTokenIDs.insert(tag.id) }
                    }
                    .focusable()
                    .focused($tokenFocus, equals: TokenFocusIndex.index(index))
            }
        }
        .padding(8)
        .contentShape(RoundedRectangle(cornerRadius: 5))
        .focusable()
        .overlay {
            RoundedRectangle(cornerRadius: 5).stroke(fieldFocus == true ? .red : .clear,
                                                     lineWidth: 3)
        }
        .focused($fieldFocus)
        .onChange(of: tokenFocus, {
            // note: FocusState は親子関係があれば、同時に true になり得る。
            print("tokenFocus: \(tokenFocus?.description ?? "nil")")
            print("fieldFocus: \(fieldFocus)")
        })
        .onChange(of: fieldFocus, {
            print("fieldFocus: \(fieldFocus)")
        })
    }
}

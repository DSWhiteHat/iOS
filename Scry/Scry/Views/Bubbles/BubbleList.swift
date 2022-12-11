//
//  BubbleList.swift
//  Scry
//
//  Created by Stebbins, Daniel Ross on 11/15/22.
//

import SwiftUI

struct BubbleList: View {
    @Environment (\.dismiss) private var dismiss
    
    @State var search: String = ""
    
    var body: some View {
        ClosableSheet {
            List {
                ListSection<Character>(search: $search)
                ListSection<Faction>(search: $search)
                ListSection<Item>(search: $search)
                ListSection<Location>(search: $search)
            }
            .searchable(text: $search)
            .padding()
            .navigationTitle("Bubble List")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: Character.self) {value in
                CharacterView(character: value)
            }
            .navigationDestination(for: Faction.self) {value in
                FactionView(faction: value)
            }
            .navigationDestination(for: Item.self) {value in
                ItemView(item: value)
            }
            .navigationDestination(for: Location.self) {value in
                LocationView(location: value)
            }
        }
    }
}

struct ListSection<T>: View where T: Bubble {
    @Binding var search: String
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)]) var bubbles: FetchedResults<T>
    
    var searchResults: [T] {
        bubbles.filter({ b in search.isEmpty || b.name!.lowercased().contains(search.lowercased()) }) as [T]
    }
    
    var body: some View {
        Section {
            ForEach(searchResults) {b in
                LinkedBubbleCapsule<T>(bubble: b)
                    .labelStyle(.titleOnly)
            }
        } header: {
            Text(String(describing: T.self))
        }
        .listRowBackground(Color.background)
    }
}

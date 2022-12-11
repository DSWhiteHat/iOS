//
//  CharacterView.swift
//  Scry
//
//  Created by Stebbins, Daniel Ross on 11/15/22.
//

import SwiftUI

struct CharacterView: View {
    @ObservedObject var character: Character
    
    @Environment (\.dismiss) private var dismiss
    @State var isEditing: Bool = false
    
    var body: some View {
        BubbleView(bubble: character, isEditing: $isEditing) {
            GeometryReader { geometry in
                VStack {
                    CapsuleGrid<Faction>(bubble: character, title: "Factions", bubbles: character.factions!, addFunction: character.addToFactions, shown: character.displayFactions, maxWidth: geometry.size.width)
                    CapsuleGrid<Location>(bubble: character, title: "Locations", bubbles: character.locations!, addFunction: character.addToLocations, shown: character.displayLocations, maxWidth: geometry.size.width)
                    CapsuleGrid<Item>(bubble: character, title: "Items", bubbles: character.items!, addFunction: character.addToItems, shown: character.displayItems, maxWidth: geometry.size.width)
                }
            }
        }
        .sheet(isPresented: $isEditing) {
            CharacterEditSheet(character: character, dismissParent: dismiss)
                .presentationDetents([.fraction(0.6)])
        }
        EmptyView()
    }
}

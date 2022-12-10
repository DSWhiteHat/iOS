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
            VStack {
                CapsuleRow<Faction>(bubble: character, title: "Factions", bubbles: character.factions!, addFunction: character.addToFactions, shown: character.displayFactions)
                CapsuleRow<Location>(bubble: character, title: "Locations", bubbles: character.locations!, addFunction: character.addToLocations, shown: character.displayLocations)
                CapsuleRow<Item>(bubble: character, title: "Items", bubbles: character.items!, addFunction: character.addToItems, shown: character.displayItems)
            }
        }
        .sheet(isPresented: $isEditing) {
            CharacterEditSheet(character: character, dismissParent: dismiss)
                .presentationDetents([.fraction(0.6)])
        }
    }
}

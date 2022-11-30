//
//  LocationView.swift
//  Scry
//
//  Created by Stebbins, Daniel Ross on 11/15/22.
//

import SwiftUI

struct LocationView: View {
    @ObservedObject var location: Location
    @Environment (\.dismiss) private var dismiss
    @State var isEditing: Bool = false
    
    var body: some View {
        BubbleView(bubble: location, isEditing: $isEditing) {
            VStack {
                if location.displayFactions {
                    CapsuleRow<Faction>(bubble: location, title: "Factions", bubbles: location.factions!, addFunction: location.addToFactions)
                }
                if location.displayCharacters {
                    CapsuleRow<Character>(bubble: location, title: "Characters", bubbles: location.characters!, addFunction: location.addToCharacters)
                }
                if location.displayItems {
                    CapsuleRow<Item>(bubble: location, title: "Items", bubbles: location.items!, addFunction: location.addToItems)
                }
            }
        }
        .sheet(isPresented: $isEditing) {
            LocationEditSheet(location: location, dismissParent: dismiss)
                .presentationDetents([.fraction(0.6)])
        }
    }
}

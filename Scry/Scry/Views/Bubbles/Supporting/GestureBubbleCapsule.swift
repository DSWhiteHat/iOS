//
//  GestureBubbleCapsule.swift
//  Scry
//
//  Created by Stebbins, Daniel Ross on 12/8/22.
//

import SwiftUI

struct GestureBubbleCapsule: View {
    @ObservedObject var mappedBubble: MappedBubble
    @Binding var selectedBubble: Bubble?
    var tool: Tool
    @Binding var showConfirmation: Bool
    
    @State private var offset = CGSize.zero
    
    var body: some View {
        let move = DragGesture()
            .onChanged {value in
                offset = value.translation
            }
            .onEnded { value in
                mappedBubble.x += value.translation.width
                mappedBubble.y += value.translation.height
                offset = CGSize.zero
            }
        
        let tap = TapGesture()
            .onEnded {
                selectedBubble = mappedBubble.bubble!
                showConfirmation = true
            }
        
        // Fixes timing problem on mappedBubble deletion.
        if let bubble = mappedBubble.bubble {
            BubbleCapsule(bubble: bubble)
                .offset(offset)
                .position(x: mappedBubble.x, y: mappedBubble.y)
                .gesture(tool == .move ? move : nil)
                .gesture(tool == .select ? tap : nil)
        }
    }
}
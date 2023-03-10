//
//  BubbleCapsule.swift
//  Scry
//
//  Created by Stebbins, Daniel Ross on 11/11/22.
//

import SwiftUI

// Just a BubbleCapsule that navigates to the bubble's detail page.
// The destination is set in the container view for type reasons.
struct LinkedBubbleCapsule<T>: View where T: Bubble{
    @ObservedObject var bubble: T
    var font: Font? = .body
    
    var body: some View {
        NavigationLink(value: bubble) {
            BubbleCapsule(bubble: bubble)
        }
    }
}


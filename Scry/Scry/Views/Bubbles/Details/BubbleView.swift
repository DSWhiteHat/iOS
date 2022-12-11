//
//  BubbleView.swift
//  Scry
//
//  Created by Stebbins, Daniel Ross on 11/16/22.
//

import SwiftUI

struct BubbleView<Content>: View where Content: View {
    @ObservedObject var bubble: Bubble
    
    @Binding var isEditing: Bool
    let content: () -> Content
    
    var body: some View {
        GeometryReader { bubbleGeometry in
            ScrollView {
                if let image = bubble.image {
                    Image(uiImage: UIImage(data: image)!)
                        .resizable()
                        .scaledToFit()
                        .border(Color(bubble: bubble), width: 2)
                        .padding()
                }
                
                if bubble.notes!.count != 0 || bubble.displayNotes {
                    MultilineTextInput(title: "Notes", text: Binding($bubble.notes)!)
                }
                
                content()
                Spacer()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                BubbleCapsule(bubble: bubble)
                    .font(.headline)
                    .labelStyle(.titleAndIcon)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { isEditing.toggle() }) {
                    Image(systemName: "pencil").imageScale(.large)
                }
            }
        }
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}

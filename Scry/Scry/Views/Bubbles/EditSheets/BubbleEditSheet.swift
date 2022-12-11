//
//  BubbleEditSheet.swift
//  Scry
//
//  Created by Thomas Stebbins on 11/20/22.
//

import SwiftUI

struct BubbleEditSheet<Content>: View where Content: View {
    @ObservedObject var bubble: Bubble
    let dismissParent: DismissAction
    let content: () -> Content
    
    @Environment (\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) var context
    
    var body: some View {
        let deleteButton = ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: { dismiss(); context.delete(bubble); dismissParent() }) {
                Image(systemName: "trash")
                    .imageScale(.large)
                    .tint(.red)
            }
        }
        
        ClosableSheet {
            VStack {
                TextField("Name", text: Binding($bubble.name)!)
                    .multilineTextAlignment(.center)
                    .bold()
                    .italic()
                    .font(.headline)
                    .padding([.leading, .trailing], 7)
                    .padding([.top, .bottom], 5)
                    .background {
                        Capsule()
                            .fill(Color(bubble: bubble))
                    }
                ColorPicker("Choose Color", selection: Binding(get: { Color(bubble: bubble) }, set: {newColor in
                    let components = newColor.components
                    bubble.red = Int16(components[0] * 255)
                    bubble.green = Int16(components[0] * 255)
                    bubble.blue = Int16(components[0] * 255)
                }), supportsOpacity: false)
                PhotoPickerView(title: "Bubble Image", selection: $bubble.image)
                
                DisplayElementButton(text: "Notes", display: $bubble.displayNotes)
                content()
                Spacer()
            }
            .navigationTitle("Edit Bubble")
            .navigationBarTitleDisplayMode(.inline)
            .padding()
            .toolbar { deleteButton }
        }
    }
}

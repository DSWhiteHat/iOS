//
//  ScrollingMapView.swift
//  Scry
//
//  Created by Stebbins, Daniel Ross on 11/30/22.
//

import SwiftUI

struct ScrollingMapView: View {
    @ObservedObject var map: Map
    let mapMenuFullyOpen: Bool
    let closeMapMenu: () -> Void
    
    @State var tool: Tool = .select
    @State var sheet: MapShownSheet?
    @State var x: Double = 0.0
    @State var y: Double = 0.0
    @State var selectedBubble: Bubble?
    @State var showSelectConfirmation: Bool = false
    @State var addMappedBubble: Bool = false
    @State var showAddConfirmation: Bool = false
    
    @State var drawColor: Color = Color.randomDarkColor
    @State var drawSize: Size = .medium
    
    @Environment(\.managedObjectContext) var context
    
    var body: some View {
        let defaultToolbar = ToolbarItemGroup(placement: .bottomBar) {
            Spacer()
            Picker("Tool", selection: $tool) {
                ForEach(Tool.allCases) {
                    Label($0.rawValue, systemImage: $0.imageName).tag($0).imageScale(.large)
                }
            }
            .pickerStyle(.menu)
            .disabled(mapMenuFullyOpen)
            Spacer()
        }
        
        let drawToolbar = ToolbarItemGroup(placement: .bottomBar) {
            SizePicker(size: $drawSize)
                .disabled(mapMenuFullyOpen)
            Spacer()
            Picker("Tool", selection: $tool) {
                ForEach(Tool.allCases) {
                    Label($0.rawValue, systemImage: $0.imageName).tag($0)
                }
            }
            .pickerStyle(.menu)
            .disabled(mapMenuFullyOpen)
            Spacer()
            ColorPicker("", selection: $drawColor)
                .labelsHidden()
                .disabled(mapMenuFullyOpen)
        }
        
        let eraseToolbar = ToolbarItemGroup(placement: .bottomBar) {
            SizePicker(size: $drawSize)
                .disabled(mapMenuFullyOpen)
            Spacer()
            Picker("Tool", selection: $tool) {
                ForEach(Tool.allCases) {
                    Label($0.rawValue, systemImage: $0.imageName).tag($0)
                }
            }
            .pickerStyle(.menu)
            .disabled(mapMenuFullyOpen)
            Spacer()
        }
        
        let tap = SpatialTapGesture()
            .onEnded { value in
                if mapMenuFullyOpen {
                    closeMapMenu()
                }
                else if tool == .select {
                    selectedBubble = nil
                }
                else if tool == .addBubble {
                    x = value.location.x
                    y = value.location.y
                    showAddConfirmation = true
                }
                // Selecting and moving handled on individual bubbles with GesturedCapsule.
            }
        
        let drag = DragGesture()
            .onChanged { value in
                if tool == .draw {
                    let circle = DrawnCircle(context: context)
                    circle.x = value.location.x
                    circle.y = value.location.y
                    let components = drawColor.components
                    circle.radius = drawSize.radius
                    circle.red = Int16(components[0] * 255)
                    circle.green = Int16(components[1] * 255)
                    circle.blue = Int16(components[2] * 255)
                    circle.opacity = components[3]
                    circle.created = Date.now
                    map.addToDrawnCircles(circle)
                }
                else if tool == .erase {
                    map.erase(context: context, x: value.location.x, y: value.location.y, eraseRadius: 10)
                }
            }
            .onEnded { value in

            }
        
        ZoomingScrollView {
            MapView(map: map, selectedBubble: $selectedBubble, tool: tool, showConfirmation: $showSelectConfirmation)
                .gesture(tool == .draw || tool == .erase ? drag : nil)
                .gesture(tap)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            switch(tool) {
            case .draw: drawToolbar
            case .erase: eraseToolbar
            default: defaultToolbar
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                if let linkedBubble = map.linkedBubble {
                    Button(action: {selectedBubble = map.linkedBubble!; sheet = .bubbleDetails}) {
                        BubbleCapsule(bubble: linkedBubble)
                            .labelStyle(.titleAndIcon)
                    }
                }
                else {
                    Text(map.name!)
                }
            }
        }
        .sheet(item: $sheet, onDismiss: sheetDismiss) {item in
            switch item {
            case .addBubble: AddBubbleSheet(selectedBubble: $selectedBubble, added: $addMappedBubble).presentationDetents([.fraction(0.3)])
            case .bubbleList: SelectionBubbleList(selection: $selectedBubble, selected: $addMappedBubble)
            case .bubbleDetails: UnknownBubbleView(bubble: Binding($selectedBubble)!)
            }
        }
        .confirmationDialog("", isPresented: $showSelectConfirmation, presenting: selectedBubble) {detail in
            Button(action: { sheet = .bubbleDetails }) {
                Text("Show Details")
            }
            Button(role: .destructive, action: { context.delete(selectedBubble!) }) {
                Text("Delete")
            }
        }
        .confirmationDialog("", isPresented: $showAddConfirmation) {
            Button(action: { sheet = .addBubble }) {
                Text("New Bubble")
            }
            Button(action: { sheet = .bubbleList }) {
                Text("Existing Bubble")
            }
        }
    }
    
    func sheetDismiss() {
        if addMappedBubble {
            let mappedBubble = MappedBubble(context: context)
            mappedBubble.bubble = selectedBubble
            mappedBubble.x = x
            mappedBubble.y = y
            map.addToMappedBubbles(mappedBubble)
            addMappedBubble = false
        }
    }
}

struct SizePicker: View {
    @Binding var size: Size
    
    var body: some View {
        Menu {
            ForEach(Size.allCases, id:\.self) { s in
                Button(action: { size = s }) {
                    HStack {
                        Text(s.rawValue)
                        if size == s {
                            Image(systemName: "checkmark")
                        }
                    }
                }
                .buttonStyle(.bordered)
            }
        } label: {
            Image(systemName: "circle.fill")
                .imageScale(size.imageScale)
        }
    }
}

enum Tool: String, Identifiable, CaseIterable {
    case select = "Select", addBubble = "Add Bubble", draw = "Draw", erase = "Erase"
    var id: RawValue { rawValue }
    var imageName: String {
        switch self {
        case .select: return "cursorarrow"
//        case .move: return "arrow.up.and.down.and.arrow.left.and.right"
        case .addBubble: return "plus.circle"
        case .draw: return "scribble.variable"
        case .erase: return "trash.square"
        }
    }
}

enum Size: String, Identifiable, CaseIterable {
    case small = "Small", medium = "Medium", large = "Large"
    var id: RawValue { rawValue }
    var imageScale: Image.Scale {
        switch self {
        case .small: return Image.Scale.small
        case .medium: return Image.Scale.medium
        case .large: return Image.Scale.large
        }
    }
    var radius: Double {
        switch self {
        case .small: return 5
        case .medium: return 10
        case .large: return 20
        }
    }
}

enum MapShownSheet: String, Identifiable {
    case addBubble, bubbleList, bubbleDetails
    var id: RawValue { rawValue }
}

//
//  BuildingDetailsView.swift
//  CampusMap
//
//  Created by Stebbins, Daniel Ross on 10/3/22.
//

import SwiftUI

struct BuildingDetailsSheet: View {
    @EnvironmentObject var manager: Manager
    @Environment (\.dismiss) private var dismiss
    
    var body: some View {
        let dismissButton = ToolbarItem(placement: .navigationBarTrailing) {
            Button("Dismiss") {
                dismiss()
            }
        }
        
        NavigationStack {
            VStack {
                Image(manager.selectedBuilding!.photo ?? "imageNotFound")
                    .resizable()
                    .scaledToFit()
                HStack {
                    Text(manager.selectedBuilding!.name)
                        .font(.system(size:30))
                    Button(action: manager.toggleFavorite) {
                        Image(systemName: manager.selectedBuilding!.isFavorite! ? "star.fill" : "star")
                            .foregroundColor(manager.selectedBuilding!.isFavorite! ? .yellow : .blue)
                            .font(.system(size:40))
                            .padding()
                    }
                }
                HStack {
                    Text("Walking Time: \(manager.walkingTime)")
                    Image(systemName: "arrow.right")
                        .foregroundColor(.blue)
                        .rotationEffect(manager.heading(to: manager.selectedBuilding!.coordinate))
                }
                if(manager.routedBuilding == manager.selectedBuilding) {
                    ScrollView {
                        ForEach(manager.route!.steps, id: \.self) { step in
                            Text(step.instructions)
                        }
                    }
                } else {
                    Button("Directions") {
                        manager.routeTo(manager.selectedBuilding!.coordinate)
                    }
                    .padding(5)
                    .buttonStyle(.borderedProminent)
                    .cornerRadius(10)
                    Spacer()
                }
            }
            .toolbar { dismissButton }
        }
    }
}

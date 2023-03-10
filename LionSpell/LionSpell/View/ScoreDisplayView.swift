//
//  ScoreDisplayView.swift
//  LionSpell
//
//  Created by Stebbins, Daniel Ross on 8/29/22.
//

import SwiftUI

// Displays the score number.
struct ScoreDisplayView: View {
    let score: Int
    var body: some View {
        Text("\(score)")
            .font(.system(size: 60, weight: .heavy, design: .monospaced))
            .foregroundColor(.white)
    }
}

struct ScoreDisplayView_Previews: PreviewProvider {
    static var previews: some View {
        ScoreDisplayView(score: 13)
    }
}

//
//  GameModel.swift
//  LionSpell
//
//  Created by Thomas Stebbins on 9/5/22.
//

import Foundation

struct Scramble {
    let numLetters: Int
    let letters: String
    let words: Array<String>
    
    init(preferences: Preferences) {
        // Generating the key letters and possible answers, in either English or French.
        let tempLetters: String
        if(preferences.language == Language.english) {
            // 5 letters that form a random pangram.
            tempLetters = String(Array(Words.words.filter({ $0.uniqueLetters.count == preferences.difficulty.rawValue }).randomElement()!.uniqueLetters).shuffled())
            
            // The list of all words that can be spelled with those five letters.
            words = Words.words.filter({ Set($0).isSubset(of: Set(tempLetters)) && $0.contains(tempLetters.first!) })
        }
        else {
            // Repeat of the code for the English words, but for the French words.
            tempLetters = String(Array(Words.frenchWords.filter({ $0.uniqueLetters.count == preferences.difficulty.rawValue }).randomElement()!.uniqueLetters).shuffled())
            words = Words.frenchWords.filter({ Set($0).isSubset(of: Set(tempLetters)) && $0.contains(tempLetters.first!) })
        }
        numLetters = preferences.difficulty.rawValue
        letters = tempLetters
    }
}

extension String {
    var uniqueLetters: String {
        var letters: Set<Character> = []
        return filter{ letters.insert($0).inserted }
    }
}

struct Words {

    static let words = ["test", "tests", "while", "greats", "postage"]
    
    static let frenchWords = ["être", "avoir", "pour"]
}

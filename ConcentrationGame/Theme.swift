//
//  Theme.swift
//  ConcentrationGame
//
//  Created by Irakli Nozadze on 18.09.22.
//

import Foundation
import UIKit

struct Theme {
    var name: String;
    var emojis: String;
    var numberOfPairs: Int;
    var color: UIColor;
    
    init (name: String, emojis: String, numberOfPairs: Int, color: UIColor) {
        self.name = name
        self.emojis = emojis
        self.numberOfPairs = numberOfPairs
        self.color = color
    }
}

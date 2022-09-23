//
//  Button.swift
//  ConcentrationGame
//
//  Created by Irakli Nozadze on 18.09.22.
//

import Foundation

class Button : ObservableObject {

      @Published var buttonLabels = ["Button: 1"]

      func generate() {
            let buttonCount = Int.random(in: 2...5)

            var newLabels = [String]()
            for index in 1...buttonCount {
                  newLabels.append("Button: \(index)")
            }
            buttonLabels = newLabels
      }
}


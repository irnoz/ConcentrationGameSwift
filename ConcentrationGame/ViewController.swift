//
//  ViewController.swift
//  ConcentrationGame
//
//  Created by Irakli Nozadze on 18.08.22.
//

import UIKit

class ViewController: UIViewController {

    private var arrayOfThemes: Array<Theme> = [
            Theme(name: "halloween", emojis: "☠️🎃🤡👻🤖👽👹🦇", numberOfPairs: 8, color: #colorLiteral(red: 1, green: 0.5750193596, blue: 0.0009748883313, alpha: 1)),
            Theme(name: "jobs", emojis: "👮‍♂️👷‍♀️💂‍♀️🕵️‍♀️👩‍⚕️👩‍🌾👩‍🍳👩‍🎓👨‍🎤👨‍🏫🧑‍🏭🧑‍💻👨‍💼👨‍🔧👩‍🔬🧑‍🎨🧑‍🚒🧑‍✈️👩‍🚀", numberOfPairs: 18.arc4random, color: #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)), // changed from Int.random(in: 5...18)
            Theme(name: "faces", emojis: "😱🥶🥵🤯🤬😭🥺🥳🥸🤪😇😂", numberOfPairs: 8, color: #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1)),
            Theme(name: "animals", emojis: "🐶🐱🐭🦊🐻🐯🦁🐷🐸🐵🐵🐔🐧🐦", numberOfPairs: 8, color: #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)),
            Theme(name: "organs", emojis: "👄🦷👅👂👃👀🫀🫁🧠", numberOfPairs: 8, color: #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)),
            Theme(name: "clothes", emojis: "🧥🥼🦺👕👖👔👙👘👠🧦🧣🎩", numberOfPairs: 8, color: #colorLiteral(red: 0.5791940689, green: 0.1280144453, blue: 0.5726861358, alpha: 1))
        ]
    
    private lazy var chosenTheme = arrayOfThemes.randomElement()!
    
    private lazy var chosenThemeName = chosenTheme.name
    private lazy var chosenThemeEmojis = chosenTheme.emojis
    private lazy var chosenThemeAmountOfPairs = chosenTheme.numberOfPairs
    private lazy var chosenThemeColor = chosenTheme.color
    
    private lazy var game: Concentration =
        Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    
    var numberOfPairsOfCards: Int { // this is private set but since its just a get only property it doesn't need private(set)
//        read only property doesn't need get so can be removed
//        get {
//            return (cardButtons.count + 1) / 2
//        }
        return (cardButtons.count + 1) / 2
    }
    
    private(set) var flipCount = 0 {
        didSet {
            updateFlipCountLabel()
        }
    }
    
    private func updateFlipCountLabel() {
        let attributes: [NSAttributedString.Key: Any] = [
            .strokeWidth : 5.0,
            .strokeColor : chosenThemeColor
        ]
        let attributedString = NSAttributedString(string: "Flips: \(flipCount)", attributes: attributes)
        flipCountLable.attributedText = attributedString
    }
    
//    IBOutlets and even actions are almost allways private
    @IBOutlet private weak var flipCountLable: UILabel! {
        didSet {
            updateFlipCountLabel()
        }
    }
    
    @IBOutlet private var cardButtons: [UIButton]! {
        didSet {
            for button in cardButtons{
                button.backgroundColor = chosenThemeColor
            }
        }
    }
    
    @IBAction private func touchCard(_ sender: UIButton) {
        flipCount += 1
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            game.choseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("chosen card was not in cardButtons")
        }
    }
    
    private func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp && card.isMatched {
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = chosenThemeColor.withAlphaComponent(0.15)
                continue
            }
            else if card.isFaceUp {
                button.setTitle(emoji(for: card), for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = card.isMatched ? chosenThemeColor.withAlphaComponent(0.15) : chosenThemeColor
            }
        }
    }
    
//    private var emojiChoices = ["🎃", "🦁", "🐵", "👻","🐱"]
//    private var emojiChoices = "🎃🦁🐵👻🐱🦄😱🧟‍♂️"
    
    private var emoji = [Card:String]()
    
    private func emoji(for card: Card) -> String {
        if emoji[card] == nil, chosenThemeEmojis.count > 0 {
            let randomStringIndex = chosenThemeEmojis.index(chosenThemeEmojis.startIndex, offsetBy: chosenThemeEmojis.count.arc4random)
            emoji[card] = String(chosenThemeEmojis.remove(at: randomStringIndex))
        }
        return emoji[card] ?? "?"
//        below code is the same as line above
//        if emoji[card.identifier] != nil {
//            return emoji[card.identifier]!
//        } else {
//            return "?"
//        }
    }
}

// extensions are really powerful but should only be used to make specific class better
extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0{
            return -Int(arc4random_uniform(UInt32(self)))
        } else {
            return 0
        }
    }
}

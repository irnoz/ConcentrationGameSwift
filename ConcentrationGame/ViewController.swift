//
//  ViewController.swift
//  ConcentrationGame
//
//  Created by Irakli Nozadze on 18.08.22.
//

import UIKit

class ViewController: UIViewController {

    let totalNumberOfCardsInGame = Int.random(in: 2..<6)
    
//    lazy var game = Concentration(numberOfPairsOfCards: totalNumberOfCardsInGame)
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
            .strokeColor : #colorLiteral(red: 1, green: 0.5750193596, blue: 0.0009748883313, alpha: 1)
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
    
    @IBOutlet private var cardButtons: [UIButton]!
    
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
                button.backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0.1502066891)
                continue
            }
            else if card.isFaceUp {
                button.setTitle(emoji(for: card), for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5750193596, blue: 0.0009748883313, alpha: 0.1527850093) : #colorLiteral(red: 1, green: 0.5750193596, blue: 0.0009748883313, alpha: 1)
            }
        }
    }
    
//    private var emojiChoices = ["🎃", "🦁", "🐵", "👻","🐱"]
    private var emojiChoices = "🎃🦁🐵👻🐱🦄😱🧟‍♂️"
    
    private var emoji = [Card:String]()
    
    private func emoji(for card: Card) -> String {
        if emoji[card] == nil, emojiChoices.count > 0 {
            let randomStringIndex = emojiChoices.index(emojiChoices.startIndex, offsetBy: emojiChoices.count.arc4random)
            emoji[card] = String(emojiChoices.remove(at: randomStringIndex))
        }
        
//        if emoji[card.identifier] != nil {
//            return emoji[card.identifier]!
//        } else {
//            return "?"
//        }
//        same as above code
        return emoji[card] ?? "?"
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

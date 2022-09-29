//
//  ViewController.swift
//  ConcentrationGame
//
//  Created by Irakli Nozadze on 18.08.22.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {

    private var arrayOfThemes: Array<Theme> = [
            Theme(name: "Halloween", emojis: "☠️🎃🤡👻🤖👽👹🦇", numberOfPairs: 8, color: #colorLiteral(red: 1, green: 0.5750193596, blue: 0.0009748883313, alpha: 1)),
            Theme(name: "Jobs", emojis: "👮‍♂️👷‍♀️💂‍♀️🕵️‍♀️👩‍⚕️👩‍🌾👩‍🍳👩‍🎓👨‍🎤👨‍🏫🧑‍🏭🧑‍💻👨‍💼👨‍🔧👩‍🔬🧑‍🎨🧑‍🚒🧑‍✈️👩‍🚀", numberOfPairs: 18.arc4random, color: #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)), // changed from Int.random(in: 5...18)
            Theme(name: "Faces", emojis: "😱🥶🥵🤯🤬😭🥺🥳🥸🤪😇😂", numberOfPairs: 8, color: #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1)),
            Theme(name: "Animals", emojis: "🐶🐱🐭🦊🐻🐯🦁🐷🐸🐵🐵🐔🐧🐦", numberOfPairs: 8, color: #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)),
            Theme(name: "Organs", emojis: "👄🦷👅👂👃👀🫀🫁🧠", numberOfPairs: 8, color: #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)),
            Theme(name: "Clothes", emojis: "🧥🥼🦺👕👖👔👙👘👠🧦🧣🎩", numberOfPairs: 8, color: #colorLiteral(red: 0.5791940689, green: 0.1280144453, blue: 0.5726861358, alpha: 1))
        ]
    
    private lazy var chosenTheme = arrayOfThemes.randomElement()!
    
    private lazy var game: Concentration =
        Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    
    var numberOfPairsOfCards: Int { // this is private set but since its just a get only property it doesn't need private(set)
//        read only property doesn't need get so can be removed
//        get {
//            return (cardButtons.count + 1) / 2
//        }
        return (cardButtons.count + 1) / 2
    }
    
     var scoreCount = 0 { // was private(set)
        didSet {
            updateLabel(of: "Score count")
        }
    }
    
    lazy var attributes: [NSAttributedString.Key: Any] = [
        .strokeWidth : 5.0,
        .strokeColor : chosenTheme.color,
    ]
    
    private func updateLabel(of type: String) {
        switch type {
        case "Score count":
            let attributedString = NSAttributedString(string: "Score: \(scoreCount)", attributes: attributes)
            scoreCountLabel.attributedText = attributedString
        case "Theme name":
            let attributedString = NSAttributedString(string: "Theme: \(chosenTheme.name)", attributes: attributes)
            themeNameLabel.attributedText = attributedString
        case "Restart button":
            let attributedString = NSAttributedString(string: "Restart", attributes: attributes)
            restartLabel.attributedText = attributedString
        default:
            print("chosen label type does not exist")
        }
    }
    
//    IBOutlets and even actions are almost allways private
    @IBOutlet private weak var themeNameLabel: UILabel! {
        didSet {
            updateLabel(of: "Theme name")
        }
    }
    
    @IBOutlet private weak var scoreCountLabel: UILabel! {
        didSet {
            updateLabel(of: "Score count")
        }
    }
    
    @IBOutlet private weak var restartLabel: UILabel! {
        didSet {
            updateLabel(of: "Restart button")
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(restartGame))
            
            restartLabel.isUserInteractionEnabled = true
            restartLabel.addGestureRecognizer(tap)
            tap.delegate = self
            
        }
    }
    @objc private func restartGame(_ sender: UITapGestureRecognizer) {
        game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
        game.updateCardsFromModel()
        choseNewTheme()
        updateCardTheme()
        attributes = [
            .strokeWidth : 5.0,
            .strokeColor : chosenTheme.color
        ]
        scoreCount = 0
        updateLabel(of: "Theme name")
        updateLabel(of: "Score count")
        updateLabel(of: "Restart button")
        updateCardButtons()
    }
    
    @IBOutlet private var cardButtons: [UIButton]! {
        didSet {
            updateCardTheme()
        }
    }
    
    @IBAction private func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            game.choseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("chosen card was not in cardButtons")
        }
        
        scoreCount = game.getScoreCountFromModel()
        updateLabel(of: "Score count")
    }
    
    private func updateCardButtons() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            button.setTitle("", for: UIControl.State.normal)
            button.backgroundColor = chosenTheme.color.withAlphaComponent(1.0)
        }
    }
    
    private func choseNewTheme() {
        chosenTheme = arrayOfThemes.randomElement()!
    }
    
    private func updateCardTheme() {
        for button in cardButtons{
            button.backgroundColor = chosenTheme.color
        }
    }
    
    private func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp && card.isMatched {
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = chosenTheme.color.withAlphaComponent(0.15)
                continue
            }
            else if card.isFaceUp {
                button.setTitle(emoji(for: card), for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = card.isMatched ? chosenTheme.color.withAlphaComponent(0.15) : chosenTheme.color
            }
        }
    }
    
    private var emoji = [Card:String]()
    
    private func emoji(for card: Card) -> String {
        if emoji[card] == nil, chosenTheme.emojis.count > 0 {
            let randomStringIndex = chosenTheme.emojis.index(chosenTheme.emojis.startIndex, offsetBy: chosenTheme.emojis.count.arc4random)
            emoji[card] = String(chosenTheme.emojis.remove(at: randomStringIndex))
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

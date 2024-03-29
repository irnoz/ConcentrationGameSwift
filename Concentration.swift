//
//  Concentration.swift
//  ConcentrationGame
//
//  Created by Irakli Nozadze on 01.09.22.
//

import Foundation

// struct doesn't stay in heap and it gets copied
struct Concentration
{
    private(set) var cards = [Card]()
    private var seenCards = Set<Int>()
    var scoreCount: Int = 0
    
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
//            this is a shortend version of below code using extension added below
            return cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly
//            let faceUpIndices = cards.indices.filter { cards[$0].isFaceUp }
//            return faceUpIndices.count == 1 ? faceUpIndices.first : nil
//            the above code does the same thing as the below one
//            var foundIndex: Int?
//            for index in cards.indices {
//                if cards[index].isFaceUp {
//                    if foundIndex == nil {
//                        foundIndex = index
//                    } else {
//                        return nil
//                    }
//                }
//            }
//            return foundIndex
        }
//        this defaults to newValue so its not required
        set(newValue) {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
//    sice class was changed to struct it assumes that functions are immutable
    mutating func choseCard(at index: Int) {
        assert(cards.indices.contains(index), "Concentration.choseCard(at: \(index)): chosen index not in the cards")
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                // check if cards match
                if cards[matchIndex] == cards[index] {
                    scoreCount += 2
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                } else {
                    if alreadySeenCard(at: index) {
                        scoreCount -= 1
                    }
                }
                cards[index].isFaceUp = true
//                indexOfOneAndOnlyFaceUpCard = nil this is no longer required
            } else {
                // either no card or 2 cards are face up
//                the following code is no longer required because of set in indexOfOneAndOnlyFaceUpCard
//                for flipDownIndex in cards.indices {
//                    cards[flipDownIndex].isFaceUp = false
//                }
//                cards[index].isFaceUp = true
                if alreadySeenCard(at: index) {
                    scoreCount -= 1
                }
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
    
    private mutating func alreadySeenCard(at index: Int) -> Bool{
        if seenCards.contains(index) {
            return true
        } else {
            seenCards.insert(index)
            return false
        }
    }
    
    func getScoreCountFromModel() -> Int{
        scoreCount
    }
    
    mutating func updateCardsFromModel() {
        for index in cards.indices {
            cards[index].isMatched = false
            cards[index].isFaceUp = false
        }
    }
    
    init(numberOfPairsOfCards: Int) {
        assert(numberOfPairsOfCards > 0, "Concentration.init(\(numberOfPairsOfCards)): you must have at least one pair of cards")
        for _ in 1...numberOfPairsOfCards {
            let card = Card()
            cards += [card, card]
        }
        // Shuffle the cards
        cards.shuffle()
    }
}


extension Collection {
//    Elemetn is just a generic type
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}

//
//  Card.swift
//  Funk the Dealer
//
//  Created by Jack Berry on 02/10/2016.
//  Copyright © 2016 EtherPlay. All rights reserved.
//

import UIKit

class Card: UIImageView {

    var frontImageView:UIImageView = UIImageView()
    var backImageView:UIImageView = UIImageView()
    var cardValue:Int = 0
    var cardNamesArray:[String] = ["ace", "2", "3", "4", "5", "6", "7", "8", "9", "10", "jack", "queen", "king"]
    var suitNamesArray:[String] = ["hearts", "diamonds", "clubs", "spades"]
    var cardName: String = ""
    var cardSuit:String = ""
    var cardsRemaining:Int = 52
    var cardString:String = ""
    var aceCount:Int = 0
    var twoCount:Int = 0
    var threeCount:Int = 0
    var fourCount:Int = 0
    var fiveCount:Int = 0
    var sixCount:Int = 0
    var sevenCount:Int = 0
    var eightCount:Int = 0
    var nineCount:Int = 0
    var tenCount:Int = 0
    var jackCount:Int = 0
    var queenCount:Int = 0
    var kingCount:Int = 0
    
    func generateCardName() {
       cardString = "\(self.cardName)_of_\(self.cardSuit)"
    }
    
   
    
}

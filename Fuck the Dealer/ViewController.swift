//
//  ViewController.swift
//  Funk the Dealer
//
//  Created by Jack Berry on 02/10/2016.
//  Copyright © 2016 EtherPlay. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var doubleDeckView: UIView!
    @IBOutlet weak var feedbackLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var guessView: UIView!
    @IBOutlet weak var guessPicker: UIPickerView!
    @IBOutlet weak var guessLabel: UILabel!
    @IBOutlet weak var resultView: UIView!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var resultNextButton: UIButton!
    @IBOutlet weak var resultPlayerLabel: UILabel!
    @IBOutlet weak var livesLabel: UILabel!
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var setupView: UIView!
    @IBOutlet weak var setupStepper: UIStepper!
    @IBOutlet weak var setupStepperLabel: UILabel!
    @IBOutlet weak var setupTextField: UITextField!
    @IBOutlet weak var setupNameLabel: UILabel!
    @IBOutlet weak var setupNameDone: UIButton!
    @IBOutlet weak var setupNumberLabel: UILabel!
    @IBOutlet weak var setupNumberDone: UIButton!
    @IBOutlet weak var playerLabel: UILabel!
    @IBOutlet weak var seeDeckScrollView: UIScrollView!
    @IBOutlet weak var AceStack: UIStackView!
    @IBOutlet weak var twoStack: UIStackView!
    @IBOutlet weak var threeStack: UIStackView!
    @IBOutlet weak var fourStack: UIStackView!
    @IBOutlet weak var fiveStack: UIStackView!
    @IBOutlet weak var sixStack: UIStackView!
    @IBOutlet weak var sevenStack: UIStackView!
    @IBOutlet weak var eightStack: UIStackView!
    @IBOutlet weak var nineStack: UIStackView!
    @IBOutlet weak var tenStack: UIStackView!
    @IBOutlet weak var jackStack: UIStackView!
    @IBOutlet weak var queenStack: UIStackView!
    @IBOutlet weak var kingStack: UIStackView!

    @IBOutlet weak var gameOverButton: UIButton!

    var cardInPlay = Card()
    var cardDoneArray:[Card] = []
    var stringCardDoneArray:[String] = []
    var pickerData:[String] = ["Ace", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten", "Jack", "Queen", "King"]
    var guessString:String = ""
    var guessInt:Int = 1
    var firstGuess:Bool = true
    var sipTotal:Int = 0
    var sipString:String = ""
    var defaultDealerTarget = 3
    var defaultDealerLives:Int = 3
    var dealerTarget:Int = 3
    var dealerLives:Int = 3
    var doubleDeck:Bool = false
    var secondDeck:Bool = false
    var playersArray:[Player] = []
    var nameEntered:Bool = false
    var playerX:Int = 1
    var setupPlayerIndex:Int = 0
    var dealer:Player!
    var lastDealer:Player!
    var currentPlayer:Player!
    var dealerIndex:Int = 0
    var currentPlayerIndex:Int = 0
    var numberofPlayers:Int = 0
    var dealerMode:Bool = true
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        guessPicker.dataSource = self
        guessPicker.delegate = self
        setupView.alpha = 1
        dealerLives = defaultDealerLives
        livesLabel.text = "\(dealerLives)"
        dealerTarget = defaultDealerTarget
        targetLabel.text = "\(defaultDealerTarget)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: IBACtions
    
    // Draw button pressed
    @IBAction func playPressed(_ sender: AnyObject) {
        getCard()
        startRound()
    }
    // Next button on results page pressed
    @IBAction func resultNextPressed(_ sender: AnyObject) {
        resultView.alpha = 0
        playButton.alpha = 1

    }
    @IBAction func gameOverPressed(_ sender: AnyObject) {
    }
    
    
    // Done button on guess input pressed
    @IBAction func guessDone(_ sender: AnyObject) {
        guessView.alpha = 0
        checkAnswer()
    }
    
    // Number of players stepper
    @IBAction func setupStepperPressed(_ sender: AnyObject) {
        self.setupStepperLabel.text = String(format: "%.0f", setupStepper.value)
    }
    
    // Done button for number of players stepper
    @IBAction func setupNumberDone(_ sender: AnyObject) {
        setupTextField.alpha = 1
        setupNameLabel.alpha = 1
        setupNameDone.alpha = 1
        setupStepper.alpha = 0
        setupStepperLabel.alpha = 0
        setupNumberLabel.alpha = 0
        setupNumberDone.alpha = 0
        createPlayers()
        namePlayers()
    }

    // Done button for enter name text field
    @IBAction func setupNameDone(_ sender: AnyObject) {
        playersArray[setupPlayerIndex].playerName = setupTextField.text!
        playerX += 1
        setupPlayerIndex += 1
        namePlayers()
    }
    
    // Button to show 'done pile'
    @IBAction func seeDeckButton(_ sender: AnyObject) {
        seeDeckScrollView.alpha = 1
    }
    
    // Button to return to the game view from done pile
    @IBAction func seeDeckBack(_ sender: AnyObject) {
        seeDeckScrollView.alpha = 0
    }
    
    // Button to see done pile from within the guess input view
    @IBAction func guessSeeDeck(_ sender: AnyObject) {
        seeDeckScrollView.alpha = 1
    }
    
    @IBAction func ddYes(_ sender: AnyObject) {
        doubleDeck = true
        doubleDeckView.alpha = 0
    }
    
    @IBAction func ddNo(_ sender: AnyObject) {
        doubleDeckView.alpha = 0
    }
    

    // Randomises a card from the deck, assigns properties to the card and displays image
    func getCard() {
        let randomNumber:Int = Int(arc4random_uniform(13))
        let suitRandomNumber:Int = Int(arc4random_uniform(4))
        cardInPlay.cardValue = randomNumber + 1
        cardInPlay.cardName = cardInPlay.cardNamesArray[randomNumber]
        cardInPlay.cardSuit = cardInPlay.suitNamesArray[suitRandomNumber]
        cardInPlay.generateCardName()
        
        // Checks if we have had that card already
        if stringCardDoneArray .contains(cardInPlay.cardString) {
            getCard()
        }else {
          cardImageView.image = UIImage(named: cardInPlay.cardString)
            
        }
    }
    

    
    func generateDoneCards(value: Int, imageName: String) {
        print("Generating Done Cards \(value), \(cardDoneArray.count) cards so far")

        func addSubview (Stack: UIStackView) {
            let imageView = UIImageView()
            imageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
            imageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
            imageView.image = UIImage(named: imageName)
            if Stack.arrangedSubviews.count <= 3 {
                Stack.addArrangedSubview(imageView)
                print("Added to stackView \(Stack.arrangedSubviews)")
               
            }
            if Stack.arrangedSubviews.count == 4 {
                print("Flipping the fourth card")
                Stack.arrangedSubviews.forEach({ $0.removeFromSuperview() })
                imageView.image = UIImage(named: "back")
                Stack.addArrangedSubview(imageView)
                return
            }
        }
        switch value {
        case 1:
            addSubview(Stack: AceStack)
        case 2:
            addSubview(Stack: twoStack)
        case 3:
            addSubview(Stack: threeStack)
        case 4:
            addSubview(Stack: fourStack)
        case 5:
            addSubview(Stack: fiveStack)
        case 6:
            addSubview(Stack: sixStack)
        case 7:
            addSubview(Stack: sevenStack)
        case 8:
            addSubview(Stack: eightStack)
            
        case 9:
            addSubview(Stack: nineStack)
        case 10:
            addSubview(Stack: tenStack)
        case 11:
            addSubview(Stack: jackStack)
        case 12:
            addSubview(Stack: queenStack)
            
        case 13:
            addSubview(Stack: kingStack)
            
        default:
            print("Error generating Done Cards")
            return
        }
    }

    
       
    
    func resetDoneCards() {
    secondDeck = true
    cardDoneArray.removeAll()
    stringCardDoneArray.removeAll()
    AceStack.arrangedSubviews.forEach({ $0.removeFromSuperview() })
    twoStack.arrangedSubviews.forEach({ $0.removeFromSuperview() })
    threeStack.arrangedSubviews.forEach({ $0.removeFromSuperview() })
    fourStack.arrangedSubviews.forEach({ $0.removeFromSuperview() })
    fiveStack.arrangedSubviews.forEach({ $0.removeFromSuperview() })
    sixStack.arrangedSubviews.forEach({ $0.removeFromSuperview() })
    sevenStack.arrangedSubviews.forEach({ $0.removeFromSuperview() })
    eightStack.arrangedSubviews.forEach({ $0.removeFromSuperview() })
    nineStack.arrangedSubviews.forEach({ $0.removeFromSuperview() })
    tenStack.arrangedSubviews.forEach({ $0.removeFromSuperview() })
    jackStack.arrangedSubviews.forEach({ $0.removeFromSuperview() })
    queenStack.arrangedSubviews.forEach({ $0.removeFromSuperview() })
    kingStack.arrangedSubviews.forEach({ $0.removeFromSuperview() })
    }
    
    // Updates the views when a new round
    func startRound() {
        guessView.alpha = 0.9
        playButton.alpha = 0
        firstGuess = true
    }
    // Updates views and resets guess settings for second guess
    func secondGuess() {
        firstGuess = false
        guessInt = 0
        guessString = ""
        guessView.alpha = 0.9
    }
    // Checks conditions when a player looses and updates properties
    func playerLooses() {
        dealerTarget -= 1
        dealer.sipsGiven += sipTotal
        resultPlayerLabel.text = "Next Player!"
    
        if dealerTarget == 0 {
            newDealer()
            resultPlayerLabel.text = "Time to pass the deck! Next dealer is \(dealer.playerName)"
            dealerLives = defaultDealerLives
            dealerTarget = defaultDealerTarget
        }
        else if dealerTarget == 1 {
            resultPlayerLabel.text = "Nearly there \(dealer.playerName), one more player!"
        }
        else if dealerTarget > 2 {
            resultPlayerLabel.text = "Next Player!"
        }
        resultView.alpha = 0.95
        currentPlayer.sipsTaken += sipTotal
        sipString = "\(sipTotal) sips for \(currentPlayer.playerName)!"
        resultLabel.text = sipString
        nextPlayer()
        nextTurn()
    }
    // Determines who is the next player/guesser is next
    func nextPlayer() {
        if currentPlayerIndex == numberofPlayers {
            currentPlayerIndex = 0
            currentPlayer = playersArray[0]
        }
        else if currentPlayerIndex < numberofPlayers {
            currentPlayerIndex += 1
            currentPlayer = playersArray[currentPlayerIndex]
        }
        if dealerIndex == currentPlayerIndex {
            if currentPlayerIndex == numberofPlayers {
                currentPlayerIndex = 0
                currentPlayer = playersArray[0]
            }
            else if currentPlayerIndex < numberofPlayers {
                currentPlayerIndex += 1
                currentPlayer = playersArray[currentPlayerIndex]
            }
        }
    }
    
    // Checks conditions when the dealer looses and updates properties
    func dealerLooses() {
        resultView.alpha = 0.95
        dealerLives -= 1
        dealerTarget = defaultDealerTarget
        dealer.timesFunked += 1
        currentPlayer.funksGiven += 1
        if firstGuess == false {
            resultLabel.text = "\(dealer.playerName) has to drink 1/4 of their drink!"
        }
        else if firstGuess == true {
            resultLabel.text = "\(dealer.playerName) has to drink 1/2 of their drink!"
        }
        if dealerLives == 0{
            newDealer()
            resultPlayerLabel.text = "Ouch! That didn't go very well. Next Dealer is \(dealer.playerName)!"
            dealerLives = defaultDealerLives
        }
        else if dealerLives == 1 {
            resultPlayerLabel.text = "One life left \(dealer.playerName)!"
        }
        else if dealerLives > 1 {
            resultPlayerLabel.text = "Back to square one! Next player please."
        }
        nextPlayer()
        nextTurn()
    }
    // Determines the next dealer
    func newDealer() {
        lastDealer = dealer
        if dealerIndex == numberofPlayers {
            dealer = playersArray[0]
            dealerIndex = 0
        }
        else if dealerIndex < numberofPlayers {
            dealerIndex += 1
            dealer = playersArray[dealerIndex]
        }
    }
    // Checks players answer to see if they have won/lost
    func checkAnswer() {
        guessView.alpha = 0
        
        if guessInt < cardInPlay.cardValue {
            if firstGuess == false {
               // playerLooses
                sipTotal = (cardInPlay.cardValue - guessInt)
                playerLooses()
                
            }
            if firstGuess == true {
                feedbackLabel.text = "Higher!"
                secondGuess()
            }
        }
    
        else if guessInt > cardInPlay.cardValue {
            if firstGuess == false {
                // playerLooses
                sipTotal = (guessInt - cardInPlay.cardValue)
                playerLooses()
            }
            if firstGuess == true {
                feedbackLabel.text = "Lower!"
                secondGuess()
            }
        }
        
        else if guessInt == cardInPlay.cardValue {
            dealerLooses()
        }
    }
    // Prepares for next turn, checks how many cards remain and moves card into done array
    func nextTurn() {
        cardDoneArray.append(cardInPlay)
        stringCardDoneArray.append(cardInPlay.cardString)
        cardInPlay.cardsRemaining -= 1
        if cardInPlay.cardsRemaining == 0 {
            if doubleDeck == true {
                if secondDeck == false {
               resetDoneCards()
                } else {
                    gameOver()
                }
            } else {
            gameOver()
            }
        }
        cardImageView.image = UIImage(named: "back")
        feedbackLabel.text = "\(dealer.playerName) is the dealer!"
        updateDealerLabels()
        generateDoneCards(value: (cardDoneArray.last?.cardValue)!, imageName: (cardDoneArray.last?.cardString)!)
    }

    func updateDealerLabels() {
        targetLabel.text = "\(dealerTarget)"
        livesLabel.text = "\(dealerLives)"
        playerLabel.text = "Player: \(currentPlayer.playerName)"
    }
    
    // Takes stepper value and creates the players for the game
    func createPlayers() {
        let howManyPlayers: Int = Int(setupStepper.value)
        for _ in 1...howManyPlayers {
            let newPlayer = Player()
            playersArray.append(newPlayer)
        }
        numberofPlayers = (playersArray.count - 1)
        if playersArray.count >= 7 {
            doubleDeckView.alpha = 1
            
        }
    }
    
    // Allows user to name all players
    func namePlayers() {
        if setupPlayerIndex == playersArray.count {
            self.setupTextField.resignFirstResponder()
            setupView.alpha = 0
            determineFirstPlayers()
        }
        setupTextField.text = ""
        setupNameLabel.text = "Enter Player \(playerX)'s name"
    }
    
    // Determines who is the first dealer and player
    func determineFirstPlayers() {
        dealerLives = defaultDealerLives
        dealerTarget = defaultDealerTarget
       let randomNumber:Int = Int(arc4random_uniform(UInt32(playersArray.count) - 1))
        var randomNumber2:Int = Int(arc4random_uniform(UInt32(playersArray.count) - 1))
        if randomNumber == randomNumber2{
            if randomNumber2 == numberofPlayers {
                randomNumber2 -= 1
            }
            else if randomNumber2 < numberofPlayers {
                randomNumber2 += 1
                
            }
        }
        // Uses random numbers to assign a dealer and player
        dealer = playersArray[randomNumber]
        dealerIndex = randomNumber
        currentPlayer = playersArray[randomNumber2]
        currentPlayerIndex = randomNumber2
        feedbackLabel.text = "\(dealer.playerName) is the dealer!"
        playerLabel.text = "Player: \(currentPlayer.playerName)"
    }
    
    func gameOver () {
        self.resultNextButton.alpha = 0
        self.gameOverButton.alpha = 1
        self.resultView.alpha = 0.9
        resultPlayerLabel.textColor = UIColor.red
        resultPlayerLabel.text = "Game Over!"
        resultLabel.text = "I hope you didn't loose too many friends!"
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "resultsSegue" {
        let destViewController: ResultsViewController = segue.destination as! ResultsViewController
     destViewController.resultPlayersArray = playersArray
        }

     }


    
    
    
    //MARK: Delegates

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
        
        
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guessString = pickerData[row]
        guessInt = pickerData.index(of: pickerData[row])! + 1
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.setupTextField.resignFirstResponder()
        self.setupTextField.endEditing(true)
        return true
    }




}


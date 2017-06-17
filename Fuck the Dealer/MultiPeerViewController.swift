//
//  MultiPeerViewController.swift
//  Funk the Dealer
//
//  Created by Jack Berry on 23/11/2016.
//  Copyright © 2016 EtherPlay. All rights reserved.
//
import MultipeerConnectivity
import UIKit

class MultiPeerViewController: UIViewController, MCSessionDelegate, MCBrowserViewControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var resultsNextButton: UIButton!
    @IBOutlet weak var guessLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var roleLabel: UILabel!
    @IBOutlet weak var dealerLivesLabel: UILabel!
    @IBOutlet weak var dealerTargetLabel: UILabel!
    @IBOutlet weak var backCardImageView: Card!
    @IBOutlet weak var cardImageView: Card!
    @IBOutlet weak var guessView: UIView!
    @IBOutlet weak var feedbackLabel: UILabel!
    @IBOutlet weak var resultView: UIView!
    @IBOutlet weak var seeDeckScrollView: UIScrollView!
    @IBOutlet weak var guessPicker: UIPickerView!
    @IBOutlet weak var resultPlayerLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var aceStack: UIStackView!
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
    @IBOutlet weak var queeenStack: UIStackView!
    @IBOutlet weak var kingStack: UIStackView!
    @IBOutlet weak var gameOverButton: UIButton!
    @IBOutlet weak var setupTextField: UITextField!
    @IBOutlet weak var setupNameLabel: UILabel!
    @IBOutlet weak var setupView: UIView!
    @IBOutlet weak var doubleDeckView: UIView!
    @IBOutlet weak var playerNameTextField: UITextField!
    @IBOutlet weak var nameDoneButton: UIButton!
    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var hostButton: UIButton!
    @IBOutlet weak var everyonesInButton: UIButton!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var wrongButton: UIButton!
    @IBOutlet weak var cardCountLabel: UILabel!
    @IBOutlet weak var peekImageView: UIImageView!
    
    
    
    var peerID: MCPeerID!
    var mcSession: MCSession!
    var mcAdvertiserAssistant: MCAdvertiserAssistant!
    var cardInPlay = Card()
    var activeCard:Bool = false
    var cardDoneArray:[Card] = []
    var stringCardDoneArray:[String] = []
    var pickerData:[String] = ["Ace", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten", "Jack", "Queen", "King"]
    var guessString:String = ""
    var guessInt:Int = 1
    var lastGuessInt = 20
    var firstGuess:Bool = true
    var sipTotal:Int = 0
    var sipString:String = ""
    var defaultJokerCount = 1
    var defaultDealerTarget = 3
    var defaultDealerLives:Int = 3
    var dealerTarget:Int = 3
    var dealerLives:Int = 3
    var jokerCount:Int = 1
    var doubleDeck:Bool = false
    var secondDeck:Bool = false
    var playersArray:[Player] = []
    var observersArray:[Player] = []
    var removedPlayersArray:[Player] = []
    var nameEntered:Bool = false
    var playerX:Int = 1
    var setupPlayerIndex:Int = 0
    var dealer:Player!
    var lastDealer:Player!
    var lastPlayer:Player?
    var currentPlayer:Player!
    var dealerIndex:Int = 0
    var currentPlayerIndex:Int = 0
    var numberofPlayers:Int = 0
    var dealerMode:Bool = true
    var myPlayer:Player!
    var hostPlayer:Player!
    var hostBool:Bool = false
    var createPlayerBool = true
    var isFlippedBool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.dataReceived), name: NSNotification.Name(rawValue: "sendDataNotification"), object: nil)
        cardCountLabel.text = "\(cardInPlay.cardsRemaining)"
        dealerLives = defaultDealerLives
        dealerLivesLabel.text = "\(dealerLives)"
        dealerTarget = defaultDealerTarget
        dealerTargetLabel.text = "\(defaultDealerTarget)"
        jokerCount = defaultJokerCount
        guessPicker.dataSource = self
        guessPicker.delegate = self
        let swipeGestureRecognizer = UISwipeGestureRecognizer(target:self, action:#selector(peekPressed))
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(cardTapped))
        backCardImageView.isUserInteractionEnabled = true
        cardImageView.isUserInteractionEnabled = true
        backCardImageView.addGestureRecognizer(swipeGestureRecognizer)
        cardImageView.addGestureRecognizer(tapGestureRecognizer)
        if doubleDeck == true {
            cardInPlay.cardsRemaining = 104
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    // Buttons and interactive features
    
    
    @IBAction func refreshRoles(_ sender: Any) {
        if hostBool == true {
            sendString(message: "Dealer \(dealer.playerName)")
            sendString(message: "Player \(currentPlayer.playerName)")
            sendString(message: "Refresh")
        } else if hostBool == false {
            sendString(message: "WhoPLR WhoDLR")
        }
        if myPlayer.playerRole == "Player" {
            if activeCard == true {
                guessView.alpha = 1
            }
        }
        if myPlayer.playerRole == "Dealer" {
            if activeCard == false {
                playButton.alpha = 1
            }
        }
    }
    
    
    // Manages peek functionality
    func peekPressed () {
        print("Peek Pressed - \(cardInPlay.cardString)")
        if myPlayer.peeks > 0 && myPlayer.playerRole == "Player" {
            myPlayer.peeks -= 1
            guessView.alpha = 0
            backCardImageView.alpha = 0
            peekImageView.alpha = 1
            UIImageView.animate(withDuration: 0.1, delay: 0.5, options: .transitionCrossDissolve, animations: {self.guessView.alpha = 1
                self.backCardImageView.alpha = 1
                self.peekImageView.alpha = 0
            }, completion: nil)
            sendString(message: "Peeker \(myPlayer.playerName)")
            if myPlayer.playerName == "Peekachu" {
                myPlayer.peeks += 1
            }
        } else if myPlayer.peeks == 0 {
            let ac = UIAlertController(title: "Nice Try!", message: "You have used all of your peeks!", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    // Allows the dealer to hide the card
    func cardTapped () {
        if myPlayer.playerRole == "Dealer" {
            if isFlippedBool == false {
                UIImageView.animate(withDuration: 3, delay: 0, options: .transitionFlipFromLeft, animations: {self.cardImageView.image = UIImage(named: "back")}, completion: nil)
                isFlippedBool = true
            } else if isFlippedBool == true {
                UIImageView.animate(withDuration: 3, delay: 0, options: .transitionFlipFromRight
                    , animations: {self.cardImageView.image = UIImage(named: self.cardInPlay.cardString)}, completion: nil)
                isFlippedBool = false
            }
        }
    }
    
    @IBAction func joinButton(_ sender: Any) {
        joinSession()
        setupView.alpha = 0
        mcSession.delegate = self
    }
    
    @IBAction func hostButton(_ sender: Any) {
        startHosting()
        everyonesInButton.alpha = 1
        wrongButton.alpha = 1
        mcSession.delegate = self
        hostBool = true
        createPlayerBool = false
        joinButton.alpha = 0
        hostButton.alpha = 0
    }
    
    @IBAction func playerNameTextField(_ sender: Any) {
    }
    
    @IBAction func nameDone(_ sender: Any) {
        if playerNameTextField.hasText {
            peerID = MCPeerID(displayName: playerNameTextField.text!)
            mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .optional)
            playerNameTextField.resignFirstResponder()
            playerNameTextField.alpha = 0
            setupNameLabel.alpha = 0
            nameDoneButton.alpha = 0
            hostButton.alpha = 1
            joinButton.alpha = 1
        } else {
            let ac = UIAlertController(title: "Uh-Oh!", message: "Please enter your name", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
        
    }
    @IBAction func everyonesInPressed(_ sender: Any) {
        if mcSession.connectedPeers.count > 0 {
            setupView.alpha = 0
            createPlayers()
            sendString(message: "DLives \(dealerLives)")
            sendString(message: "DTarget \(dealerTarget)")
            sendString(message: "DDeck \(doubleDeck)")
        }
    }
    @IBAction func wrongButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "multiHomeSegue", sender: nil)
        
    }
    
    
    
    @IBAction func playButtonTapped(_ sender: Any) {
        if myPlayer.playerRole == "Dealer" {
            startRound()
            getCard()
        }
        if myPlayer.playerRole == "Player" {
            guessView.alpha = 1
        }
    }
    
    
    @IBAction func seeDeckButton(_ sender: Any) {
        seeDeckScrollView.alpha = 1
    }
    @IBAction func resultsNextPressed(_ sender: Any) {
        resultView.alpha = 0
        if myPlayer.playerRole == "Dealer" {
            // playButton.alpha = 1
        }
    }
    @IBAction func guessDoneTapped(_ sender: Any) {
        if guessInt == lastGuessInt {
            let action1 = UIAlertAction(title: "OK", style: .default) { (action) in
                self.sendString(message: "Guess \(self.guessInt)")
                self.checkAnswer()
            }
            let action2 = UIAlertAction(title: "Cancel", style: .default) { (action) in
                self.guessView.alpha = 1
            }
            let ac = UIAlertController(title: "Are you sure?", message: "That is the same as your first answer!", preferredStyle: .alert)
            ac.addAction(action1)
            ac.addAction(action2)
            present(ac, animated: true)
        } else {
            sendString(message: "Guess \(guessInt)")
            checkAnswer()
        }
    }
    @IBAction func seeDeckBack(_ sender: Any) {
        seeDeckScrollView.alpha = 0
    }
    @IBAction func guessSeeDeck(_ sender: Any) {
        seeDeckScrollView.alpha = 1
    }
    
    
    
    
    
    //MARK: Multipeer code
    
    func startHosting() {
        mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "ep-ftd", discoveryInfo: nil, session: mcSession)
        mcAdvertiserAssistant.start()
    }
    func joinSession() {
        let mcBrowser = MCBrowserViewController(serviceType: "ep-ftd", session: mcSession)
        mcBrowser.delegate = self
        present(mcBrowser, animated: true, completion: nil)
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    }
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
    }
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL, withError error: Error?) {
    }
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true, completion: nil)
    }
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true, completion: nil)
    }
    // Manages the session changing state of connection
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            print("Connected: \(peerID.displayName)")
        case .connecting:
            print("Connecting: \(peerID.displayName)")
        case .notConnected:
            print("Not Connected: \(peerID.displayName)")
            if cardInPlay.cardsRemaining > 0 && mcSession.connectedPeers.count > 0 {
                let ac = UIAlertController(title: "Connection Lost", message: "One or more players has lost connection", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                present(ac, animated: true)
                removePlayer(playerName: "\(peerID.displayName)")
            }
            else if cardInPlay.cardsRemaining > 0 && mcSession.connectedPeers.count == 0 {
                performSegue(withIdentifier: "multiHomeSegue", sender: nil)
            }
        }
    }
    
    // Converts the NSData object sent via multipeer bavck to a string for handling
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        
        print("received")
        DispatchQueue.global(qos: .userInteractive).async{
            print("qeueing")
            let stringData = NSString(data: data, encoding: String.Encoding.utf8.rawValue) as! String
            print(stringData)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "sendDataNotification"), object: stringData)
            
        }
        print("done")
        
    }
    // Handles the reconverted string, looks for a keyword and extracts attached data/acts on it
    func dataReceived (notification: NSNotification) {
        print("Data received")
        if createPlayerBool == true {
            createPlayerBool = false
            createPlayers()
        }
        let stringData = notification.object
        var dataReceived:[String] = []
        dataReceived.append(stringData as! String)
        var foundRole: String = ""
        // Decodes string and finds its purpose
        func findRole (convertedString: String) {
            if convertedString.contains("Dealer") {
                print("dealer found")
                foundRole = "Dealer"
                let r = convertedString.index(convertedString.startIndex, offsetBy: 7)..<convertedString.endIndex
                let justName = convertedString[r]
                for players in self.playersArray {
                    if justName == players.playerName {
                        dealer = players
                        print("I think \(dealer.playerName) is the dealer")
                        DispatchQueue.main.async {
                            self.dealer.playerRole = "Dealer"
                            self.checkRoles()
                            self.updateUI()
                            if self.myPlayer.playerRole == "Dealer" {
                                self.playButton.alpha = 1
                            }
                        }
                    }
                }
                
            }
            if convertedString.contains("Player") {
                print("player found")
                foundRole = "Player"
                let r = convertedString.index(convertedString.startIndex, offsetBy: 7)..<convertedString.endIndex
                let justName = convertedString[r]
                for players in self.playersArray {
                    if justName == players.playerName {
                        currentPlayer = players
                        print("I think \(currentPlayer.playerName) is the player")
                        DispatchQueue.main.async {
                            self.currentPlayer.playerRole = "Player"
                            self.checkRoles()
                            self.updateUI()
                        }
                    }
                }
            }
            if convertedString.contains("Observer") {
                print("observer found")
                foundRole = "Observer"
                let r = convertedString.index(convertedString.startIndex, offsetBy: 9)..<convertedString.endIndex
                let justName = convertedString[r]
                for players in self.playersArray {
                    if justName == players.playerName {
                        print("I think \(justName) an observer")
                        players.playerRole = "Observer"
                        DispatchQueue.main.async {
                            self.checkRoles()
                            self.updateUI()
                        }
                    }
                }
            }
            
            if convertedString.contains("Go!") {
                DispatchQueue.main.async {
                    self.firstGuess = true
                    self.activeCard = true
                    self.checkRoles()
                }
                if myPlayer.playerRole == "Player" {
                    DispatchQueue.main.async {
                        self.showGuessView()
                        
                    }
                }
            }
            if convertedString.contains("CardValue") {
                let r = convertedString.index(convertedString.startIndex, offsetBy: 10)..<convertedString.endIndex
                let justNumbers = convertedString[r]
                print("Done it - \(justNumbers)")
                let cardValueInt:Int = Int(justNumbers)!
                DispatchQueue.main.async {
                    self.cardInPlay.cardValue = cardValueInt
                    print("\(self.cardInPlay.cardValue) - is the value right?")
                }
                
            }
            if convertedString.contains("CardString") {
                let r = convertedString.index(convertedString.startIndex, offsetBy: 11)..<convertedString.endIndex
                let justCardString = convertedString[r]
                print("Done it - \(justCardString)")
                DispatchQueue.main.async {
                    self.cardInPlay.cardString = justCardString
                    self.peekImageView.image = UIImage(named: justCardString)
                }
            }
            if convertedString.contains("Guess") {
                let r = convertedString.index(convertedString.startIndex, offsetBy: 6)..<convertedString.endIndex
                let justNumbers = convertedString[r]
                print("Done it GUESS - \(justNumbers)")
                let guessValueInt:Int = Int(justNumbers)!
                guessInt = guessValueInt
                DispatchQueue.main.async {
                    self.checkAnswer()
                }
            }
            if convertedString.contains("DLives") {
                let r = convertedString.index(convertedString.startIndex, offsetBy: 7)..<convertedString.endIndex
                let justNumbers = convertedString[r]
                print("Assigning default D Lives- \(justNumbers)")
                let dLivesValueInt:Int = Int(justNumbers)!
                DispatchQueue.main.async {
                    self.defaultDealerLives = dLivesValueInt
                    self.dealerLives = dLivesValueInt
                    self.updateDealerLabels()
                }
            }
            if convertedString.contains("DTarget") {
                let r = convertedString.index(convertedString.startIndex, offsetBy: 8)..<convertedString.endIndex
                let justNumbers = convertedString[r]
                print("Assigning default D Target- \(justNumbers)")
                let dTargetValueInt:Int = Int(justNumbers)!
                DispatchQueue.main.async {
                    self.defaultDealerTarget = dTargetValueInt
                    self.dealerTarget = dTargetValueInt
                    self.updateDealerLabels()
                }
            }
            if convertedString.contains("DDeck") {
                let r = convertedString.index(convertedString.startIndex, offsetBy: 6)..<convertedString.endIndex
                let justBool = convertedString[r]
                print("Assigning double deck - \(justBool)")
                if justBool == "true" {
                    DispatchQueue.main.async {
                        self.doubleDeck = true
                        self.cardInPlay.cardsRemaining = 104
                    }
                }
            }
            if convertedString.contains("WhoDLR") {
                if hostBool == true {
                    DispatchQueue.main.async {
                        self.sendString(message: "Dealer \(self.dealer.playerName)")
                    }
                }
                
            }
            if convertedString.contains("WhoPLR") {
                if hostBool == true {
                    DispatchQueue.main.async {
                        self.sendString(message: "Player \(self.currentPlayer.playerName)")
                    }
                }
                
            }
            if convertedString.contains("Peeker") {
                let r = convertedString.index(convertedString.startIndex, offsetBy: 7)..<convertedString.endIndex
                let justName = convertedString[r]
                DispatchQueue.main.async {
                    let ac = UIAlertController(title: "Somebody Peeked", message: "\(justName) just peeked at the card!", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(ac, animated: true)
                }
            }
            if convertedString.contains("Refresh") {
                DispatchQueue.main.async {
                    self.reassignRoles()
                }
            }
            if convertedString.contains("Host") {
                let r = convertedString.index(convertedString.startIndex, offsetBy: 5)..<convertedString.endIndex
                let justName = convertedString[r]
                for players in playersArray {
                    if justName == players.playerName {
                        DispatchQueue.main.async {
                            self.hostPlayer = players
                        }
                    }
                }
            }
        }
        for strings in dataReceived {
            findRole(convertedString: strings)
        }
        if dataReceived.count < 4 {
            dataReceived.removeFirst()
        }
    }
    func removePlayer(playerName: String) {
        var removablePlayer = Player()
        for players in playersArray {
            if players.playerName == playerName {
                removablePlayer = players
                print("Removing \(removablePlayer.playerName)")
                removedPlayersArray.append(removablePlayer)
                if let findIndex = observersArray.index(of: removablePlayer) {
                    observersArray.remove(at: findIndex)
                }
                if let findIndex2 = playersArray.index(of: removablePlayer) {
                    playersArray.remove(at: findIndex2)
                }
                disconnectedReassign(removablePlayer: removablePlayer)
            }
            
        }
        
        // TODO: Sort out if host disconnects
        if removablePlayer == hostPlayer {
            print("The host has DC'd")
            var nameStringArray:[String] = []
            for players in playersArray {
                nameStringArray.append(players.playerName)
            }
            print(nameStringArray)
            nameStringArray.sort(by: <)
            print(nameStringArray)
            for findplayer in playersArray {
                if findplayer.playerName == nameStringArray[0] {
                    hostPlayer = findplayer
                    print("The new host is \(hostPlayer.playerName)")
                    if myPlayer == hostPlayer {
                        hostBool = true
                        //startHosting()
                    }
                }
            }
        }
        
        
    }
    
    func disconnectedReassign (removablePlayer : Player) {
        if removablePlayer.playerRole == "Dealer" {
            print("Assigning new dealer due to removal")
            if hostBool == true {
                if self.mcSession.connectedPeers.count == 1 {
                    for players in playersArray {
                        if players.playerRole == "Observer" {
                            dealer = players
                            dealer.playerRole = "Dealer"
                            sendString(message: "Dealer \(currentPlayer.playerName)")
                            checkRoles()
                            updateUI()
                        }
                    }
                } else {
                    newDealer()
                }
            }
        }
        if removablePlayer.playerRole == "Player" {
            print("Assigning new player due to removal")
            if hostBool == true {
                if self.mcSession.connectedPeers.count == 1 {
                    for players in playersArray {
                        if players.playerRole == "Observer" {
                            currentPlayer = players
                            currentPlayer.playerRole = "Player"
                            sendString(message: "Player \(currentPlayer.playerName)")
                            checkRoles()
                            updateUI()
                        }
                    }
                } else if self.mcSession.connectedPeers.count > 1 {
                    nextPlayer()
                }
            }
        } else if removablePlayer.playerRole == "Observer" {
            return
        }
    }
    
    func reassignRoles() {
        for resetPlayer in playersArray {
            if resetPlayer.playerName == dealer.playerName {
                dealer = resetPlayer
                resetPlayer.playerRole = "Dealer"
            }
            if resetPlayer.playerName == currentPlayer.playerName {
                currentPlayer = resetPlayer
                resetPlayer.playerRole = "Player"
            }else {
                resetPlayer.playerRole = "Observer"
            }
        }
        updateUI()
        checkRoles()
    }
    
    func sendString(message: String) {
        let stringToSend = message.data(using: String.Encoding.utf8, allowLossyConversion: false)
        do {
            try mcSession.send(stringToSend!, toPeers: mcSession.connectedPeers, with: .reliable)
        } catch let error as NSError {
            let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    func showGuessView() {
        if myPlayer.playerRole == "Player" {
            guessView.alpha = 1
        }
    }
    func updateUI() {
        if dealer == nil {
            sendString(message: "WhoDLR")
            return
        } else if currentPlayer == nil {
            sendString(message: "WhoPLR")
        }
        else {
            roleLabel.text = "Role: \(myPlayer.playerRole)"
            feedbackLabel.text = "\(dealer.playerName) is the dealer!"
        }
    }
    
    func checkRoles() {
        if myPlayer.playerRole == "Dealer" {
            dealer = myPlayer
            isFlippedBool = false
            if firstGuess == true {
                playButton.alpha = 1
            }
            if activeCard == false {
                playButton.alpha = 1
            }
        }
        if myPlayer.playerRole == "Player" {
            currentPlayer = myPlayer
            playButton.alpha = 0
            if activeCard == true {
                guessView.alpha = 1
            }
        }
        if myPlayer.playerRole == "Observer" {
            playButton.alpha = 0
        }
        if myPlayer.playerRole == "Not Assigned" {
            sendString(message: "WhoDLR")
            sendString(message: "WhoPLR")
            myPlayer.playerRole = "Observer"
        }
    }
    func showJoker() {
        currentPlayer.peeks += 1
        cardInPlay.cardValue = 14
        cardInPlay.cardName = "Joker"
        cardInPlay.cardSuit = "Joker"
        activeCard = true
        cardImageView.image = UIImage(named: "red_joker")
        sendString(message: "CardValue \(14)")
        sendString(message: "CardString red_joker")
    }
    
    func getCard() {
        cardImageView.alpha = 1
        playButton.alpha = 0
        // Randomly decides whether its a joker
        if jokerCount > 0 {
            let jokerRandomNumber = Int(arc4random_uniform(15) + 1)
            print("Spinning Joker \(jokerRandomNumber)")
            if jokerRandomNumber == 15 {
                print("Hit Joker")
                showJoker()
                return
            }
        }
        // If it's not a joker then...
        let randomNumber:Int = Int(arc4random_uniform(13))
        let suitRandomNumber:Int = Int(arc4random_uniform(4))
        cardInPlay.cardValue = randomNumber + 1
        cardInPlay.cardName = cardInPlay.cardNamesArray[randomNumber]
        cardInPlay.cardSuit = cardInPlay.suitNamesArray[suitRandomNumber]
        cardInPlay.generateCardName()
        // Checks if we have had that card already
        if stringCardDoneArray .contains(cardInPlay.cardString) {
            if cardInPlay.cardsRemaining < 10 && jokerCount > 0 {
                print("Hit joker via repeated card")
                showJoker()
            } else {
                getCard()
            }
        }else {
            activeCard = true
            cardImageView.image = UIImage(named: cardInPlay.cardString)
            sendString(message: "CardValue \(cardInPlay.cardValue)")
            sendString(message: "CardString \(cardInPlay.cardString)")
        }
    }
    // Arranges and displays the done pile
    func generateDoneCards(value: Int, imageName: String) {
        print("Generating Done Cards\(value), \(imageName)")
        func addSubview (Stack: UIStackView) {
            let imageView = UIImageView()
            imageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
            imageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
            imageView.image = UIImage(named: imageName)
            if Stack.arrangedSubviews.count <= 3 {
                Stack.addArrangedSubview(imageView)
                print("Added to stackView \(Stack.arrangedSubviews)")
                print("Dealer: \(dealer.playerName), Player: \(currentPlayer.playerName)")
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
            addSubview(Stack: aceStack)
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
            addSubview(Stack: queeenStack)
            
        case 13:
            addSubview(Stack: kingStack)
            
        default:
            print("Error generating Done Cards")
            return
        }
    }
    
    func resetDoneCards() {
        secondDeck = true
        jokerCount = defaultJokerCount
        cardDoneArray.removeAll()
        stringCardDoneArray.removeAll()
        aceStack.arrangedSubviews.forEach({ $0.removeFromSuperview() })
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
        queeenStack.arrangedSubviews.forEach({ $0.removeFromSuperview() })
        kingStack.arrangedSubviews.forEach({ $0.removeFromSuperview() })
    }
    // Updates the views when a new round
    func startRound() {
        //  guessView.alpha = 0.9
        //playButton.alpha = 0
        firstGuess = true
        sendString(message: "Go!")
    }
    
    // Updates views and resets guess settings for second guess
    func secondGuess() {
        firstGuess = false
        lastGuessInt = guessInt
        guessString = ""
        showGuessView()
    }
    // Checks conditions when a player looses and updates properties
    func playerLooses() {
        dealerTarget -= 1
        dealer.sipsGiven += sipTotal
        resultPlayerLabel.text = "Next Player!"
        if dealerTarget == 0 {
            newDealer()
            resultPlayerLabel.text = "Time to pass the deck Dealer!"
            dealerLives = defaultDealerLives
            dealerTarget = defaultDealerTarget
        }
        else if dealerTarget == 1 {
            resultPlayerLabel.text = "Nearly there \(dealer.playerName), one more player!"
        }
        else if dealerTarget >= 2 {
            resultPlayerLabel.text = "Next Player!"
        }
        resultView.alpha = 0.95
        currentPlayer.sipsTaken += sipTotal
        sipString = "\(sipTotal) sips for \(currentPlayer.playerName)!"
        resultLabel.text = sipString
        for shuffleRoles in playersArray {
            shuffleRoles.lastRole = shuffleRoles.playerRole
        }
        if hostBool == true {
            if myPlayer.playerRole == "Player" {
                if mcSession.connectedPeers.count > 1 {
                    myPlayer.playerRole = "Observer"
                }
            }
            nextPlayer()
        } else if hostBool == false {
            if myPlayer.playerRole == "Player" {
                if mcSession.connectedPeers.count > 1 {
                    myPlayer.playerRole = "Observer"
                }
            }
        }
        nextTurn()
    }
    // Determines who is the next player/guesser is next
    /*
     
     func changePlayer() {
     lastPlayer = currentPlayer
     if mcSession.connectedPeers.count == 1 {
     return
     }
     // is it last in the array:
     //Yes
     if currentPlayerIndex == mcSession.connectedPeers.count {
     // Is it the dealer at the start of the array?
     if dealerIndex == 0 {
     currentPlayerIndex = 1
     if playersArray[currentPlayerIndex].lastRole == "Observer" {
     currentPlayer = playersArray[currentPlayerIndex]
     playersArray[currentPlayerIndex].playerRole = "Player"
     lastPlayer?.playerRole = "Observer"
     }
     // No dealer
     } else if dealerIndex > 0 {
     currentPlayerIndex = 0
     if playersArray[currentPlayerIndex].lastRole == "Observer" {
     currentPlayer = playersArray[currentPlayerIndex]
     playersArray[currentPlayerIndex].playerRole = "Player"
     lastPlayer?.playerRole = "Observer"
     }
     }
     }
     // Not last
     else if currentPlayerIndex < mcSession.connectedPeers.count {
     currentPlayerIndex += 1
     // If it's matched the dealer but not last
     if currentPlayerIndex == dealerIndex && currentPlayerIndex < mcSession.connectedPeers.count {
     currentPlayerIndex += 1
     if playersArray[currentPlayerIndex].lastRole == "Observer" {
     currentPlayer = playersArray[currentPlayerIndex]
     playersArray[currentPlayerIndex].playerRole = "Player"
     lastPlayer?.playerRole = "Observer"
     }
     // If it's matched the dealer and IS last
     } else if currentPlayerIndex == dealerIndex && currentPlayerIndex == mcSession.connectedPeers.count {
     currentPlayerIndex = 0
     if playersArray[currentPlayerIndex].lastRole == "Observer" {
     currentPlayer = playersArray[currentPlayerIndex]
     playersArray[currentPlayerIndex].playerRole = "Player"
     lastPlayer?.playerRole = "Observer"
     }
     }
     // No dealer
     else if playersArray[currentPlayerIndex].lastRole == "Observer" {
     currentPlayer = playersArray[currentPlayerIndex]
     playersArray[currentPlayerIndex].playerRole = "Player"
     lastPlayer?.playerRole = "Observer"
     }
     }
     sendString(message: "Player \(currentPlayer.playerName)")
     sendString(message: "Observer \(lastPlayer?.playerName)")
     }
     */
    func nextPlayer() {
        if currentPlayer != nil {
            lastPlayer = currentPlayer
        }
        var playerIndex:Int = 0
        if mcSession.connectedPeers.count == 1 {
            return
        }
        if let findIndex = observersArray.index(of: currentPlayer) {
            playerIndex = findIndex
        }
        if playerIndex == observersArray.count - 1 {
            playerIndex = 0
            currentPlayer = observersArray[playerIndex]
            lastPlayer?.playerRole = "Observer"
            currentPlayer.playerRole = "Player"
        } else if playerIndex < observersArray.count - 1 {
            playerIndex += 1
            currentPlayer = observersArray[playerIndex]
            lastPlayer?.playerRole = "Observer"
            currentPlayer.playerRole = "Player"
        }
        print("NEW PLAYER \(currentPlayer.playerName)")
        sendString(message: "Player \(currentPlayer.playerName)")
        sendString(message: "Observer \(lastPlayer?.playerName)")
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
            self.resultPlayerLabel.text = "Ouch! That didn't go very well. At least you tried!"
            dealerLives = defaultDealerLives
        }
        else if dealerLives == 1 {
            resultPlayerLabel.text = "One life left \(dealer.playerName)!"
        }
        else if dealerLives > 1 {
            resultPlayerLabel.text = "Back to square one! Next player please."
        }
        if hostBool == true {
            nextPlayer()
        }else if hostBool == false {
            if myPlayer.playerRole == "Player" {
                if mcSession.connectedPeers.count > 1 {
                    myPlayer.playerRole = "Observer"
                }
            }
        }
        nextTurn()
    }
    
    // Determines the next dealer
    func newDealer() {
        lastDealer = dealer
        print("assigning new dealer")
        if hostBool == true {
            if mcSession.connectedPeers.count == 1 {
                if dealerLives == 0 || dealerTarget == 0 {
                    dealer = currentPlayer
                    dealer.playerRole = "Dealer"
                    currentPlayer = lastDealer
                    currentPlayer.playerRole = "Player"
                    sendString(message: "Dealer \(dealer.playerName)")
                    sendString(message: "Player \(currentPlayer.playerName)")
                    print("Sent new dealer")
                }
                return
            }
            observersArray.append(dealer)
            if dealerIndex == numberofPlayers {
                dealerIndex = 0
                dealer = playersArray[dealerIndex]
                dealer.playerRole = "Dealer"
            }
            else if dealerIndex < numberofPlayers {
                dealerIndex += 1
                dealer = playersArray[dealerIndex]
                dealer.playerRole = "Dealer"
            }
            print("NEW DEALER\(dealer.playerName)")
            sendString(message: "Dealer \(dealer.playerName)")
            if let findIndex = observersArray.index(of: dealer) {
                observersArray.remove(at: findIndex)
            }
        }
        else {
            return
        }
    }
    // Checks players answer to see if they have won/lost
    func checkAnswer() {
        guessView.alpha = 0
        if cardInPlay.cardValue == 14 {
            print("Checking answer for joker")
            if firstGuess == false {
                sipTotal = 10
                playerLooses()
                lastGuessInt = 20
                return
            }
            if firstGuess == true {
                feedbackLabel.text = "You're screwed!"
                secondGuess()
                return
            }
        }
        if guessInt < cardInPlay.cardValue {
            if firstGuess == false {
                sipTotal = (cardInPlay.cardValue - guessInt)
                playerLooses()
                lastGuessInt = 20
                
            }
            if firstGuess == true {
                feedbackLabel.text = "Higher!"
                secondGuess()
            }
        }
            
        else if guessInt > cardInPlay.cardValue {
            if firstGuess == false {
                sipTotal = (guessInt - cardInPlay.cardValue)
                playerLooses()
                lastGuessInt = 20
            }
            if firstGuess == true {
                feedbackLabel.text = "Lower!"
                secondGuess()
            }
        }
            
        else if guessInt == cardInPlay.cardValue {
            dealerLooses()
            lastGuessInt = 20
        }
    }
    // Prepares for next turn, checks how many cards remain and moves card into done array
    func nextTurn() {
        if cardInPlay.cardValue < 14 {
            cardDoneArray.append(cardInPlay)
            stringCardDoneArray.append(cardInPlay.cardString)
            generateDoneCards(value: (cardDoneArray.last?.cardValue)!, imageName: (cardDoneArray.last?.cardString)!)
            cardInPlay.cardsRemaining -= 1
        } else if cardInPlay.cardValue == 14 {
            jokerCount -= 1
        }
        activeCard = false
        cardCountLabel.text = "\(cardInPlay.cardsRemaining)"
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
        updateUI()
        checkRoles()
        if myPlayer.playerRole == "Dealer" {
            playButton.alpha = 1
        }
    }
    
    func updateDealerLabels() {
        dealerTargetLabel.text = "\(dealerTarget)"
        dealerLivesLabel.text = "\(dealerLives)"
        roleLabel.text = "Role: \(myPlayer.playerRole)"
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
        print("+++REMOVING \(observersArray[randomNumber].playerName) from array. Dealer should be \(dealer.playerName)")
        observersArray.remove(at: randomNumber)
        playersArray[randomNumber].playerRole = "Dealer"
        dealerIndex = randomNumber
        currentPlayer = playersArray[randomNumber2]
        playersArray[randomNumber2].playerRole = "Player"
        currentPlayerIndex = randomNumber2
        sendFirstPlayerRoles()
        updateUI()
    }
    func sendFirstPlayerRoles() {
        
        let firstDealer = "Dealer \(dealer.playerName)".data(using: String.Encoding.utf8, allowLossyConversion:false)
        let firstPlayer = "Player \(currentPlayer.playerName)".data(using: String.Encoding.utf8, allowLossyConversion: false)
        print("converted")
        do {
            try mcSession.send(firstDealer!, toPeers: mcSession.connectedPeers, with: .reliable)
        } catch let error as NSError {
            let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
        do {
            try mcSession.send(firstPlayer!, toPeers: mcSession.connectedPeers, with: .reliable)
        } catch let error as NSError {
            let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
        print("sent")
        checkRoles()
    }
    
    func gameOver () {
        self.resultsNextButton.alpha = 0
        self.gameOverButton.alpha = 1
        self.resultView.alpha = 0.9
        resultPlayerLabel.textColor = UIColor.red
        resultPlayerLabel.text = "Game Over!"
        resultLabel.text = "I hope you didn't loose too many friends!"
    }
    // Takes stepper value and creates the players for the game
    func createPlayers() {
        var hostPlayer = Player()
        hostPlayer.playerName = mcSession.myPeerID.displayName
        playersArray.append(hostPlayer)
        myPlayer = hostPlayer
        // let howManyPlayers: Int = Int(mcSession.connectedPeers.count)
        for players in mcSession.connectedPeers {
            let newPlayer = Player()
            newPlayer.playerName = players.displayName
            playersArray.append(newPlayer)
        }
        numberofPlayers = (playersArray.count - 1)
        observersArray = playersArray
        print("\(observersArray)")
        if hostBool == true {
            determineFirstPlayers()
            hostPlayer = myPlayer
            sendString(message: "Host \(myPlayer.playerName)")
        }
        //feedbackLabel.text = "\(dealer.playerName) is the dealer!"
        // roleLabel.text = "Role: \(myPlayer.playerRole)"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "multipeerResultSegue" {
            let destViewController: ResultsViewController = segue.destination as! ResultsViewController
            destViewController.resultPlayersArray = playersArray
            mcSession.disconnect()
            if hostBool == true {
                mcAdvertiserAssistant.stop()
            }
        }
        if segue.identifier == "multiHomeSegue" {
            mcSession.disconnect()
            if hostBool == true {
                mcAdvertiserAssistant.stop()
            }
        }
        
    }
    
    
    
    
    
    
    
    // Delegates
    
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
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // TODO: Get "done" button working
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.setupTextField.resignFirstResponder()
        self.setupTextField.endEditing(true)
        return true
    }
    
    
    
    
}



// TODO: fix pickerview so the last selected number is still set when your next go comes up but picker hasnt moved

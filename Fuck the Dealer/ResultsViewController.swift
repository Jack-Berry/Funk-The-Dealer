//
//  ResultsViewController.swift
//  Funk the Dealer
//
//  Created by Jack Berry on 11/10/2016.
//  Copyright © 2016 EtherPlay. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {
    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var mostPlayerLabel: UILabel!
    
    @IBOutlet weak var fewestPlayerLabel: UILabel!
    
    @IBOutlet weak var givenPlayerLabel: UILabel!
    
    @IBOutlet weak var takenPlayerLabel: UILabel!
    
    @IBOutlet weak var MVPPlayerLabel: UILabel!
    
    var resultPlayersArray:[Player] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        MVPPlayerLabel.text = "You all sucked!"
        mostSips()
        fewestSips()
        funksGiven()
        funksTaken()
        MVPCalculator()
        

        // Do any additional setup after loading the view.
//        testLabel.text = playersArray[0].playerName
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func mainMenuPressed(_ sender: AnyObject) {
        resultPlayersArray.removeAll()
    }
    
    
    
    
    func mostSips() {
        var highestSips:Int = 0
        var highestPlayer = Player()
        for player in resultPlayersArray {
            if player.sipsTaken > highestSips {
                highestSips = player.sipsTaken
                highestPlayer = player
            }
        }
        mostPlayerLabel.text = highestPlayer.playerName
    }
    func fewestSips() {
        var fewestSips:Int = 999
        var fewestPlayer = Player()
        
        for player in resultPlayersArray {
            if player.sipsTaken < fewestSips {
                fewestSips = player.sipsTaken
                fewestPlayer = player
            }
        }
        fewestPlayerLabel.text = fewestPlayer.playerName
    }
    
    func funksGiven() {
        var mostFunksGiven:Int = 0
        var mostPlayer = Player()
    
        for player in resultPlayersArray {
            if player.funksGiven > mostFunksGiven {
                mostFunksGiven = player.funksGiven
                mostPlayer = player
            }
            
        }
        givenPlayerLabel.text = mostPlayer.playerName
    }
    
    func funksTaken() {
        var mostFunksTaken:Int = 0
        var funkedPlayer = Player()
        for player in resultPlayersArray {
            if player.timesFunked > mostFunksTaken {
                mostFunksTaken = player.timesFunked
                funkedPlayer = player
            }
        }
        takenPlayerLabel.text = funkedPlayer.playerName
    }
    
    func MVPCalculator () {
        var playerScore:Int = 0
        var MVPPlayer = Player()
        var highScore:Int = 0
        for player in resultPlayersArray {
            var funkGive:Int = player.funksGiven * 6
            var funkTake:Int = player.timesFunked * 6
           playerScore += player.sipsGiven
            playerScore -= player.sipsTaken
            playerScore += funkGive
            playerScore -= funkTake
            if playerScore > highScore {
                MVPPlayer = player
                highScore = playerScore
            }
        }
        MVPPlayerLabel.text = MVPPlayer.playerName
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

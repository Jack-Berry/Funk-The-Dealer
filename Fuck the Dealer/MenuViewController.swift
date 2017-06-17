//
//  MenuViewController.swift
//  Funk the Dealer
//
//  Created by Jack Berry on 05/10/2016.
//  Copyright © 2016 EtherPlay. All rights reserved.
//

import MultipeerConnectivity
import UIKit

class MenuViewController: UIViewController {
    
    @IBOutlet weak var settingsView: UIView!
    @IBOutlet weak var targetNumber: UILabel!
    @IBOutlet weak var livesNumber: UILabel!
    @IBOutlet weak var targetStepper: UIStepper!
    @IBOutlet weak var livesStepper: UIStepper!


    var dealerTarget:Int = 3
    var dealerLives:Int = 3
    var doubleDeck:Bool = false
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
     /*   peerID = MCPeerID(displayName: UIDevice.current.name)
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .optional)
        mcSession.delegate = self*/
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playPressed(_ sender: Any) {
    }
    
    
    @IBAction func settingsButtonPressed(_ sender: AnyObject) {
        settingsView.alpha = 1
    }

    @IBAction func settingsDonePressed(_ sender: AnyObject) {
        settingsView.alpha = 0
    }
    
    @IBAction func targetStepper(_ sender: AnyObject) {
        self.targetNumber.text = String(format: "%.0f", targetStepper.value)
        dealerTarget = Int(targetStepper.value)
        
    }
    
    @IBAction func livesStepper(_ sender: AnyObject) {
        self.livesNumber.text = String(format: "%.0f", livesStepper.value)
        dealerLives = Int(livesStepper.value)
    }
    
    @IBAction func doubleDeckSwitch(_ sender: AnyObject) {
        doubleDeck = true
        print("double deck on")
    }
    

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "singleSegue" {
        let destViewController: ViewController = segue.destination as! ViewController
        destViewController.defaultDealerTarget = dealerTarget
        destViewController.defaultDealerLives = dealerLives
        destViewController.doubleDeck = doubleDeck
        }
    else if segue.identifier == "multiSegue" {
        let destViewController: MultiPeerViewController = segue.destination as! MultiPeerViewController
        destViewController.defaultDealerTarget = dealerTarget
        destViewController.defaultDealerLives = dealerLives
        destViewController.doubleDeck = doubleDeck
    }

    }
    
    // TODO: double deck, number of guesses, player/dealer view 
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

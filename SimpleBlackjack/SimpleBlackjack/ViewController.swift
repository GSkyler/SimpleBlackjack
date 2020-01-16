//
//  ViewController.swift
//  SimpleBlackjack
//
//  Created by conant cougars on 1/13/20.
//  Copyright © 2020 conant cougars. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var balance:Int = 100
    var bet:Int = 10
    var deck:Array<Int> = []
    var pCards:Array<Int> = []
    var dCards:Array<Int> = []
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var dealerCardLabel: UILabel!
    @IBOutlet weak var playerCardLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var betLabel: UILabel!
    @IBOutlet weak var hitButton: UIButton!
    @IBOutlet weak var standButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
            
        upSwipe.direction = .up
        downSwipe.direction = .down

        view.addGestureRecognizer(upSwipe)
        view.addGestureRecognizer(downSwipe)
        
        balanceLabel.text = "\(balance)"
        betLabel.text = "\(bet)"
        reset()
        
    }
    
    @IBAction func handleHit(_ sender: Any) {
        hit(playerHit: true)
        let cardSum = calcSum(playerSum: true)
        if cardSum > 21{
            playerCardLabel.text! += " YOU BUSTED"
            resultLabel.text = "YOU LOSE"
            balance -= bet
            balanceLabel.text = "\(balance)"
            endHand()
        }
    }
    
    @IBAction func handleReset(_ sender: Any) {
        reset()
    }
    
    @IBAction func handleStand(_ sender: Any) {
        handleDealerPlay()
    }
    
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer) {
        if (sender.direction == .up) {
            if(bet+5 <= balance){
                bet += 5
                betLabel.text = "\(bet)"
            }
        }
            
        if (sender.direction == .down) {
            if(bet-5 > 0){
                bet -= 5
                betLabel.text = "\(bet)"
            }
        }
    }
    
    func reset(){
        deck.removeAll()
        pCards.removeAll()
        dCards.removeAll()
        playerCardLabel.text = ""
        dealerCardLabel.text = ""
        resultLabel.text = ""
        for _ in 1...4{
            for i in 1...9{
                deck.append(i)
            }
            for _ in 1...4{
                deck.append(10)
            }
        }
        hitButton.isEnabled = true
        standButton.isEnabled = true
        dCards.append(deck.remove(at: Int.random(in: 0..<deck.count)))
        dealerCardLabel.text = "\(dCards)"
    }
    
    func handleDealerPlay(){
        var dealerSum = 0
        while dealerSum <= 16 {
            hit(playerHit: false)
            dealerSum = calcSum(playerSum: false)
        }
        if dealerSum > 21 {
            dealerCardLabel.text! += " DEALER BUSTED"
            resultLabel.text = "YOU WIN"
            balance += bet
            balanceLabel.text = "\(balance)"
            endHand()
        }
        else if dealerSum == calcSum(playerSum: true){
            resultLabel.text = "DEALER WINS"
            balance -= bet
            balanceLabel.text = "\(balance)"
            endHand()
        }
        else if dealerSum > calcSum(playerSum: true){
            resultLabel.text = "DEALER WINS"
            balance -= bet
            balanceLabel.text = "\(balance)"
            endHand()
        }
        else if dealerSum < calcSum(playerSum: true){
            resultLabel.text = "YOU WIN"
            balance += bet
            balanceLabel.text = "\(balance)"
            endHand()
        }
    }
    
    func hit(playerHit:Bool){
        let rNum = Int.random(in: 0..<deck.count)
        if(playerHit){
            pCards.append(deck.remove(at: rNum))
            playerCardLabel.text = "\(pCards)"
        }
        else{
            dCards.append(deck.remove(at: rNum))
            dealerCardLabel.text = "\(dCards)"
        }
    }
    
    func calcSum(playerSum: Bool) -> Int {
        var sum = 0
        if(playerSum){
            for num in pCards{
                sum += num
            }
        }
        else{
            for num in dCards{
                sum += num
            }
        }
        return sum
    }
    
    func endHand(){
        hitButton.isEnabled = false
        standButton.isEnabled = false
    }
    
}


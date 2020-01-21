//
//  ViewController.swift
//  SimpleBlackjack
//
//  Created by conant cougars on 1/13/20.
//  Copyright © 2020 conant cougars. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let suits = ["C", "S", "H", "D"]
    var balance:Int = 100
    var bet:Int = 10
    var mainDeck:Array<Card> = []
    var pCardImageViews:Array<UIImageView> = []
    var dCardImageViews:Array<UIImageView> = []
    var deck:Array<Int> = []
    var pCards:Array<Int> = []
    var dCards:Array<Int> = []
    var pCardObjects:Array<Card> = []
    var dCardObjects:Array<Card> = []
    @IBOutlet weak var balanceLabel: UILabel!
//    @IBOutlet weak var playerSumLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
//    @IBOutlet weak var dealerSumLabel: UILabel!
    @IBOutlet weak var betLabel: UILabel!
    @IBOutlet weak var hitButton: UIButton!
    @IBOutlet weak var standButton: UIButton!
    @IBOutlet weak var dealerCard1: UIImageView!
    @IBOutlet weak var dealerCard2: UIImageView!
    @IBOutlet weak var dealerCard3: UIImageView!
    @IBOutlet weak var dealerCard4: UIImageView!
    @IBOutlet weak var dealerCard5: UIImageView!
    @IBOutlet weak var dealerCard6: UIImageView!
    @IBOutlet weak var dealerCard7: UIImageView!
    @IBOutlet weak var playerCard1: UIImageView!
    @IBOutlet weak var playerCard2: UIImageView!
    @IBOutlet weak var playerCard3: UIImageView!
    @IBOutlet weak var playerCard4: UIImageView!
    @IBOutlet weak var playerCard5: UIImageView!
    @IBOutlet weak var playerCard6: UIImageView!
    @IBOutlet weak var playerCard7: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
            
        upSwipe.direction = .up
        downSwipe.direction = .down

        view.addGestureRecognizer(upSwipe)
        view.addGestureRecognizer(downSwipe)
        
        pCardImageViews.append(playerCard1)
        pCardImageViews.append(playerCard2)
        pCardImageViews.append(playerCard3)
        pCardImageViews.append(playerCard4)
        pCardImageViews.append(playerCard5)
        pCardImageViews.append(playerCard6)
        pCardImageViews.append(playerCard7)
        dCardImageViews.append(dealerCard1)
        dCardImageViews.append(dealerCard2)
        dCardImageViews.append(dealerCard3)
        dCardImageViews.append(dealerCard4)
        dCardImageViews.append(dealerCard5)
        dCardImageViews.append(dealerCard6)
        dCardImageViews.append(dealerCard7)
        
        balanceLabel.text = "\(balance)"
        betLabel.text = "\(bet)"
        reset()
        
    }
    
    @IBAction func handleHit(_ sender: Any) {
        hit(playerHit: true)
        let cardSum = calcSum(playerSum: true)
//        playerSumLabel.text = "Your sum: \(cardSum)"
        if cardSum > 21{
//            playerSumLabel.text! += " YOU BUSTED"
            resultLabel.text = "YOU LOSE"
            balance -= bet
            balanceLabel.text = "\(balance)"
            endHand()
        }
    }
    
    @IBAction func handleDouble(_ sender: Any) {
        let oldBet = bet
        bet *= 2
        if bet > balance {
            bet = balance
        }
        
        hit(playerHit: true)
        
        if calcSum(playerSum: true) > 21 {
            resultLabel.text = "YOU LOSE"
            balance -= bet
            balanceLabel.text = "\(balance)"
            endHand()
        }
        else{
            dCardObjects[1].setHidden(hidden: false)
            updateImageViews()
            handleDealerPlay()
        }
        
        bet = oldBet
    
    }
    
    @IBAction func handleReset(_ sender: Any) {
        reset()
    }
    
    @IBAction func handleStand(_ sender: Any) {
        dCardObjects[1].setHidden(hidden: false)
        updateImageViews()
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
        pCardObjects.removeAll()
        dCardObjects.removeAll()
//        playerSumLabel.text = ""
//        dealerSumLabel.text = ""
        resultLabel.text = ""
        for suit in suits{
            for i in 2...10{
                let cardName = suit + "\(i)"
                let path = Bundle.main.path(forResource: cardName, ofType: "jpg", inDirectory: "cards")!
                mainDeck.append(Card(v: i, path: path))
            }
            for i in 11...13{
                let cardName = suit + "\(i)"
                let path = Bundle.main.path(forResource: cardName, ofType: "jpg", inDirectory: "cards")!
                mainDeck.append(Card(v: 10, path: path))
            }
            let cardName = suit + "14"
            let path = Bundle.main.path(forResource: cardName, ofType: "jpg", inDirectory: "cards")!
            mainDeck.append(Card(v: 1, path: path))
        }
        hitButton.isEnabled = true
        standButton.isEnabled = true
        pCardObjects.append(mainDeck.remove(at: Int.random(in: 0..<mainDeck.count)))
        dCardObjects.append(mainDeck.remove(at: Int.random(in: 0..<mainDeck.count)))
        pCardObjects.append(mainDeck.remove(at: Int.random(in: 0..<mainDeck.count)))
        dCardObjects.append(mainDeck.remove(at: Int.random(in: 0..<mainDeck.count)))
        dCardObjects[1].setHidden(hidden: true)
        
        updateImageViews()
        
//        playerSumLabel.text = "Your sum: \(calcSum(playerSum: true))"
//        dealerSumLabel.text = "Dealer sum: ?"
    }
    
    func handleDealerPlay(){
        var dealerSum = calcSum(playerSum: false)
        while dealerSum <= 16 {
            hit(playerHit: false)
            dealerSum = calcSum(playerSum: false)
        }
        if dealerSum > 21 {
//            dealerSumLabel.text! += " DEALER BUSTED"
            resultLabel.text = "YOU WIN"
            balance += bet
            balanceLabel.text = "\(balance)"
            endHand()
        }
        else if dealerSum == calcSum(playerSum: true){
            resultLabel.text = "TIE"
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
    
    func updateImageViews(){
        clearImageViews()
        var nextPCardX = 20
        var nextDCardX = 20
        
        for i in 0...pCardObjects.count-1 {
            let cardImage = UIImage.init(contentsOfFile: pCardObjects[i].getPath())!
            pCardImageViews[i] = UIImageView(image: cardImage)
            pCardImageViews[i].frame = CGRect(x: nextPCardX, y: 350, width: 70, height: 100)
            self.view.addSubview(pCardImageViews[i])
            nextPCardX += 30
        }
        for i in 0...dCardObjects.count-1 {
            let cardImage = UIImage.init(contentsOfFile: dCardObjects[i].getPath())!
            dCardImageViews[i] = UIImageView(image: cardImage)
            dCardImageViews[i].frame = CGRect(x: nextDCardX, y: 150, width: 70, height: 100)
            self.view.addSubview(dCardImageViews[i])
            nextDCardX += 30
        }
    }
    func clearImageViews() {
        for imageView in pCardImageViews {
            imageView.removeFromSuperview()
        }
        for imageView in dCardImageViews {
            imageView.removeFromSuperview()
        }
    }
    
    func hit(playerHit:Bool){
        let rNum = Int.random(in: 0..<mainDeck.count)
        if(playerHit){
            pCardObjects.append(mainDeck.remove(at: rNum))
        }
        else{
            dCardObjects.append(mainDeck.remove(at: rNum))
        }
        updateImageViews()
    }
    
    func calcSum(playerSum: Bool) -> Int {
        var sum = 0
        if(playerSum){
            for card in pCardObjects {
                sum += card.getVal()
            }
        }
        else{
            for card in dCardObjects {
                sum += card.getVal()
            }
        }
        return sum
    }
    
    func endHand(){
        hitButton.isEnabled = false
        standButton.isEnabled = false
    }
    
}

class Card {
    
    var val:Int
    var cardPath:String
    var isHidden:Bool
    
    init(v: Int, path: String){
        val = v
        cardPath = path
        isHidden = false
    }
    
    func setHidden(hidden: Bool){
        isHidden = hidden
    }
    
    func getVal() -> Int {
        return val
    }
    func getPath() -> String {
        if !isHidden{
            return cardPath
        }
        return Bundle.main.path(forResource: "BACK-2", ofType: "jpg", inDirectory: "cards")!
    }
    
}

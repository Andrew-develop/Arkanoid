//
//  GameViewController.swift
//  Arkanoid
//
//  Created by Sergio Ramos on 17.12.2020.
//

import UIKit
import CoreMotion
import CoreData
import Lottie
import AVFoundation

class GameViewController: UIViewController {
    
    @IBOutlet weak var gameField: UIView!
    @IBOutlet weak var platform: UIImageView!
    @IBOutlet weak var ball: UIImageView!
    
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var livesLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    var audioPlayer = AVAudioPlayer()
    
    let motionManager = CMMotionManager()
    var timerPlatform: Timer!
    var timerBall: Timer!
    var timerPresent: Timer!
    
    var check = true
    let present = UIImageView()
    
    var arr = Array(repeating: Array(repeating: UIView(), count: 5), count: 3)
    var blockWidth : CGFloat!
    var blockHeight : CGFloat!
    
    var accelerationX : Int16 = 1
    var accelerationY : Int16 = -1
    
    var possibleScore = 0
    
    var live = 3
    var score = 0
    var level = 1
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //view settings
        present.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        present.image = UIImage(named: "coin")
        present.isHidden = true
        gameField.addSubview(present)
        
        let myColor = UIColor.white
        platform.layer.borderWidth = 1
        platform.layer.borderColor = myColor.cgColor
        platform.layer.cornerRadius = 4
        
        blockWidth = view.frame.width / 5
        blockHeight = view.frame.height / 20
        
        let context = appDelegate.persistentContainer.viewContext
        
        //ball & platform interface
        let ballFetchRequest: NSFetchRequest<Ball> = Ball.fetchRequest()
        let balls = try! context.fetch(ballFetchRequest)
        
        for i in 0..<balls.count {
            if balls[i].status {
                ball.image = UIImage(named: balls[i].name!)
                break
            }
        }
        
        let platformFetchRequest: NSFetchRequest<Platform> = Platform.fetchRequest()
        let platforms = try! context.fetch(platformFetchRequest)
        
        for i in 0..<platforms.count {
            if platforms[i].status {
                platform.image = UIImage(named: platforms[i].name!)
                break
            }
        }
        
        //currentGame settings
        let currentGameFetchRequest: NSFetchRequest<CurrentGame> = CurrentGame.fetchRequest()
        let currentGame = try! context.fetch(currentGameFetchRequest)
        
        if currentGame.count != 0 {
            live = Int(currentGame[0].lives)
            score = Int(currentGame[0].score)
            level = Int(currentGame[0].level)
        }
        
        livesLabel.text = "Lives: \(live)"
        scoreLabel.text = "Score: \(score)"
        levelLabel.text = "Level: \(level)"
        
        //currentBlock settings
        let currentBlockFetchRequest: NSFetchRequest<CurrentBlock> = CurrentBlock.fetchRequest()
        let currentBlock = try! context.fetch(currentBlockFetchRequest)
        
        if currentBlock.count != 0 {
            currentBlock.forEach { (block) in
                let newBlock = UIView(frame: CGRect(x: CGFloat(block.koorX) * blockWidth, y: CGFloat(block.koorY) * blockHeight, width: blockWidth, height: blockHeight))
                newBlock.tag = Int(block.tag)
                if newBlock.tag > 0 {
                    setColor(block: newBlock)
                    newBlock.layer.borderWidth = 1
                    possibleScore += newBlock.tag
                }
                arr[Int(block.koorY)][Int(block.koorX)] = newBlock
                gameField.addSubview(newBlock)
            }
        }
        else {
            startCreateBlocks()
        }
        
        let userFetchRequest: NSFetchRequest<User> = User.fetchRequest()
        let user = try! context.fetch(userFetchRequest)
        
        if user[0].control == "slopes" {
            motionManager.startDeviceMotionUpdates()
            timerPlatform = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(updatePlatform), userInfo: nil, repeats: true)
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        tap.numberOfTapsRequired = 2
        gameField.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
    
    @objc func updatePlatform() {
        if let deviceMotion = motionManager.deviceMotion {
            if (platform.frame.origin.x > 0 && deviceMotion.rotationRate.y < -0.12) {
                platform.frame = CGRect(x: platform.frame.origin.x - 4, y: platform.frame.origin.y, width: platform.frame.width, height: platform.frame.height)
            }
            else if (platform.frame.origin.x < gameField.frame.width - platform.frame.width && deviceMotion.rotationRate.y > 0.12) {
                platform.frame = CGRect(x: platform.frame.origin.x + 4, y: platform.frame.origin.y, width: platform.frame.width, height: platform.frame.height)
            }
        }
    }
    
    @IBAction func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        guard let gestureView = gesture.view
        else {
            return
        }
        if (translation.x > 0 && gestureView.frame.maxX < view.frame.width) || (translation.x < 0 && gestureView.frame.minX > 0) {
            gestureView.center = CGPoint(
            x: gestureView.center.x + translation.x,
            y: gestureView.center.y
            )
        }
        gesture.setTranslation(.zero, in: view)
    }
    
    func startCreateBlocks() {
        for i in 0..<3 {
            for j in 0..<5 {
                let newBlock = UIView(frame: CGRect(x: CGFloat(j) * CGFloat(blockWidth), y: CGFloat(i) * CGFloat(blockHeight), width: blockWidth, height: blockHeight))
                newBlock.tag = Int.random(in: 0..<5)
                if newBlock.tag > 0 {
                    setColor(block: newBlock)
                    newBlock.layer.borderWidth = 1
                    possibleScore += newBlock.tag
                }
                arr[i][j] = newBlock
                gameField.addSubview(newBlock)
            }
        }
    }
    
    @objc func doubleTapped() {
        if timerBall != nil {
            timerBall.invalidate()
            timerBall = nil
        }
        else {
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
            let user = try! context.fetch(fetchRequest)
            
            timerBall = Timer.scheduledTimer(timeInterval: user[0].speed / -1000, target: self, selector: #selector(updateBall), userInfo: nil, repeats: true)
        }
    }
    
    @objc func updateBall() {
        ball.frame = CGRect(x: ball.frame.origin.x + CGFloat(accelerationX), y: ball.frame.origin.y + CGFloat(accelerationY), width: ball.frame.width, height: ball.frame.height)
        if ball.frame.minY <= blockHeight * 3 + 1 {
            if accelerationY == -1 {
                if abs(ball.frame.minY) < 1 {
                    accelerationY = 1
                }
                else {
                    for j in 1..<4 {
                        if abs(ball.frame.minY - blockHeight * CGFloat(j)) < 2 {
                            for i in 0..<5 {
                                if ball.frame.origin.x > arr[j - 1][i].frame.minX && ball.frame.origin.x < arr[j - 1][i].frame.maxX {
                                    if arr[j - 1][i].tag > 0 {
                                        accelerationY = 1
                                        afterHit(block: arr[j - 1][i])
                                        break
                                    }
                                }
                            }
                        }
                    }
                }
            }
            if accelerationY == 1 {
                for j in 1..<3 {
                    if abs(ball.frame.maxY - blockHeight * CGFloat(j)) < 2 {
                        for i in 0..<5 {
                            if ball.frame.origin.x > arr[j][i].frame.minX && ball.frame.origin.x < arr[j][i].frame.maxX {
                                if arr[j][i].tag > 0 {
                                    accelerationY = -1
                                    afterHit(block: arr[j][i])
                                    break
                                }
                            }
                        }
                    }
                }
            }
            if accelerationX == -1 {
                if abs(ball.frame.minX) < 1 {
                    accelerationX = 1
                }
                else {
                    for j in 1..<5 {
                        if abs(ball.frame.minX - blockWidth * CGFloat(j)) < 3 {
                            for i in 0..<3 {
                                if ball.frame.origin.y > arr[i][j - 1].frame.minY && ball.frame.origin.y < arr[i][j - 1].frame.maxY {
                                    if arr[i][j - 1].tag > 0 {
                                        accelerationX = 1
                                        afterHit(block: arr[i][j - 1])
                                        break
                                    }
                                }
                            }
                        }
                    }
                }
            }
            if accelerationX == 1 {
                if abs(ball.frame.maxX - gameField.frame.width) < 2 {
                    accelerationX = -1
                }
                else {
                    for j in 1..<5 {
                        if abs(ball.frame.maxX - blockWidth * CGFloat(j)) < 3 {
                            for i in 0..<3 {
                                if ball.frame.origin.y > arr[i][j].frame.minY && ball.frame.origin.y < arr[i][j].frame.maxY {
                                    if arr[i][j].tag > 0 {
                                        accelerationX = -1
                                        afterHit(block: arr[i][j])
                                        break
                                    }
                                }
                            }
                        }
                    }
                }
            }
            if possibleScore == 0 {
                afterWin()
            }
        }
        else {
            if abs(ball.frame.minX) < 1 {
                accelerationX = 1
            }
            else if abs(ball.frame.maxX - gameField.frame.width) < 1 {
                accelerationX = -1
            }
            else if abs(ball.frame.maxY - platform.frame.minY) < 1 && ball.frame.origin.x > platform.frame.minX && ball.frame.origin.x < platform.frame.maxX {
                accelerationY = -1
            }
            else if abs(ball.frame.maxY - gameField.frame.height) < 1 {
                live -= 1
                livesLabel.text = "Lives: \(live)"
                timerBall.invalidate()
                timerBall = nil
                ball.frame.origin.x = gameField.frame.midX
                ball.frame.origin.y = platform.frame.minY - ball.frame.height
                accelerationX = 1
                accelerationY = -1
                if live == 0 {
                    afterLose()
                }
            }
        }
    }
    
    func afterHit(block : UIView) {
        possibleScore -= 1
        block.tag -= 1
        if block.tag == 0 {
            block.alpha = 0
            possiblePresent(x: block.center.x, y: block.center.y)
        }
        else {
            setColor(block: block)
        }
        score += 1
        scoreLabel.text = "Score: \(score)"
    }
    
    func afterLose() {
        let context = appDelegate.persistentContainer.viewContext
        let result = GameResults(context: context)
        result.level = Int16(level)
        result.score = Int16(score)
        result.date = Date()
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        let user = try! context.fetch(fetchRequest)
        user[0].coins += Int16(score)
        appDelegate.saveContext()
        clearArray()
        clearCoreData()
        level = 1
        score = 0
        live = 3
        livesLabel.text = "Lives: \(live)"
        scoreLabel.text = "Score: \(score)"
        levelLabel.text = "Level: \(level)"
        animateLoss()
        let path = Bundle.main.path(forResource: "lossSound", ofType: "mp3")!
        let url = URL(fileURLWithPath: path)
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer.play()
        } catch {
            print("error")
        }
        startCreateBlocks()
    }
    
    func afterWin() {
        clearArray()
        clearCoreData()
        timerBall.invalidate()
        timerBall = nil
        level += 1
        levelLabel.text = "Level: \(level)"
        accelerationX = 1
        accelerationY = -1
        animateWin()
        let path = Bundle.main.path(forResource: "winSound", ofType: "mp3")!
        let url = URL(fileURLWithPath: path)
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer.play()
        } catch {
            print("error")
        }
        startCreateBlocks()
    }
    
    func setColor(block : UIView) {
        if block.tag == 1 {
            block.backgroundColor = .yellow
        }
        else if block.tag == 2 {
            block.backgroundColor = .green
        }
        else if block.tag == 3 {
            block.backgroundColor = .red
        }
        else if block.tag == 4 {
            block.backgroundColor = .blue
        }
    }
    
    func possiblePresent(x : CGFloat, y : CGFloat) {
        if Int.random(in: 0..<3) == 0 && check == true {
            check = false
            present.frame.origin.x = x
            present.frame.origin.y = y
            present.isHidden = false
            timerPresent = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(presentMoving), userInfo: nil, repeats: true)
        }
    }
    
    @objc func presentMoving() {
        present.frame.origin.y += 1
        if abs(present.frame.maxY - gameField.frame.height) < 1 {
            timerPresent.invalidate()
            timerPresent = nil
            present.isHidden = true
            check = true
        }
        else if abs(present.frame.maxY - platform.frame.minY) < 1 && present.frame.origin.x > platform.frame.minX && present.frame.origin.x < platform.frame.maxX {
            timerPresent.invalidate()
            timerPresent = nil
            score += 5
            scoreLabel.text = "Score: \(score)"
            present.isHidden = true
            check = true
        }
    }
    
    func animateWin() {
        let animation = AnimationView()
        animation.animation = Animation.named("win")
        animation.frame = CGRect(x: 0, y: 0, width: 300, height: 200)
        animation.center = view.center
        animation.loopMode = .loop
        view.addSubview(animation)
        animation.play(fromProgress: 0, toProgress: 1, loopMode: LottieLoopMode.playOnce) { _ in
            animation.removeFromSuperview()
        }
    }
    
    func animateLoss() {
        let animation = AnimationView()
        animation.animation = Animation.named("loss")
        animation.frame = CGRect(x: 0, y: 0, width: 300, height: 200)
        animation.center = view.center
        animation.loopMode = .loop
        view.addSubview(animation)
        animation.play(fromProgress: 0, toProgress: 1, loopMode: LottieLoopMode.playOnce) { _ in
            animation.removeFromSuperview()
        }
    }
    
    func clearArray() {
        for i in 0..<3 {
            for j in 0..<5 {
                arr[i][j].removeFromSuperview()
            }
        }
    }
    
    func clearCoreData() {
        let context = appDelegate.persistentContainer.viewContext
        let currentGameFetchRequest: NSFetchRequest<CurrentGame> = CurrentGame.fetchRequest()
        let currentGame = try! context.fetch(currentGameFetchRequest)
        currentGame.forEach { (game) in
            context.delete(game)
            appDelegate.saveContext()
        }
        let currentBlockFetchRequest: NSFetchRequest<CurrentBlock> = CurrentBlock.fetchRequest()
        let currentBlock = try! context.fetch(currentBlockFetchRequest)
        currentBlock.forEach { (block) in
            context.delete(block)
            appDelegate.saveContext()
        }
    }
    
    @IBAction func menu(_ sender: UIButton) {
        if score > 0 {
            let context = appDelegate.persistentContainer.viewContext
            
            let currentGameFetchRequest: NSFetchRequest<CurrentGame> = CurrentGame.fetchRequest()
            let currentGame = try! context.fetch(currentGameFetchRequest)
            currentGame.forEach { (game) in
                context.delete(game)
                appDelegate.saveContext()
            }
            let currentBlockFetchRequest: NSFetchRequest<CurrentBlock> = CurrentBlock.fetchRequest()
            let currentBlock = try! context.fetch(currentBlockFetchRequest)
            currentBlock.forEach { (block) in
                context.delete(block)
                appDelegate.saveContext()
            }
            
            let newCurrentGame = CurrentGame(context: context)
            newCurrentGame.level = Int16(level)
            newCurrentGame.score = Int16(score)
            newCurrentGame.lives = Int16(live)
            
            for i in 0..<3 {
                for j in 0..<5 {
                    let newCurrentBlock = CurrentBlock(context: context)
                    newCurrentBlock.koorX = Int16(j)
                    newCurrentBlock.koorY = Int16(i)
                    newCurrentBlock.tag = Int16(arr[i][j].tag)
                }
            }
            appDelegate.saveContext()
        }
        let vc = storyboard?.instantiateViewController(withIdentifier: "start") as! ViewController
        navigationController?.pushViewController(vc, animated: false)
        dismiss(animated: false, completion: nil)
    }
    
}

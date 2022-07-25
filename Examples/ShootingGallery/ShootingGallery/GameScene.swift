//
//  GameScene.swift
//  ShootingGallery
//
//  Created by Jaime Yesid Leon Parada on 20/06/22.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var bulletsSprite: SKSpriteNode!
    var bulletTextures = [
        SKTexture(imageNamed: "shots0"),
        SKTexture(imageNamed: "shots1"),
        SKTexture(imageNamed: "shots2"),
        SKTexture(imageNamed: "shots3")
    ]
    
    var scoreLabel: SKLabelNode!
    var targetSpeed = 4.0
    var targetDelay = 0.8
    var targetsCreated = 0
    var isGameOver = false
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var bulletsInClip = 3 {
        didSet {
            bulletsSprite.texture = bulletTextures[bulletsInClip]
        }
    }
    
    //MARK - Override methods
    override func didMove(to view: SKView) {
        createBackground()
        createWater()
        createOverlay()
        levelUp()
    }
    
    override func mouseDown(with event: NSEvent) {
        if isGameOver {
            if let newGame = SKScene(fileNamed: "GameScene") {
                let transition = SKTransition.doorway(withDuration: 1)
                view?.presentScene(newGame, transition: transition)
            }
        } else {
            if bulletsInClip > 0 {
                run(SKAction.playSoundFileNamed("shot.wav", waitForCompletion: false))
                bulletsInClip -= 1
                
                let location = event.location(in: self)
                shot(at: location)
            } else {
                run(SKAction.playSoundFileNamed("empty.wav", waitForCompletion: false))
            }
        }
    }
    
    override func keyDown(with event: NSEvent) {
        guard isGameOver == false else { return }
        
        if event.charactersIgnoringModifiers == " " {
            run(SKAction.playSoundFileNamed("reload.wav", waitForCompletion: false))
            bulletsInClip = 3
            score -= 1
        }
    }
    
    // MARK -- Private functions
    
    private func createBackground(){
        let background = SKSpriteNode(imageNamed: "wood-background")
        background.position = CGPoint(x: 400, y: 300)
        background.blendMode = .replace
        addChild(background)
        
        let grass = SKSpriteNode(imageNamed: "grass-trees")
        grass.position = CGPoint(x: 400, y: 300)
        addChild(grass)
        grass.zPosition = 100
    }
    
    private func createWater(){
        func animate(_ node: SKNode, distance: Double, duration: TimeInterval){
            let movementUp = SKAction.moveBy(x: 0, y: distance, duration: duration)
            let movementDown = movementUp.reversed()
            let sequence = SKAction.sequence([movementUp, movementDown])
            let repeatForever = SKAction.repeatForever(sequence)
            
            node.run(repeatForever)
        }
        
        let waterBackground = SKSpriteNode(imageNamed: "water-bg")
        waterBackground.position = CGPoint(x: 400, y: 180)
        waterBackground.zPosition = 200
        addChild(waterBackground)
        
        let waterForeground = SKSpriteNode(imageNamed: "water-fg")
        waterForeground.position = CGPoint(x: 400, y: 120)
        waterForeground.zPosition = 300
        addChild(waterForeground)
        
        animate(waterBackground, distance: 8, duration: 1.3)
        animate(waterForeground, distance: 12, duration: 1)
    }
    
    private func createOverlay(){
        let curtains = SKSpriteNode(imageNamed: "curtains")
        curtains.position = CGPoint(x: 400, y: 300)
        curtains.zPosition = 400
        addChild(curtains)
        
        bulletsSprite = SKSpriteNode(imageNamed: "shots3")
        bulletsSprite.position = CGPoint(x: 170, y: 60)
        bulletsSprite.zPosition = 500
        addChild(bulletsSprite)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: 680, y: 50)
        scoreLabel.zPosition = 500
        scoreLabel.text = "Score 0"
        addChild(scoreLabel)
    }
    
    private func createTarget(){
        // Create and initialize our custom node
        let target = Target()
        target.setup()
        
        // decide where we want to place it in the game scene
        let level = Int.random(in: 0...2)
        // default to targets moving left to right
        var movingRight = true
        
        switch level {
        case 0:
            // in front of the grass
            target.zPosition = 150
            target.position.y = 280
            target.setScale(0.7)
        case 1:
            // in fron of the water background
            target.zPosition = 250
            target.position.y = 190
            target.setScale(0.85)
            movingRight = false
        default:
            // in front of the wateer foreground
            target.zPosition = 350
            target.position.y = 100
        }
        
        // now position thet target at the left or fight edge, moving it to the opposite edge.
        let move: SKAction
        
        if movingRight {
            target.position.x = 0
            move = SKAction.moveTo(x: 800, duration: targetSpeed)
        } else {
            target.position.x = 800
            // flip the target horizontally so it faces the direction of travel
            target.xScale = -target.xScale
            move = SKAction.moveTo(x: 0, duration: targetSpeed)
        }
        
        // Create a sequence that moves the target across the screen then removed it from the screen afterwards
        let sequence = SKAction.sequence([move, SKAction.removeFromParent()])
        
        // start the target moving, then add it to our game scene
        target.run(sequence)
        addChild(target)
        levelUp()
    }
    
    private func levelUp() {
        // make the game slightly harder
        targetSpeed *= 0.99
        targetDelay *= 0.99
        
        // update our target counter
        targetsCreated += 1
        
        if targetsCreated < 100 {
            // schedule another target to be created after `targetdelay` seconds have passed
            DispatchQueue.main.asyncAfter(deadline: .now() + targetDelay) {
                self.createTarget()
            }
        } else {
            // Game over
            DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                self.gameOver()
            }
        }
    }
    
    // MARK - Actions
    func shot(at location:CGPoint) {
        let hitNodes = nodes(at: location).filter { $0.name == "target"}
        guard let hitNode = hitNodes.first else { return }
        guard let parentNode = hitNode.parent as? Target else { return }
        
        parentNode.hit()
        
        score += 3
    }
    
    // MARK - Game Over
    func gameOver(){
        isGameOver = true
        
        let gameOverTitle = SKSpriteNode(imageNamed: "game-over")
        gameOverTitle.position = CGPoint(x: 400, y: 300)
        gameOverTitle.setScale(2)
        gameOverTitle.alpha = 0
        
        let fadeIn = SKAction.fadeIn(withDuration: 0.3)
        let scaleDown = SKAction.scale(to: 1, duration: 0.3)
        let group = SKAction.group([fadeIn, scaleDown])
        
        gameOverTitle.run(group)
        gameOverTitle.zPosition = 900
        addChild(gameOverTitle)
    }
}

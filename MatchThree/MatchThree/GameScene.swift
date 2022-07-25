//
//  GameScene.swift
//  MatchThree
//
//  Created by Jaime Yesid Leon Parada on 13/07/22.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    private var nextBall = GKShuffledDistribution(lowestValue: 0, highestValue: 3)
    private var cols = [[Ball]]()
    private var currentMatches = Set<Ball>()
    private var scoreLabel: SKLabelNode!
    private var timer: SKShapeNode!
    private var gameStartTime: TimeInterval = 0
    
    private var score = 0 {
        didSet {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            
            if let formattedScore = formatter.string(from: score as NSNumber) {
                scoreLabel.text = "Score: \(formattedScore)"
            }
        }
    }
    
    private let ballSize = 50.0
    private let ballsPerColumn = 10
    private let ballsPerRow = 14
    
    
    override func didMove(to view: SKView) {
        for x in 0..<ballsPerRow {
            var col = [Ball]()
            
            for y in 0..<ballsPerColumn {
                let ball = createBall(row: y, col: x)
                col.append(ball)
            }
            
            cols.append(col)
        }
        
        timer = SKShapeNode(rect: CGRect(x: 0, y: 0, width: 200, height: 40))
        timer.fillColor = NSColor.green
        timer.strokeColor = NSColor.clear
        
        scoreLabel = SKLabelNode(fontNamed: "HelveticaNeue")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.position = CGPoint(x: 55, y: frame.maxY - 55)
        addChild(scoreLabel)
        
        timer = SKShapeNode(rect: CGRect(x: 0, y: 0, width: 200, height: 40))
        timer.fillColor = .green
        timer.strokeColor = .clear
        timer.position = CGPoint(x: 545, y: 539)
        addChild(timer)
    }
    
    override func mouseDown(with event: NSEvent) {
        let location = event.location(in: self)
        
        guard let clickedBall = ball(at: location) else { return }
        
        isUserInteractionEnabled = false
        
        currentMatches.removeAll()
        match(ball: clickedBall)
        
        let sortedMatches = currentMatches.sorted {
            $0.row > $1.row
        }
        
        for match in sortedMatches {
            destroy(match)
        }
        
        // Move down any balls that need it
        for (columnIndex, col) in cols.enumerated() {
            for (rowIndex, ball) in col.enumerated() {
                ball.row = rowIndex
                
                let action = SKAction.move(to: position(for: ball), duration: 0.1)
                ball.run(action)
            }
            // Add new balls
            while cols[columnIndex].count < ballsPerColumn {
                let ball = createBall(row: cols[columnIndex].count, col: columnIndex, startOffScreen: true)
                cols[columnIndex].append(ball)
            }
        }
        
        let newScore = currentMatches.count
        
        if newScore == 1 {
            score -= 1000
        } else if newScore == 2 {
            // meh do nothing
        } else {
            let scoreToAdd = pow(2, Double(min(newScore, 16)))
            score += Int(scoreToAdd)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if gameStartTime == 0 {
            gameStartTime = currentTime
        }
        
        let elapsed = (currentTime - gameStartTime)
        let remaining = 100 - elapsed
        timer.xScale = max(0, Double(remaining) / 100)
    }
    
    private func position(for ball: Ball) -> CGPoint {
        let x = 72 + ballSize * Double(ball.col)
        let y = 50 + ballSize * Double(ball.row)
        
        return CGPoint(x: x, y: y)
    }
    
    private func createBall(row: Int, col: Int, startOffScreen: Bool = false) -> Ball {
        let ballImages = ["ballBlue", "ballGreen", "ballPurple", "ballRed"]
        let ballImage = ballImages[nextBall.nextInt()]
        
        let ball = Ball(imageNamed: ballImage)
        ball.row = row
        ball.col = col
        
        if startOffScreen {
            let finalPosition = position(for: ball)
            ball.position = finalPosition
            ball.position.y += 600
            
            let action = SKAction.move(to: finalPosition, duration: 0.4)
            ball.run(action) { [weak self] in
                self?.isUserInteractionEnabled = true
            }
        } else {
            ball.position = position(for: ball)
        }
        
        ball.name = ballImage
        addChild(ball)
        
        return ball
    }
    
    func ball(at point: CGPoint) -> Ball? {
        let balls = nodes(at: point).filter {
            $0.name?.hasPrefix("ball") ?? false
        }
        return balls.first as? Ball
        
//        let ballss = nodes(at: point).compactMap { $0 as? Ball }
//        return ballss.first
    }
    
    func match(ball originalBall: Ball) {
        var checkBalls = [Ball?]()
        currentMatches.insert(originalBall)
        
        let pos = originalBall.position
        
        checkBalls.append(ball(at: CGPoint(x: pos.x, y: pos.y - ballSize)))
        checkBalls.append(ball(at: CGPoint(x: pos.x, y: pos.y + ballSize)))
        checkBalls.append(ball(at: CGPoint(x: pos.x - ballSize, y: pos.y)))
        checkBalls.append(ball(at: CGPoint(x: pos.x + ballSize, y: pos.y)))
        
        for case let check? in checkBalls {
            if currentMatches.contains(check) { continue }
            if check.name == originalBall.name {
                match(ball: check)
            }
        }
    }
    
    func destroy(_ ball: Ball) {
        if let particles = SKEmitterNode(fileNamed: "FireParticle") {
            particles.position = ball.position
            addChild(particles)
            
            let wait = SKAction.wait(forDuration: TimeInterval(particles.particleLifetime))
            let sequence = SKAction.sequence([wait, SKAction.removeFromParent()])
            particles.run(sequence)
        }
        
        
        cols[ball.col].remove(at: ball.row)
        ball.removeFromParent()
    }
}
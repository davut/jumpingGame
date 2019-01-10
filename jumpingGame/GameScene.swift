//
//  GameScene.swift
//  jumpingGame
//
//  Created by djepbarov on 9.01.2019.
//  Copyright © 2019 Davut. All rights reserved.
//

import SpriteKit
import GameplayKit

let Ball1Category   : UInt32 = 0x1 << 0
let Ball2Category   : UInt32 = 0x1 << 1

private enum JumpState {
    case jumped
    case notJumped
}

private enum GameState {
    case ended
    case started
}


class GameScene: SKScene {
    private var ball1: Ball!
    private var ball2: Ball!
    private var ground: SKSpriteNode!
    private var scoreLabel: SKLabelNode!
    private var restartBtn: SKNode!
    private var score: Int = 0 {
        didSet {
            scoreLabel.text = "\(score)"
        }
    }
    private var gameState = GameState.started
    private var jumpState = JumpState.notJumped
    
    override func didMove(to view: SKView) {
        layout()
        guard gameState == .started else {return}
        moveBalls()
    }
    
    func moveBalls() {
        ball1.run(SKAction.repeatForever(SKAction.moveBy(x: 100, y: 0, duration: 0.5)))
        ball2.run(SKAction.repeatForever(SKAction.moveBy(x: -100, y: 0, duration: 0.5)))
    }
    
    func randomSize(for ball: Ball) {
        let random = CGFloat.random(in: 50...100)
        ball.size = CGSize(width: random, height: random)
        ball.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: random, height: random))
        if ball.name == "ball1" {
            ball1.physicsBody?.categoryBitMask = Ball1Category
            ball1.physicsBody?.contactTestBitMask = Ball2Category
            ball.position = CGPoint(x: -306, y: (-100))
        }
        else if ball.name == "ball2" {
            ball.position = CGPoint(x: 306, y: (-100))
            ball2.physicsBody?.categoryBitMask = Ball2Category
            ball2.physicsBody?.contactTestBitMask = Ball1Category
        }
        
        
    }
    
    func layout() {
        self.backgroundColor = .white
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        
        ball1 = Ball(color: .gray, size: CGSize(width: 50, height: 50))
        ball1.name = "ball1"
        randomSize(for: ball1)
        ball1.physicsBody?.affectedByGravity = true
        ball1.physicsBody?.isDynamic = true
        ball1.physicsBody?.mass = 5
        ball1.physicsBody?.linearDamping = 2
        addChild(ball1)
        
        ball2 = Ball(color: .red, size: CGSize(width: 50, height: 50))
        ball2.name = "ball2"
        randomSize(for: ball2)
        ball2.physicsBody?.affectedByGravity = true
        ball2.physicsBody?.isDynamic = true
        ball2.physicsBody?.mass = 5
        ball2.physicsBody?.linearDamping = 2
        addChild(ball2)
        
        ground = SKSpriteNode(color: #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1), size: CGSize(width: UIScreen.main.bounds.width * 2, height: self.frame.height / 2))
        ground.position = CGPoint(x:0, y:-((self.frame.height / 2) / 2) - 100 )
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: UIScreen.main.bounds.width * 2, height: self.frame.height / 2))
        ground.physicsBody?.affectedByGravity = false
        ground.physicsBody?.isDynamic = false
        addChild(ground)
        
        scoreLabel = SKLabelNode(text: "0")
        scoreLabel.fontSize = 100
        scoreLabel.color = .white
        ground.addChild(scoreLabel)
        
        restartBtn = SKSpriteNode(color: #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1), size: CGSize(width: 300, height: 100))
        restartBtn.name = "restart"
        restartBtn.position = CGPoint(x: 0, y: 0)
        restartBtn.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 300, height: 80))
        restartBtn.physicsBody?.isDynamic = false
        let restartLabel = SKLabelNode(text: "Restart")
        restartLabel.fontSize = 50
        restartBtn.addChild(restartLabel)
        
    }
    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    func jumpHigher(for higherBall: Ball, andLowerFor lowerBall: Ball, in x: CGFloat) {
        jumpState = .jumped
        if x < CGFloat(0) {
            if higherBall.name == "ball1"{
                ball1.run(SKAction.moveTo(y: 200, duration: 0.5))
                ball1.physicsBody?.applyImpulse(CGVector(dx: 50, dy: 4))
                score += 1
            }
            else {
                ball1.run(SKAction.moveTo(y: 20, duration: 0.5))
            }
        }
        else {
            if higherBall.name == "ball2" {
                ball2.run(SKAction.moveTo(y: 200, duration: 0.5))
                ball2.physicsBody?.applyImpulse(CGVector(dx: -50, dy: 4))
                score += 1
            }
            else {
                ball2.run(SKAction.moveTo(y: 20, duration: 0.5))
            }
            
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
        guard let touchPosition = touches.first?.location(in: self) else {return}
        print(touchPosition.x, touchPosition.y)
        if let body = physicsWorld.body(at: touchPosition) {
            if body.node!.name == "restart" {
                randomSize(for: ball1)
                randomSize(for: ball2)
                restartBtn.removeFromParent()
                score = 0
                gameState = .started
                moveBalls()
                return
            }
        }
        guard gameState == .started else {return}
        guard jumpState == .notJumped else {return}
        // Ball 1 is bigger
        if ball1 > ball2 {
            jumpHigher(for: ball1, andLowerFor: ball2, in: touchPosition.x)
        }
        // Ball 2 is bigger
        else if ball1 < ball2 {
            jumpHigher(for: ball2, andLowerFor: ball1, in: touchPosition.x)
        }
      
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        if !intersects(ball1) {
            jumpState = .notJumped
            randomSize(for: ball1)
            randomSize(for: ball2)
        }
        if !intersects(ball2) {
            jumpState = .notJumped
            randomSize(for: ball2)
            randomSize(for: ball1)
        }
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        guard gameState == .started else {return}
        if contact.bodyA.node?.name == "ball1" && contact.bodyB.node?.name == "ball2" {
            scoreLabel.text = "Game Over"
            addChild(restartBtn)
            ball1.removeAllActions()
            ball2.removeAllActions()
            gameState = .ended
            jumpState = .notJumped
        }
//        if contact.bodyA.node?.name == "ball2" && contact.bodyB.node?.name == "ball1" {
//            scoreLabel.text = "Game Over"
//            addChild(restartBtn)
//        }
    }
}

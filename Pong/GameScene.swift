//
//  GameScene.swift
//  Pong
//
//  Created by Marat Fatekhov on 15.01.2024.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var ball = SKSpriteNode()
    var enemy = SKSpriteNode()
    var main = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        ball = self.childNode(withName: "ball") as! SKSpriteNode
        enemy = self.childNode(withName: "enemy") as! SKSpriteNode
        main = self.childNode(withName: "main") as! SKSpriteNode
        
        ball.physicsBody?.applyImpulse(CGVector(dx: 50, dy: 50))
                
        // Add gesture recognizer
        let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        view.addGestureRecognizer(swipeGesture)
        
        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
        border.friction = 0
        border.restitution = 1
        self.physicsBody = border
    }
    
    @objc func handleSwipe(_ gestureRecognizer: UIPanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: view)
        
        switch gestureRecognizer.state {
        case .changed:
            // Move the node based on the swipe gesture
            main.position.x += translation.x
            gestureRecognizer.setTranslation(CGPoint.zero, in: view)
            
        default:
            break
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            // Check if the touch is on the targetNode
            if ball.contains(location) {
                applyForceToPlayer()
            }
        }
    }
    
    func applyForceToPlayer() {
        // Apply force to playerNode
        let newDx = -(ball.physicsBody?.velocity.dx)!
        let force = CGVector(dx: -(ball.physicsBody?.velocity.dx)!, dy: -(ball.physicsBody?.velocity.dy)!)
        ball.physicsBody?.applyForce(force)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        let moveAction = SKAction.moveTo(x: ball.position.x, duration: 1.0)
        enemy.run(moveAction)
    }
}

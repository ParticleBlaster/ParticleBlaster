//
//  GameScene.swift
//  ParticleBlaster
//
//  Created by Bohan Huang on 12/3/17.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private let player = SKSpriteNode(imageNamed: "player")
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.white
        player.position = CGPoint(x: size.width * 0.1, y: size.height * 0.5)
        addChild(player)
        
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(addMonster),
                SKAction.wait(forDuration: 1.0)
            ])
        ))
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    func addMonster() {
        
        // Create sprite
        let monster = SKSpriteNode(imageNamed: "monster")
        
        // Determine where to spawn the monster along the Y axis
        let actualY = random(min: monster.size.height/2, max: size.height - monster.size.height/2)
        
        // Position the monster slightly off-screen along the right edge,
        // and along a random position along the Y axis as calculated above
        monster.position = CGPoint(x: size.width + monster.size.width/2, y: actualY)
        
        // Add the monster to the scene
        addChild(monster)
        
        // Determine speed of the monster
        let actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))
        
        // Create the actions
        let actionMove = SKAction.move(to: CGPoint(x: -monster.size.width/2, y: actualY), duration: TimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        monster.run(SKAction.sequence([actionMove, actionMoveDone]))
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // Choose one of the touches to work with
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: self)
        
        // Set up initial location of projectile
        let projectile = SKSpriteNode(imageNamed: "projectile")
        projectile.position = player.position
        
        // Determine offset of location to projectile
        let offset = touchLocation - projectile.position
        
        // Bail out if shooting down or backwards
        if (offset.x < 0) { return }
        
        // Add the projectile after double checked position
        addChild(projectile)
        
        // Get the direction of where to shoot
        let direction = offset.normalized()
        
        // Make it shoot far enough to be guaranteed off screen
        let shootAmount = direction * 1000
        
        // Add the shoot amount to the current position
        let realDest = shootAmount + projectile.position
        
        // Create the actions
        let actionMove = SKAction.move(to: realDest, duration: 2.0)
        let actionMoveDone = SKAction.removeFromParent()
        projectile.run(SKAction.sequence([actionMove, actionMoveDone]))
        
    }
}

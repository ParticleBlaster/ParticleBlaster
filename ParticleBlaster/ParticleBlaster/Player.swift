//
//  Player.swift
//  ParticleBlaster
//
//  Created by Richard Jiang on 21/03/17.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

import SpriteKit

class Player : GameObject {
    init(image: String) {
        super.init(imageName: image)
        setupPhysicsProperty()
    }
    
    init() {
        super.init(imageName: "Spaceship")
        setupPhysicsProperty()
    }
    
    func updateRotation(newAngle: CGFloat) {
        self.shape.zRotation = newAngle
    }
    
    func hitByObstacle() {
        self.timeToLive -= 1
    }
    
    func checkDead() -> Bool {
        if self.timeToLive == 0 {
            return true
        } else {
            return false
        }
    }

    func setupPhysicsProperty() {
        self.shape.size = CGSize(width: Constants.playerWidth, height: Constants.playerHeight)
        self.shape.physicsBody = SKPhysicsBody(texture: self.shape.texture!, size: self.shape.size)
        self.shape.physicsBody?.isDynamic = true
        self.shape.physicsBody?.categoryBitMask = PhysicsCategory.Player
        self.shape.physicsBody?.contactTestBitMask = PhysicsCategory.Obstacle | PhysicsCategory.Map
        self.shape.physicsBody?.collisionBitMask = PhysicsCategory.Map | PhysicsCategory.Obstacle | PhysicsCategory.Player
        self.shape.physicsBody?.mass = 0
    }
}

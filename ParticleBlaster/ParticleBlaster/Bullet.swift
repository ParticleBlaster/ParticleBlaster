//
//  Bullet.swift
//  ParticleBlaster
//
//  Created by Richard Jiang on 23/03/17.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

import SpriteKit

class Bullet : GameObject {
    
    init(image: String) {
        super.init(imageName: image)
        setupPhysicsProperty()
    }
    
    init() {
        super.init(imageName: "bullet-blue")
        setupPhysicsProperty()
    }
    
    
    private func setupPhysicsProperty() {
        self.shape.size = CGSize(width: Constants.defaultBulletRadius, height: Constants.defaultBulletRadius)
        self.shape.physicsBody = SKPhysicsBody(circleOfRadius: Constants.defaultBulletRadius)
        self.shape.physicsBody?.isDynamic = true
        self.shape.physicsBody?.categoryBitMask = PhysicsCategory.Bullet
        self.shape.physicsBody?.contactTestBitMask = PhysicsCategory.Obstacle | PhysicsCategory.Player
        self.shape.physicsBody?.collisionBitMask = PhysicsCategory.None //PhysicsCategory.Obstacle
        self.shape.physicsBody?.usesPreciseCollisionDetection = true
    }
}

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
    
    override init() {
        super.init(imageName: "bullet-blue")
        setupPhysicsProperty()
    }
    
    required convenience init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupPhysicsProperty() {
        self.shape.size = CGSize(width: Constants.defaultBulletRadius * 2, height: Constants.defaultBulletRadius * 2)
        self.shape.physicsBody = SKPhysicsBody(circleOfRadius: Constants.defaultBulletRadius)
        self.shape.physicsBody?.isDynamic = true
        self.shape.physicsBody?.categoryBitMask = PhysicsCategory.Bullet
        self.shape.physicsBody?.contactTestBitMask = PhysicsCategory.Obstacle | PhysicsCategory.Player
        self.shape.physicsBody?.collisionBitMask = PhysicsCategory.None //PhysicsCategory.Obstacle
        self.shape.physicsBody?.usesPreciseCollisionDetection = true
    }
}

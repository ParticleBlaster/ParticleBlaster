//
//  ATField.swift
//  ParticleBlaster
//
//  Created by Bohan Huang on 8/4/17.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

import Foundation
import SpriteKit

class ATField : GameObject {
    
    init(image: String) {
        super.init(imageName: image)
        setupPhysicsProperty()
    }
    
    init() {
        super.init(imageName: "ATField")
        setupPhysicsProperty()
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

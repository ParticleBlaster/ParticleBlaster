//
//  Grenade.swift
//  ParticleBlaster
//
//  Created by Richard Jiang on 06/04/17.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

import UIKit
import SpriteKit

class Grenade : GameObject {
    var exploded: Bool = false
    
    init(image: String) {
        super.init(imageName: image)
        setupPhysicsProperty()
    }
    
    init() {
        super.init(imageName: "bullet-orange")
        setupPhysicsProperty()
    }
    
    private func setupPhysicsProperty() {
        self.shape.size = CGSize(width: Constants.grenadeRadius * 2, height: Constants.grenadeRadius * 2)
        self.shape.physicsBody = SKPhysicsBody(circleOfRadius: Constants.grenadeRadius)
        self.shape.physicsBody?.isDynamic = true
        self.shape.physicsBody?.categoryBitMask = PhysicsCategory.Bullet
        self.shape.physicsBody?.contactTestBitMask = PhysicsCategory.Obstacle | PhysicsCategory.Player
        self.shape.physicsBody?.collisionBitMask = PhysicsCategory.None //PhysicsCategory.Obstacle
        self.shape.physicsBody?.usesPreciseCollisionDetection = true
    }
    
    func explode() {
        if !self.exploded {
            self.shape.physicsBody?.velocity = CGVector.zero
            let currCenter = self.shape.position
            self.shape = SKSpriteNode(imageNamed: "bullet-red") // TODO: should be named as explodedGrenade
            self.shape.size = CGSize(width: Constants.grenadeRadius, height: Constants.grenadeRadius)
            self.shape.position = currCenter
            
        }
    }
}

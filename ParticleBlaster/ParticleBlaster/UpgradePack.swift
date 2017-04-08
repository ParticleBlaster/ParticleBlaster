//
//  UpgradePack.swift
//  ParticleBlaster
//
//  Created by Richard Jiang on 08/04/17.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

import UIKit
import SpriteKit

class UpgradePack : GameObject {
    
    init(image: String) {
        super.init(imageName: image)
        setupPhysicsProperty()
    }
    
    init() {
        super.init(imageName: "bullet-green")
        setupPhysicsProperty()
    }
    
    
    private func setupPhysicsProperty() {
        self.shape.size = CGSize(width: Constants.upgradePackRadius * 2, height: Constants.upgradePackRadius * 2)
        self.shape.physicsBody = SKPhysicsBody(circleOfRadius: Constants.upgradePackRadius)
        self.shape.physicsBody?.isDynamic = true
        self.shape.physicsBody?.categoryBitMask = PhysicsCategory.Upgrade
        self.shape.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        self.shape.physicsBody?.collisionBitMask = PhysicsCategory.Obstacle //PhysicsCategory.Obstacle
        //self.shape.physicsBody?.usesPreciseCollisionDetection = true
    }
}

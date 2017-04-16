//
//  UpgradePack.swift
//  ParticleBlaster
//
//  Created by Richard Jiang on 08/04/17.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

/**
 *  The `UpgradePack` class is the model for weapon upgrade pack
 */

import UIKit
import SpriteKit

class UpgradePack : GameObject {
    
    override init() {
        super.init(imageName: Constants.defaultUpgradePackSpriteFilename, timeToLive: Constants.defaultTimeToLive)
        setupPhysicsProperty()
    }
    
    required convenience init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupPhysicsProperty() {
        self.shape.size = CGSize(width: Constants.upgradePackRadius * 2, height: Constants.upgradePackRadius * 2)
        self.shape.physicsBody = SKPhysicsBody(circleOfRadius: Constants.upgradePackRadius)
        self.shape.physicsBody?.isDynamic = true
        self.shape.physicsBody?.categoryBitMask = PhysicsCategory.Upgrade
        self.shape.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        self.shape.physicsBody?.collisionBitMask = PhysicsCategory.Obstacle
    }
}

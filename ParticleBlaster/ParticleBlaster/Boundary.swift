//
//  Boundary.swift
//  ParticleBlaster
//
//  Created by Bui Hiep on 7/4/17.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

import SpriteKit

class Boundary: SKNode {
    init(rect: CGRect) {
        super.init()
        physicsBody = SKPhysicsBody(edgeLoopFrom: rect)
        physicsBody?.isDynamic = false
        physicsBody?.categoryBitMask = PhysicsCategory.Map
        physicsBody?.contactTestBitMask = PhysicsCategory.All
        physicsBody?.collisionBitMask = PhysicsCategory.None
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

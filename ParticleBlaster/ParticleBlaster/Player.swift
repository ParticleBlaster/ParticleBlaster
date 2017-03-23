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
    }
    
    init() {
        super.init(imageName: "Spaceship")
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
    
}

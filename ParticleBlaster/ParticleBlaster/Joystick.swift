//
//  Joystick.swift
//  ParticleBlaster
//
//  Created by Richard Jiang on 21/03/17.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

import SpriteKit

class Joystick : GameObject {
    init(image: String) {
        super.init(imageName: image)
    }
    
    init() {
        super.init(imageName: "top")
    }
    
    func releaseJoystick() {
        self.shape.run(SKAction.move(to: CGPoint(x: Constants.joystickPlateCenterX, y: Constants.joystickPlateCenterY), duration: 0.2))
    }
    
}

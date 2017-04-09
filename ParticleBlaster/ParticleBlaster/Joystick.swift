//
//  Joystick.swift
//  ParticleBlaster
//
//  Created by Richard Jiang on 21/03/17.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

import SpriteKit

class Joystick : GameObject {
    var joystickPlateCenterX: CGFloat?
    var joystickPlateCenterY: CGFloat?
    
    init(image: String) {
        self.joystickPlateCenterX = nil
        self.joystickPlateCenterY = nil
        super.init(imageName: image)
    }
    
    override init() {
        self.joystickPlateCenterX = nil
        self.joystickPlateCenterY = nil
        super.init(imageName: "top")
    }
    
    required convenience init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func releaseJoystick() {
        self.shape.run(SKAction.move(to: CGPoint(x: joystickPlateCenterX!, y: joystickPlateCenterY!), duration: 0.2))
    }
    
    func updateJoystickPlateCenterPosition(x: CGFloat, y: CGFloat) {
        self.joystickPlateCenterX = x
        self.joystickPlateCenterY = y
    }
}

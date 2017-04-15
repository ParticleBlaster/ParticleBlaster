//
//  Joystick.swift
//  ParticleBlaster
//
//  Created by Richard Jiang on 21/03/17.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

import SpriteKit

class Joystick : GameObject {
    var joystickPlateCenter: CGPoint?
    
    init(image: String) {
        self.joystickPlateCenter = nil
        super.init(imageName: image)
    }
    
    override init() {
        self.joystickPlateCenter = nil
        super.init(imageName: "top")
        //self.shape.alpha = 0.5
    }
    
    required convenience init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func releaseJoystick() {
        self.shape.run(SKAction.move(to: self.joystickPlateCenter!, duration: 0.2))
    }
    
    func initializeJoystick(position: CGPoint) {
        self.shape.size = CGSize(width: Constants.joystickPlateWidth / 2, height: Constants.joystickPlateHeight / 2)
        // Note: position is given as center position already
        self.shape.position = position
        self.shape.alpha = Constants.joystickAlpha
        self.joystickPlateCenter = position
        self.shape.zPosition = Constants.defaultJoystickZPosition
    }
}

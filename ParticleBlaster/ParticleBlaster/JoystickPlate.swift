//
//  JoystickPlate.swift
//  ParticleBlaster
//
//  Created by Richard Jiang on 21/03/17.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

/**
 *  The `JoystickPlate` defines the plate part of the joystick
 *
 *  The representation invariants:
 *      - It should be a static game object
 */

import SpriteKit

class JoystickPlate : GameObject {
    init(image: String) {
        super.init(imageName: image)
        _checkRep()
    }
    
    override init() {
        super.init(imageName: "plate")
        _checkRep()
    }
    
    required convenience init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initializeJoystickPlate(position: CGPoint) {
        _checkRep()
        self.shape.position = position
        self.shape.size = CGSize(width: Constants.joystickPlateWidth, height: Constants.joystickPlateHeight)
        self.shape.zPosition = Constants.defaultJoystickPlateZPosition
        _checkRep()
    }
 
    // A valid JoystickPlate should be a static game object
    private func _checkRep() {
        assert(self.isStatic == true, "Should be a static game object.")
    }
}

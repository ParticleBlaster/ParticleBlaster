//
//  Joystick.swift
//  ParticleBlaster
//
//  Created by Richard Jiang on 21/03/17.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

/**
 *  The `Joystick` defines the top part of the joystick
 *
 *  The representation invariants:
 *      - It should be a static game object
 */

import SpriteKit

class Joystick : GameObject {
    var joystickPlateCenter: CGPoint?
    
    init(image: String) {
        self.joystickPlateCenter = nil
        super.init(imageName: image)
        _checkRep()
    }
    
    override init() {
        self.joystickPlateCenter = nil
        super.init(imageName: "top")
        _checkRep()
    }
    
    required convenience init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func releaseJoystick() {
        _checkRep()
        self.shape.run(SKAction.move(to: self.joystickPlateCenter!, duration: 0.2))
        _checkRep()
    }
    
    func initializeJoystick(position: CGPoint) {
        _checkRep()
        self.shape.size = CGSize(width: Constants.joystickPlateWidth / 2, height: Constants.joystickPlateHeight / 2)
        self.shape.position = position
        self.shape.alpha = Constants.joystickAlpha
        self.joystickPlateCenter = position
        self.shape.zPosition = Constants.defaultJoystickZPosition
        _checkRep()
    }
    
    // A valid Joystick should be a static game object
    private func _checkRep() {
        assert(self.isStatic == true, "Should be a static game object.")
    }
}

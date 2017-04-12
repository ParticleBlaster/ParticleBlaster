//
//  JoystickPlate.swift
//  ParticleBlaster
//
//  Created by Richard Jiang on 21/03/17.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

import SpriteKit

class JoystickPlate : GameObject {
    init(image: String) {
        super.init(imageName: image)
    }
    
    override init() {
        super.init(imageName: "plate")
    }
    
    required convenience init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initializeJoystickPlate(position: CGPoint) {
        self.shape.position = position
        self.shape.size = CGSize(width: Constants.joystickPlateWidth, height: Constants.joystickPlateHeight)
        self.shape.zPosition = Constants.defaultJoystickPlateZPosition
    }
    
}

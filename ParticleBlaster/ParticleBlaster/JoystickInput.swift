//
//  JoystickInput.swift
//  ParticleBlaster
//
//  Created by Richthofen on 16/03/2017.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

import UIKit
import SpriteKit

class JoystickInput {
    var direction: CGVector
    var isFired: Bool
    
    init(direction: CGVector, isFired: Bool) {
        self.direction = direction
        self.isFired = isFired
    }
}

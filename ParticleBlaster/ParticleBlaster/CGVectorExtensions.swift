//
//  CGVectorExtensions.swift
//  ParticleBlaster
//
//  Created by Richard Jiang on 22/03/17.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

import UIKit

extension CGVector {
    func length() -> CGFloat {
        return sqrt((self.dx * self.dx) + (self.dy * self.dy))
    }
    
    func normalized() -> CGVector {
        return CGVector(dx: self.dx / length(), dy: self.dy / length())
    }

    // Define right as the orthonormal direction
    func orthonormalVector() -> CGVector {
        return CGVector(dx: self.dy, dy: -self.dx).normalized()
    }

    func normalizeJoystickDirection() -> CGVector{
        let dx = self.dx * Constants.joystickWidth / 2
        let dy = self.dy * Constants.joystickHeight / 2
        return CGVector(dx: dx, dy: dy)
    }
}

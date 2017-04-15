//
//  SinglePlayerViewParams.swift
//  ParticleBlaster
//
//  Created by Bohan Huang on 30/3/17.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

/**
 *  The `SinglePlayerViewParams` class defines the view parameters used to positioning nodes in singleplayer mode
 */

import SpriteKit

class SinglePlayerViewParams {
    static var joystickPlateCenter: CGPoint!
    static var fireButtonCenter: CGPoint!
    
    static var playerCenter: CGPoint!
    
    static func initializeJoystickInfo(viewSize: CGSize) {
        self.joystickPlateCenter = CGPoint(x: viewSize.width * 0.15, y: viewSize.height * 0.17)
        self.fireButtonCenter = CGPoint(x: viewSize.width * 0.85, y: viewSize.height * 0.17)
        self.playerCenter = CGPoint(x: viewSize.width * 0.1,y: viewSize.height * 0.5)
    }
}

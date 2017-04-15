//
//  ViewParams.swift
//  ParticleBlaster
//
//  Created by Bohan Huang on 29/3/17.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

/**
 *  The `MultiplayerViewParams` class defines the view parameters used to positioning nodes in multiplayer mode
 */

import SpriteKit

class MultiPlayerViewParams {
    static var playerCenter1: CGPoint!
    static var joystickPlateCenter1: CGPoint!
    static var fireButtonCenter1: CGPoint!
    
    static var playerCenter2: CGPoint!
    static var joystickPlateCenter2: CGPoint!
    static var fireButtonCenter2: CGPoint!

    static func initializeJoystickInfo(viewSize: CGSize) {
        self.playerCenter1 = CGPoint(x: viewSize.width * 0.1, y: viewSize.height * 0.5)
        self.joystickPlateCenter1 = CGPoint(x: viewSize.width * 0.1, y: viewSize.height * 0.9)
        self.fireButtonCenter1 = CGPoint(x: viewSize.width * 0.1, y: viewSize.height * 0.1)

        self.playerCenter2 = CGPoint(x: viewSize.width * 0.9, y: viewSize.height * 0.5)
        self.joystickPlateCenter2 = CGPoint(x: viewSize.width * 0.9, y: viewSize.height * 0.1)
        self.fireButtonCenter2 = CGPoint(x: viewSize.width * 0.9, y: viewSize.height * 0.9)
    }
}

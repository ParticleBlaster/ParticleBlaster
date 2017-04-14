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
    static let playerWidth: CGFloat = CGFloat(50)
    static let playerHeight: CGFloat = CGFloat(50)
    static let playerRadius: CGFloat = CGFloat(22)
    
    static var joystickPlateWidth: CGFloat!
    static var joystickPlateHeight: CGFloat!
    
    static var joystickWidth: CGFloat!
    static var joystickHeight: CGFloat!
    
    static var fireButtonWidth: CGFloat!
    static var fireButtonHeight: CGFloat!
    
    static var playerCenter1: CGPoint!
    static var joystickPlateCenter1: CGPoint!
    static var fireButtonCenter1: CGPoint!
    
    static var playerCenter2: CGPoint!
    static var joystickPlateCenter2: CGPoint!
    static var fireButtonCenter2: CGPoint!

    static func initializeJoystickInfo(viewSize: CGSize) {
        self.joystickPlateWidth = viewSize.width / 16
        self.joystickPlateHeight = viewSize.width / 16
        self.joystickWidth = self.joystickPlateWidth / 2
        self.joystickHeight = self.joystickPlateHeight / 2
        self.fireButtonWidth = self.joystickPlateWidth
        self.fireButtonHeight = self.joystickPlateHeight
        
        self.playerCenter1 = CGPoint(x: viewSize.width * 0.1, y: viewSize.height * 0.5)
        self.joystickPlateCenter1 = CGPoint(x: viewSize.width * 0.1, y: viewSize.height * 0.1)
        self.fireButtonCenter1 = CGPoint(x: viewSize.width * 0.1, y: viewSize.height * 0.9)
        
        self.playerCenter2 = CGPoint(x: viewSize.width * 0.9, y: viewSize.height * 0.5)
        self.joystickPlateCenter2 = CGPoint(x: viewSize.width * 0.9, y: viewSize.height * 0.9)
        self.fireButtonCenter2 = CGPoint(x: viewSize.width * 0.9, y: viewSize.height * 0.1)
    }
}

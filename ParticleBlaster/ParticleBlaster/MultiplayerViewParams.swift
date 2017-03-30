//
//  ViewParams.swift
//  ParticleBlaster
//
//  Created by Bohan Huang on 29/3/17.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

import SpriteKit

class MultiplayerViewParams {
    static let playerWidth: CGFloat = CGFloat(50)
    static let playerHeight: CGFloat = CGFloat(50)
    static let playerRadius: CGFloat = CGFloat(22)
    
    static var joystickPlateWidth: CGFloat!
    static var joystickPlateHeight: CGFloat!
    
    static var joystickWidth: CGFloat!
    static var joystickHeight: CGFloat!
    
    static var fireButtonWidth: CGFloat!
    static var fireButtonHeight: CGFloat!
    
    static var playerCenterX1: CGFloat!
    static var playerCenterY1: CGFloat!
    static var joystickPlateCenterX1: CGFloat!
    static var joystickPlateCenterY1: CGFloat!
    static var fireButtonCenterX1: CGFloat!
    static var fireButtonCenterY1: CGFloat!
    
    static var playerCenterX2: CGFloat!
    static var playerCenterY2: CGFloat!
    static var joystickPlateCenterX2: CGFloat!
    static var joystickPlateCenterY2: CGFloat!
    static var fireButtonCenterX2: CGFloat!
    static var fireButtonCenterY2: CGFloat!

    static func initializeJoystickInfo(viewSize: CGSize) {
        self.joystickPlateWidth = viewSize.width / 16
        self.joystickPlateHeight = viewSize.width / 16
        self.joystickWidth = self.joystickPlateWidth / 2
        self.joystickHeight = self.joystickPlateHeight / 2
        self.fireButtonWidth = self.joystickPlateWidth
        self.fireButtonHeight = self.joystickPlateHeight
        
        self.playerCenterX1 = viewSize.width * 0.1
        self.playerCenterY1 = viewSize.height * 0.5
        
        self.joystickPlateCenterX1 = viewSize.width * 0.1
        self.joystickPlateCenterY1 = viewSize.height * 0.1
        
        self.fireButtonCenterX1 = viewSize.width * 0.1
        self.fireButtonCenterY1 = viewSize.height * 0.9
       
        self.playerCenterX2 = viewSize.width * 0.9
        self.playerCenterY2 = viewSize.height * 0.5
        
        self.joystickPlateCenterX2 = viewSize.width * 0.9
        self.joystickPlateCenterY2 = viewSize.height * 0.9
        
        self.fireButtonCenterX2 = viewSize.width * 0.9
        self.fireButtonCenterY2 = viewSize.height * 0.1
        
    }
}

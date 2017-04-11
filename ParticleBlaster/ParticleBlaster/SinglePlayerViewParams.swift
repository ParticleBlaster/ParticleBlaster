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

class SingleplayerViewParams {
    static let playerWidth: CGFloat = CGFloat(50)
    static let playerHeight: CGFloat = CGFloat(50)
    static let playerRadius: CGFloat = CGFloat(22)
    
    // Game Scene Constants
    static var joystickPlateWidth: CGFloat!
    static var joystickPlateHeight: CGFloat!
    static var joystickPlateCenterX: CGFloat!
    static var joystickPlateCenterY: CGFloat!
    static var joystickWidth: CGFloat!
    static var joystickHeight: CGFloat!
    static var fireButtonCenterX: CGFloat!
    static var fireButtonCenterY: CGFloat!
    static var fireButtonWidth: CGFloat!
    static var fireButtonHeight: CGFloat!
    
    // TODO: consider changing all CGPointX and CGPointY to be CGPoint
    static var playerCenterX: CGFloat!
    static var playerCenterY: CGFloat!
    
    static var obstacle1CenterX: CGFloat!
    static var obstacle1CenterY: CGFloat!
    static var obstacle2CenterX: CGFloat!
    static var obstacle2CenterY: CGFloat!
    
    static var defaultMultiObs1Center: CGPoint!
    static var defaultMultiObs2Center: CGPoint!
    
    static let obstacleWidth: CGFloat = CGFloat(75)
    static let obstacleHeight: CGFloat = CGFloat(75)
    
    static func initializeJoystickInfo(viewSize: CGSize) {
        self.joystickPlateWidth = viewSize.width / 8
        self.joystickPlateHeight = viewSize.width / 8
        self.joystickPlateCenterX = viewSize.width * 0.15
        self.joystickPlateCenterY = viewSize.height * 0.17
        self.joystickWidth = self.joystickPlateWidth / 2
        self.joystickHeight = self.joystickPlateHeight / 2
        self.fireButtonCenterX = viewSize.width * 0.85
        self.fireButtonCenterY = viewSize.height * 0.17
        self.fireButtonWidth = self.joystickWidth * 1.5
        self.fireButtonHeight = self.joystickHeight * 1.5
        
        self.playerCenterX = viewSize.width * 0.1
        self.playerCenterY = viewSize.height * 0.5
        
        self.obstacle1CenterX = viewSize.width * 0.9
        self.obstacle1CenterY = viewSize.height * 0.8
        self.obstacle2CenterX = viewSize.width * 0.9
        self.obstacle2CenterY = viewSize.height * 0.2
        
        self.defaultMultiObs1Center = CGPoint(x: viewSize.width * 0.5, y: viewSize.height * 0.8)
        self.defaultMultiObs2Center = CGPoint(x: viewSize.width * 0.5, y: viewSize.height * 0.2)
        
        // self.viewCentralPoint = CGPoint(x: viewSize.width * 0.5, y: viewSize.height * 0.5)
    }
}

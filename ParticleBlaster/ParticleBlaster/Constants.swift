//
//  Constants.swift
//  ParticleBlaster
//
//  Created by Bohan Huang on 12/3/17.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

import SpriteKit

class Constants {
    static let backgroundColor = SKColor.white
    static let TITLE_FONT = "FinalFrontierOldStyle"
    
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
    
    static var playerCenterX: CGFloat!
    static var playerCenterY: CGFloat!
    static let playerWidth: CGFloat = CGFloat(50)
    static let playerHeight: CGFloat = CGFloat(50)
    
    static var obstacle1CenterX: CGFloat!
    static var obstacle1CenterY: CGFloat!
    static var obstacle2CenterX: CGFloat!
    static var obstacle2CenterY: CGFloat!
    
    static let obstacleWidth: CGFloat = CGFloat(75)
    static let obstacleHeight: CGFloat = CGFloat(75)
    
    static let defaultBulletWidth: CGFloat = CGFloat(8)
    static let defaultBulletHeight: CGFloat = CGFloat(64)
    
    static func initializeJoystickInfo(viewSize: CGSize) {
        self.joystickPlateWidth = viewSize.width / 8
        self.joystickPlateHeight = viewSize.width / 8
        self.joystickPlateCenterX = viewSize.width * 0.1
        self.joystickPlateCenterY = viewSize.height * 0.1
        self.joystickWidth = self.joystickPlateWidth / 2
        self.joystickHeight = self.joystickPlateHeight / 2
        self.fireButtonCenterX = viewSize.width * 0.9
        self.fireButtonCenterY = viewSize.height * 0.1
        self.fireButtonWidth = self.joystickPlateWidth
        self.fireButtonHeight = self.joystickPlateHeight
        
        self.playerCenterX = viewSize.width * 0.1
        self.playerCenterY = viewSize.height * 0.5
        
        self.obstacle1CenterX = viewSize.width * 0.95
        self.obstacle1CenterY = viewSize.height * 0.8
        self.obstacle2CenterX = viewSize.width * 0.95
        self.obstacle2CenterY = viewSize.height * 0.2
    }
    
    // Game Static Constants
    static let playerVelocity: CGFloat = CGFloat(500)
    static let obstacleVelocity: CGFloat = CGFloat(100)
    static let bulletVelocity: CGFloat = CGFloat(1000)
    
    // Score Related Constants
    static let defaultScoreDivider: Float = 500
    
    // Physics Related Constants
    static let defaultTimeToLive: Int = 10
    static let playerTimeToLive: Int = 1
}

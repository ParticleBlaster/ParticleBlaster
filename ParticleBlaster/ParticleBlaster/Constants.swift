//
//  Constants.swift
//  ParticleBlaster
//
//  Created by Bohan Huang on 12/3/17.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

import Foundation
import SpriteKit

class Constants {
    static let backgroundColor = SKColor.white
    static let TITLE_FONT = "FinalFrontierOldStyle"
    
    // Game Constants
    static var joystickPlateWidth: CGFloat!
    static var joystickPlateHeight: CGFloat!
    static var joystickPlateCenterX: CGFloat!
    static var joystickPlateCenterY: CGFloat!
    static var joystickWidth: CGFloat!
    static var joystickHeight: CGFloat!
    
    static func initializeJoystickInfo(viewSize: CGSize) {
        self.joystickPlateWidth = viewSize.width / 8
        self.joystickPlateHeight = viewSize.width / 8
        self.joystickPlateCenterX = viewSize.width * 0.1
        self.joystickPlateCenterY = viewSize.height * 0.1
        self.joystickWidth = self.joystickPlateWidth / 2
        self.joystickHeight = self.joystickPlateHeight / 2
    }
    
    // Game Static Constants
    static let playerVelocity: CGFloat = CGFloat(400)
}

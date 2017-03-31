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
    static let playerRadius: CGFloat = CGFloat(22)
    
    static var obstacle1CenterX: CGFloat!
    static var obstacle1CenterY: CGFloat!
    static var obstacle2CenterX: CGFloat!
    static var obstacle2CenterY: CGFloat!
    
    static let obstacleWidth: CGFloat = CGFloat(75)
    static let obstacleHeight: CGFloat = CGFloat(75)
    
    static let defaultBulletRadius: CGFloat = CGFloat(16)
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
        
        self.obstacle1CenterX = viewSize.width * 0.9
        self.obstacle1CenterY = viewSize.height * 0.8
        self.obstacle2CenterX = viewSize.width * 0.9
        self.obstacle2CenterY = viewSize.height * 0.2
    }
    
    // Game Static Constants
    static let playerVelocity: CGFloat = CGFloat(300)
    static let obstacleVelocity: CGFloat = CGFloat(100)
    static let bulletVelocity: CGFloat = CGFloat(1000)
    
    // Score Related Constants
    static let defaultScoreDivider: Float = 500
    static let scoreDisplayOffset: CGFloat = CGFloat(15)
    
    // Physics Related Constants
    static let defaultTimeToLive: Int = 10
    static let playerTimeToLive: Int = 1
    
    static let obstacleImpulseValue: CGFloat = CGFloat(1500)
    static let obstacleForceValue: CGFloat = CGFloat(10)
    static let playerForceValue: CGFloat = CGFloat(50)
    
    static let obstacleMass: CGFloat = CGFloat(20)
    static let playerMass: CGFloat = CGFloat(10)
    
    static let destroyObstacleScoreFont = "Papyrus"
    static let destroyObstacleScoreFontSize = CGFloat(25)
    static let destroyObstacleScoreOffset = CGVector(dx: 0, dy: 5)
    static let destroyObstacleScoreFadeTime = 0.5
    //static let destroyObstacleScore
    
    enum gameMode {
        case single
        case multi
    }

    // Homepage Constants
    static let backgroundImage: UIImage = #imageLiteral(resourceName: "homepage")
    
    // Star Wars Theme Obstacles
    static let starwarsBB8 = Obstacle(image: "starwars-bb8", userSetInitialPosition: defaultPosition)
    static let starwarsBountyHunter = Obstacle(image: "starwars-bountyhunter", userSetInitialPosition: defaultPosition)
    static let starwarsC3PO = Obstacle(image: "starwars-c3po", userSetInitialPosition: defaultPosition)
    static let starwarsDarthVader = Obstacle(image: "starwars-darthvadar", userSetInitialPosition: defaultPosition)
    static let starwarsPrincess = Obstacle(image: "starwars-princess", userSetInitialPosition: defaultPosition)
    static let starwarsR2D2 = Obstacle(image: "starwars-r2d2", userSetInitialPosition: defaultPosition)
    static let starwarsSith = Obstacle(image: "starwars-sith", userSetInitialPosition: defaultPosition)
    static let starwarsThunderTrooper = Obstacle(image: "starwars-thundertrooper", userSetInitialPosition: defaultPosition)
    
    static let starwarsObstacles = [starwarsBB8,
                                    starwarsBountyHunter,
                                    starwarsC3PO,
                                    starwarsDarthVader,
                                    starwarsPrincess,
                                    starwarsR2D2,
                                    starwarsSith,
                                    starwarsThunderTrooper]
    
    static let defaultPosition: CGPoint = CGPoint(x: 0, y: 0)
    static let levelObstacleStandardWidth: CGFloat = 50
    static func getHeightWithSameRatio(withWidth: CGFloat, forShape: SKSpriteNode) -> CGFloat {
        return forShape.size.height / forShape.size.width * withWidth
    }
    
    // Border Constants
    static let cornerRadius: CGFloat = 10
    
    static let strokeSmall: CGFloat = 3
    static let strokeMedium: CGFloat = 5
    static let strokeLarge: CGFloat = 7
    
    // Font Constants
    static let titleFont = "FinalFrontierOldStyle"
    static let fontSizeSmall: CGFloat = 20
    static let fontSizeMedium: CGFloat = 40
    static let fontSizeLarge: CGFloat = 80
    static let fontSizeLargeX: CGFloat = 120
    
    // Level Designer Constants
    static let levelScreenRatio: CGFloat = 0.7
    static let screenBorderMarginRatio: CGFloat = 0.005
    static let screenBorderOriginRatio: CGFloat = 0.25
    static let screenBorderSizeRatio: CGFloat = levelScreenRatio + screenBorderMarginRatio * 2
    static let screenCenterPositionRatio: CGFloat = screenBorderOriginRatio + levelScreenRatio * 0.5 + screenBorderMarginRatio
    static let screenMin = screenBorderOriginRatio + screenBorderMarginRatio
    static let screenMax = screenBorderOriginRatio + screenBorderMarginRatio * 2 + levelScreenRatio
    
    static let currentObstacleZPosition: CGFloat = CGFloat.greatestFiniteMagnitude
    
    static let TITLE_FONT = "FinalFrontierOldStyle"
    static let normalFont = "FinalFrontierOldStyle"
    static let normalFontSize: CGFloat = 40.0

    // archived key
    static let settingFileName = "settingFileName"
    static let settingSoundKey = "settingSoundKey"
    static let settingMusicKey = "settingMusicKey"

    static let labelGameTitle = "Tri Adventure"
    static let labelPlay = "PLAY"
    static let labelDesign = "DESIGN"
    
    // asset filenames
    static let homepageBackgroundFilename = "homepage"
    static let settingBackgroundFilename = "setting-background"
    static let soundButtonFilename = "sound-btn"
    static let soundButtonDisabledFilename = "sound-btn-disabled"
    static let musicButtonFilename = "music-btn"
    static let musicButtonDisabledFilename = "music-btn-disabled"
    static let backButtonFilename = "back-btn"
    static let backButtonDisabledFilename = "back-btn-disabled"
    static let backgroundButtonLargeFilename = "background-btn-large"
    static let backgroundButtonFilename = "background-btn"
    static let upwardButtonFilename = "upward-btn"
    static let upwardButtonDisabledFilename = "upward-btn-disabled"
    static let downwardButtonFilename = "downward-btn"
    static let downwardButtonDisabledFilename = "downward-btn-disabled"
    static let lockButtonFilename = "lock-btn"

    // sizes
    static let iconButtonDefaultSize = CGSize(width: 100, height: 100)
    static let textButtonDefaultSize = CGSize(width: 215, height: 100)
    static let screenPadding = CGSize(width: 50, height: 50)
    static let buttonVerticalMargin: CGFloat = 30
    static let buttonHorizontalMargin: CGFloat = 30
}

enum LevelDifficultyLevel: Int {
    case UNDEFINED = 0
    case EASY = 1
    case INTERMEDIATE = 2
    case HARD = 3
}

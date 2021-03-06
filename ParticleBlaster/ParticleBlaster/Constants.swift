//
//  Constants.swift
//  ParticleBlaster
//
//  Created by Bohan Huang on 12/3/17.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

import SpriteKit

struct PhysicsCategory {
    static let None      : UInt32 = 0
    static let All       : UInt32 = UInt32.max
    static let Obstacle  : UInt32 = 0x1 << 0       // 1
    static let Bullet    : UInt32 = 0x1 << 1       // 2
    static let Player    : UInt32 = 0x1 << 2       // 3
    static let Map       : UInt32 = 0x1 << 3       // 4
    static let Grenade   : UInt32 = 0x1 << 4       // 5
    static let Upgrade   : UInt32 = 0x1 << 5       // 6
}

enum GameMode: Int {
    case single = 0
    case multiple = 1
}

enum ControllerType: Int {
    case single = 0
    case multi1 = 1
    case multi2 = 2
}

enum WeaponCategory: Int {
    case Bullet = 0
    case Grenade = 1
    case Missile = 2
    
    static let defaultGrenadeNumber = 4
    static let defaultMissileNumber = 2
    
    func getSpecialWeaponCounterNumber() -> Int {
        switch self {
        case .Grenade:
            return 4
        case .Missile:
            return 2
        default:
            return 0
        }
    }
}

class Constants {
    static let numOfPreloadSingleModeLevel = 12
    static let backgroundColor = SKColor.white
    static let defaultBackgroundZPosition: CGFloat = CGFloat(-100)
    
    static var viewCentralPoint: CGPoint!
    
    // Game Scene Constants
    static var joystickPlateWidth: CGFloat!
    static var joystickPlateHeight: CGFloat!
    static var joystickPlateAllowedRange: CGFloat!
    static var joystickPlateTouchEndRange: CGFloat!
    static var fireButtonWidth: CGFloat!
    static var fireButtonHeight: CGFloat!
    
    static let joystickAlpha: CGFloat = CGFloat(0.8)
    static let fireButtonPressAlpha: CGFloat = CGFloat(1)
    static let fireButtonReleaseAlpha: CGFloat = CGFloat(0.6)
    
    static let defaultJoystickZPosition: CGFloat = CGFloat(50)
    static let defaultJoystickPlateZPosition: CGFloat = CGFloat(49)
    static let defaultFireButtonZPosition: CGFloat = CGFloat(50)
    
    static let playerWidth: CGFloat = CGFloat(50)
    static let playerHeight: CGFloat = CGFloat(50)
    static let playerRadius: CGFloat = CGFloat(22)
    
    static func initializeJoystickInfo(viewSize: CGSize) {
        self.joystickPlateWidth = viewSize.width / 8
        self.joystickPlateHeight = viewSize.width / 8
        self.joystickPlateAllowedRange = self.joystickPlateWidth * 1.5
        self.joystickPlateTouchEndRange = self.joystickPlateWidth * 1.75
        
        self.fireButtonWidth = self.joystickPlateWidth
        self.fireButtonHeight = self.joystickPlateHeight

        self.viewCentralPoint = CGPoint(x: viewSize.width * 0.5, y: viewSize.height * 0.5)
    }
    
    // Game Static Constants
    static let playerVelocity: CGFloat = CGFloat(400)
    static let obstacleVelocity: CGFloat = CGFloat(200)
    static let bulletVelocity: CGFloat = CGFloat(1000)
    
    static let defaultMissileSpriteFilename = "missile"
    static let missileVelocity: CGFloat = CGFloat(350)
    static let missileInitialForceValue: CGFloat = CGFloat(20)
    static let missileConstantForceValue: CGFloat = CGFloat(2)
    static let missileLaunchOffset: CGFloat = CGFloat(30)
    static let missileLaunchTime = 0.8
    static let missileInitialAccelerationTime = 0.2
    static let shieldRadius: CGFloat = CGFloat(120)
    
    static let defaultBulletSpriteFilename = "bullet-new"
    static let defaultBulletRadius: CGFloat = CGFloat(16)
    static let defaultBulletWidth: CGFloat = CGFloat(12)
    static let defaultBulletHeight: CGFloat = CGFloat(42)
    
    static let defaultGrenadeSpriteFilename = "grenade-new"
    static let grenadeThrowingVelocity: CGFloat = CGFloat(500)
    static let grenadeThrowingTime: CGFloat = CGFloat(0.8)
    static let grenadeRadius: CGFloat = CGFloat(15)
    static let grenadeExplodeSizeExpansionValue: Int = 5
    static let grenadeThrowingDistance: CGFloat = CGFloat(250)
    static let grenadeExplosionAnimationTime = 0.8
    static let grenadeExplosionAnimationZPosition: CGFloat = CGFloat(5)
    static let sceneAnimationTime = 0.5
    
    static let defaultUpgradePackSpriteFilename = "upgradePack"
    static let upgradePackRadius: CGFloat = CGFloat(20)
    static let upgradePackMoveVelocity: CGVector = CGVector(dx: 0, dy: -5)
    static let upgradePackMoveOffset = CGVector(dx: 0, dy: -40)
    static let upgradePackFadeTime = 1.0
    static let upgradePackMoveTime = 5.0
    
    static let defaultWeaponZPosition: CGFloat = CGFloat(-1)
    
    // Score Related Constants
    static let defaultScoreDivider: Float = 500
    static let scoreDisplayOffset: CGFloat = CGFloat(15)
    
    // Physics Related Constants
    static let defaultTimeToLive: Int = 10
    static let playerTimeToLive: Int = 1
    static let multiplayerTimeToLive: Int = 5
    static let obstacleMinimumWidth: CGFloat = 20
    
    static let obstacleImpulseValue: CGFloat = CGFloat(50)
    static let obstacleForceValue: CGFloat = CGFloat(50)
    static let obstacleHitByGrenadeImpulseValue: CGFloat = CGFloat(150)
    static let playerForceValue: CGFloat = CGFloat(50)
    
    static let obstacleMass: CGFloat = CGFloat(20)
    static let playerMass: CGFloat = CGFloat(10)
    
    static let destroyObstacleScoreFont = "Papyrus"
    static let destroyObstacleScoreFontSize = CGFloat(40)
    static let destroyObstacleScoreOffset = CGVector(dx: 0, dy: 5)
    static let destroyObstacleScoreFadeTime = 0.5
    //static let destroyObstacleScore
    
    // Homepage Constants
    static let backgroundImage: UIImage = #imageLiteral(resourceName: "homepage")

    static let maxNumOfObstacle = 15
    static let defaultThemeName = "Planets"
    
    // Game Pause Constants
    static let pauseTitle = "Game Paused"
    static let pauseResumeTitle = "Resume"
    static let pauseReplayTitle = "Replay"
    static let pauseHomepageTitle = "Homepage"
    
    static let zPositionLabel: CGFloat = 1
    static let zPositionButton: CGFloat = 1
    static let zPositionBackground: CGFloat = 0
    
    static let pauseLabelOffset: CGFloat = 0.2
    static let pauseResumeButtonOffset: CGFloat = 0.05
    static let pauseReplayButtonOffset: CGFloat = -0.1
    static let pauseHomepageButtonOffset: CGFloat = -0.25
    
    // Obstalces' size
    static let obstacleBasicWidth: CGFloat = 80
    static let obstacleBasicSize = CGSize(width: 80, height: 80)
    static let obstacleSizeMap = [
        "obs": Constants.obstacleBasicSize,
        "planet-1": Constants.obstacleBasicSize,
        "planet-2": Constants.obstacleBasicSize * 1.2,
        "planet-3": Constants.obstacleBasicSize * 1.4,
        "planet-4": Constants.obstacleBasicSize * 1.6,
        "planet-5": Constants.obstacleBasicSize * 1.8,
        "planet-6": Constants.obstacleBasicSize * 2.0
    ]
    static let timeToLiveMap = [
        "obs": 10,
        "planet-1": 3,
        "planet-2": 4,
        "planet-3": 6,
        "planet-4": 7,
        "planet-5": 8,
        "planet-6": 10
    ]
    static let standardObstacleSize = CGSize(width: 80, height: 80)
    static let defaultFirstPlayerPositionRatio = CGPoint(x: 0.15, y: 0.5)
    static let defaultSecondPlayerPositionRatio = CGPoint(x: 0.85, y: 0.5)
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
    static let fontSizeHuge: CGFloat = 150
    
    // Level Designer Constants
    static let levelScreenPreviewRatio: CGFloat = 0.5
    static let levelScreenRatio: CGFloat = 0.6
    static let screenBorderMarginRatio: CGFloat = 0.005
    static let screenBorderOriginRatio: CGFloat = 0.35
    static let screenBorderSizeRatio: CGFloat = levelScreenRatio + screenBorderMarginRatio * 2
    static let screenCenterPositionRatio: CGFloat = screenBorderOriginRatio + levelScreenRatio * 0.5 + screenBorderMarginRatio
    static let screenMin = screenBorderOriginRatio + screenBorderMarginRatio
    static let screenMax = screenBorderOriginRatio + screenBorderMarginRatio * 2 + levelScreenRatio
    
    static let currentObstacleZPosition: CGFloat = CGFloat.greatestFiniteMagnitude
    static let zPositionModal: CGFloat = 10
    
    static let normalFont = "FinalFrontierOldStyle"
    static let normalFontSize: CGFloat = 40.0

    // archived key
    static let playerFilenamePrefix = "player-"
    static let levelPrefix = "gameLevel"
    static let gameDataFilename = "gameDataFilename"
    static let settingFileName = "settingFileName"
    static let settingSoundKey = "settingSoundKey"
    static let settingMusicKey = "settingMusicKey"
    static let gameDataNumSingleModeLevelKey = "gameDataNumSingleModeLevelKey"
    static let gameDataNumMultiModeLevelKey = "gameDataNumMultiModeLevelKey"
    static let gameDataAchievedSingleModeLevelKey = "gameDataAchievedSingleModeLevelKey" 
    static let imageNameKey = "imageNameKey"
    static let initialPositionKey = "initialPositionKey"
    static let ratioPositionKey = "ratioPositionKey"
    static let gameModekey = "gameModeKey"
    static let playersKey = "playersKey"
    static let backgroundImageNameKey = "backgroundImageNameKey"
    static let themeNameKey = "themeNameKey"
    static let gameIdKey = "gameIdKey"
    static let obstaclesKey = "obstaclesKey"
    static let launchedBeforeKey = "launchedBeforeKey"

    static let labelGameTitle = "Tri Adventure"
    static let labelPlay = "PLAY"
    static let labelCancel = "CANCEL"
    static let labelEdit = "EDIT"
    static let labelSave = "SAVE"
    static let labelDesign = "DESIGN"
    static let labelSinglePlayer = "1 PLAYER"
    static let labelMultiplePlayers = "2 PLAYERS"
    
    // asset filenames
    static let spaceshipFilename = "Spaceship"
    static let gameplayBackgroundFilename = "space-background"
    static let homepageBackgroundFilename = "homepage"
    static let settingBackgroundFilename = "setting-background"
    static let soundButtonFilename = "sound-btn"
    static let soundButtonDisabledFilename = "sound-btn-disabled"
    static let musicButtonFilename = "music-btn"
    static let musicButtonDisabledFilename = "music-btn-disabled"
    static let backButtonFilename = "back-btn"
    static let backButtonDisabledFilename = "back-btn-disabled"
    static let backgroundButtonLargeFilename = "background-btn-large"
    static let backgroundButtonDisabledLargeFilename = "background-btn-large-disabled"
    static let backgroundButtonFilename = "background-btn"
    static let upwardButtonFilename = "upward-btn"
    static let upwardButtonDisabledFilename = "upward-btn-disabled"
    static let downwardButtonFilename = "downward-btn"
    static let downwardButtonDisabledFilename = "downward-btn-disabled"
    static let lockButtonFilename = "lock-btn"
    static let addButtonFilename = "add-btn"
    static let rankButtonFilename = "rank-btn"
    static let rankButtonDisabledFilename = "rank-btn-disabled"
    static let transparentBackgroundFilename = "transparent-background"
    static let pauseButtonFilename = "setting-btn"
    

    // Sizes
    static let iconButtonDefaultSize = CGSize(width: 100, height: 100)
    static let textButtonDefaultSize = CGSize(width: 215, height: 100)
    static let textButtonTransparentDefaultSize = CGSize(width: 150, height: 100)
    static let screenPadding = CGSize(width: 50, height: 50)
    static let obstaclePadding = CGSize(width: 10, height: 10)
    static let screenPaddingThinner = CGSize(width: 20, height: 20)
    static let buttonVerticalMargin: CGFloat = 30
    static let buttonHorizontalMargin: CGFloat = 30

    // Sound
    static let buttonPressedSoundFilename = "button-pressed.mp3"
    static let backgroundSoundFilename = "background-music-aac"
    static let shootingSoundFilename = "pew-pew-lei.caf"
    static let throwGrenadeSoundFilename = "pew-pew-lei.caf"
    static let launchMissileSoundFilename = "missile.mp3"
    static let grenadeExplodeSoundFilename = "explosion.mp3"
    
    // MFi Controller
    static let debouncingInteval: Float = 0.005

    // Alpha values
    static let normalBlurAlpha: CGFloat = 0.2
    static let fullAlpha: CGFloat = 1
    
    // Error Message
    static let errorMessageNSCoder = "init(coder:) has not been implemented"
}

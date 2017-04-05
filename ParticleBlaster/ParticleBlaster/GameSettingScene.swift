//
//  GameSettingScene.swift
//  ParticleBlaster
//
//  Created by Bui Hiep on 23/3/17.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

import SpriteKit

class GameSettingScene: SKScene, SKPhysicsContactDelegate {
    private var background: SKSpriteNode!
    private var soundButton: IconButton!
    private var musicButton: IconButton!
    private var backButton: IconButton!
    private var gameSetting: GameSetting!

    override func didMove(to view: SKView) {
        gameSetting = GameSetting.getInstance()

        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)

        background = SKSpriteNode(imageNamed: Constants.settingBackgroundFilename)
        soundButton = IconButton(imageNamed: Constants.soundButtonFilename,
                                 disabledImageNamed: Constants.soundButtonDisabledFilename,
                                 size: Constants.iconButtonDefaultSize,
                                 isPositive: gameSetting.isSoundEnabled)
        musicButton = IconButton(imageNamed: Constants.musicButtonFilename,
                                 disabledImageNamed: Constants.musicButtonDisabledFilename,
                                 size: Constants.iconButtonDefaultSize,
                                 isPositive: gameSetting.isMusicEnabled)
        backButton = IconButton(imageNamed: Constants.backButtonFilename,
                                disabledImageNamed: Constants.backButtonDisabledFilename,
                                size: Constants.iconButtonDefaultSize)
        background.position = .zero
        background.zPosition = 0
        musicButton.position = CGPoint(x: -70, y: 0)
        musicButton.zPosition = 1
        soundButton.position = CGPoint(x: 70, y: 0)
        soundButton.zPosition = 1
        backButton.position = CGPoint(x: -(self.size.width / 2 - Constants.screenPadding.width - backButton.size.width / 2),
                                      y: -(self.size.height / 2 - Constants.screenPadding.height - backButton.size.height / 2))
        backButton.zPosition = 1
        musicButton.onPressHandler = self.musicButtonPressed
        soundButton.onPressHandler = self.soundButtonPressed
        backButton.onPressHandler = self.backButtonPressed

        addChild(background)
        addChild(musicButton)
        addChild(soundButton)
        addChild(backButton)
    }

    func musicButtonPressed() {
        gameSetting.toggleMusic()
        musicButton.isPositive = gameSetting.isMusicEnabled
    }

    func soundButtonPressed() {
        gameSetting.toggleSound()
        soundButton.isPositive = gameSetting.isSoundEnabled
    }

    func backButtonPressed() {
        print("go back!")
    }
}


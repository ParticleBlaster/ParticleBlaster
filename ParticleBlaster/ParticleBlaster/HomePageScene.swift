//
//  HomePageScene.swift
//  ParticleBlaster
//
//  Created by Richthofen on 13/03/2017.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

import SpriteKit
import GameplayKit

class HomePageScene: SKScene {
    private var background: SKSpriteNode!
    private var playButton: TextButton!
    private var designButton: TextButton!
    private var soundButton: IconButton!
    private var musicButton: IconButton!
    private var gameSetting: GameSetting!

    override func didMove(to view: SKView) {
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        gameSetting = GameSetting.getInstance()

        background = SKSpriteNode(imageNamed: Constants.homepageBackgroundFilename)
        background.position = .zero
        background.size = size
        background.zPosition = 0
        addChild(background)

        let titleText = SKLabelNode(text: "Tri Adventure")
        titleText.fontSize = 120
        titleText.fontName = Constants.TITLE_FONT
        titleText.position = CGPoint(x: 0, y: size.height / 2 - Constants.screenPadding.height - titleText.frame.size.height)
        titleText.fontColor = SKColor.white
        titleText.zPosition = 1
        addChild(titleText)

        playButton = TextButton(imageNamed: Constants.backgroundButtonLargeFilename, text: Constants.labelPlay)
        playButton.position = CGPoint(x: 0, y: playButton.size.height)
        playButton.zPosition = 1
        playButton.onPressHandler = self.playButtonPressed
        addChild(playButton)

        designButton = TextButton(imageNamed: Constants.backgroundButtonLargeFilename, text: Constants.labelDesign)
        designButton.position = CGPoint(x: 0, y: playButton.size.height / 2  - designButton.size.height / 2 - Constants.buttonVerticalMargin)
        designButton.zPosition = 1
        designButton.onPressHandler = self.designButtonPressed
        addChild(designButton)

        soundButton = IconButton(size: Constants.iconButtonDefaultSize,
                                 imageNamed: Constants.soundButtonFilename,
                                 disabledImageNamed: Constants.soundButtonDisabledFilename,
                                 isPositive: gameSetting.isSoundEnabled)
        musicButton = IconButton(size: Constants.iconButtonDefaultSize,
                                 imageNamed: Constants.musicButtonFilename,
                                 disabledImageNamed: Constants.musicButtonDisabledFilename,
                                 isPositive: gameSetting.isMusicEnabled)
        soundButton.zPosition = 1
        soundButton.position = CGPoint(x: -soundButton.size.width / 2 - Constants.buttonVerticalMargin / 2,
                                       y: playButton.size.height / 2  - designButton.size.height - 2 * Constants.buttonVerticalMargin - soundButton.size.height / 2);
        soundButton.onPressHandler = self.soundButtonPressed
        addChild(soundButton)

        musicButton.zPosition = 1
        musicButton.position = CGPoint(x: musicButton.size.width / 2 + Constants.buttonVerticalMargin / 2,
                                       y: playButton.size.height / 2  - designButton.size.height - 2 * Constants.buttonVerticalMargin - musicButton.size.height / 2);
        musicButton.onPressHandler = self.musicButtonPressed
        addChild(musicButton)

        // Play and loop the background music
        let backgroundMusic = SKAudioNode(fileNamed: "background-music-aac.caf")
        backgroundMusic.autoplayLooped = true
        addChild(backgroundMusic)
    }

    private func playButtonPressed() {
    }

    private func designButtonPressed() {
    }

    func musicButtonPressed() {
        gameSetting.toggleMusic()
        musicButton.isPositive = gameSetting.isMusicEnabled
    }

    func soundButtonPressed() {
        gameSetting.toggleSound()
        soundButton.isPositive = gameSetting.isSoundEnabled
    }
}

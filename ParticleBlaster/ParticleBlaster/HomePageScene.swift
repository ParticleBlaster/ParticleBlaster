//
//  HomePageScene.swift
//  ParticleBlaster
//
//  Created by Richthofen on 13/03/2017.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

import SpriteKit

class HomePageScene: SKScene {
    private let buttonGameStart = SKShapeNode(rect: CGRect(x: 0, y: 0, width: 200, height: 60), cornerRadius: 10)
    var viewController: UIViewController?
    var zPositionCounter: CGFloat = 0

    private var background: SKSpriteNode!
    private var playButton: TextButton!
    private var designButton: TextButton!
    private var soundButton: IconButton!
    private var musicButton: IconButton!
    private var gameSetting: GameSetting!

    var navigationDelegate: NavigationDelegate?

    override func didMove(to view: SKView) {
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        gameSetting = GameSetting.getInstance()

        background = SKSpriteNode(imageNamed: Constants.homepageBackgroundFilename)
        background.position = .zero
        background.size = size
        background.zPosition = zPositionCounter
        zPositionCounter += 1
        addChild(background)
        
        // Create a simple red rectangle that's 100x44
        
        buttonGameStart.position = CGPoint(x: size.width * 0.1, y: size.height * 0.1)
        buttonGameStart.fillColor = SKColor.clear
        buttonGameStart.strokeColor = SKColor.white
        buttonGameStart.lineWidth = 5
        buttonGameStart.zPosition = zPositionCounter
        zPositionCounter += 1
        
        let titleText = SKLabelNode(text: "Tri Adventure")
        titleText.fontSize = Constants.fontSizeLargeX
        titleText.fontName = Constants.titleFont
        titleText.position = CGPoint(x: size.width * 0.5, y: size.height * 0.85)
        titleText.fontColor = SKColor.white
        titleText.zPosition = zPositionCounter
        zPositionCounter += 1
        addChild(titleText)
        
        let buttonText = SKLabelNode(text: "Start Game")
        buttonText.fontSize = Constants.fontSizeLarge
        buttonText.fontName = Constants.titleFont
        buttonText.position = CGPoint(x: buttonGameStart.frame.size.width * 0.5, y: buttonGameStart.frame.size.height * 0.25)
        buttonText.fontColor = SKColor.white    
        buttonText.zPosition = zPositionCounter
        zPositionCounter += 1
        
        buttonGameStart.addChild(buttonText)
        
        addChild(buttonGameStart)


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
        navigationDelegate?.navigateToLevelSelectScene(isSingleMode: true)
    }

    private func designButtonPressed() {
        navigationDelegate?.navigateToDesignScene()
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

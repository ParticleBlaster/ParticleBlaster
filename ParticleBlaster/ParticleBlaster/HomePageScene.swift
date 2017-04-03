//
//  HomePageScene.swift
//  ParticleBlaster
//
//  Created by Richthofen on 13/03/2017.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//
import SpriteKit

class HomePageScene: SKScene {
    private var background: SKSpriteNode!
    private var playButton: TextButton!
    private var designButton: TextButton!
    private var soundButton: IconButton!
    private var musicButton: IconButton!
    private var rankButton: IconButton!
    private var gameSetting: GameSetting!
    
    var viewController: UIViewController?
    
    var navigationDelegate: NavigationDelegate?
    
    override init(size: CGSize) {
        super.init(size: size)

        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        gameSetting = GameSetting.getInstance()
        
        background = SKSpriteNode(imageNamed: Constants.homepageBackgroundFilename)
        background.position = .zero
        background.size = size
        background.zPosition = 0
        addChild(background)
        
        let titleText = SKLabelNode(text: Constants.labelGameTitle)
        titleText.fontSize = Constants.fontSizeHuge
        titleText.fontName = Constants.titleFont
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
        
        soundButton = IconButton(imageNamed: Constants.soundButtonFilename,
                                 disabledImageNamed: Constants.soundButtonDisabledFilename,
                                 size: Constants.iconButtonDefaultSize,
                                 isPositive: gameSetting.isSoundEnabled)
        musicButton = IconButton(imageNamed: Constants.musicButtonFilename,
                                 disabledImageNamed: Constants.musicButtonDisabledFilename,
                                 size: Constants.iconButtonDefaultSize,
                                 isPositive: gameSetting.isMusicEnabled)
        rankButton = IconButton(imageNamed: Constants.rankButtonFilename,
                                disabledImageNamed: Constants.rankButtonDisabledFilename,
                                size: Constants.iconButtonDefaultSize,
                                isPositive: false,
                                isEnabled: false)
        soundButton.zPosition = 1
        soundButton.position = CGPoint(x: 0,
                                       y: playButton.size.height / 2  - designButton.size.height - 2 * Constants.buttonVerticalMargin - soundButton.size.height / 2);
        soundButton.onPressHandler = self.soundButtonPressed
        addChild(soundButton)
        
        musicButton.zPosition = 1
        musicButton.position = CGPoint(x: soundButton.position.x + soundButton.size.width / 2 + Constants.buttonHorizontalMargin + musicButton.size.width / 2,
                                       y: playButton.size.height / 2  - designButton.size.height - 2 * Constants.buttonVerticalMargin - musicButton.size.height / 2);
        musicButton.onPressHandler = self.musicButtonPressed
        addChild(musicButton)

        rankButton.zPosition = 1
        rankButton.position = CGPoint(x: soundButton.position.x - soundButton.size.width / 2 - Constants.buttonHorizontalMargin - rankButton.size.width / 2,
                                      y: playButton.size.height / 2  - designButton.size.height - 2 * Constants.buttonVerticalMargin - musicButton.size.height / 2);
        rankButton.onPressHandler = self.rankButtonPressed
        addChild(rankButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func onGCEnableChange(isEnabled: Bool) {
        rankButton.isPositive = isEnabled
        rankButton.isEnabled = isEnabled
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
        if gameSetting.isMusicEnabled {
            AudioUtils.playBackgroundMusic()
        } else {
            AudioUtils.pauseBackgroundMusic()
        }
    }
    
    func soundButtonPressed() {
        gameSetting.toggleSound()
        soundButton.isPositive = gameSetting.isSoundEnabled
    }

    func rankButtonPressed() {
        navigationDelegate?.navigateToLeaderBoard()
    }
}

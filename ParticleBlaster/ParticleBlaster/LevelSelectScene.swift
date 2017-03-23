//
//  LevelSelectScene.swift
//  ParticleBlaster
//
//  Created by Bui Hiep on 24/3/17.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//
import SpriteKit

class LevelSelectScene: SKScene {
    private var background: SKSpriteNode!
    private var backButton: IconButton!
    private var preButton: IconButton!
    private var nextButton: IconButton!

    var navigationDelegate: NavigationDelegate?

    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)

        background = SKSpriteNode(imageNamed: Constants.homepageBackgroundFilename)
        preButton = IconButton(size: Constants.iconButtonDefaultSize,
                                 imageNamed: Constants.upwardButtonFilename,
                                 disabledImageNamed: Constants.upwardButtonDisabledFilename)
        nextButton = IconButton(size: Constants.iconButtonDefaultSize,
                                 imageNamed: Constants.downwardButtonFilename,
                                 disabledImageNamed: Constants.downwardButtonDisabledFilename)
        backButton = IconButton(size: Constants.iconButtonDefaultSize,
                                imageNamed: Constants.backButtonFilename,
                                disabledImageNamed: Constants.backButtonDisabledFilename)
        background.position = .zero
        background.zPosition = 0
        backButton.zPosition = 1
        backButton.position = CGPoint(x: -(self.size.width / 2 - Constants.screenPadding.width - backButton.size.width / 2),
                                      y: -(self.size.height / 2 - Constants.screenPadding.height - backButton.size.height / 2))
        nextButton.zPosition = 1
        nextButton.position = CGPoint(x: self.size.width / 2 - Constants.screenPadding.width - nextButton.size.width / 2,
                                      y: -(self.size.height / 2 - Constants.screenPadding.height - nextButton.size.height / 2))
        preButton.zPosition = 1
        preButton.position = CGPoint(x: nextButton.position.x,
                                     y: nextButton.position.y + preButton.size.height / 2 + Constants.buttonVerticalMargin + nextButton.size.height / 2)

        backButton.onPressHandler = self.backButtonPressed
        preButton.onPressHandler = self.preButtonPressed
        nextButton.onPressHandler = self.nextButtonPressed
        addChild(background)
        addChild(preButton)
        addChild(nextButton)
        addChild(backButton)
    }

    func backButtonPressed() {
        navigationDelegate?.navigateToHomePage()
    }

    func preButtonPressed() {
    }

    func nextButtonPressed() {
    }
}

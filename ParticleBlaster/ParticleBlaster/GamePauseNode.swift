//
//  GamePauseScene.swift
//  ParticleBlaster
//
//  Created by Richthofen on 12/04/2017.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

/**
 *  The `GamePauseNode` is SKNode in the scene that is used to pause the game on-click
 */

import Foundation
import SpriteKit

class GamePauseNode: SKNode {
    private var background: SKSpriteNode!
    private var buttonHomePage: TextButton!
    private var buttonResume: TextButton!
    private var buttonReplay: TextButton!
    private var viewController: GameViewController!
    
    init(size: CGSize, viewController: GameViewController) {
        self.background = SKSpriteNode(imageNamed: Constants.homepageBackgroundFilename)
        self.buttonHomePage = TextButton(imageNamed: Constants.backgroundButtonLargeFilename, text: Constants.pauseHomepageTitle)
        self.buttonResume = TextButton(imageNamed: Constants.backgroundButtonLargeFilename, text: Constants.pauseResumeTitle)
        self.buttonReplay = TextButton(imageNamed: Constants.backgroundButtonLargeFilename, text: Constants.pauseReplayTitle)
        self.viewController = viewController
        super.init()
        
        self.alpha = Constants.fullAlpha
        self.isUserInteractionEnabled = true
        
        // Set the background image
        background.position = .zero
        background.size = size
        background.alpha = Constants.fullAlpha
        background.zPosition = Constants.zPositionBackground
        addChild(background)
        
        // Choose font and set parameters for displaying laber of text
        let label = SKLabelNode(fontNamed: Constants.titleFont)
        label.text = Constants.pauseTitle
        label.fontName = Constants.titleFont
        label.fontSize = Constants.fontSizeHuge
        label.fontColor = SKColor.white
        label.position = CGPoint(x: 0, y: size.height * Constants.pauseLabelOffset)
        label.zPosition = Constants.zPositionLabel
        addChild(label)
        
        // Set button positions
        buttonResume.position = CGPoint(x: 0, y: size.height * Constants.pauseResumeButtonOffset)
        buttonResume.onPressHandler = self.resumeButtonPressed
        buttonResume.zPosition = Constants.zPositionButton
        addChild(buttonResume)
        
        buttonReplay.position = CGPoint(x: 0, y: size.height * Constants.pauseReplayButtonOffset)
        buttonReplay.onPressHandler = self.replayButtonPressed
        buttonReplay.zPosition = Constants.zPositionButton
        addChild(buttonReplay)
        
        buttonHomePage.position = CGPoint(x: 0, y: size.height * Constants.pauseHomepageButtonOffset)
        buttonHomePage.onPressHandler = self.homepageButtonPressed
        buttonHomePage.zPosition = Constants.zPositionButton
        addChild(buttonHomePage)
    }
    
    private func replayButtonPressed() {
        self.viewController.viewDidLoad()
    }
    
    private func resumeButtonPressed() {
        self.viewController.doResumeGame()
    }
    
    private func homepageButtonPressed() {
        self.viewController.goBack()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError(Constants.errorMessageNSCoder)
    }
}

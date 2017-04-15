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
        self.buttonHomePage = TextButton(imageNamed: Constants.backgroundButtonLargeFilename, text: "Homepage")
        self.buttonResume = TextButton(imageNamed: Constants.backgroundButtonLargeFilename, text: "Resume")
        self.buttonReplay = TextButton(imageNamed: Constants.backgroundButtonLargeFilename, text: "Replay")
        self.viewController = viewController
        super.init()
        
        // Set the background image
        background.position = .zero
        background.size = size
        background.alpha = 1
        background.zPosition = 0
        addChild(background)
        
        // Choose font and set parameters for displaying laber of text
        let label = SKLabelNode(fontNamed: Constants.titleFont)
        label.text = "Pause"
        label.fontName = Constants.titleFont
        label.fontSize = Constants.fontSizeHuge
        label.fontColor = SKColor.white
        label.position = CGPoint(x: frame.midX + 0, y: frame.midY + size.height * 0.2)
        label.zPosition = 1
        addChild(label)
        
        // Set button positions
        buttonResume.position = CGPoint(x: frame.midX + 0, y: frame.midY + size.height * 0.05)
        buttonResume.onPressHandler = self.resumeButtonPressed
        buttonResume.zPosition = 1
        addChild(buttonResume)
        
        buttonReplay.position = CGPoint(x: frame.midX + 0, y: frame.midY + size.height * -0.1)
        buttonReplay.onPressHandler = self.replayButtonPressed
        buttonReplay.zPosition = 1
        addChild(buttonReplay)
        
        buttonHomePage.position = CGPoint(x: frame.midX + 0, y: frame.midY + size.height * -0.25)
        buttonHomePage.onPressHandler = self.homepageButtonPressed
        buttonHomePage.zPosition = 1
        addChild(buttonHomePage)
    }
    
    private func replayButtonPressed() {
        self.viewController.viewDidLoad()
    }
    
    private func resumeButtonPressed() {
        self.viewController.doResumeGame()
    }
    
    private func homepageButtonPressed() {
        self.viewController.dismiss(animated: true, completion: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

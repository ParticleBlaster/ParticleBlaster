//
//  GamePauseScene.swift
//  ParticleBlaster
//
//  Created by Richthofen on 12/04/2017.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

import Foundation
import SpriteKit

class GamePauseNode: SKNode {
    var background: SKSpriteNode!
    var buttonHomePage: TextButton!
    var buttonResume: TextButton!
    var buttonReplay: TextButton!
    var viewController: GameViewController!
    
    init(size: CGSize, viewController: GameViewController) {
        self.background = SKSpriteNode(imageNamed: Constants.homepageBackgroundFilename)
        self.buttonHomePage = TextButton(imageNamed: Constants.backgroundButtonLargeFilename, text: "Homepage")
        self.buttonResume = TextButton(imageNamed: Constants.backgroundButtonLargeFilename, text: "Resume")
        self.buttonReplay = TextButton(imageNamed: Constants.backgroundButtonLargeFilename, text: "Replay")
        self.viewController = viewController
        super.init()
        
        // Set the background image
//        anchorPoint = CGPoint(x: 0.5, y: 0.5)
//        background.position = CGPoint(x: frame.midX, y: frame.midY)
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

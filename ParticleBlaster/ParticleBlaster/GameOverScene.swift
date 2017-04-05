//
//  GameOverScene.swift
//  ParticleBlaster
//
//  Created by Bohan Huang on 12/3/17.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {
    var background: SKSpriteNode!
    var buttonHomePage: TextButton!
    var buttonReplay: TextButton!
    var viewController: GameViewController!
    
    init(size: CGSize, won:Bool, viewController: GameViewController) {
        self.background = SKSpriteNode(imageNamed: Constants.homepageBackgroundFilename)
        self.buttonHomePage = TextButton(imageNamed: Constants.backgroundButtonLargeFilename, text: "Homepage")
        self.buttonReplay = TextButton(imageNamed: Constants.backgroundButtonLargeFilename, text: "Replay")
        self.viewController = viewController
        super.init(size: size)
        
        // Set the background image
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        background.position = .zero
        background.size = size
        background.zPosition = 0
        addChild(background)
        
        // Set the message to either “You Won” or “You Lose” based on the won parameter
        let message = won ? "You Won!" : "You Lose :["
        
        // Choose font and set parameters for displaying laber of text
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.text = message
        label.fontName = Constants.titleFont
        label.fontSize = Constants.fontSizeHuge
        label.fontColor = SKColor.white
        label.position = CGPoint(x: 0, y: size.height * 0.2)
        label.zPosition = 1
        addChild(label)
        
        buttonReplay.position = CGPoint(x: 0, y: size.height * 0)
        buttonReplay.onPressHandler = self.replayButtonPressed
        buttonReplay.zPosition = 1
        addChild(buttonReplay)
        
        buttonHomePage.position = CGPoint(x: 0, y: size.height * -0.2)
        buttonHomePage.onPressHandler = self.homepageButtonPressed
        buttonHomePage.zPosition = 1
        addChild(buttonHomePage)
    }
    
    private func replayButtonPressed() {
        self.viewController.dismiss(animated: true, completion: nil)
    }
    
    private func homepageButtonPressed() {
        self.viewController.dismiss(animated: true, completion: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

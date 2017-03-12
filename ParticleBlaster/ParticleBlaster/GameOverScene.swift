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
    
    init(size: CGSize, won:Bool) {
        
        super.init(size: size)
        
        // Set the background color
        backgroundColor = Constants.backgroundColor
        
        // Set the message to either “You Won” or “You Lose” based on the won parameter
        let message = won ? "You Won!" : "You Lose :["
        
        // Choose font and set parameters for displaying laber of text
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.text = message
        label.fontSize = 40
        label.fontColor = SKColor.black
        label.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(label)
        
        // Run a sequence of two actions
        run(SKAction.sequence([
            // Wait for 3 seconds
            SKAction.wait(forDuration: 3.0),
            // Transitie to a new scene
            SKAction.run() {
                let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
                let scene = GameScene(size: size)
                self.view?.presentScene(scene, transition:reveal)
            }
        ]))
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

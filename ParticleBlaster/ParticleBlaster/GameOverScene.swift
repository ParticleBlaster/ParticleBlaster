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
    
    var buttonHomePage: SKShapeNode
    
    init(size: CGSize, won:Bool) {
        
        buttonHomePage = SKShapeNode(rect: CGRect(x: 0, y: 0, width: 400, height: 60), cornerRadius: 10)
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
        
        buttonHomePage.position = CGPoint(x: frame.midX - buttonHomePage.frame.midX, y: size.height * 0.3)
        buttonHomePage.fillColor = SKColor.clear
        buttonHomePage.strokeColor = SKColor.black
        buttonHomePage.lineWidth = 5
        buttonHomePage.zPosition = 1
        
        let buttonText = SKLabelNode(text: "Back to home page")
        buttonText.position = CGPoint(x: buttonHomePage.frame.size.width * 0.5, y: buttonHomePage.frame.size.height * 0.25)
        buttonText.fontSize = 40
        buttonText.fontName = Constants.TITLE_FONT
        buttonText.fontColor = SKColor.black
        buttonText.zPosition = 2
        
        buttonHomePage.addChild(buttonText)
        addChild(buttonHomePage)

//        // Run a sequence of two actions
//        run(SKAction.sequence([
//            // Wait for 3 seconds
//            SKAction.wait(forDuration: 3.0),
//            // Transitie to a new scene
//            SKAction.run() {
//                let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
//                let scene = GameScene(size: size)
//                self.view?.presentScene(scene, transition:reveal)
//            }
//        ]))
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let touchLocation = touch!.location(in: self)
        // Check if the location of the touch is within the button's bounds
        if buttonHomePage.contains(touchLocation) {
            print("back to manu tapped!")
            
//            let reveal = SKTransition.crossFade(withDuration: 0.5)
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            let homePageScene = HomePageScene(size: self.size)
            homePageScene.scaleMode = .resizeFill
            self.view?.presentScene(homePageScene, transition: reveal)
            
        }
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

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
    
    private let background = SKSpriteNode(imageNamed: "homepage")
    private let buttonGameStart = SKShapeNode(rect: CGRect(x: 0, y: 0, width: 200, height: 60), cornerRadius: 10)
    var viewController: UIViewController?
    var zPositionCounter: CGFloat = 0
//        SKSpriteNode(color: SKColor.clear, size: CGSize(width: 200, height: 80))
    
    
    override func didMove(to view: SKView) {
        
        background.position = CGPoint(x: frame.midX, y: frame.midY)
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
        
        
        // Play and loop the background music
        let backgroundMusic = SKAudioNode(fileNamed: "background-music-aac.caf")
        backgroundMusic.autoplayLooped = true
        addChild(backgroundMusic)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let touchLocation = touch!.location(in: self)
        // Check if the location of the touch is within the button's bounds
        if buttonGameStart.contains(touchLocation) {
            print("game start tapped!")
            self.viewController?.performSegue(withIdentifier: "homeToSingleGame", sender: self)
//            
////            let reveal = SKTransition.crossFade(withDuration: 0.5)
//            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
//            let gameScene = GameScene(size: self.size)
//            gameScene.scaleMode = .resizeFill
//            
////            self.removeFromParent()
//            self.view?.presentScene(gameScene, transition: reveal)
//            
        }
        
    }

    
}

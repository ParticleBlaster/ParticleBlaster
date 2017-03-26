//
//  LevelDesignerScene.swift
//  ParticleBlaster
//
//  Created by Richthofen on 26/03/2017.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

import Foundation
import SpriteKit

class LevelDesignerScene: SKScene {
    
    private let background = SKSpriteNode(imageNamed: "homepage")
    private let buttonBackToHomepage = SKShapeNode(rect: CGRect(x: 0, y: 0, width: 100, height: 30), cornerRadius: 10)
    private let levelScreen = SKSpriteNode(imageNamed: "solar-system")
    var obstacles = [Obstacle]()
    var currentObstacle: Obstacle?
    var viewController: UIViewController?
    var zPositionCounter: CGFloat = 0
    let paletteItemInteval: CGFloat = 80
    var returnHomeHandler: (() -> ())?
    
    
    override func didMove(to view: SKView) {
        
        var startX = size.width * 0.3
        let startY = size.width * 0.125
        
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.alpha = 0.2
        background.size = size
        addChild(background)
        background.zPosition = zPositionCounter
        zPositionCounter += 1
        
        // Create a back button
        
        buttonBackToHomepage.position = CGPoint(x: size.width * 0.03, y: size.height * 0.03)
        buttonBackToHomepage.fillColor = SKColor.clear
        buttonBackToHomepage.strokeColor = SKColor.white
        buttonBackToHomepage.lineWidth = Constants.strokeSmall
        buttonBackToHomepage.zPosition = zPositionCounter
        zPositionCounter += 1
        
        let buttonText = SKLabelNode(text: "Back to Home")
        buttonText.fontSize = Constants.fontSizeMedium
        buttonText.fontName = Constants.titleFont
        buttonText.position = CGPoint(x: buttonBackToHomepage.frame.size.width * 0.5, y: buttonBackToHomepage.frame.size.height * 0.25)
        buttonText.fontColor = SKColor.white
        buttonText.zPosition = zPositionCounter
        zPositionCounter += 1
        
        buttonBackToHomepage.addChild(buttonText)

        addChild(buttonBackToHomepage)
        
        // Create a screen shot
        
        let levelScreenBorder = SKShapeNode(rect: CGRect(origin: CGPoint(x: size.width * Constants.screenBorderOriginRatio,
                                                                         y: size.height * Constants.screenBorderOriginRatio),
                                                         size: CGSize(width: size.width * Constants.screenBorderSizeRatio,
                                                                      height: size.height * Constants.screenBorderSizeRatio)),
                                            cornerRadius: Constants.cornerRadius)
        levelScreenBorder.fillColor = SKColor.clear
        levelScreenBorder.strokeColor = SKColor.white
        levelScreenBorder.lineWidth = Constants.strokeMedium
        levelScreenBorder.zPosition = zPositionCounter
        zPositionCounter += 1
        
        
        levelScreen.size = CGSize(width: size.width * Constants.levelScreenRatio,
                                  height: size.height * Constants.levelScreenRatio)
        levelScreen.position = CGPoint(x: size.width * Constants.screenCenterPositionRatio,
                                       y: size.height * Constants.screenCenterPositionRatio)

        levelScreen.alpha = 1
        levelScreen.zPosition = zPositionCounter
        zPositionCounter += 1
        
        levelScreenBorder.addChild(levelScreen)
        addChild(levelScreenBorder)
        
        // Create obstacle pallete
        
        obstacles = Constants.starwarsObstacles
        for obstacle in obstacles {
            obstacle.shape.size = CGSize(width: Constants.levelObstacleStandardWidth,
                                         height: Constants.getHeightWithSameRatio(withWidth: Constants.levelObstacleStandardWidth, forShape: obstacle.shape))
            obstacle.shape.position = CGPoint(x: startX, y: startY)
            obstacle.shape.alpha = 1
            obstacle.shape.zPosition = zPositionCounter
            zPositionCounter += 1
            
            addChild(obstacle.shape)
            startX += paletteItemInteval
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let touchLocation = touch!.location(in: self)
        // Check if the location of the touch is within the button's bounds
        if buttonBackToHomepage.contains(touchLocation) {
            print("LevelDeisgner: back to homepage tapped!")
            self.returnHomeHandler!()
        }
        
        if currentObstacle == nil {
            for obstacle in obstacles {
                if obstacle.shape.contains(touchLocation) {
                    addCurrentObstacle(obstacle)
                }
            }
        }
    }
    
    private func addCurrentObstacle(_ selectedObstacle: Obstacle) {
        guard currentObstacle == nil else {
            return
        }
        
        currentObstacle = selectedObstacle
        addChild(currentObstacle!.shape)
    }
    
    private func removeCurrentObstacle() {
        guard currentObstacle != nil else {
            return
        }
        
        currentObstacle!.shape.removeFromParent()
        currentObstacle = nil
    }

}

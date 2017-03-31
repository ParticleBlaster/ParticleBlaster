//
//  LevelDesignerScene.swift
//  ParticleBlaster
//
//  Created by Richthofen on 26/03/2017.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

import SpriteKit

class LevelDesignerScene: SKScene {
    
    private let background = SKSpriteNode(imageNamed: "homepage")
    private let buttonBackToHomepage = SKShapeNode(rect: CGRect(x: 0, y: 0, width: 190, height: 60), cornerRadius: 10)
    private let buttonSave = SKShapeNode(rect: CGRect(x: 0, y: 0, width: 190, height: 60), cornerRadius: 10)
    private let levelScreen = SKSpriteNode(imageNamed: "solar-system")
    var paletteItems = [Obstacle]()
    var currentObstacle: Obstacle?
    var viewController: LevelDesignerViewController?
    var zPositionCounter: CGFloat = 0
    let paletteItemInteval: CGFloat = 80
    
    var returnHomeHandler: (() -> ())?
    var addNewObstacleHandler: ((Obstacle) -> ())?
    var removeObstacleHandler: ((Int) -> (Obstacle))?
    var updateObstacleHandler: ((Int, Obstacle) -> ())?
    
    var textInput = UITextField()
    
    
    override func didMove(to view: SKView) {
        
        var startX = size.width * 0.3
        let startY = size.width * 0.125
        
        // Create a background
        
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.alpha = 0.2
        background.size = size
        addChild(background)
        background.zPosition = zPositionCounter
        zPositionCounter += 1
        
        // Create a back button
        
        buttonBackToHomepage.position = CGPoint(x: size.width * 0.03, y: size.height * 0.05)
        buttonBackToHomepage.fillColor = SKColor.clear
        buttonBackToHomepage.strokeColor = SKColor.white
        buttonBackToHomepage.lineWidth = Constants.strokeMedium
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
        
        // Create a back button
        
        buttonSave.position = CGPoint(x: size.width * 0.03, y: size.height * 0.15)
        buttonSave.fillColor = SKColor.clear
        buttonSave.strokeColor = SKColor.white
        buttonSave.lineWidth = Constants.strokeMedium
        buttonSave.zPosition = zPositionCounter
        zPositionCounter += 1
        
        let saveText = SKLabelNode(text: "Save")
        saveText.fontSize = Constants.fontSizeMedium
        saveText.fontName = Constants.titleFont
        saveText.position = CGPoint(x: buttonSave.frame.size.width * 0.5, y: buttonSave.frame.size.height * 0.25)
        buttonText.fontColor = SKColor.white
        buttonText.zPosition = zPositionCounter
        zPositionCounter += 1
        
        buttonSave.addChild(saveText)
        
        addChild(buttonSave)
        
        // Create a level name text input
        
        textInput.frame = CGRect(origin: CGPoint(x: size.width * 0.03, y: size.height * 0.05 - Constants.screenBorderMarginRatio * 2 * size.height),
                                 size: CGSize(width: 190 + Constants.screenBorderMarginRatio * size.width,
                                              height: 60 + Constants.screenBorderMarginRatio * size.height))
        textInput.font = UIFont(name: Constants.titleFont, size: Constants.fontSizeMedium)
        textInput.textColor = UIColor.white
        textInput.layer.cornerRadius = 10
        textInput.layer.borderColor = SKColor.white.cgColor
        textInput.layer.borderWidth = Constants.strokeMedium
        textInput.layer.backgroundColor = UIColor.clear.cgColor
        textInput.attributedPlaceholder = NSAttributedString(string: "Level Name",
                                                             attributes:[NSForegroundColorAttributeName: UIColor.white])
        textInput.textAlignment = .center

        self.view!.addSubview(textInput)
        
        
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
        
        paletteItems = Constants.starwarsObstacles
        for item in paletteItems {
            item.shape.size = CGSize(width: Constants.levelObstacleStandardWidth,
                                         height: Constants.getHeightWithSameRatio(withWidth: Constants.levelObstacleStandardWidth, forShape: item.shape))
            item.shape.position = CGPoint(x: startX, y: startY)
            item.shape.alpha = 1
            item.shape.zPosition = zPositionCounter
            zPositionCounter += 1
            
            addChild(item.shape)
            startX += paletteItemInteval
        }
        
        drawObstacles()
    }
    
    private func checkTouchRange(touch: UITouch, frame: CGRect) -> Bool {
        return frame.contains(touch.location(in: self))
    }
    
    private func touchPaletteItems(touch: UITouch) {
        for item in paletteItems {
            guard currentObstacle == nil else {
                return
            }
            
            if checkTouchRange(touch: touch, frame: item.shape.frame) {
                addCurrentObstacle(item)
                return
            }
        }
    }
    
    private func touchSceenItems(touch: UITouch) {
        guard let currentObstacles = self.viewController?.currentLevel.obstacles else {
            return
        }
        
        for item in currentObstacles {
            guard currentObstacle == nil else {
                return
            }
            
            if checkTouchRange(touch: touch, frame: item.shape.frame) {
                item.shape.position = translateFromLevelScreenToSelf(withPosition: item.shape.position)
                
                item.shape.removeFromParent()
                addCurrentObstacle(item)
                return
            }
        }
    }

    
    private func moveCurrentObstacle(touch: UITouch) {
        currentObstacle!.shape.position = touch.location(in: self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            self.touchPaletteItems(touch: touch)
            self.touchSceenItems(touch: touch)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard currentObstacle != nil else {
            return
        }
        print("ready for moving")
        for touch in touches {
            self.moveCurrentObstacle(touch: touch)
        }
        
        drawObstacles()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touch ended")
        
        let touch = touches.first
        let touchLocation = touch!.location(in: self)
        // Check if the location of the touch is within the button's bounds
        if buttonBackToHomepage.contains(touchLocation) {
            print("LevelDeisgner: back to homepage tapped!")
            self.removeFromParent()
            self.returnHomeHandler!()
        }
        
        if buttonSave.contains(touchLocation) {
            print("button save pressed: level name = \(textInput.text)")
        }
        
        if currentObstacle != nil {
            
            if checkTouchRange(touch: touch!, frame: levelScreen.frame) {
                if let addNewObstacle = self.addNewObstacleHandler {
                    addNewObstacle(currentObstacle!.copy())
                    removeCurrentObstacle()
                }
            } else {
                removeCurrentObstacle()
//                let scale = SKAction.scale(to: 0.1, duration: 0.5)
//                let fade = SKAction.fadeOut(withDuration: 0.5)
//                let sequence = SKAction.sequence([scale, fade])
//                
//                currentObstacle!.shape.run(sequence, completion: {
//                    self.removeCurrentObstacle()
//                })
            }
        }
        
        drawObstacles()
    }

    
    private func addCurrentObstacle(_ selectedObstacle: Obstacle) {
        guard currentObstacle == nil else {
            return
        }
        print("ready to assign current obstacle")
        currentObstacle = selectedObstacle.copy()
        currentObstacle!.shape.zPosition = Constants.currentObstacleZPosition
        addChild(currentObstacle!.shape)
        print("done assigning current obstacle")
    }
    
    private func removeCurrentObstacle() {
        guard currentObstacle != nil else {
            return
        }
        print("ready to remove current obstacle")
        currentObstacle!.shape.removeFromParent()
        currentObstacle = nil
        print("done removing current obstacle")
    }
    
    private func drawObstacles() {
        print("in drawObstacles()")
        guard let currentObstacles = self.viewController?.currentLevel.obstacles else {
            print("error: currentObstacles = nil")
            return
        }
        print("currentObstacles has \(currentObstacles) elements")
        
        levelScreen.removeAllChildren()
        
        for index in 0 ..< currentObstacles.count {
            print("obstacle \(index): \(currentObstacles[index].shape.name) at \(currentObstacles[index].shape.position)")
            let shape = currentObstacles[index].shape.copy() as! SKSpriteNode
            shape.scale(to: CGSize(width: shape.size.width * Constants.levelScreenRatio,
                                   height: shape.size.height * Constants.levelScreenRatio))
            shape.position = translateFromSelfToLevelScreen(withPosition: shape.position)
            
//            shape.zPosition = zPositionCounter
//            zPositionCounter += 1
            levelScreen.addChild(shape)
        }
    }
    
    private func translateFromSelfToLevelScreen(withPosition: CGPoint) -> CGPoint {
        let x = withPosition.x - Constants.screenCenterPositionRatio * size.width
        let y = withPosition.y - Constants.screenCenterPositionRatio * size.height
        return CGPoint(x: x, y: y)
    }
    
    private func translateFromLevelScreenToSelf(withPosition: CGPoint) -> CGPoint {
        let x = withPosition.x + Constants.screenCenterPositionRatio * size.width
        let y = withPosition.y + Constants.screenCenterPositionRatio * size.height
        return CGPoint(x: x, y: y)
    }

}

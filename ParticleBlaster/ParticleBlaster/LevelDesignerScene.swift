//
//  LevelDesignerScene.swift
//  ParticleBlaster
//
//  Created by Richthofen on 26/03/2017.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

import SpriteKit

class LevelDesignerScene: SKScene {
    
    var currentLevelBackgroundImageName: String = "solar-system"
    private let background = SKSpriteNode(imageNamed: "homepage")
    private let buttonBackToHomepage = SKShapeNode(rect: CGRect(x: 0, y: 0, width: 190, height: 60), cornerRadius: 10)
    private let buttonSave = SKShapeNode(rect: CGRect(x: 0, y: 0, width: 190, height: 60), cornerRadius: 10)
    private let buttonPreview = SKShapeNode(rect: CGRect(x: 0, y: 0, width: 190, height: 60), cornerRadius: 10)
    private let buttonTheme = SKShapeNode(rect: CGRect(x: 0, y: 0, width: 190, height: 60), cornerRadius: 10)
    private let levelScreen = SKSpriteNode()
    var paletteItems = [Obstacle]()
    var currentObstacle: Obstacle?
    var viewController: LevelDesignerViewController?
    var zPositionCounter: CGFloat = 0
    let paletteItemInteval: CGFloat = 80
    var themeSelected: String = ""

    var returnHomeHandler: (() -> ())?
    var addNewObstacleHandler: ((Obstacle) -> ())?
    var removeObstacleHandler: ((Int) -> (Obstacle))?
    var addNewPlayerHandler: ((Player) -> ())?
    var removePlayerHandler: ((Int) -> (Player))?
    var updateBackgroundImageNameHandler: ((String) -> ())?
    var saveGameLevelHandler: (() -> (Bool))?
    var previewHandler: (() -> ())?

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

        // Create a Preview button

        buttonPreview.position = CGPoint(x: size.width * 0.03, y: size.height * 0.25)
        buttonPreview.fillColor = SKColor.clear
        buttonPreview.strokeColor = SKColor.white
        buttonPreview.lineWidth = Constants.strokeMedium
        buttonPreview.zPosition = zPositionCounter
        zPositionCounter += 1

        let previewText = SKLabelNode(text: "Preview")
        previewText.fontSize = Constants.fontSizeMedium
        previewText.fontName = Constants.titleFont
        previewText.position = CGPoint(x: buttonPreview.frame.size.width * 0.5, y: buttonPreview.frame.size.height * 0.25)
        previewText.fontColor = SKColor.white
        previewText.zPosition = zPositionCounter
        zPositionCounter += 1

        buttonPreview.addChild(previewText)

        addChild(buttonPreview)

        // Create a theme section

        buttonTheme.position = CGPoint(x: size.width * 0.03, y: size.height * 0.5)
        buttonTheme.fillColor = SKColor.clear
        buttonTheme.strokeColor = SKColor.white
        buttonTheme.lineWidth = Constants.strokeMedium
        buttonTheme.zPosition = zPositionCounter
        zPositionCounter += 1

        let themeText = SKLabelNode(text: themeSelected)
        themeText.fontSize = Constants.fontSizeMedium
        themeText.fontName = Constants.titleFont
        themeText.position = CGPoint(x: buttonTheme.frame.size.width * 0.5, y: buttonTheme.frame.size.height * 0.25)
        themeText.fontColor = SKColor.white
        themeText.zPosition = zPositionCounter
        zPositionCounter += 1

        buttonTheme.addChild(themeText)

        addChild(buttonTheme)


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

        levelScreen.texture = SKTexture(imageNamed: currentLevelBackgroundImageName)
        if let updateBackground = updateBackgroundImageNameHandler {
            updateBackground(currentLevelBackgroundImageName)
        }
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
        
        for index in 0 ..< currentObstacles.count {
            let item = currentObstacles[index].copyWithoutPhysicsBody()
            item.shape.position = translateFromActualLevelToSelf(withPosition: item.shape.position)
            if checkTouchRange(touch: touch, frame: item.shape.frame) {
                if let removeObstacle = self.removeObstacleHandler {
                    addCurrentObstacle(removeObstacle(index))
                    currentObstacle!.shape.position = item.shape.position
                }
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
            print("button save pressed: level name = \(String(describing: textInput.text))")
        }
        
        if buttonPreview.contains(touchLocation) {
            print("button preview pressed")
            if let preview = self.previewHandler {
                preview()
            }
        }

        if currentObstacle != nil {
            
            if checkTouchRange(touch: touch!, frame: levelScreen.frame) {
                if let addNewObstacle = self.addNewObstacleHandler {
                    let obstacle = currentObstacle!.copyWithoutPhysicsBody()
                    obstacle.shape.position = translateFromSelfToActualLevel(withPosition: obstacle.shape.position)
                    addNewObstacle(obstacle)
                    removeCurrentObstacle()
                }
            } else {
                removeCurrentObstacle()
            }
        }
        
        drawObstacles()
    }
    
    
    private func addCurrentObstacle(_ selectedObstacle: Obstacle) {
        guard currentObstacle == nil else {
            return
        }
        print("ready to assign current obstacle")
        currentObstacle = selectedObstacle.copyWithoutPhysicsBody()
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
            print("obstacle \(index): \(String(describing: currentObstacles[index].shape.name)) at \(currentObstacles[index].shape.position)")
            let shape = currentObstacles[index].shape.copy() as! SKSpriteNode
            shape.scale(to: CGSize(width: shape.size.width * Constants.levelScreenRatio,
                                   height: shape.size.height * Constants.levelScreenRatio))
            shape.position = translateFromActualLevelToSelf(withPosition: shape.position)
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
    
    private func translateFromActualLevelToSelf(withPosition: CGPoint) -> CGPoint {
        let x = withPosition.x * Constants.levelScreenRatio + Constants.screenMin * size.width
        let y = withPosition.y * Constants.levelScreenRatio + Constants.screenMin * size.height
        return CGPoint(x: x, y: y)
    }

    private func translateFromSelfToActualLevel(withPosition: CGPoint) -> CGPoint {
        let x = (withPosition.x - Constants.screenMin * size.width) / Constants.levelScreenRatio
        let y = (withPosition.y - Constants.screenMin * size.height) / Constants.levelScreenRatio
        return CGPoint(x: x, y: y)
    }
}

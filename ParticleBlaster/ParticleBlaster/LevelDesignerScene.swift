//
//  LevelDesignerScene.swift
//  ParticleBlaster
//
//  Created by Richthofen on 26/03/2017.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

import SpriteKit

class LevelDesignerScene: SKScene {
    var gameLevel: GameLevel
    var navigationDelegate: NavigationDelegate?

    private let normalZPosition: CGFloat = 1
    private let background = SKSpriteNode(imageNamed: Constants.homepageBackgroundFilename)
    private var backButton: IconButton!
    private var saveButton: TextButton!
    private var playButton: TextButton!
    private let levelScreen = SKSpriteNode(imageNamed: Constants.gameplayBackgroundFilename)
    private var players: [Player] = []
    
    var paletteItems = [Obstacle]()
    var currentObject: GameObject?
    let paletteItemInteval: CGFloat = 80

    init(size: CGSize, gameLevel: GameLevel) {
        self.gameLevel = gameLevel
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMove(to view: SKView) {
        physicsWorld.gravity = .zero

        var startX = size.width * 0.3
        let startY = size.width * 0.125
        // Create a background
        
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.alpha = 0.2
        background.size = size
        addChild(background)
        background.zPosition = 0
        
        // Create a back button
        backButton = IconButton(imageNamed: Constants.backButtonFilename,
                                disabledImageNamed: Constants.backButtonDisabledFilename,
                                size: Constants.iconButtonDefaultSize)
        backButton.zPosition = normalZPosition
        backButton.position = CGPoint(x: Constants.screenPadding.width + backButton.size.width / 2,
                                      y: Constants.screenPadding.height + backButton.size.height / 2)
        backButton.onPressHandler = onBackButtonPressed
        addChild(backButton)
    
        // create a save button
        saveButton = TextButton(imageNamed: Constants.transparentBackgroundFilename,
                                text: Constants.labelSave,
                                size: Constants.textButtonTransparentDefaultSize)
        saveButton.zPosition = normalZPosition
        saveButton.position = CGPoint(x: Constants.screenPadding.width + saveButton.size.width / 2,
                                      y: self.size.height - Constants.screenPaddingThinner.height - saveButton.size.height / 2)
        saveButton.onPressHandler = onSaveButtonPressed
        addChild(saveButton)

        // create play button
        playButton = TextButton(imageNamed: Constants.transparentBackgroundFilename,
                                text: Constants.labelPlay,
                                size: Constants.textButtonTransparentDefaultSize)
        playButton.zPosition = normalZPosition
        playButton.position = CGPoint(x: Constants.screenPadding.width + playButton.size.width / 2,
                                      y: saveButton.position.y - saveButton.size.height/2 - Constants.screenPaddingThinner.height - playButton.size.height / 2)
        playButton.onPressHandler = onPlayButtonPressed
        addChild(playButton)

        // Create a screen shot
        let levelScreenBorder = SKShapeNode(rect: CGRect(origin: CGPoint(x: size.width * Constants.screenBorderOriginRatio,
                                                                         y: size.height * Constants.screenBorderOriginRatio),
                                                         size: CGSize(width: size.width * Constants.screenBorderSizeRatio,
                                                                      height: size.height * Constants.screenBorderSizeRatio)),
                                            cornerRadius: Constants.cornerRadius)
        levelScreenBorder.fillColor = SKColor.clear
        levelScreenBorder.strokeColor = SKColor.white
        levelScreenBorder.lineWidth = Constants.strokeMedium
        levelScreenBorder.zPosition = normalZPosition

        levelScreen.size = CGSize(width: size.width * Constants.levelScreenRatio,
                                  height: size.height * Constants.levelScreenRatio)
        levelScreen.position = CGPoint(x: size.width * Constants.screenCenterPositionRatio,
                                       y: size.height * Constants.screenCenterPositionRatio)

        levelScreen.alpha = 1
        levelScreen.zPosition = normalZPosition

        addChild(levelScreen)
        addChild(levelScreenBorder)
        
        // Create obstacle pallete
        for itemFilename in Constants.starwarsObstaclesFilename {
            let item = Obstacle(image: itemFilename, userSetInitialPosition: .zero, isPhysicsBody: false)
            item.shape.size = CGSize(width: Constants.levelObstacleStandardWidth,
                                     height: Constants.getHeightWithSameRatio(withWidth: Constants.levelObstacleStandardWidth, forShape: item.shape))
            item.shape.position = CGPoint(x: startX, y: startY)
            item.shape.alpha = 1
            item.shape.zPosition = normalZPosition
            paletteItems.append(item)
            addChild(item.shape)
            startX += paletteItemInteval
        }

        addChild(Boundary(rect: levelScreen.frame))
        drawInitialObstacles()
        preparePlayers()
    }
    
    private func checkTouchRange(touch: UITouch, frame: CGRect, inside area: SKNode) -> Bool {
        return frame.contains(touch.location(in: area))
    }

    private func isValidPlayerPosition(_ position: CGPoint, for player: Player) -> Bool {
        let node = player.shape
        return position.x - node.frame.size.width / 2 >= -levelScreen.frame.size.width / 2
            && position.x + node.frame.size.width / 2 <= levelScreen.frame.size.width / 2
            && position.y - node.frame.size.height / 2 >= -levelScreen.frame.size.height / 2
            && position.y + node.frame.size.height / 2 <= levelScreen.frame.size.height / 2
    }
    
    private func touchPaletteItems(touch: UITouch) {
        for item in paletteItems {
            if checkTouchRange(touch: touch, frame: item.shape.frame, inside: self) {
                addcurrentObject(item, at: touch.location(in: self))
                return
            }
        }
    }
    
    private func touchSceenItems(touch: UITouch) {
        for (index, item) in gameLevel.obstacles.enumerated() {
            if checkTouchRange(touch: touch, frame: item.shape.frame, inside: levelScreen) {
                item.shape.removeFromParent()
                addcurrentObject(item, at: touch.location(in: self))
                gameLevel.removeObstacle(at: index)
                return
            }
        }
        // special case, we use the player itself instead of making a copy
        for player in players {
            if checkTouchRange(touch: touch, frame: player.shape.frame, inside: levelScreen) {
                currentObject = player
                return
            }
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard currentObject == nil, let touch = touches.first else {
            return
        }
        self.touchPaletteItems(touch: touch)
        self.touchSceenItems(touch: touch)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard currentObject != nil, let touch = touches.first else {
            return
        }
        if let player = currentObject as? Player {
            if !isValidPlayerPosition(touch.location(in: levelScreen), for: player) {
                // if player is moving outside the levelScreen, then stop moving it
                currentObject = nil
                return
            }
            currentObject!.shape.position = touch.location(in: levelScreen)
            return
        }
        currentObject!.shape.position = touch.location(in: self)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        
        if let obstacle = currentObject as? Obstacle {
            if checkTouchRange(touch: touch, frame: levelScreen.frame, inside: self) {
                let obstacle = obstacle.copy() as! Obstacle
                gameLevel.addObstacle(obstacle)
                obstacle.setupPhysicsProperty()
                drawObstacle(obstacle)
                removecurrentObject(withAnimation: false)
            } else {
                removecurrentObject(withAnimation: true)
            }
        }
        currentObject = nil
    }

    private func removeWithAnimation(_ node: SKNode) {
        let scaleAction = SKAction.scale(to: 0.1, duration: 0.2)
        scaleAction.timingMode = .easeOut
        node.run(SKAction.sequence([scaleAction, SKAction.removeFromParent()]))
    }

    private func addcurrentObject(_ selectedObstacle: Obstacle, at position: CGPoint) {
        guard currentObject == nil else {
            return
        }
        let obstacle = selectedObstacle.copy() as! Obstacle
        obstacle.shape.zPosition = normalZPosition + 1
        obstacle.shape.position = position
        obstacle.shape.size = CGSize(width: Constants.levelObstacleStandardWidth,
                                     height: Constants.getHeightWithSameRatio(withWidth: Constants.levelObstacleStandardWidth, forShape: obstacle.shape))
        addChild(obstacle.shape)
        currentObject = obstacle
    }
    
    private func removecurrentObject(withAnimation: Bool) {
        guard currentObject != nil else {
            return
        }
        if withAnimation {
            removeWithAnimation(currentObject!.shape)
        } else {
            currentObject!.shape.removeFromParent()
        }
        currentObject = nil
    }
    
    private func drawInitialObstacles() {
        levelScreen.removeAllChildren()
        for obstacle in gameLevel.obstacles {
            obstacle.shape.size = CGSize(width: Constants.levelObstacleStandardWidth,
                                         height: Constants.getHeightWithSameRatio(withWidth: Constants.levelObstacleStandardWidth, forShape: obstacle.shape))
            obstacle.setupPhysicsProperty()
            obstacle.shape.position = ratioPositionToLevelScreenPosition(obstacle.initialPosition)
            drawObstacle(obstacle, shouldTranslatePosition: false)
        }
    }

    private func drawObstacle(_ obstacle: Obstacle, shouldTranslatePosition: Bool = true) {
        let shape = obstacle.shape
        shape.scale(to: CGSize(width: shape.size.width * Constants.levelScreenRatio,
                               height: shape.size.height * Constants.levelScreenRatio))
        if shouldTranslatePosition {
            shape.position = translateFromSelfToLevelScreen(shape.position)
        }
        shape.zPosition = normalZPosition
        levelScreen.addChild(shape)
    }

    private func preparePlayers() {
        let player1 = Player(image: "\(Constants.playerFilenamePrefix)1")
        player1.shape.scale(to: CGSize(width: player1.shape.size.width * Constants.levelScreenRatio,
                                       height: player1.shape.size.width * Constants.levelScreenRatio))
        player1.setupPhysicsProperty()
        player1.shape.physicsBody?.allowsRotation = false
        if gameLevel.playerPositions.count > 0 {
            player1.shape.position = ratioPositionToLevelScreenPosition(gameLevel.playerPositions[0])
        } else {
            player1.shape.position = CGPoint(x: -levelScreen.frame.size.width/2 + player1.shape.size.width/2, y: 0)
        }
        players.append(player1)

        if gameLevel.gameMode == .multiple {
            let player2 = Player(image: "\(Constants.playerFilenamePrefix)2")
            player2.shape.scale(to: CGSize(width: player2.shape.size.width * Constants.levelScreenRatio,
                                           height: player2.shape.size.width * Constants.levelScreenRatio))
            player2.setupPhysicsProperty()
            player2.shape.physicsBody?.allowsRotation = false
            
            if gameLevel.playerPositions.count > 1 {
                player2.shape.position = ratioPositionToLevelScreenPosition(gameLevel.playerPositions[1])
            } else {
                player2.shape.position = CGPoint(x: levelScreen.frame.size.width/2 - player2.shape.size.width/2, y: 0)
            }
            players.append(player2)
        }

        for player in players {
            player.shape.zPosition = normalZPosition + 1
            levelScreen.addChild(player.shape)
        }
    }

    /// Convert the current designing level to standard format game level
    private func convertToStandardLevel() -> GameLevel {
        let level = GameLevel(id: gameLevel.id, gameMode: gameLevel.gameMode)
        for player in players {
            level.playerPositions.append(levelScreenPositionToRatioPosition(player.shape.position))
        }
        for obstacle in gameLevel.obstacles {
            let obstacleClone = obstacle.copy() as! Obstacle
            obstacleClone.initialPosition = levelScreenPositionToRatioPosition(obstacle.shape.position)
            level.addObstacle(obstacleClone)
        }
        return level
    }
    
    private func onBackButtonPressed() {
        self.navigationDelegate?.navigateToLevelSelectScene(gameMode: gameLevel.gameMode)
    }

    private func onSaveButtonPressed() {
        let level = convertToStandardLevel()
        let _ = GameData.getInstance().saveLevel(level)
    }

    private func onPlayButtonPressed() {
        let level = convertToStandardLevel()
        self.navigationDelegate?.navigateToPlayScene(gameLevel: level)
    }

    private func levelScreenPositionToRatioPosition(_ position: CGPoint) -> CGPoint {
        let sWidth = levelScreen.frame.size.width
        let sHeight = levelScreen.frame.size.height
        let translatedX = position.x + sWidth/2
        let translatedY = position.y + sHeight/2
        return CGPoint(x: translatedX / sWidth, y: translatedY / sHeight)
    }

    private func ratioPositionToLevelScreenPosition(_ position: CGPoint) -> CGPoint {
        let sWidth = levelScreen.frame.size.width
        let sHeight = levelScreen.frame.size.height
        let translatedX = position.x * sWidth - sWidth/2
        let translatedY = position.y * sHeight - sHeight/2
        return CGPoint(x: translatedX, y: translatedY)
    }
    
    private func translateFromSelfToLevelScreen(_ position: CGPoint) -> CGPoint {
        let x = position.x - Constants.screenCenterPositionRatio * size.width
        let y = position.y - Constants.screenCenterPositionRatio * size.height
        return CGPoint(x: x, y: y)
    }
    
    private func translateFromLevelScreenToSelf(_ position: CGPoint) -> CGPoint {
        let x = position.x + Constants.screenCenterPositionRatio * size.width
        let y = position.y + Constants.screenCenterPositionRatio * size.height
        return CGPoint(x: x, y: y)
    }
    
}

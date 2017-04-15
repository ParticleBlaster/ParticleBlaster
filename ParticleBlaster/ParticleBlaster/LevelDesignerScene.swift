//
//  LevelDesignerScene.swift
//  ParticleBlaster
//
//  Created by Richthofen on 26/03/2017.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

import SpriteKit

/// MARK: Logic related part
class LevelDesignerScene: SKScene {
    var gameLevel: GameLevel
    var navigationDelegate: NavigationDelegate?

    fileprivate let normalZPosition: CGFloat = 1
    fileprivate let background = SKSpriteNode(imageNamed: Constants.homepageBackgroundFilename)
    fileprivate var backButton: IconButton!
    fileprivate var saveButton: TextButton!
    fileprivate var playButton: TextButton!
    fileprivate var levelScreen = SKSpriteNode()
    fileprivate var players: [Player] = []
    fileprivate var currentTheme: Theme!
    fileprivate var shouldSaveButtonBeEnabled: Bool = false
    
    var paletteItems = [Obstacle]()
    var currentObject: GameObject?

    init(size: CGSize, gameLevel: GameLevel) {
        self.gameLevel = gameLevel
        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMove(to view: SKView) {
        physicsWorld.gravity = .zero
        
        initTheme()
        initLayout()
        initPalette()
        initLevelScreen()
        initThemeList()
        backButton.onPressHandler = onBackButtonPressed
        saveButton.onPressHandler = onSaveButtonPressed
        playButton.onPressHandler = onPlayButtonPressed

        drawInitialObstacles()
        preparePlayers()
    }

    private func isTouchInside(touch: UITouch, frame: CGRect, inside area: SKNode) -> Bool {
        return frame.contains(touch.location(in: area))
    }

    private func validatePlayerPosition(_ position: CGPoint, for player: Player) -> CGPoint {
        let node = player.shape
        var x = position.x
        var y = position.y
        x = max(x, -levelScreen.frame.size.width / 2 + node.frame.size.width / 2)
        x = min(x, levelScreen.frame.size.width / 2 - node.frame.size.width / 2)
        y = max(y, -levelScreen.frame.size.height / 2 + node.frame.size.height / 2)
        y = min(y, levelScreen.frame.size.height / 2 - node.frame.size.height / 2)
        return CGPoint(x: x, y: y)
    }

    private func touchPaletteItems(touch: UITouch) {
        guard gameLevel.obstacleCount < Constants.maxNumOfObstacle else {
            return
        }
        for item in paletteItems {
            if isTouchInside(touch: touch, frame: item.shape.frame, inside: self) {
                addcurrentObject(item, at: touch.location(in: self))
                return
            }
        }
    }

    private func touchSceenItems(touch: UITouch) {
        for (index, item) in gameLevel.obstacles.enumerated() {
            if isTouchInside(touch: touch, frame: item.shape.frame, inside: levelScreen) {
                item.shape.removeFromParent()
                addcurrentObject(item, at: touch.location(in: self))
                gameLevel.removeObstacle(at: index)
                return
            }
        }
        // we use the player itself instead of making a copy, and will not allow user to move these players out of level screen
        for player in players {
            if isTouchInside(touch: touch, frame: player.shape.frame, inside: levelScreen) {
                currentObject = player
                return
            }
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard currentObject == nil, let touch = touches.first else {
            return
        }
        shouldSaveButtonBeEnabled = false
        self.touchPaletteItems(touch: touch)
        self.touchSceenItems(touch: touch)
        if self.checkTouchRange(touch: touch, frame: self.levelScreen.frame) {
            shouldSaveButtonBeEnabled = true
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard currentObject != nil, let touch = touches.first else {
            return
        }
        if let player = currentObject as? Player {
            let validatedPosition = validatePlayerPosition(touch.location(in: levelScreen), for: player)
            currentObject!.shape.position = validatedPosition
            return
        }
        currentObject!.shape.position = touch.location(in: self)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        
        if self.checkTouchRange(touch: touch, frame: self.levelScreen.frame) {
            shouldSaveButtonBeEnabled = true
        }
        
        if let obstacle = currentObject as? Obstacle {
            if isTouchInside(touch: touch, frame: levelScreen.frame, inside: self) {
                let obstacle = obstacle.copy() as! Obstacle
                gameLevel.addObstacle(obstacle)
                obstacle.setupPhysicsProperty()
                drawObstacle(obstacle)
                removecurrentObject(withAnimation: false)
            } else {
                removecurrentObject(withAnimation: true)
            }

            if shouldSaveButtonBeEnabled {
                self.saveButton.isPositive = true
                self.saveButton.isEnabled = true
            }
        }
        currentObject = nil
        removeOutsideObstacles()
    }
    
    private func checkTouchRange(touch: UITouch, frame: CGRect) -> Bool {
        let location = touch.location(in: self)
        if frame.contains(location) {
            return true
        } else {
            return false
        }
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
        // as ratio change, need to reset to size of obstacle
        obstacle.setupShape(withPhysicsBody: false)
        obstacle.shape.zPosition = normalZPosition + 1
        obstacle.shape.position = position
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

    private func removeOutsideObstacles() {
        for (index, obstacle) in gameLevel.obstacles.enumerated().reversed() {
            let position = obstacle.shape.position
            guard position.x <= -levelScreen.frame.size.width/2
                || position.x >= levelScreen.frame.size.width/2
                || position.y <= -levelScreen.frame.size.height/2
                || position.y >= levelScreen.frame.size.height/2 else {
                continue
            }
            gameLevel.obstacles.remove(at: index)
            removeWithAnimation(obstacle.shape)
        }
    }

    /// Convert the current designing level to standard format game level
    private func convertToStandardLevel() -> GameLevel {
        let level = GameLevel(id: gameLevel.id, gameMode: gameLevel.gameMode)
        for player in players {
            let copiedPlayer = player.copy() as! Player
            copiedPlayer.ratioPosition = levelScreenPositionToRatioPosition(player.shape.position)
            level.players.append(copiedPlayer)
        }
        for obstacle in gameLevel.obstacles {
            let obstacleClone = obstacle.copy() as! Obstacle
            obstacleClone.initialPosition = levelScreenPositionToRatioPosition(obstacle.shape.position)
            obstacleClone.setupShape()
            level.addObstacle(obstacleClone)
        }
        level.backgroundImageName = gameLevel.backgroundImageName
        level.themeName = gameLevel.themeName
        return level
    }

    private func onBackButtonPressed() {
        self.navigationDelegate?.navigateToLevelSelectScene(gameMode: gameLevel.gameMode)
    }

    private func onSaveButtonPressed() {
        self.saveButton.isPositive = false
        self.saveButton.isEnabled = false
        let level = convertToStandardLevel()
        let _ = GameData.getInstance().saveLevel(level)
    }

    private func onPlayButtonPressed() {
        let level = convertToStandardLevel()
        self.navigationDelegate?.navigateToPlayScene(gameLevel: level)
    }

    fileprivate func levelScreenPositionToRatioPosition(_ position: CGPoint) -> CGPoint {
        let sWidth = levelScreen.frame.size.width
        let sHeight = levelScreen.frame.size.height
        let translatedX = position.x + sWidth/2
        let translatedY = position.y + sHeight/2
        return CGPoint(x: translatedX / sWidth, y: translatedY / sHeight)
    }

    fileprivate func ratioPositionToLevelScreenPosition(_ position: CGPoint) -> CGPoint {
        let sWidth = levelScreen.frame.size.width
        let sHeight = levelScreen.frame.size.height
        let translatedX = position.x * sWidth - sWidth/2
        let translatedY = position.y * sHeight - sHeight/2
        return CGPoint(x: translatedX, y: translatedY)
    }

    fileprivate func translateFromSelfToLevelScreen(_ position: CGPoint) -> CGPoint {
        let x = position.x - Constants.screenCenterPositionRatio * size.width
        let y = position.y - Constants.screenCenterPositionRatio * size.height
        return CGPoint(x: x, y: y)
    }

    fileprivate func translateFromLevelScreenToSelf(_ position: CGPoint) -> CGPoint {
        let x = position.x + Constants.screenCenterPositionRatio * size.width
        let y = position.y + Constants.screenCenterPositionRatio * size.height
        return CGPoint(x: x, y: y)
    }
}

/// MARK: Viewing related part
extension LevelDesignerScene {
    fileprivate func initLayout() {
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.alpha = Constants.normalBlurAlpha
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
        addChild(backButton)

        // create a save button
        saveButton = TextButton(imageNamed: Constants.backgroundButtonLargeFilename,
                                disabledImageNamed: Constants.backgroundButtonDisabledLargeFilename,
                                text: Constants.labelSave,
                                size: Constants.textButtonTransparentDefaultSize)

        saveButton.zPosition = normalZPosition
        saveButton.position = CGPoint(x: Constants.screenPadding.width + saveButton.size.width / 2,
                                      y: self.size.height - Constants.screenPaddingThinner.height - saveButton.size.height / 2)
        addChild(saveButton)

        // create play button
        playButton = TextButton(imageNamed: Constants.backgroundButtonLargeFilename,
                                text: Constants.labelPlay,
                                size: Constants.textButtonTransparentDefaultSize)
        playButton.zPosition = normalZPosition
        playButton.position = CGPoint(x: Constants.screenPadding.width + playButton.size.width / 2,
                                      y: saveButton.position.y - saveButton.size.height/2 - Constants.screenPaddingThinner.height - playButton.size.height / 2)
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
        addChild(Boundary(rect: levelScreen.frame))
    }

    fileprivate func initPalette() {
        for item in paletteItems {
            item.shape.removeFromParent()
        }
        paletteItems.removeAll()

        var posX = size.width - Constants.obstaclePadding.width
        let posY = levelScreen.frame.minY/2
        // Create obstacle pallete
        for itemFilename in currentTheme.obstaclesNames.reversed() {
            let item = Obstacle(image: itemFilename, userSetInitialPosition: .zero)
            item.shape.position = CGPoint(x: posX - item.shape.size.width/2, y: posY)
            // remove physicBody
            item.shape.physicsBody = nil
            item.shape.alpha = 1
            item.shape.zPosition = normalZPosition
            paletteItems.append(item)
            addChild(item.shape)
            posX -= item.shape.size.width
        }
    }

    fileprivate func initLevelScreen() {
        levelScreen.texture = SKTexture(imageNamed: currentTheme.backgroundName)
        gameLevel.backgroundImageName = currentTheme.backgroundName
    }

    fileprivate func initThemeList() {
        var yValue = playButton.position.y - saveButton.size.height/2 - Constants.screenPaddingThinner.height - playButton.size.height / 2 - 30
        // Create obstacle pallete
        for key in ThemeConfig.themeNames {
            let value = ThemeConfig.themes[key]!
            let themeIconImageName = value.iconName
            let themeIcon = IconButton(imageNamed: themeIconImageName,
                                    disabledImageNamed: themeIconImageName,
                                    size: CGSize(width: 150,
                                                 height: Constants.getHeightWithSameRatio(withWidth: 150,
                                                                                          forShape: SKSpriteNode(imageNamed: themeIconImageName))))
            themeIcon.zPosition = normalZPosition
            themeIcon.position = CGPoint(x: Constants.screenPadding.width + playButton.size.width / 2,
                                         y: yValue)
            themeIcon.tag = key
            themeIcon.onPressHandlerWithTag = loadTheme
            yValue -= 50 + themeIcon.size.height * 0.5
            addChild(themeIcon)
        }
    }

    fileprivate func initTheme() {
        print("initTheme: gameLevel.themeName = \(gameLevel.themeName)")
        currentTheme = ThemeConfig.themes[gameLevel.themeName]
    }
    
    fileprivate func loadTheme(_ name: String?) {
        guard name != gameLevel.themeName else {
            return
        }
        
        gameLevel.themeName = name!
        currentTheme = ThemeConfig.themes[name!]
        initPalette()
        clearAllObstaclesFromLevelScreen()
        initLevelScreen()
        clearAllSpaceshipsFromLevelScreen()
        preparePlayers()
    }

    fileprivate func clearAllObstaclesFromLevelScreen() {
        for item in gameLevel.obstacles {
            item.shape.removeFromParent()
        }
        gameLevel.removeAllObstacle()
    }
    
    fileprivate func clearAllSpaceshipsFromLevelScreen() {
        for item in gameLevel.players {
            item.shape.removeFromParent()
        }
        gameLevel.players.removeAll()
    }
    
    fileprivate func preparePlayers() {
        for player in players {
            player.shape.removeFromParent()
        }
        players.removeAll()
        
        var player1: Player
        if gameLevel.players.count > 0 {
            player1 = gameLevel.players[0]
            player1.shape.position = ratioPositionToLevelScreenPosition(player1.ratioPosition)
        } else {
            player1 = Player(image: currentTheme.spaceshipsNames[0])
            player1.shape.position = ratioPositionToLevelScreenPosition(Constants.defaultFirstPlayerPositionRatio)
        }
        let player1Width = player1.shape.size.width * Constants.levelScreenRatio
        player1.shape.scale(to: CGSize(width: player1Width,
                                       height: Constants.getHeightWithSameRatio(withWidth: player1Width, forShape: player1.shape)))
        player1.shape.physicsBody?.allowsRotation = false
        players.append(player1)

        if gameLevel.gameMode == .multiple {
            var player2: Player
            if gameLevel.players.count > 1 {
                player2 = gameLevel.players[1]
                player2.shape.position = ratioPositionToLevelScreenPosition(player2.ratioPosition)
            } else {
                player2 = Player(image: currentTheme.spaceshipsNames[1])
                player2.shape.position = ratioPositionToLevelScreenPosition(Constants.defaultSecondPlayerPositionRatio)
            }
            let player2Width = player2.shape.size.width * Constants.levelScreenRatio
            player2.shape.scale(to: CGSize(width: player2Width,
                                           height: Constants.getHeightWithSameRatio(withWidth: player2Width, forShape: player2.shape)))
            player2.shape.physicsBody?.allowsRotation = false
            players.append(player2)
        }

        for player in players {
            player.shape.zPosition = normalZPosition + 1
            levelScreen.addChild(player.shape)
            gameLevel.players.append(player)
        }
    }

    fileprivate func drawInitialObstacles() {
        levelScreen.removeAllChildren()
        for obstacle in gameLevel.obstacles {
            obstacle.setupPhysicsProperty()
            obstacle.shape.position = ratioPositionToLevelScreenPosition(obstacle.initialPosition)
            drawObstacle(obstacle, shouldTranslatePosition: false)
        }
    }

    fileprivate func drawObstacle(_ obstacle: Obstacle, shouldTranslatePosition: Bool = true) {
        let shape = obstacle.shape
        shape.scale(to: CGSize(width: shape.size.width * Constants.levelScreenRatio,
                               height: shape.size.height * Constants.levelScreenRatio))
        if shouldTranslatePosition {
            shape.position = translateFromSelfToLevelScreen(shape.position)
        }
        shape.zPosition = normalZPosition
        levelScreen.addChild(shape)
    }
}

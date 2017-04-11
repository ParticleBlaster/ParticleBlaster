//
//  LevelSelectScene.swift
//  ParticleBlaster
//
//  Created by Bui Hiep on 24/3/17.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//
import SpriteKit

class LevelSelectScene: SKScene {
    var navigationDelegate: NavigationDelegate?
    private var gameData: GameData
    private var gameMode: GameMode

    private let modal = SKNode()
    private var background: SKSpriteNode!
    private var backButton: IconButton!
    private var preButton: IconButton!
    private var nextButton: IconButton!
    private let gridLayer = SKNode()
    private var levelBoxList = [SKNode]()
    private var currentPage: Int = -1 {
        didSet {
            guard oldValue != currentPage else {
                return
            }
            self.reloadLevelPage()
            self.updatePaginationButtons()
        }
    }

    private let levelBoxSize = CGSize(width: 120, height: 120)
    private let numRows = 4
    private let numCols = 4
    private let levelBoxMargin: CGFloat = 25

    init(size: CGSize, gameMode: GameMode = .single) {
        self.gameMode = gameMode
        self.gameData = GameData.getInstance()
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)

        background = SKSpriteNode(imageNamed: Constants.homepageBackgroundFilename)
        preButton = IconButton(imageNamed: Constants.upwardButtonFilename,
                               disabledImageNamed: Constants.upwardButtonDisabledFilename,
                               size: Constants.iconButtonDefaultSize)
        
        nextButton = IconButton(imageNamed: Constants.downwardButtonFilename,
                                disabledImageNamed: Constants.downwardButtonDisabledFilename,
                                size: Constants.iconButtonDefaultSize)
        
        backButton = IconButton(imageNamed: Constants.backButtonFilename,
                                disabledImageNamed: Constants.backButtonDisabledFilename,
                                size: Constants.iconButtonDefaultSize)
        background.position = .zero
        background.zPosition = 0
        backButton.zPosition = 1
        background.size = size
        backButton.position = CGPoint(x: -(self.size.width / 2 - Constants.screenPadding.width - backButton.size.width / 2),
                                      y: -(self.size.height / 2 - Constants.screenPadding.height - backButton.size.height / 2))
        nextButton.zPosition = 1
        nextButton.position = CGPoint(x: self.size.width / 2 - Constants.screenPadding.width - nextButton.size.width / 2,
                                      y: -(self.size.height / 2 - Constants.screenPadding.height - nextButton.size.height / 2))
        preButton.zPosition = 1
        preButton.position = CGPoint(x: nextButton.position.x,
                                     y: nextButton.position.y + preButton.size.height / 2 + Constants.buttonVerticalMargin + nextButton.size.height / 2)
        
        backButton.onPressHandler = self.backButtonPressed
        preButton.onPressHandler = self.preButtonPressed
        nextButton.onPressHandler = self.nextButtonPressed
        addChild(background)
        addChild(preButton)
        addChild(nextButton)
        addChild(backButton)
        
        prepareGrid()
    }

    private func prepareGrid() {
        gridLayer.position = CGPoint(x: -(CGFloat(numCols) * levelBoxSize.width + levelBoxMargin * CGFloat(numCols - 1)) / 2,
                                     y: -(CGFloat(numRows) * levelBoxSize.height + levelBoxMargin * CGFloat(numRows - 1)) / 2)
        gridLayer.zPosition = 1
        addChild(gridLayer)
        let levelCount = gameMode == .single ? gameData.numSingleModeLevel : gameData.numMultiModeLevel
        
        for index in 0..<levelCount {
            var levelBox: SKNode
            if gameMode == .multiple || index <= gameData.achievedSingleModeLevel + 1 {
                let button = TextButton(imageNamed: Constants.backgroundButtonFilename,
                                      text: "\(index + 1)", size: levelBoxSize)
                button.onPressHandler = self.onLevelBoxPressed(levelIndex: index)
                levelBox = button
            } else {
                let button = IconButton(imageNamed: Constants.lockButtonFilename, disabledImageNamed: nil, size: levelBoxSize)
                button.isEnabled = false
                levelBox = button
            }
            levelBox.zPosition = 1
            levelBox.position = pointFor(levelIndex: index)
            levelBoxList.append(levelBox)
        }

        // if multiple mode selector, allow user to add new level
        // TODO: Change back to using if statement
        // if gameMode == .multiple {
            let button = IconButton(imageNamed: Constants.addButtonFilename, disabledImageNamed: nil, size: levelBoxSize)
            button.onPressHandler = self.addButtonPressed
            button.position = pointFor(levelIndex: levelBoxList.count)
            levelBoxList.append(button)
        // }
        currentPage = 0
    }

    private func reloadLevelPage() {
        gridLayer.removeAllChildren()
        let startIndex = currentPage * numRows * numCols
        let endIndex = min(startIndex + numRows * numCols, levelBoxList.count)
        for index in startIndex..<endIndex {
            gridLayer.addChild(levelBoxList[index])
        }
    }

    private func pointFor(levelIndex index: Int) -> CGPoint {
        let mIndex = index % (numRows * numCols)
        let row = mIndex / numCols
        let col = mIndex % numCols
        return CGPoint(x: CGFloat(col) * (levelBoxSize.width + levelBoxMargin) + levelBoxSize.width / 2,
                       y: CGFloat(numRows - 1 - row) * (levelBoxSize.height + levelBoxMargin) + levelBoxSize.height / 2)
    }

    private func backButtonPressed() {
        navigationDelegate?.navigateToHomePage()
    }

    private func updatePaginationButtons() {
        if currentPage == 0 {
            preButton.isEnabled = false
            preButton.isPositive = false
        } else {
            preButton.isEnabled = true
            preButton.isPositive = true
        }
        var maxPageNumber = levelBoxList.count / (numRows * numCols)
        if levelBoxList.count % (numRows * numCols) > 0 {
            maxPageNumber += 1
        }
        if currentPage == maxPageNumber - 1 {
            nextButton.isEnabled = false
            nextButton.isPositive = false
        } else {
            nextButton.isEnabled = true
            nextButton.isPositive = true
        }
    }

    /// Draw screen shot of game level for previewing
    private func previewGameLevel(for gameLevel: GameLevel) {
        modal.removeAllChildren()
        let maskLayer = SKSpriteNode()
        maskLayer.color = .black
        maskLayer.size = self.size
        maskLayer.alpha = 0.5
        maskLayer.zPosition = Constants.zPositionModal
        maskLayer.position = .zero

        let levelScreen = SKSpriteNode(imageNamed: gameLevel.backgroundImageName!)
        levelScreen.size = CGSize(width: size.width * Constants.levelScreenPreviewRatio,
                                  height: size.height * Constants.levelScreenPreviewRatio)
        levelScreen.position = .zero
        levelScreen.zPosition = Constants.zPositionModal + 1
        levelScreen.alpha = 1
        // add obstacles to preview
        for obstacle in gameLevel.obstacles {
            let shape = obstacle.shape.copy() as! SKSpriteNode
            shape.physicsBody = nil
            shape.size = CGSize(width: shape.size.width * Constants.levelScreenPreviewRatio,
                                height: shape.size.height * Constants.levelScreenPreviewRatio)
            shape.position = ratioPositionToLevelScreenPosition(obstacle.initialPosition, in: levelScreen)
            shape.zPosition = Constants.zPositionModal + 2
            levelScreen.addChild(shape)
        }
        // add players to preview
        for player in gameLevel.players {
            let shape = player.shape.copy() as! SKSpriteNode
            shape.physicsBody = nil
            shape.size = CGSize(width: shape.size.width * Constants.levelScreenPreviewRatio,
                                height: shape.size.height * Constants.levelScreenPreviewRatio)
            shape.position = ratioPositionToLevelScreenPosition(player.ratioPosition, in: levelScreen)
            shape.zPosition = Constants.zPositionModal + 2
            levelScreen.addChild(shape)
        }

        // Add action buttons for the modal
        let cancelButton = TextButton(imageNamed: Constants.transparentBackgroundFilename,
                                      text: Constants.labelCancel,
                                      size: Constants.textButtonTransparentDefaultSize)
        let playButton = TextButton(imageNamed: Constants.transparentBackgroundFilename,
                                    text: Constants.labelPlay,
                                    size: Constants.textButtonTransparentDefaultSize)
        modal.addChild(cancelButton)
        modal.addChild(playButton)
        cancelButton.zPosition = Constants.zPositionModal + 1
        playButton.zPosition = Constants.zPositionModal + 1
        cancelButton.onPressHandler = self.cancelButtonPressed
        playButton.onPressHandler = self.playButtonPressed(gameLevel: gameLevel)
        // TODO: change back to distinguish between multiple and single mode
//        if gameLevel.gameMode == .multiple {
            playButton.position = CGPoint(x: 0, y: -levelScreen.frame.size.height/2 - playButton.size.height/2)
//        } else {
//            playButton.position = CGPoint(x: playButton.size.width/2,
//                                          y: -levelScreen.frame.size.height/2 - playButton.size.height/2)
//        }
        cancelButton.position = CGPoint(x: playButton.position.x - playButton.size.width/2 - cancelButton.size.width / 2,
                                        y: -levelScreen.frame.size.height/2 - cancelButton.size.height/2)
//        if gameLevel.gameMode == .multiple {
            let editButton = TextButton(imageNamed: Constants.transparentBackgroundFilename,
                                        text: Constants.labelEdit,
                                        size: Constants.textButtonTransparentDefaultSize)
            editButton.onPressHandler = self.editButtonPressed(gameLevel: gameLevel)
            modal.addChild(editButton)
            editButton.position = CGPoint(x: playButton.position.x + playButton.size.width/2 + editButton.size.width / 2,
                                          y: -levelScreen.frame.size.height/2 - editButton.size.height/2)
            editButton.zPosition = Constants.zPositionModal + 1
//        }
        modal.addChild(maskLayer)
        modal.addChild(levelScreen)
        addChild(modal)
    }

    private func ratioPositionToLevelScreenPosition(_ position: CGPoint, in layer: SKNode) -> CGPoint {
        let sWidth = layer.frame.size.width
        let sHeight = layer.frame.size.height
        let translatedX = position.x * sWidth - sWidth/2
        let translatedY = position.y * sHeight - sHeight/2
        return CGPoint(x: translatedX, y: translatedY)
    }

    private func playButtonPressed(gameLevel: GameLevel) -> (() -> Void) {
        return {
            self.cancelButtonPressed()
            self.navigationDelegate?.navigateToPlayScene(gameLevel: gameLevel)
        }
    }

    private func editButtonPressed(gameLevel: GameLevel) -> (() -> Void) {
        return {
            self.cancelButtonPressed()
            self.navigationDelegate?.navigateToDesignScene(gameLevel: gameLevel)
        }
    }

    private func cancelButtonPressed() {
        self.modal.removeFromParent()
    }
    
    private func addButtonPressed() {
        let gameLevel = gameData.createLevel(gameMode: gameMode)
        self.navigationDelegate?.navigateToDesignScene(gameLevel: gameLevel)
    }

    private func preButtonPressed() {
        currentPage -= 1
    }

    private func nextButtonPressed() {
        currentPage += 1
    }

    private func onLevelBoxPressed(levelIndex: Int) -> (() -> Void) {
        return {
            guard let gameLevel = FileUtils.loadGameLevel(id: levelIndex, gameMode: self.gameMode) else {
                return
            }
            self.previewGameLevel(for: gameLevel)
        }
    }
}

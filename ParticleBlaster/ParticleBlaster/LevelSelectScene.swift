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

    // TODO: passing level list, for now just hard-coded
    private var levelList = Array(repeating: 0, count: 40)
    private var userLevelIndex = 10
    
    private let levelBoxSize = CGSize(width: 120, height: 120)
    private let numRows = 4
    private let numCols = 4
    private let levelBoxMargin: CGFloat = 25

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
        for (index, _) in levelList.enumerated() {
            var levelBox: SKNode
            if index <= userLevelIndex {
                let button = TextButton(imageNamed: Constants.backgroundButtonFilename,
                                      text: "\(index)", size: levelBoxSize)
                button.onPressHandler = self.onLevelBoxPressed(level: index)
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
        var maxPageNumber = levelList.count / (numRows * numCols)
        if levelList.count % (numRows * numCols) > 0 {
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

    private func preButtonPressed() {
        currentPage -= 1
    }

    private func nextButtonPressed() {
        currentPage += 1
    }

    private func onLevelBoxPressed(level: Int) -> (() -> Void) {
        return {
            self.navigationDelegate?.navigateToPlayScene(isSingleMode: true)
        }
    }
}

//
//  GameViewController.swift
//  ParticleBlaster
//
//  Created by Bohan Huang on 12/3/17.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import GameKit

class GameViewController: UIViewController, SKPhysicsContactDelegate {

    var navigationDelegate: NavigationDelegate?
    var gameLevel: GameLevel!

    // Initialise game scene for displaying game objects
    var scene: GameScene!
    var skView: SKView!
    var pauseNode: GamePauseNode!

    // Initialise game logic for controlling game objects
    var gameLogic: GameLogic!

    // Initialised score related supporting attributes
    var startTime: DispatchTime!
    var currLevelObtainedScore: Int = 0

    /* Start of UIViewController related methods */

    override func viewDidLoad() {
        super.viewDidLoad()

        Constants.initializeJoystickInfo(viewSize: view.bounds.size)
        SinglePlayerViewParams.initializeJoystickInfo(viewSize: view.bounds.size)
        MultiPlayerViewParams.initializeJoystickInfo(viewSize: view.bounds.size)

        var obstaclesCopy = [Obstacle]()
        for obs in self.gameLevel.obstacles {
            obstaclesCopy.append(obs.copy() as! Obstacle)
        }

        if gameLevel.gameMode == .single {
            print("it is single")
            self.scene = SinglePlayerGameScene(size: view.bounds.size)
            self.scene.setupBackground(backgroundImageName: self.gameLevel.backgroundImageName)
            self.gameLogic = SinglePlayerGameLogic(gameViewController: self, obstaclePool: obstaclesCopy, player: gameLevel.players[0])
        } else {
            print("it is multi")
            self.scene = MultiplayerGameScene(size: view.bounds.size)
            self.scene.setupBackground(backgroundImageName: self.gameLevel.backgroundImageName)
            self.gameLogic = MultiplayerGameLogic(gameViewController: self, obstaclePool: obstaclesCopy, players: gameLevel.players)
        }

        setupGameScene()
        setupGamePause()
        checkGameStatus()
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    /* End of UIViewController related methods */

    // Contact delegate method
    func didBegin(_ contact: SKPhysicsContact) {

        // Arranges two colliding bodies so they are sorted by their category bit masks
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }

        if ((firstBody.categoryBitMask & PhysicsCategory.Obstacle != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Bullet != 0)) {
            if let obs = firstBody.node as? SKSpriteNode, let
                bullet = secondBody.node as? SKSpriteNode {
                self.gameLogic.bulletDidCollideWithObstacle(bullet: bullet, obstacle: obs)
            }
        } else if ((firstBody.categoryBitMask & PhysicsCategory.Obstacle != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Obstacle != 0)) {
            if let obs1 = firstBody.node as? SKSpriteNode, let
                obs2 = secondBody.node as? SKSpriteNode {
                self.gameLogic.obstaclesDidCollideWithEachOther(obs1: obs1, obs2: obs2)
            }
        } else if ((firstBody.categoryBitMask & PhysicsCategory.Obstacle != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Player != 0)) {
            if let obs = firstBody.node as? SKSpriteNode, let
                currPlayer = secondBody.node as? SKSpriteNode {
                self.gameLogic.obstacleDidCollideWithPlayer(obs: obs, player: currPlayer)
            }
        } else if ((secondBody.categoryBitMask & PhysicsCategory.Map != 0)) {
            if let object = firstBody.node as? SKSpriteNode {
                self.gameLogic.objectDidCollideWithMap(object: object)
            }
        } else if ((firstBody.categoryBitMask & PhysicsCategory.Bullet != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Player != 0)) {
            if let bullet = firstBody.node as? SKSpriteNode, let player = secondBody.node as? SKSpriteNode {
                self.gameLogic.bulletDidCollideWithPlayer(bullet: bullet, player: player)
            }
        } else if ((firstBody.categoryBitMask & PhysicsCategory.Player != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Upgrade != 0)) {
            if let player = firstBody.node as? SKSpriteNode, let upgradePack = secondBody.node as? SKSpriteNode {
                self.gameLogic.upgradePackDidCollideWithPlayer(upgrade: upgradePack, player: player)
            }
        } else if ((firstBody.categoryBitMask & PhysicsCategory.Obstacle != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Grenade != 0)) {
            if let obstacle = firstBody.node as? SKSpriteNode, let grenade = secondBody.node as? SKSpriteNode {
                self.gameLogic.grenadeDidCollideWithObstacle(obstacle: obstacle, grenade: grenade)
            }
        }

        checkGameStatus()
    }

    /* Start of setup related methods */

    /* Start of game pause related methods */

    func doPauseGame() {
        self.scene.wasPaused = true
        self.scene.physicsWorld.speed = 0
        pauseAllMFiControllers()
        scene.addChild(pauseNode)
    }

    func doResumeGame() {
        self.scene.wasPaused = false
        self.scene.physicsWorld.speed = 1
        resumeAllMFiControllers()
        self.pauseNode.removeFromParent()
    }

    func goback() {
        self.navigationDelegate?.onAppeared()
        dismiss(animated: true, completion: nil)
    }

    /* End of game pause related methods */

    /* Start of private methods */

    private func configMFiController(index: Int, playerController: PlayerController) {
        MFiControllerConfig.mfis[index].moveHandler = playerController.moveMFIJoystickAndRotatePlayerHandler
        MFiControllerConfig.mfis[index].shootHandler = playerController.fireHandler
        MFiControllerConfig.mfis[index].endMoveHandler = playerController.endJoystickMoveHandler
        MFiControllerConfig.mfis[index].pauseHandler = self.doPauseGame
        MFiControllerConfig.mfis[index].resumeHandler = self.doResumeGame

        print("finish mfi config")
    }

    private func configAllMFiControllers() {
        for i in 0..<self.gameLogic.playerControllers.count {
            // Set up MFi controller for each playerController
            let playerController = self.gameLogic.playerControllers[i]
            configMFiController(index: i, playerController: playerController)
        }
    }

    private func deConfigMFiController(index: Int) {
        MFiControllerConfig.mfis[index].moveHandler = nil
        MFiControllerConfig.mfis[index].shootHandler = nil
        MFiControllerConfig.mfis[index].endMoveHandler = nil
        MFiControllerConfig.mfis[index].pauseHandler = nil
        MFiControllerConfig.mfis[index].resumeHandler = nil

        print("finish mfi deconfig")
    }

    private func deConfigAllMFiControllers() {
        for i in 0..<self.gameLogic.playerControllers.count {
            // Deconfig MFi controller for each playerController
            deConfigMFiController(index: i)
        }
    }

    private func pauseAllMFiControllers() {
        for i in 0..<self.gameLogic.playerControllers.count {
            // Deconfig MFi controller for each playerController
            deConfigMFiController(index: i)
            MFiControllerConfig.mfis[i].isGamePaused = true
            MFiControllerConfig.mfis[i].pauseHandler = self.doPauseGame
            MFiControllerConfig.mfis[i].resumeHandler = self.doResumeGame
        }
    }

    private func resumeAllMFiControllers() {
        for i in 0..<self.gameLogic.playerControllers.count {
            // Set up MFi controller for each playerController
            let playerController = self.gameLogic.playerControllers[i]
            configMFiController(index: i, playerController: playerController)
            MFiControllerConfig.mfis[i].isGamePaused = false
        }
    }

    private func setupGameScene() {
        // Set up scene controller
        scene.viewController = self

        // Set up player controllers
        for i in 0..<self.gameLogic.playerControllers.count {
            let playerController = self.gameLogic.playerControllers[i]
            self.scene.players.append(playerController.player)
            self.scene.joysticks.append(playerController.joystick)
            scene.joystickPlates.append(playerController.joystickPlate)
            scene.fireButtons.append(playerController.fireButton)
            scene.playerVelocityUpdateHandlers.append(playerController.updatePlayerVelocityHandler)
            scene.rotateJoystickAndPlayerHandlers.append(playerController.moveJoystickAndRotatePlayerHandler)
            scene.endJoystickMoveHandlers.append(playerController.endJoystickMoveHandler)
            scene.fireHandlers.append(playerController.fireHandler)
            scene.updateWeaponVelocityHandlers.append(playerController.updateWeaponVelocityHandler)

            // Set up MFi controller for each playerController
            configMFiController(index: i, playerController: playerController)
        }

        // Set up obstacles
        for obstacle in self.gameLogic.obstaclePool {
            obstacle.shape.removeFromParent()
            self.scene.addChild(obstacle.shape)
        }
        scene.obstacleVelocityUpdateHandler = self.gameLogic.updateObstaclesVelocityHandler

        // Set up map
        scene.addChild(self.gameLogic.map)

        // Set up connection between skView and game scene
        skView = view as! SKView
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
        self.startTime = DispatchTime.now()
    }

    private func setupGamePause() {
        self.pauseNode = GamePauseNode(size: view.bounds.size, viewController: self)
        pauseNode.zPosition = 100
        pauseNode.position = CGPoint(x: view.frame.midX, y: view.frame.midY)
    }

    // This method checks the game winning / losing status and display the GameOverScene according to the checks
    private func checkGameStatus() {
        if self.gameLogic.winningCondition {
            // Present GameWinScene
            if self.gameLevel.gameMode == .single {
                let skView = view as! SKView
                let gameOverScene = GameOverScene(size: view.bounds.size, message: "You Scored \(self.currLevelObtainedScore) !", viewController: self)
                skView.presentScene(gameOverScene)
                updateScoreToLeaderboard()
            } else {
                if (self.gameLogic as! MultiplayerGameLogic).doesPlayer1Win {
                    let skView = view as! SKView
                    let gameOverScene = GameOverScene(size: view.bounds.size, message: "Player 1 Won!", viewController: self)
                    skView.presentScene(gameOverScene)
                } else {
                    let skView = view as! SKView
                    let gameOverScene = GameOverScene(size: view.bounds.size, message: "Player 2 Won!", viewController: self)
                    skView.presentScene(gameOverScene)
                }
            }
            deConfigAllMFiControllers()
        } else if self.gameLogic.losingCondition {
            // Present GameLoseScene
            let skView = view as! SKView
            let gameOverScene = GameOverScene(size: view.bounds.size, message: "You Lose :[", viewController: self)
            skView.presentScene(gameOverScene)
            deConfigAllMFiControllers()
        }
    }

    // This method
    private func updateScoreToLeaderboard() {
        let level = gameLevel.id
        let score = self.currLevelObtainedScore
        GameData.getInstance().finishGameLevel(gameLevel)
        GameCenterUtils.submitAchievedLevelToGC(level + 1)
        GameCenterUtils.submitScore(for: level, score: score)
    }

    /* End of private methods */

    func goBack() {
        self.navigationDelegate?.onAppeared()
        dismiss(animated: true, completion: nil)
    }

}

extension GameViewController: GKGameCenterControllerDelegate {
    // Delegate to dismiss the GC controller
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
}

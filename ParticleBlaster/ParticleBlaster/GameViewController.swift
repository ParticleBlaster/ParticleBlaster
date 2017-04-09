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

class GameViewController: UIViewController, SKPhysicsContactDelegate {

    // Waiting for prepareForSegue
//    var gameMode: GameMode!
    var gameLevel: GameLevel!
    
    // Initialise game scene for displaying game objects
    var scene: GameScene!
    var skView: SKView!

    // Initialise game logic for controlling game objects
    var gameLogic: GameLogic!

    // Initialised score related supporting attributes
    var startTime: DispatchTime!
    var currLevelObtainedScore: Int = 0

    /* Start of UIViewController related methods */

    override func viewDidLoad() {
        super.viewDidLoad()

        resetVariables()
        
        Constants.initializeJoystickInfo(viewSize: view.bounds.size)
        MultiplayerViewParams.initializeJoystickInfo(viewSize: view.bounds.size)

        if gameLevel.gameMode == .single {
            print("it is single")
            self.scene = SinglePlayerGameScene(size: view.bounds.size)
            self.gameLogic = SinglePlayerGameLogic(gameViewController: self)
        } else {
            print("it is multi")
            self.scene = MultiplayerGameScene(size: view.bounds.size)
            self.gameLogic = MultiplayerGameLogic(gameViewController: self)
        }

        setupGameScene()
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

    // TODO: implement the method for replay
    func resetVariables() {
    }
    
//    func setGameMode(_ gameMode: GameMode = .single) {
//        self.setGameMode = gameMode
//    }

    /* TODO: Implement Level object for loading initial status of players and obstacles
    func loadLevel(_ level: Level) {
    }
     */

    /* Start of setup related methods */
    
    private func configMFiController(index: Int, playerController: PlayerController) {
        MFiControllerConfig.mfis[index].moveHandler = playerController.moveMFIJoystickAndRotatePlayerHandler
        MFiControllerConfig.mfis[index].shootHandler = playerController.shootHandler
        
        print("finish mfi config")
    }

    private func setupGameScene() {
        scene.viewController = self
        scene.gameLevel = self.gameLevel

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
//            scene.updateMissileVelocityHandlers.append(playerController.updateMissileVelocityHandler)
            
            // Set up MFi controller for each playerController
            configMFiController(index: i, playerController: playerController)
        }
        
        scene.obstacleVelocityUpdateHandler = self.gameLogic.updateObstacleVelocityHandler

        // Link game scene to view
        skView = view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
        self.startTime = DispatchTime.now()
    }

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
        
        if self.gameLogic.winningCondition {
            // present GameWinScene
            let skView = view as! SKView
            let gameOverScene = GameOverScene(size: view.bounds.size, won: true, viewController: self)
            skView.presentScene(gameOverScene)
        } else if self.gameLogic.losingCondition {
            // present GameLoseScene
            let skView = view as! SKView
            let gameOverScene = GameOverScene(size: view.bounds.size, won: false, viewController: self)
            skView.presentScene(gameOverScene)
        }
    }
}

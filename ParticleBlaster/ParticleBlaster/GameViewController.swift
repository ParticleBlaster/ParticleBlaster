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
    
    var gameMode = Constants.gameMode.single
    
    // Initialise game scene for displaying game objects
    var scene: GameScene!
    
    // Initialise game logic for controlling game objects
    var gameLogic: GameLogic!

    // Initialised score related supporting attributes
    var startTime: DispatchTime!
    var currLevelObtainedScore: Int = 0
    
    /* Start of UIViewController related methods */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Constants.initializeJoystickInfo(viewSize: view.bounds.size)
        MultiplayerViewParams.initializeJoystickInfo(viewSize: view.bounds.size)
        
        if gameMode == Constants.gameMode.single {
            self.scene = SinglePlayerGameScene(size: view.bounds.size)
            self.gameLogic = SinglePlayerGameLogic(gameViewController: self)
        } else {
            self.gameLogic = MultiplayerGameLogic(gameViewController: self)
            self.scene = MultiplayerGameScene(size: view.bounds.size)
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
    
    private func setupGameScene() {
        scene.viewController = self
        
        for i in 0..<self.gameLogic.playerControllers.count {
            let playerController = self.gameLogic.playerControllers[i]
            self.scene.players.append(playerController.player)
            self.scene.joysticks.append(playerController.joystick)
            scene.joystickPlates.append(playerController.joystickPlate)
            scene.fireButtons.append(playerController.fireButton)
            scene.playerVelocityUpdateHandlers.append(playerController.updatePlayerVelocityHandler)
            scene.rotateJoystickAndPlayerHandlers.append(playerController.moveJoystickAndRotatePlayerHandler)
            scene.endJoystickMoveHandlers.append(playerController.endJoystickMoveHandler)
            scene.fireHandlers.append(playerController.shootHandler)
        }

        scene.obstacleVelocityUpdateHandler = self.gameLogic.updateObstacleVelocityHandler
        
        // Link game scene to view
        let skView = view as! SKView
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
                self.gameLogic.bulletObstacleDidCollide(bullet: bullet, obstacle: obs)
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
        }
    }
}

extension GameViewController: NavigationDelegate {
    func navigateToHomePage() {
        let skView = view as! SKView
        let reveal = SKTransition.crossFade(withDuration: 0.5)
        let scene = HomePageScene(size: skView.frame.size)
        scene.navigationDelegate = self
        skView.presentScene(scene, transition: reveal)
    }

    func navigateToDesignScene() {
        // TODO: implement this
    }

    func navigateToPlayScene() {
        let skView = view as! SKView
        let reveal = SKTransition.crossFade(withDuration: 0.5)
        let scene = GameScene(size: skView.frame.size)
        skView.presentScene(scene, transition: reveal)
    }

    func navigateToLevelSelectScene(isSingleMode: Bool = true) {
        let skView = view as! SKView
        let reveal = SKTransition.crossFade(withDuration: 0.5)
        let scene = LevelSelectScene(size: skView.frame.size)
        scene.navigationDelegate = self
        skView.presentScene(scene, transition: reveal)
    }
}

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
    
    // Initialise game scene for displaying game objects
    var scene: GameScene!

    // Initialised score related supporting attributes
    var startTime: DispatchTime!
    var currLevelObtainedScore: Int = 0

    
    // Game logic
    var gameLogic: GameLogic!
    // var gameLogic = PlayerController(gameViewController: self)
    
    /* Start of UIViewController related methods */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scene = GameScene(size: view.bounds.size)
        Constants.initializeJoystickInfo(viewSize: view.bounds.size)
        self.gameLogic = SinglePlayerGameLogic(gameViewController: self)
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
        // Release any cached data, images, etc that aren't in use.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    /* End of UIViewController related methods */
    
    private func setupGameScene() {
        let playerController = (self.gameLogic as! SinglePlayerGameLogic).playerController
        
        // Initialise game scene sttributes assignment
        scene.viewController = self
        scene.player = playerController.player
        scene.joystick = playerController.joystick
        scene.joystickPlate = playerController.joystickPlate
        scene.fireButton = playerController.fireButton
        
        // Logic handlers assignment
        scene.playerVelocityUpdateHandler = playerController.updatePlayerVelocityHandler
        scene.rotateJoystickAndPlayerHandler = playerController.moveJoystickAndRotatePlayerHandler
        scene.endJoystickMoveHandler = playerController.endJoystickMoveHandler
        scene.fireHandler = playerController.shootHandler
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

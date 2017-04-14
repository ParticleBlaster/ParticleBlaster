//
//  SinglePlayerGameLogic.swift
//  ParticleBlaster
//
//  Created by Bohan Huang on 29/3/17.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

/**
 *  The `SinglePlayerGameLogic` class conforms to GameLogic protocol
 *  It defines the logic for single player mode
 */

import UIKit
import SpriteKit

class SinglePlayerGameLogic: GameLogic {
    /* Start of stored properties */
    var gameViewController: GameViewController
    var numberOfPlayers: Int
    var playerControllers: [PlayerController]
    var obstaclePool: [Obstacle]
    var map: Boundary
    /* End of stored properties */
    
    /* Start of computed properties */
    var winningCondition: Bool {
        get {
            return self.obstaclePool.isEmpty
        }
    }
    
    var losingCondition: Bool {
        get {
            return self.player.checkDead()
        }
    }
    
    var playerController: PlayerController {
        get {
            return playerControllers[0]
        }
    }
    
    var player: Player {
        get {
            return self.playerController.player
        }
    }
    /* End of computed properties */
    
    /* Start of initialiser */
    init(gameViewController: GameViewController, obstaclePool: [Obstacle], player: Player) {
        self.gameViewController = gameViewController
        
        self.obstaclePool = obstaclePool
        self.map = Boundary(rect: self.gameViewController.scene.frame)
        
        self.numberOfPlayers = 1
        let playerController = PlayerController(gameViewController: self.gameViewController, player: player.copy() as! Player, controllerType: ControllerType.single)
        self.playerControllers = [playerController]
        
        prepareObstacles()
        preparePlayer()
        preparePlayerControllersSubscribers()
        
        _checkRep()
    }
    /* End of initialiser */
    
    /* Start of preparation methods for GameObjects */
    // This function initializes the player's starting location
    private func preparePlayer() {
        let player = self.player
        player.shape.position = CGPoint(x: player.ratioPosition.x * self.gameViewController.scene.frame.size.width,
                                        y: player.ratioPosition.y * self.gameViewController.scene.frame.size.height)
    }
    
    // This function links the handler in PlayerController with the actual implementation in GameLogic
    private func preparePlayerControllersSubscribers() {
        for playerController in self.playerControllers {
            playerController.obtainObstacleListHandler = self.obtainObstaclesHandler
        }
    }
    
    // This function initializes the obstacle list
    private func prepareObstacles() {
        for obstacle in self.obstaclePool {
            obstacle.setupShape()
            obstacle.shape.zPosition = 1
            // Convert to absolute position as position is archived as ratio values
            obstacle.shape.position = CGPoint(x: obstacle.initialPosition.x * self.gameViewController.scene.frame.size.width, y: obstacle.initialPosition.y * self.gameViewController.scene.frame.size.height)
            obstacle.timeToLive = SpriteUtils.getObstacleTimeToLive(obstacle)
        }
    }
    /* End of preparation methods for GameObjects */
    
    /* Start of function handlers */
    // This function handles the velocity update
    func updateObstaclesVelocityHandler() {
        for obs in self.obstaclePool {
            let direction = CGVector(dx: self.player.shape.position.x - obs.shape.position.x, dy: self.player.shape.position.y - obs.shape.position.y).normalized()
            let percentage = obs.shape.size.width * obs.shape.size.height / (Constants.standardObstacleSize.width * Constants.standardObstacleSize.height)
            let appliedForce = CGVector(dx: direction.dx * Constants.obstacleForceValue * percentage, dy: direction.dy * Constants.obstacleForceValue * percentage
            )
            obs.pushedByForce(appliedForce: appliedForce)
        }
    }
    
    // This function returns the obstacle list of the current GameLogic
    func obtainObstaclesHandler() -> [Obstacle] {
        return self.obstaclePool
    }
    /* End of function handlers */
    
    /* Start of collision delegate function implementations */
    // This function is invoked when a weapon collides with the obstacle
    func bulletDidCollideWithObstacle(bullet: SKSpriteNode, obstacle: SKSpriteNode) {
        self.playerControllers[0].removeWeaponAfterCollision(weaponNode: bullet)
        
        self.obstacleIsHit(obstacleNode: obstacle)
    }
    
    // This function is invoked when the plaer collides with the obstacle
    func obstacleDidCollideWithPlayer(obs: SKSpriteNode, player: SKSpriteNode) {
        self.player.hitByObstacle()
        if self.player.checkDead() {
            print ("You are dead!")
        }
    }
    
    // This function is invoked when an arbitrary object collides with the map boundary; the bullet will be ignored; 
    // All other GameObjects should not be allowed to pass through
    func objectDidCollideWithMap(object: SKSpriteNode) {
        if object.physicsBody?.categoryBitMask == PhysicsCategory.Bullet {
            self.playerControllers[0].removeWeaponAfterCollision(weaponNode: object)
            object.removeFromParent()
        }
        object.removeAllActions()
    }
    
    // This function is invoked when the upgrade pack collides with the player
    func upgradePackDidCollideWithPlayer(upgrade: SKSpriteNode, player: SKSpriteNode) {
        // Upgrade possibility: 75% perentage for grenade, 25% percentage for missile
        let randomNumber = arc4random_uniform(101)
        if randomNumber <= 75 {
            self.playerControllers[0].upgradeWeapon(newWeapon: WeaponCategory.Grenade)
        } else {
            self.playerControllers[0].upgradeWeapon(newWeapon: WeaponCategory.Missile)
        }
        
        self.gameViewController.scene.removeElement(node: upgrade)
    }
    
    // This function is invoked when a grenade collides with the obstacle;
    // An impulse will be applied to the obstacle for special effects
    func grenadeDidCollideWithObstacle(obstacle: SKSpriteNode, grenade: SKSpriteNode) {
        self.playerControllers[0].grenadeExplode(grenadeNode: grenade)
        let impulseDirection = CGVector(dx: obstacle.position.x - grenade.position.x, dy: obstacle.position.y - grenade.position.y).normalized()
        let percentage = obstacle.size.width * obstacle.size.height / (Constants.standardObstacleSize.width * Constants.standardObstacleSize.height)
        let obstacleImpulse = CGVector(dx: impulseDirection.dx * Constants.obstacleHitByGrenadeImpulseValue * percentage,
                                       dy: impulseDirection.dy * Constants.obstacleHitByGrenadeImpulseValue * percentage)
        
        obstacle.physicsBody?.applyImpulse(obstacleImpulse)
        
        self.obstacleIsHit(obstacleNode: obstacle)
    }
    /* End of collision delegate function implementations */
    
    /* Start of supporting functions for collision implementation */
    // This function adds an upgrade pack to the game
    private func dropUpgradePack(dropPosition: CGPoint) {
        let upgradePack = UpgradePack()
        upgradePack.shape.position = dropPosition
        
        let upgradePackFadeInAction = SKAction.fadeIn(withDuration: Constants.upgradePackFadeTime)
        let upgradePackFadeOutAction = SKAction.fadeOut(withDuration: Constants.upgradePackFadeTime)
        let upgradePackMoveAction = SKAction.move(by: Constants.upgradePackMoveOffset, duration: Constants.upgradePackMoveTime)
        let upgradePackAction = SKAction.sequence([upgradePackFadeInAction, upgradePackMoveAction, upgradePackFadeOutAction])
        
        self.gameViewController.scene.addChild(upgradePack.shape)
        
        upgradePack.shape.run(upgradePackAction, completion: {
            self.gameViewController.scene.removeElement(node: upgradePack.shape)
        })
    }
    
    // This function updates the obstacle when it has been detected to be hit by a weapon
    private func obstacleIsHit(obstacleNode: SKSpriteNode) {
        let obstacleGotHit = self.obstaclePool.filter({$0.shape == obstacleNode})[0]
        obstacleGotHit.hitByBullet()
        if obstacleGotHit.checkDestroyed() {
            let obstacleCenter = obstacleNode.position
            let scoreDisplayCenter = CGPoint(x: obstacleCenter.x, y: obstacleCenter.y + 15)
            self.gameViewController.scene.removeElement(node: obstacleNode)
            let obsDestroyedTime = DispatchTime.now()
            let elapsedTimeInSeconds = obsDestroyedTime.getTimeInSecond(to: self.gameViewController.startTime)
            let scoreForThisObs = Int(Constants.defaultScoreDivider / elapsedTimeInSeconds)
            self.gameViewController.currLevelObtainedScore += scoreForThisObs
            self.gameViewController.scene.displayScoreAnimation(displayScore: scoreForThisObs, scoreSceneCenter: scoreDisplayCenter)
            self.obstaclePool = self.obstaclePool.filter({$0.shape != obstacleNode})
            
            self.dropUpgradePack(dropPosition: obstacleCenter)
        }
    }
    /* End of supporting functions for collision implementation */
    
    private func _checkRep() {
        assert(self.numberOfPlayers == playerControllers.count, "Invalid number of players.")
    }
}

// Mark: functions defined in the GameLogic protocol, but should not be implemented
extension SinglePlayerGameLogic {
    // Future imporvement: add special effects when obs are colliding with each other, like bouncing away
    func obstaclesDidCollideWithEachOther(obs1: SKSpriteNode, obs2: SKSpriteNode) {
    }
    
    // In single player mode, bullet can only collides with its own mothership, so nothing happens
    func bulletDidCollideWithPlayer(bullet: SKSpriteNode, player: SKSpriteNode) {
    }
}

//
//  SinglePlayerGameLogic.swift
//  ParticleBlaster
//
//  Created by Bohan Huang on 29/3/17.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

/**
 *  The 'SinglePlayerGameLogic'c class conforms to GameLogic protocol
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
        let playerController = PlayerController(gameViewController: self.gameViewController, player: player.copy() as! Player)
        self.playerControllers = [playerController]
        
        prepareObstacles()
        preparePlayer()
        preparePlayerControllers()
        
        _checkRep()
    }
    /* End of initialiser */
    
    
    func updateObstaclesVelocityHandler() {
        for obs in self.obstaclePool {
            let direction = CGVector(dx: self.player.shape.position.x - obs.shape.position.x, dy: self.player.shape.position.y - obs.shape.position.y).normalized()
            let percentage = obs.shape.size.width * obs.shape.size.height / (Constants.standardObstacleSize.width * Constants.standardObstacleSize.height)
            let appliedForce = CGVector(dx: direction.dx * Constants.obstacleForceValue * percentage, dy: direction.dy * Constants.obstacleForceValue * percentage
            )
            obs.pushedByForce(appliedForce: appliedForce)
        }
    }
    
    func obtainObstaclesHandler() -> [Obstacle] {
        return self.obstaclePool
    }
    
    func bulletDidCollideWithObstacle(bullet: SKSpriteNode, obstacle: SKSpriteNode) {
        self.playerControllers[0].removeWeaponAfterCollision(weaponNode: bullet)
        
        self.obstacleIsHit(obstacleNode: obstacle)
    }
    
    // TODO: can implement a bounce-off effect if the player hits the obs but not dead yet
    // In single player mode, the time-to-live value of a player should decrease 
    // when it collides with an obstacles
    func obstacleDidCollideWithPlayer(obs: SKSpriteNode, player: SKSpriteNode) {
        self.player.hitByObstacle()
        if self.player.checkDead() {
            print ("You are dead!")
        }
    }
    
    // In single player mode, obstacles have no special effects after colliding with each other
    func obstaclesDidCollideWithEachOther(obs1: SKSpriteNode, obs2: SKSpriteNode) {
    }
    
    // In single player mode, when an object collides with the map
    // If it is a bullets, it should be removed from the scene (as if it flies out of the boundary)
    // Otherwise it should collides with the map and be constrainted inside the map
    func objectDidCollideWithMap(object: SKSpriteNode) {
        if object.physicsBody?.categoryBitMask == PhysicsCategory.Bullet {
            self.playerControllers[0].removeWeaponAfterCollision(weaponNode: object)
            object.removeFromParent()
        }
        object.removeAllActions()
    }
    
    func bulletDidCollideWithPlayer(bullet: SKSpriteNode, player: SKSpriteNode) {
    }
    
    func upgradePackDidCollideWithPlayer(upgrade: SKSpriteNode, player: SKSpriteNode) {
        // 75% perentage for grenade, 25% percentage for missile
        let randomNumber = arc4random_uniform(101)
        if randomNumber <= 75 {
            self.playerControllers[0].upgradeWeapon(newWeapon: WeaponCategory.Grenade)
        } else {
            self.playerControllers[0].upgradeWeapon(newWeapon: WeaponCategory.Missile)
        }
        
        self.gameViewController.scene.removeElement(node: upgrade)
    }
    
    func grenadeDidCollideWithObstacle(obstacle: SKSpriteNode, grenade: SKSpriteNode) {
        self.playerControllers[0].grenadeExplode(grenadeNode: grenade)
        let impulseDirection = CGVector(dx: obstacle.position.x - grenade.position.x, dy: obstacle.position.y - grenade.position.y).normalized()
        let percentage = obstacle.size.width * obstacle.size.height / (Constants.standardObstacleSize.width * Constants.standardObstacleSize.height)
        let obstacleImpulse = CGVector(dx: impulseDirection.dx * Constants.obstacleHitByGrenadeImpulseValue * percentage,
                                       dy: impulseDirection.dy * Constants.obstacleHitByGrenadeImpulseValue * percentage)
        
        obstacle.physicsBody?.applyImpulse(obstacleImpulse)
        
        self.obstacleIsHit(obstacleNode: obstacle)
    }
    
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
            
            // Upgrade pack drops
            self.dropUpgradePack(dropPosition: obstacleCenter)
        }
    }
    
    

    func preparePlayer() {
        let player = self.player
        player.shape.position = CGPoint(x: player.ratioPosition.x * self.gameViewController.scene.frame.size.width,
                                        y: player.ratioPosition.y * self.gameViewController.scene.frame.size.height)
    }

    /* Start of private methods */
    private func preparePlayerControllers() {
        for playerController in self.playerControllers {
            playerController.updateJoystickPlateCenter(x: Constants.joystickPlateCenterX, y: Constants.joystickPlateCenterY)
            playerController.obtainObstacleListHandler = self.obtainObstaclesHandler
        }
    }
    
    private func prepareObstacles() {
        for obstacle in self.obstaclePool {
            obstacle.setupShape()
            obstacle.shape.zPosition = 1
            // Convert to absolute position as position is archived as ratio values
            obstacle.shape.position = CGPoint(x: obstacle.initialPosition.x * self.gameViewController.scene.frame.size.width, y: obstacle.initialPosition.y * self.gameViewController.scene.frame.size.height)
            obstacle.timeToLive = SpriteUtils.getObstacleTimeToLive(obstacle)
        }
    }

    private func _checkRep() {
        assert(self.numberOfPlayers == playerControllers.count, "Invalid number of players.")
    }
    /* End of private methods */
}

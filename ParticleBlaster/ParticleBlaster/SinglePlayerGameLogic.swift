//
//  SinglePlayerGameLogic.swift
//  ParticleBlaster
//
//  Created by Bohan Huang on 29/3/17.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

import UIKit
import SpriteKit

class SinglePlayerGameLogic: GameLogic {
    var gameViewController: GameViewController
    var numberOfPlayers: Int
    var playerControllers: [PlayerController]
    var obstaclePool: [Obstacle]
    var winningCondition: Bool
    var losingCondition: Bool
    var map: MapObject
    
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
    
    init(gameViewController: GameViewController) {
        self.gameViewController = gameViewController
        
        self.numberOfPlayers = 1
        let player = PlayerController(gameViewController: self.gameViewController)
        
        player.updateJoystickPlateCenter(x: Constants.joystickPlateCenterX, y: Constants.joystickPlateCenterY)
        self.playerControllers = [player]
        self.obstaclePool = [Obstacle]()
        self.winningCondition = false
        self.losingCondition = false
        self.map = MapObject(view: self.gameViewController.view)
        
        player.obtainObstacleListHandler = self.getObstacleList
        
        initialiseFakeObstacles()
        prepareObstacles()
        prepareMap()
    }
    
    func updateWinningCondition() {
        self.winningCondition = self.obstaclePool.isEmpty
    }
    
    func updateLosingCondition() {
        self.losingCondition = self.player.checkDead()
    }

    func updateObstacleVelocityHandler() {
        for obs in self.obstaclePool {
            let direction = CGVector(dx: self.player.shape.position.x - obs.shape.position.x, dy: self.player.shape.position.y - obs.shape.position.y).normalized()
            let appliedForce = CGVector(dx: direction.dx * Constants.obstacleForceValue, dy: direction.dy * Constants.obstacleForceValue)
            obs.pushedByForce(force: appliedForce)
        }
    }
    
    func getObstacleList() -> [Obstacle] {
        return self.obstaclePool
    }
    
    func bulletDidCollideWithObstacle(bullet: SKSpriteNode, obstacle: SKSpriteNode) {
        //self.gameViewController.scene.removeElement(node: bullet)
        
        self.playerControllers[0].removeBulletAndMissileAfterCollision(weaponNode: bullet)
        
        let obstacleGotHit = self.obstaclePool.filter({$0.shape == obstacle})[0]
        obstacleGotHit.hitByBullet()
        if obstacleGotHit.checkDestroyed() {
            let obstacleCenter = obstacle.position
            let scoreDisplayCenter = CGPoint(x: obstacleCenter.x, y: obstacleCenter.y + 15)
            self.gameViewController.scene.removeElement(node: obstacle)
            let obsDestroyedTime = DispatchTime.now()
            let elapsedTimeInSeconds = Float(obsDestroyedTime.uptimeNanoseconds - self.gameViewController.startTime.uptimeNanoseconds) / 1_000_000_000
            let scoreForThisObs = Int(Constants.defaultScoreDivider / elapsedTimeInSeconds)
            self.gameViewController.currLevelObtainedScore += scoreForThisObs
            self.gameViewController.scene.displayScoreAnimation(displayScore: scoreForThisObs, scoreSceneCenter: scoreDisplayCenter)
            self.obstaclePool = self.obstaclePool.filter({$0.shape != obstacle})
            
            // Upgrade pack drops
            self.dropUpgradePack(dropPosition: obstacleCenter)
        }
    }
    
    // TODO: can implement a bounce-off effect if the player hits the obs but not dead yet
    func obstacleDidCollideWithPlayer(obs: SKSpriteNode, player: SKSpriteNode) {
        self.player.hitByObstacle()
        if self.player.checkDead() {
            print ("You are dead!")
            self.losingCondition = true
            // self.gameViewController.scene.removeElement(node: player)
        }
    }
    
    func obstaclesDidCollideWithEachOther(obs1: SKSpriteNode, obs2: SKSpriteNode) {
        let obstacle1Velocity = obs1.physicsBody?.velocity.normalized()
        let obstacle2Velocity = obs2.physicsBody?.velocity.normalized()
        
        let impulse1 = CGVector(dx: obstacle2Velocity!.dx * Constants.obstacleImpulseValue, dy: obstacle2Velocity!.dy * Constants.obstacleImpulseValue)
        let impulse2 = CGVector(dx: obstacle1Velocity!.dx * Constants.obstacleImpulseValue, dy: obstacle1Velocity!.dy * Constants.obstacleImpulseValue)
        
        obs1.physicsBody?.applyImpulse(impulse1)
        obs2.physicsBody?.applyImpulse(impulse2)
    }
    
    func objectDidCollideWithMap(object: SKSpriteNode) {
        // TODO: The interaction between player and boundary seems buggy (probably due to player physics body)
        object.removeAllActions()
    }
    
    func bulletDidCollideWithPlayer(bullet: SKSpriteNode, player: SKSpriteNode) {
        
    }
    
    func upgradePackDidCollideWithPlayer(upgrade: SKSpriteNode, player: SKSpriteNode) {
        // 50% for grenade, 35% for shield, 15% for missile
        let randomNumber = arc4random_uniform(101)
        if randomNumber <= 50 {
            self.playerControllers[0].upgradeWeapon(newWeapon: WeaponCategory.Grenade)
        } else if randomNumber <= 85 {
            // Put the logic for shield here
        } else {
            self.playerControllers[0].upgradeWeapon(newWeapon: WeaponCategory.Missile)
        }
        self.gameViewController.scene.removeElement(node: upgrade)
    }
    
    func grenadeDidCollideWithObstacle(obstacle: SKSpriteNode, grenade: SKSpriteNode) {
        
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
    
    private func prepareObstacles() {
        for obs in self.obstaclePool {
            self.gameViewController.scene.addSingleObstacle(newObstacle: obs)
        }
    }
    
    private func prepareMap() {
        for boundary in self.map.boundaries {
            self.gameViewController.scene.addBoundary(boundary: boundary)
        }
    }
    
    private func initialiseFakeObstacles() {
        // TODO: Remove manual assignment of obstacle information after the Level class is created
        let obs1 = Obstacle(userSetInitialPosition: CGPoint(x: Constants.obstacle1CenterX, y: Constants.obstacle1CenterY))
        let obs2 = Obstacle(userSetInitialPosition: CGPoint(x: Constants.obstacle2CenterX, y: Constants.obstacle2CenterY))
        
        self.obstaclePool.append(obs1)
        self.obstaclePool.append(obs2)
    }
    
    private func _checkRep() {
        assert(self.numberOfPlayers == playerControllers.count, "Invalid number of players.")
    }
    
}

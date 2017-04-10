//
//  MultiPlayerGameLogic.swift
//  ParticleBlaster
//
//  Created by Bohan Huang on 29/3/17.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

import UIKit
import SpriteKit

class MultiplayerGameLogic: GameLogic {
    var gameViewController: GameViewController
    var numberOfPlayers: Int
    var playerControllers: [PlayerController]
    var obstaclePool: [Obstacle]
    var map: Boundary
    
    var winningCondition: Bool {
        get {
            return self.player1.checkDead() || self.player2.checkDead()
        }
    }
    
    var losingCondition: Bool {
        get {
            return self.player1.checkDead() || self.player2.checkDead()
        }
    }
    
    var doesPlayer1Win: Bool {
        get {
            return self.player2.checkDead()
        }
    }
    
    var playerController1: PlayerController {
        get {
            return playerControllers[0]
        }
    }
    
    var playerController2: PlayerController {
        get {
            return playerControllers[1]
        }
    }
    
    var player1: Player {
        get {
            return self.playerController1.player
        }
    }
    
    var player2: Player {
        get {
            return self.playerController2.player
        }
    }
    
    // TODO: possible improvement: remaining life percentage band/strap
    init(gameViewController: GameViewController, obstaclePool: [Obstacle]) {
        self.gameViewController = gameViewController
        
        self.numberOfPlayers = 2
        self.playerControllers = [PlayerController]()
        
        let player1 = PlayerController(gameViewController: self.gameViewController, playerIndex: 1)
        player1.updateJoystickPlateCenter(x: MultiplayerViewParams.joystickPlateCenterX1, y: MultiplayerViewParams.joystickPlateCenterY1)
        // TODO: Refactor
        player1.player.timeToLive = 5
        let player2 = PlayerController(gameViewController: self.gameViewController, playerIndex: 2)
        player2.updateJoystickPlateCenter(x: MultiplayerViewParams.joystickPlateCenterX2, y: MultiplayerViewParams.joystickPlateCenterY2)
        // TODO: Refactor
        player2.player.timeToLive = 5
        self.playerControllers.append(player1)
        self.playerControllers.append(player2)
        self.obstaclePool = obstaclePool
        self.map = Boundary(rect: self.gameViewController.scene.frame)
        
        player1.obtainObstacleListHandler = self.getObstacleList
        player2.obtainObstacleListHandler = self.getObstacleList
        
        prepareObstacles()
        prepareMap()
    }
    
    // Shouldn't be implementing this
    func updateObstacleVelocityHandler() {
    }
    
    func getObstacleList() -> [Obstacle] {
        return self.obstaclePool
    }
    
    func bulletDidCollideWithObstacle(bullet: SKSpriteNode, obstacle: SKSpriteNode) {
        //self.gameViewController.scene.removeElement(node: bullet)
        for playerController in self.playerControllers {
            //playerController.removeBulletAndMissileAfterCollision(weaponNode: bullet)
            //playerController.removeWeaponAfterCollision(weaponNode: bullet, weaponType: WeaponCategory.Bullet)
            playerController.removeWeaponAfterCollision(weaponNode: bullet)
        }
    }
    
    // Obstacle in this case will not be moving, but the player will be hurt
    func obstacleDidCollideWithPlayer(obs: SKSpriteNode, player: SKSpriteNode) {
        self.playerGotHit(player: player)
    }
    
    // Shouldn't be implementing this
    func obstaclesDidCollideWithEachOther(obs1: SKSpriteNode, obs2: SKSpriteNode) {
    }
    
    func bulletDidCollideWithPlayer(bullet: SKSpriteNode, player: SKSpriteNode) {
        if !self.bulletCollideWithItsMothership(bulletNode: bullet, playerNode: player) {
            self.gameViewController.scene.removeElement(node: bullet)
            self.playerGotHit(player: player)
            
            let bulletMothershipController = self.playerControllers.filter({$0.weaponPool.map({ele in ele.shape}).contains(bullet)})[0]
            bulletMothershipController.removeWeaponAfterCollision(weaponNode: bullet)
        }
    }
    
    func objectDidCollideWithMap(object: SKSpriteNode) {
        object.removeAllActions()
    }
    
    private func bulletCollideWithItsMothership(bulletNode: SKSpriteNode, playerNode: SKSpriteNode) -> Bool {
        let bulletMothershipController = self.playerControllers.filter({$0.weaponPool.map({ele in ele.shape}).contains(bulletNode)})[0]
        return bulletMothershipController.player.shape == playerNode
    }
    
    func upgradePackDidCollideWithPlayer(upgrade: SKSpriteNode, player: SKSpriteNode) {
        
    }
    
    func grenadeDidCollideWithObstacle(obstacle: SKSpriteNode, grenade: SKSpriteNode) {
        
    }
    
    private func retrieveBulletObject(bulletNode: SKSpriteNode) -> Bullet {
        let bulletMothership = self.playerControllers.filter({$0.weaponPool.map({$0.shape}).contains(bulletNode)})[0]
        let bullet = bulletMothership.weaponPool.filter({$0.shape == bulletNode})[0] as! Bullet
        return bullet
    }
    
    private func prepareObstacles() {
        for obstacle in self.obstaclePool {
            obstacle.setupShape()
            obstacle.shape.zPosition = 1
            // convert to absolute position as position is archived as ratio values
            obstacle.shape.position = CGPoint(x: obstacle.initialPosition.x * self.gameViewController.scene.frame.size.width, y: obstacle.initialPosition.y * self.gameViewController.scene.frame.size.height)
            self.gameViewController.scene.addChild(obstacle.shape)
        }
    }
    
    private func prepareMap() {
        self.gameViewController.scene.addChild(self.map)
    }
    
    private func _checkRep() {
        assert(self.numberOfPlayers == playerControllers.count, "Invalid number of players.")
    }
    
    private func playerGotHit(player: SKSpriteNode) {
        let collidedPlayerController = self.playerControllers.filter({$0.player.shape == player})[0]
        collidedPlayerController.player.hitByObstacle()
        if collidedPlayerController.player.checkDead() {
            print ("game over!")
        }
    }
}

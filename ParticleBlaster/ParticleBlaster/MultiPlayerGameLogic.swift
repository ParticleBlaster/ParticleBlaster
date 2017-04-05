//
//  MultiPlayerGameLogic.swift
//  ParticleBlaster
//
//  Created by Bohan Huang on 29/3/17.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class MultiplayerGameLogic: GameLogic {
    var gameViewController: GameViewController
    var numberOfPlayers: Int
    var playerControllers: [PlayerController]
    var obstaclePool: [Obstacle]
    var winningCondition: Bool
    var losingCondition: Bool
    var map: MapObject
    
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
    init(gameViewController: GameViewController) {
        self.gameViewController = gameViewController
        
        self.numberOfPlayers = 2
        self.playerControllers = [PlayerController]()
        let player1 = PlayerController(gameViewController: self.gameViewController)
        player1.updateJoystickPlateCenter(x: MultiplayerViewParams.joystickPlateCenterX1, y: MultiplayerViewParams.joystickPlateCenterY1)
        // TODO: Refactor
        player1.player.timeToLive = 10
        let player2 = PlayerController(gameViewController: self.gameViewController)
        player2.updateJoystickPlateCenter(x: MultiplayerViewParams.joystickPlateCenterX2, y: MultiplayerViewParams.joystickPlateCenterY2)
        // TODO: Refactor
        player2.player.timeToLive = 10
        self.playerControllers.append(player1)
        self.playerControllers.append(player2)
        self.obstaclePool = [Obstacle]()
        self.winningCondition = false
        self.losingCondition = false
        self.map = MapObject(view: self.gameViewController.view)
        
        initialiseFakeObstacles()
        prepareObstacles()
        prepareMap()
    }
    
    func updateWinningCondition() {
        self.winningCondition = player1.checkDead() || player2.checkDead()
    }
    
    // Shouldn't be implementing this
    func updateObstacleVelocityHandler() {
    }
    
    func bulletDidCollideWithObstacle(bullet: SKSpriteNode, obstacle: SKSpriteNode) {
        self.gameViewController.scene.removeElement(node: bullet)
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
            
            let bulletMothershipController = self.playerControllers.filter({$0.bulletPool.map({ele in ele.shape}).contains(bullet)})[0]
            bulletMothershipController.removeBullet(bulletNode: bullet)
        }
    }
    
    func objectDidCollideWithMap(object: SKSpriteNode) {
        object.removeAllActions()
    }
    
    private func bulletCollideWithItsMothership(bulletNode: SKSpriteNode, playerNode: SKSpriteNode) -> Bool {
        let bulletMothershipController = self.playerControllers.filter({$0.bulletPool.map({ele in ele.shape}).contains(bulletNode)})[0]
        return bulletMothershipController.player.shape == playerNode
    }
    
    private func retrieveBulletObject(bulletNode: SKSpriteNode) -> Bullet {
        let bulletMothership = self.playerControllers.filter({$0.bulletPool.map({$0.shape}).contains(bulletNode)})[0]
        let bullet = bulletMothership.bulletPool.filter({$0.shape == bulletNode})[0]
        return bullet
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
        let obs1 = Obstacle(userSetInitialPosition: Constants.defaultMultiObs1Center, isStatic: true)
        let obs2 = Obstacle(userSetInitialPosition: Constants.defaultMultiObs2Center, isStatic: true)
        
        self.obstaclePool.append(obs1)
        self.obstaclePool.append(obs2)
    }
    
    private func _checkRep() {
        assert(self.numberOfPlayers == playerControllers.count, "Invalid number of players.")
    }
    
    private func playerGotHit(player: SKSpriteNode) {
        let collidedPlayerController = self.playerControllers.filter({$0.player.shape == player})[0]
        collidedPlayerController.player.hitByObstacle()
        if collidedPlayerController.player.checkDead() {
            print ("game over!")
            updateWinningCondition()
        }
    }
}

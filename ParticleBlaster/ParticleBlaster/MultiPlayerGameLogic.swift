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
    
    init(gameViewController: GameViewController) {
        self.gameViewController = gameViewController
        
        self.numberOfPlayers = 2
        self.playerControllers = [PlayerController]()
        let player1 = PlayerController(gameViewController: self.gameViewController)
        player1.updateJoystickPlateCenter(x: MultiplayerViewParams.joystickPlateCenterX1, y: MultiplayerViewParams.joystickPlateCenterY1)
        let player2 = PlayerController(gameViewController: self.gameViewController)
        player2.updateJoystickPlateCenter(x: MultiplayerViewParams.joystickPlateCenterX2, y: MultiplayerViewParams.joystickPlateCenterY2)
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
    }
    
    func updateObstacleVelocityHandler() {
    }
    
    func bulletObstacleDidCollide(bullet: SKSpriteNode, obstacle: SKSpriteNode) {
    }
    
    func obstacleDidCollideWithPlayer(obs: SKSpriteNode, player: SKSpriteNode) {
        
    }
    
    func obstaclesDidCollideWithEachOther(obs1: SKSpriteNode, obs2: SKSpriteNode) {
    }
    
    func bulletDidCollideWithPlayer(bullet: SKSpriteNode, player: SKSpriteNode) {
        
    }
    
    func objectDidCollideWithMap(object: SKSpriteNode) {
        object.removeAllActions()
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

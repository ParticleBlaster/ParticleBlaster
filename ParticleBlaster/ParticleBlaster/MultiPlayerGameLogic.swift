//
//  MultiPlayerGameLogic.swift
//  ParticleBlaster
//
//  Created by Bohan Huang on 29/3/17.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

/**
 *  The `MultiPlayerGameLogic` class conforms to GameLogic protocol
 *  It defines the logic for multi player mode
 */


import UIKit
import SpriteKit

class MultiplayerGameLogic: GameLogic {
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
    /* End of computed properties */
    
    /* Start of initializer */
    init(gameViewController: GameViewController, obstaclePool: [Obstacle], players: [Player]) {
        self.gameViewController = gameViewController
        
        self.numberOfPlayers = 2
        self.playerControllers = [PlayerController]()
        
        // TODO: Refactor; initialization of players should include the `timeToLive` of players
        // Where this `timeToLive` is supposed to be from level designers or default
        let player1 = PlayerController(gameViewController: self.gameViewController, player: players[0].copy() as! Player, controllerType: ControllerType.multi1)
        player1.player.timeToLive = 5
        
        let player2 = PlayerController(gameViewController: self.gameViewController, player: players[1].copy() as! Player, controllerType: ControllerType.multi2)
        player2.player.timeToLive = 5
        
        self.playerControllers.append(player1)
        self.playerControllers.append(player2)
        self.obstaclePool = obstaclePool
        self.map = Boundary(rect: self.gameViewController.scene.frame)
        
        player1.obtainObstacleListHandler = self.obtainObstaclesHandler
        player2.obtainObstacleListHandler = self.obtainObstaclesHandler
        
        prepareObstacles()
        preparePlayers()
    }
    /* End of initializer */
    
    /* Start of preparation methods for GameObjects */
    // This function initializes the obstacle list
    private func prepareObstacles() {
        for obstacle in self.obstaclePool {
            obstacle.setupShape()
            obstacle.shape.zPosition = 1
            // convert to absolute position as position is archived as ratio values
            obstacle.shape.position = CGPoint(x: obstacle.initialPosition.x * self.gameViewController.scene.frame.size.width,
                                              y: obstacle.initialPosition.y * self.gameViewController.scene.frame.size.height)
        }
    }
    
    // This function initializes the players' starting locations
    func preparePlayers() {
        let players = [player1, player2]
        for player in players {
            player.shape.position = CGPoint(x: player.ratioPosition.x * self.gameViewController.scene.frame.size.width,
                                            y: player.ratioPosition.y * self.gameViewController.scene.frame.size.height)
        }
    }
    /* End of preparation methods for GameObjects */
    
    /* Start of function handlers */
    // This function returns the obstacle list
    func obtainObstaclesHandler() -> [Obstacle] {
        return self.obstaclePool
    }
    /* End of function handlers */
    
    /* Start of collision delegate function implementations */
    // This function is invoked when the bullet collides with the obstacle
    func bulletDidCollideWithObstacle(bullet: SKSpriteNode, obstacle: SKSpriteNode) {
        for playerController in self.playerControllers {
            playerController.removeWeaponAfterCollision(weaponNode: bullet)
        }
    }
    
    // This function is invoked when the obstacle collides with the player
    // The player is designed to be hurt, but the obstacle is not affected
    func obstacleDidCollideWithPlayer(obs: SKSpriteNode, player: SKSpriteNode) {
        self.playerGotHit(player: player)
    }
    
    // This function is invoked when the bullet collides with the player
    // If the player shoots the bullet, nothing should be done; otherwise, the player is enemy and is hurt
    func bulletDidCollideWithPlayer(bullet: SKSpriteNode, player: SKSpriteNode) {
        if !self.bulletCollideWithItsMothership(bulletNode: bullet, playerNode: player) {
            self.gameViewController.scene.removeElement(node: bullet)
            self.playerGotHit(player: player)
            
            let bulletMothershipController = self.playerControllers.filter({$0.weaponPool.map({ele in ele.shape}).contains(bullet)})[0]
            bulletMothershipController.removeWeaponAfterCollision(weaponNode: bullet)
        }
    }
    
    // This function is invoked when an arbitrary GamObject collides with the map boundary
    func objectDidCollideWithMap(object: SKSpriteNode) {
        object.removeAllActions()
    }
    /* End of collision delegate function implementations */
    
    /* Start of supporting functions for collision implementation */
    // This function checks whether the bullet is colliding with its own mothership
    private func bulletCollideWithItsMothership(bulletNode: SKSpriteNode, playerNode: SKSpriteNode) -> Bool {
        let bulletMothershipController = self.playerControllers.filter({$0.weaponPool.map({ele in ele.shape}).contains(bulletNode)})[0]
        return bulletMothershipController.player.shape == playerNode
    }
    
    // This function updates the player when it is detected to have been hit by an obstacle or bullet
    private func playerGotHit(player: SKSpriteNode) {
        let collidedPlayerController = self.playerControllers.filter({$0.player.shape == player})[0]
        collidedPlayerController.player.hitByObstacle()
        if collidedPlayerController.player.checkDead() {
            print ("game over!")
        }
    }
    /* End of supporting functions for collision implementation */
    
    private func _checkRep() {
        assert(self.numberOfPlayers == playerControllers.count, "Invalid number of players.")
    }
}

// Mark: functions defined in the GameLogic protocol, but should not be implemented under the design
extension MultiplayerGameLogic {
    func upgradePackDidCollideWithPlayer(upgrade: SKSpriteNode, player: SKSpriteNode) {
    }
    
    func grenadeDidCollideWithObstacle(obstacle: SKSpriteNode, grenade: SKSpriteNode) {
    }
    
    func obstaclesDidCollideWithEachOther(obs1: SKSpriteNode, obs2: SKSpriteNode) {
    }
    
    func updateObstaclesVelocityHandler() {
    }
}

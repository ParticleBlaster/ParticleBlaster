//
//  GameLogic.swift
//  ParticleBlaster
//
//  Created by Bohan Huang on 29/3/17.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

/**
 *  The `GameLogic` protocol defines the basic methods and properties of
 *  To define the logic of a new game play
 *      - Create a class conforming to this protocol
 *      - Implement the basic methods and properties of the class
 *      - Define any other methods in the class for unique game logic
 */

import SpriteKit

protocol GameLogic {
    // Game Controller
    var gameViewController: GameViewController { get set }
    
    /* Start of game logic related properties */
    var winningCondition: Bool { get }
    var losingCondition: Bool { get }
    /* End of game logic related properties */
    
    /* Start of game object related properties */
    // The number of players in the game
    var numberOfPlayers: Int { get set }
    // The player-controllers for each player
    var playerControllers: [PlayerController] { get set }
    // The obstacles in the game
    var obstaclePool: [Obstacle] { get set }
    // The map boundary of the game
    var map: Boundary { get set }
    /* End of game object related properties */
    
    /* Start of Obstacles behavior related methods */
    func obtainObstaclesHandler() -> [Obstacle]
    func updateObstaclesVelocityHandler()
    /* End of obstacles behavior related methods */
    
    /* Start of collision related methods */
    func bulletDidCollideWithObstacle(bullet: SKSpriteNode, obstacle: SKSpriteNode)
    func bulletDidCollideWithPlayer(bullet: SKSpriteNode, player: SKSpriteNode)
    func grenadeDidCollideWithObstacle(obstacle: SKSpriteNode, grenade: SKSpriteNode)
    func obstacleDidCollideWithPlayer(obs: SKSpriteNode, player: SKSpriteNode)
    func obstaclesDidCollideWithEachOther(obs1: SKSpriteNode, obs2: SKSpriteNode)
    func objectDidCollideWithMap(object: SKSpriteNode)
    func upgradePackDidCollideWithPlayer(upgrade: SKSpriteNode, player: SKSpriteNode)
    /* End of collision related methods */
}

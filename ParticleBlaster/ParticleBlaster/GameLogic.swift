//
//  GameLogic.swift
//  ParticleBlaster
//
//  Created by Bohan Huang on 29/3/17.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

import Foundation
import SpriteKit

protocol GameLogic {
    var gameViewController: GameViewController { get set }
    var numberOfPlayers: Int { get set }
    var playerControllers: [PlayerController] { get set }
    var obstaclePool: [Obstacle] { get set }
    var map: MapObject { get set }
    var winningCondition: Bool { get }
    var losingCondition: Bool { get }
    
    func getObstacleList() -> [Obstacle]
    func updateObstacleVelocityHandler()
    func bulletDidCollideWithObstacle(bullet: SKSpriteNode, obstacle: SKSpriteNode)
    func obstacleDidCollideWithPlayer(obs: SKSpriteNode, player: SKSpriteNode)
    func obstaclesDidCollideWithEachOther(obs1: SKSpriteNode, obs2: SKSpriteNode)
    func objectDidCollideWithMap(object: SKSpriteNode)
    func bulletDidCollideWithPlayer(bullet: SKSpriteNode, player: SKSpriteNode)
    func upgradePackDidCollideWithPlayer(upgrade: SKSpriteNode, player: SKSpriteNode)
}

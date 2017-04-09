//
//  GameLevel.swift
//  ParticleBlaster
//
//  Created by Richthofen on 26/03/2017.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

import Foundation
import CoreGraphics

class GameLevel: NSObject, NSCoding {
    // index of the level in level list (index from 0)
    var id: Int = 0
    var highestScore: Int = 0
    var obstacles = [Obstacle]()
    var gameMode: GameMode
    var backgroundImageName: String? = nil
    var players: [Player] = []
    var playerPositions: [CGPoint] = []
    var simpleObstacles = [SimpleObstacle]()
    
    init(id: Int = 0, gameMode: GameMode = .single) {
        self.gameMode = gameMode
        self.id = id
        self.highestScore = 0
    }

    var obstacleCount: Int {
        return obstacles.count
    }

    func addObstacle(_ obs: Obstacle) {
        obstacles.append(obs)
    }

    func removeObstacle(at index: Int) {
        guard 0 <= index && index < obstacles.count else {
            return
        }
        obstacles.remove(at: index)
    }

    required convenience init?(coder decoder: NSCoder) {
        guard let simpleObstacles = decoder.decodeObject(forKey: Constants.obstaclesKey) as? [SimpleObstacle],
            let playerPositions = decoder.decodeObject(forKey: Constants.playerPositionsKey) as? [CGPoint] else {
                return nil
        }
        let id = decoder.decodeInteger(forKey: Constants.gameIdKey)
        let gameMode = GameMode(rawValue: decoder.decodeInteger(forKey: Constants.gameModekey)) ?? .single
        self.init(id: id, gameMode: gameMode)
        self.obstacles = simpleObstacles.map { return Obstacle(image: $0.imageName, userSetInitialPosition: $0.position, isPhysicsBody: false) }
        self.playerPositions = playerPositions
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: Constants.gameIdKey)
        simpleObstacles = obstacles.map { return SimpleObstacle(obstacle: $0) }
        aCoder.encode(simpleObstacles, forKey: Constants.obstaclesKey)
        aCoder.encode(gameMode.rawValue, forKey: Constants.gameModekey)
        aCoder.encode(playerPositions, forKey: Constants.playerPositionsKey)
    }
}

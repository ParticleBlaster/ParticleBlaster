//
//  GameLevel.swift
//  ParticleBlaster
//
//  Created by Richthofen on 26/03/2017.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

import Foundation

class GameLevel: NSObject, NSCoding {
    var name: String
    var highestScore: Int
    var difficulty: LevelDifficultyLevel
    var obstacles = [Obstacle]()
//    var players = [Player]()

    
    override init() {
        self.name = ""
        self.highestScore = 0
        self.difficulty = LevelDifficultyLevel.UNDEFINED
    }
    
    init(_ name: String) {
        self.name = name
        self.highestScore = 0
        self.difficulty = LevelDifficultyLevel.UNDEFINED
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
        guard let levelName = decoder.decodeObject(forKey: Constants.levelNameKey) as? String,
            let obstacles = decoder.decodeObject(forKey: Constants.obstaclesKey) as? [Obstacle] else {
                return nil
        }
        self.init(levelName)
        self.obstacles = obstacles
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: Constants.levelNameKey)
        aCoder.encode(obstacles, forKey: Constants.obstaclesKey)
    }
}

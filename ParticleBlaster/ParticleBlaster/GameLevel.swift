//
//  GameLevel.swift
//  ParticleBlaster
//
//  Created by Richthofen on 26/03/2017.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

import Foundation

class GameLevel {
    var name: String
    var highestScore: Int
    var difficulty: LevelDifficultyLevel
    var obstacles = [Obstacle]()
//    var players = [Player]()

    
    init() {
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

}

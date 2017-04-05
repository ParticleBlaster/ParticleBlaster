//
//  GameData.swift
//  ParticleBlaster
//
//  Created by Bui Hiep on 6/4/17.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

import Foundation

class GameData: NSObject, NSCoding {
    static var instance: GameData? = nil
    var numSingleModeLevel: Int = 20
    var numMultiModeLevel: Int = 0
    var achievedSingleModeLevel: Int = -1

    static func getInstance() -> GameData {
        if instance == nil {
            instance = FileUtils.loadGameData() ?? GameData()
        }
        return instance!
    }

    func saveLevel(_ level: GameLevel) -> Bool {
        guard FileUtils.saveGameLevel(level) else {
            return false
        }
        if level.gameMode == .single {
            numSingleModeLevel = max(numSingleModeLevel, level.id + 1)
        } else {
            numMultiModeLevel = max(numMultiModeLevel, level.id + 1)
        }
        return FileUtils.saveGameData()
    }

    func createLevel(gameMode: GameMode) -> GameLevel {
        let id = gameMode == .single ? numSingleModeLevel : numMultiModeLevel
        return GameLevel(id: id, gameMode: gameMode)
    }
    
    // MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(numMultiModeLevel, forKey: Constants.gameDataNumMultiModeLevelKey)
        aCoder.encode(achievedSingleModeLevel, forKey: Constants.gameDataAchievedSingleModeLevelKey)
    }

    required convenience init?(coder aDecoder: NSCoder) {
        let numMultiModeLevel = aDecoder.decodeInteger(forKey: Constants.gameDataNumMultiModeLevelKey)
        let achievedSingleModeLevel = aDecoder.decodeInteger(forKey: Constants.gameDataAchievedSingleModeLevelKey)
        self.init()
        self.numMultiModeLevel = numMultiModeLevel
        self.achievedSingleModeLevel = achievedSingleModeLevel
    }
}

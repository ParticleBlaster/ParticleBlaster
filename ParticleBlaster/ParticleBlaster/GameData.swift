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
//    var numSingleModeLevel: Int = 20
//    var numMultiModeLevel: Int = 0
//    var achievedSingleModeLevel: Int = -1
    var numSingleModeLevel: Int = 0
    var numMultiModeLevel: Int = 0
    var achievedSingleModeLevel: Int = 1000
    

    static func getInstance() -> GameData {
        if instance == nil {
            instance = FileUtils.loadGameData() ?? GameData()
        }
        return instance!
    }

    func finishGameLevel(_ level: GameLevel) {
        guard level.gameMode == .single else {
            return
        }
        guard level.id > achievedSingleModeLevel else {
            return
        }
        achievedSingleModeLevel = min(numSingleModeLevel - 1, level.id)
        GameCenterUtils.submitAchievedLevelToGC(achievedSingleModeLevel)
        let _ = FileUtils.saveGameData()
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
    // TODO: Do not save numSingleModeLevel when change back to support level design for multiple mode
    func encode(with aCoder: NSCoder) {
        aCoder.encode(numSingleModeLevel, forKey: Constants.gameDataNumSingleModeLevelKey)
        aCoder.encode(numMultiModeLevel, forKey: Constants.gameDataNumMultiModeLevelKey)
        aCoder.encode(achievedSingleModeLevel, forKey: Constants.gameDataAchievedSingleModeLevelKey)
    }

    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
        self.numSingleModeLevel = aDecoder.decodeInteger(forKey: Constants.gameDataNumSingleModeLevelKey)
        self.numMultiModeLevel = aDecoder.decodeInteger(forKey: Constants.gameDataNumMultiModeLevelKey)
        self.achievedSingleModeLevel = aDecoder.decodeInteger(forKey: Constants.gameDataAchievedSingleModeLevelKey)
    }
}

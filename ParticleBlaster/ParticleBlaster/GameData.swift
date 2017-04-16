//
//  GameData.swift
//  ParticleBlaster
//
//  Created by Bui Hiep on 6/4/17.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

import Foundation

/*
 *  The `GameData` class is the model keeping information gereral game data
 *  It contains the following properties:
 *      -   instance                : static property to support singlaton pattern
 *      -   numSingleModeLevel      : number of single player mode levels (default to be 12 - number of pre-defined levels)
 *      -   numMultiModeLevel       : number of multiple player mode levels
 *      -   achivedSingleModeLevel  : highest level that user have cleared (default to be -1). This
 *          property is used to lock levels that user are not allow to play at current time.
 */
class GameData: NSObject, NSCoding {
    static var instance: GameData? = nil
    var numSingleModeLevel: Int = 12
    var numMultiModeLevel: Int = 0
    var achievedSingleModeLevel: Int = -1
    

    // Singlaton pattern to get instance of the GameData
    static func getInstance() -> GameData {
        if instance == nil {
            instance = FileUtils.loadGameData() ?? GameData()
        }
        return instance!
    }

    // Update game data when user finish one level
    func finishGameLevel(_ level: GameLevel) {
        guard level.gameMode == .single else {
            return
        }
        guard level.id > achievedSingleModeLevel else {
            return
        }
        achievedSingleModeLevel = max(achievedSingleModeLevel, level.id)
        let _ = FileUtils.saveGameData()
    }

    // Save the game level and update the corresponding properties
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

    // create a empty level for provided game mode
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
        self.init()
        self.numMultiModeLevel = aDecoder.decodeInteger(forKey: Constants.gameDataNumMultiModeLevelKey)
        self.achievedSingleModeLevel = aDecoder.decodeInteger(forKey: Constants.gameDataAchievedSingleModeLevelKey)
    }
}

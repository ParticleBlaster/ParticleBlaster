//
//  FIleUtils.swift
//  ParticleBlaster
//
//  Created by Bui Hiep on 23/3/17.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

import Foundation

class FileUtils {
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!

    static func loadSetting() -> GameSetting? {
        let fileUrl = DocumentsDirectory.appendingPathComponent(Constants.settingFileName)
        return NSKeyedUnarchiver.unarchiveObject(withFile: fileUrl.path) as? GameSetting
    }

    static func saveSetting() -> Bool {
        let setting = GameSetting.getInstance()
        let fileUrl = DocumentsDirectory.appendingPathComponent(Constants.settingFileName)
        return NSKeyedArchiver.archiveRootObject(setting, toFile: fileUrl.path)
    }

    static func loadLevelNameList() -> [String] {
        return []
    }

    static func saveLevelNameList(levelNameList: [String]) -> Bool {
        return false
    }

    static func getLevelUrl(named levelName: String) -> URL {
        return DocumentsDirectory.appendingPathComponent(Constants.levelPrefix + levelName)
    }
    
    static func loadGameLevel(named levelName: String) -> GameLevel? {
        let fileUrl = getLevelUrl(named: levelName)
        return NSKeyedUnarchiver.unarchiveObject(withFile: fileUrl.path) as? GameLevel
    }

    static func saveGameLevel(_ gameLevel: GameLevel) -> Bool {
        let fileUrl = getLevelUrl(named: gameLevel.name)
        return NSKeyedArchiver.archiveRootObject(gameLevel, toFile: fileUrl.path)
    }
}

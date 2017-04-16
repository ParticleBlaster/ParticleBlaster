//
//  FIleUtils.swift
//  ParticleBlaster
//
//  Created by Bui Hiep on 23/3/17.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

import Foundation

/*
 *  The FileUtils class includes methods which support saving and loading data in user device
 */
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

    static func loadGameData() -> GameData? {
        let fileUrl = DocumentsDirectory.appendingPathComponent(Constants.gameDataFilename)
        return NSKeyedUnarchiver.unarchiveObject(withFile: fileUrl.path) as? GameData
    }

    static func saveGameData() -> Bool {
        let gameData = GameData.getInstance()
        let fileUrl = DocumentsDirectory.appendingPathComponent(Constants.gameDataFilename)
        return NSKeyedArchiver.archiveRootObject(gameData, toFile: fileUrl.path)
    }
    
    /// Get level filename for particular game id and game mode
    static func getLevelFilename(id: Int, gameMode: GameMode = .single) -> String {
        return "\(Constants.levelPrefix)_\(gameMode.rawValue)_\(id)"
    }
    
    /// Get the level file url which we use to store the game level for particular game id and mode
    static func getLevelUrl(id: Int, gameMode: GameMode = .single) -> URL {
        return DocumentsDirectory.appendingPathComponent(getLevelFilename(id: id, gameMode: gameMode))
    }
    
    static func loadGameLevel(id: Int, gameMode: GameMode = .single) -> GameLevel? {
        let fileUrl = getLevelUrl(id: id, gameMode: gameMode)
        return NSKeyedUnarchiver.unarchiveObject(withFile: fileUrl.path) as? GameLevel
    }

    static func saveGameLevel(_ gameLevel: GameLevel) -> Bool {
        let fileUrl = getLevelUrl(id: gameLevel.id, gameMode: gameLevel.gameMode)
        return NSKeyedArchiver.archiveRootObject(gameLevel, toFile: fileUrl.path)
    }

    /// This method is called once when user open the app. It will check if this is very first time when user launch the app
    ///  then it will save pre-defined levels into device
    static func savePreloadGameLevels() {
        // Detect is the first launch of user
        let launchedBefore = UserDefaults.standard.bool(forKey: Constants.launchedBeforeKey)
        guard !launchedBefore else {
            return
        }
        UserDefaults.standard.set(true, forKey: Constants.launchedBeforeKey)
        for index in 0..<GameData.getInstance().numSingleModeLevel {
            let filename = getLevelFilename(id: index, gameMode: .single)
            guard let filePath = Bundle.main.path(forResource: filename, ofType: nil) else {
                continue
            }
            let targetPath = getLevelUrl(id: index, gameMode: .single).path
            let _ = copyFile(fromPath: filePath, toPath: targetPath)
        }
    }

    /// Copy file from particular file path to other file path in the device
    static func copyFile(fromPath: String, toPath: String) -> Bool {
        let fileManager = FileManager.default
        do {
            try fileManager.copyItem(atPath: fromPath, toPath: toPath)
            return true
        }
        catch {
            return false
        }
    }
}

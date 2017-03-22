//
//  Setting.swift
//  ParticleBlaster
//
//  Created by Bui Hiep on 23/3/17.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

import Foundation

class GameSetting: NSObject, NSCoding {
    static var instance: GameSetting? = nil
    var isSoundEnabled: Bool
    var isMusicEnabled: Bool

    static func getInstance() -> GameSetting {
        if instance == nil {
            instance = FileUtils.loadSetting() ?? GameSetting()
        }
        return instance!
    }

    init(musicEnabled: Bool = true, soundEnabled: Bool = true) {
        isSoundEnabled = soundEnabled
        isMusicEnabled = musicEnabled
    }

    // MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(isSoundEnabled, forKey: Constants.settingSoundKey)
        aCoder.encode(isMusicEnabled, forKey: Constants.settingMusicKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let soundEnabled = aDecoder.decodeBool(forKey: Constants.settingSoundKey)
        let musicEnabled = aDecoder.decodeBool(forKey: Constants.settingMusicKey)
        self.init(musicEnabled: musicEnabled, soundEnabled: soundEnabled)
    }

}

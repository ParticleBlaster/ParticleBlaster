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
    var isSoundEnabled: Bool {
        didSet {
            guard oldValue != isSoundEnabled else {
                return
            }
            if !FileUtils.saveSetting() {
                isSoundEnabled = oldValue
            }
        }
    }
    var isMusicEnabled: Bool {
        didSet {
            guard oldValue != isMusicEnabled else {
                return
            }
            if !FileUtils.saveSetting() {
                isMusicEnabled = oldValue
            }
        }
    }

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

    func toggleMusic() {
        isMusicEnabled = !isMusicEnabled
    }

    func toggleSound() {
        isSoundEnabled = !isSoundEnabled
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

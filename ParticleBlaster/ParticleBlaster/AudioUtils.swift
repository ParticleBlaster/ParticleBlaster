//
//  AudioUtils.swift
//  ParticleBlaster
//
//  Created by Bui Hiep on 31/3/17.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//
import SpriteKit
import AVFoundation

class AudioUtils {
    static var gameSetting = GameSetting.getInstance()
    static var buttonPressedSound = SKAction.playSoundFileNamed(Constants.buttonPressedSoundFilename, waitForCompletion: false)
    static var shootingSound = SKAction.playSoundFileNamed(Constants.shootingSoundFilename, waitForCompletion: false)
    static var backgroundPlayer: AVAudioPlayer? = nil

    public static func pressButton(on scene: SKNode) {
        guard gameSetting.isSoundEnabled else {
            return
        }
        scene.run(buttonPressedSound)
    }

    public static func playShootingSound(on scene: SKNode) {
        scene.run(shootingSound)
    }
    
    public static func playBackgroundMusic() {
        if backgroundPlayer == nil {
            let url = Bundle.main.url(forResource: Constants.backgroundSoundFilename, withExtension: "caf")!
            do {
                backgroundPlayer = try AVAudioPlayer(contentsOf: url)
                // negative value to make it loop forever
                backgroundPlayer?.numberOfLoops = -1
                backgroundPlayer?.prepareToPlay()
                
            } catch let error {
                print(error.localizedDescription)
                return
            }
        }
        backgroundPlayer?.play()
    }

    public static func pauseBackgroundMusic() {
        guard let player = backgroundPlayer else {
            return
        }
        player.pause()
    }
}

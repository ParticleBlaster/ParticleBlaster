//
//  AudioUtils.swift
//  ParticleBlaster
//
//  Created by Bui Hiep on 31/3/17.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//
import SpriteKit
import AVFoundation

/*
 *  The AudioUtils class includes methods which support playing audios
 */
class AudioUtils {
    static var gameSetting = GameSetting.getInstance()
    static var buttonPressedSound = SKAction.playSoundFileNamed(Constants.buttonPressedSoundFilename, waitForCompletion: false)
    static var backgroundPlayer: AVAudioPlayer? = nil

    /// Play the sound when button pressed
    public static func pressButton(on scene: SKNode) {
        guard gameSetting.isSoundEnabled else {
            return
        }
        scene.run(buttonPressedSound)
    }

    /// Play the music with particular file name
    public static func playMusic(named fileName: String, on scene: SKNode) {
        guard gameSetting.isMusicEnabled else {
            return
        }
        let action = SKAction.playSoundFileNamed(fileName, waitForCompletion: false)
        scene.run(action)
    }
    
    /// Start or continue playing background music
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

    /// Pause playing background music
    public static func pauseBackgroundMusic() {
        guard let player = backgroundPlayer else {
            return
        }
        player.pause()
    }
}

//
//  GameCenterUtils.swift
//  ParticleBlaster
//
//  Created by Bui Hiep on 31/3/17.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

import GameKit

class GameCenterUtils {
    static let levelLeaderboardID = "com.score.levelLeaderboard"

    static var gcEnabled = false

    /// Authenticate local player
    static func authenticateLocalPlayer(in vc: UIViewController, completion: ((_ isSuccess: Bool) -> Void)? = nil) {
        let localPlayer: GKLocalPlayer = GKLocalPlayer.localPlayer()

        localPlayer.authenticateHandler = {(ViewController, error) -> Void in
            if((ViewController) != nil) {
                // Show login if player is not logged in
                vc.present(ViewController!, animated: true, completion: nil)
            } else if (localPlayer.isAuthenticated) {
                // Player is already authenticated & logged in, load game center
                self.gcEnabled = true
                if let completion = completion {
                    completion(true)
                }
            } else {
                // Game center is not enabled on the users device
                self.gcEnabled = false
                if let completion = completion {
                    completion(false)
                }
            }
        }
    }

    static func submitAchievedLevelToGC(_ level: Int) {
        guard gcEnabled else {
            return
        }
        // Submit score to GC leaderboard
        let bestScoreInt = GKScore(leaderboardIdentifier: levelLeaderboardID)
        bestScoreInt.value = Int64(level)
        GKScore.report([bestScoreInt])
    }

    static func submitScore(for level: Int, score: Int, completion: (() -> Void)?) {
        guard gcEnabled else {
            return
        }
        guard let leaderboardId = getLeaderboardId(level: level) else {
            return
        }
    
        let bestScoreInt = GKScore(leaderboardIdentifier: leaderboardId)
        bestScoreInt.value = Int64(score)
        GKScore.report([bestScoreInt]) { (error) in
            if error == nil, let callback = completion {
                callback()
            }
        }
    }

    static func getLeaderboardId(level: Int) -> String? {
        guard level >= 0 || level < Constants.numOfPreloadSingleModeLevel else {
            return nil
        }
        return "com.score.level_\(level + 1)_Leaderboard"
    }

    /// Open leaderboard high score for specific level in single mode
    static func openLeaderboard(in vc: UIViewController, level: Int) {
        guard gcEnabled else {
            return
        }
        guard let leaderboardId = getLeaderboardId(level: level) else {
            return
        }
        guard let gcDelegate = vc as? GKGameCenterControllerDelegate else {
            return
        }
        let gcVC = GKGameCenterViewController()
        gcVC.gameCenterDelegate = gcDelegate
        gcVC.viewState = .leaderboards
        gcVC.leaderboardIdentifier = leaderboardId
        vc.present(gcVC, animated: true, completion: nil)
    }

    /// Open default leaderboard for showing highest achieved level
    static func openLevelLeaderboard(in vc: UIViewController) {
        guard gcEnabled else {
            return
        }
        guard let gcDelegate = vc as? GKGameCenterControllerDelegate else {
            return
        }
        let gcVC = GKGameCenterViewController()
        gcVC.gameCenterDelegate = gcDelegate
        gcVC.viewState = .leaderboards
        gcVC.leaderboardIdentifier = levelLeaderboardID
        vc.present(gcVC, animated: true, completion: nil)
    }
}

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
    static func submitAchievedLevelToGC(_ level: Int) {
        guard gcEnabled else {
            return
        }
        // Submit score to GC leaderboard
        let bestScoreInt = GKScore(leaderboardIdentifier: levelLeaderboardID)
        bestScoreInt.value = Int64(level)
        GKScore.report([bestScoreInt]) { (error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                print("Best Score submitted to your Leaderboard!")
            }
        }
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
            if error != nil {
                print(error!.localizedDescription)
            } else {
                print("Best Score submitted to your level \(level + 1) Leaderboard!")
                if let callback = completion {
                    callback()
                }
            }
        }
    }

    static func getLeaderboardId(level: Int) -> String? {
        guard level >= 0 || level < Constants.numOfPreloadSingleModeLevel else {
            return nil
        }
        return "com.score.level_\(level + 1)_Leaderboard"
    }

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

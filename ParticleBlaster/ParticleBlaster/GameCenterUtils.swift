//
//  GameCenterUtils.swift
//  ParticleBlaster
//
//  Created by Bui Hiep on 31/3/17.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

import GameKit

class GameCenterUtils {
    static func submitAchievedLevelToGC(_ level: Int) {
        // Submit score to GC leaderboard
        let bestScoreInt = GKScore(leaderboardIdentifier: Constants.levelLeaderboardID)
        bestScoreInt.value = Int64(level)
        GKScore.report([bestScoreInt]) { (error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                print("Best Score submitted to your Leaderboard!")
            }
        }
    }
}

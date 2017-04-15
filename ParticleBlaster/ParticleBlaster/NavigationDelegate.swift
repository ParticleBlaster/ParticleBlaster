//
//  NavigationProtocol.swift
//  ParticleBlaster
//
//  Created by Bui Hiep on 23/3/17.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

/**
 *  The `NavigationDelegate` protocol defines the methods of navigation to scenes
 */

protocol NavigationDelegate {
    /// Navigate and pass gameLevel to GameViewController to start playing game
    func navigateToPlayScene(gameLevel: GameLevel)
    /// Open Design Scene and pass gameLevel as the initial game level
    func navigateToDesignScene(gameLevel: GameLevel)
    /// Open Level Select Scene with parameter gameMode to determine the list of levels - single or multiple mode
    func navigateToLevelSelectScene(gameMode: GameMode)
    /// Open Home Scene
    func navigateToHomePage()
    /// Open default Leaderboard
    func navigateToLeaderBoard()
}

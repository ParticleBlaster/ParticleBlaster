//
//  NavigationProtocol.swift
//  ParticleBlaster
//
//  Created by Bui Hiep on 23/3/17.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

protocol NavigationDelegate {
    func navigateToPlayScene(gameLevel: GameLevel)
    func navigateToDesignScene(gameLevel: GameLevel)
    func navigateToLevelSelectScene(gameMode: GameMode)
    func navigateToHomePage()
    func navigateToLeaderBoard()
}

//
//  NavigationProtocol.swift
//  ParticleBlaster
//
//  Created by Bui Hiep on 23/3/17.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

protocol NavigationDelegate {
    func navigateToPlayScene(isSingleMode: Bool)
    func navigateToDesignScene()
    func navigateToLevelSelectScene(isSingleMode: Bool)
    func navigateToHomePage()
}

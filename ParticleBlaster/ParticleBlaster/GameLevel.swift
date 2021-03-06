//
//  GameLevel.swift
//  ParticleBlaster
//
//  Created by Richthofen on 26/03/2017.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

import Foundation
import CoreGraphics

/*
 *  The `GameLevel` class is the base model keeping information about a game level
 *  It contains the following properties:
 *      -   id                  : Indentifier of the game level.
 *      -   obstacles           : List of obstacles in the screen
 *      -   players             : List of players in the screen
 *      -   gameMode            : Determine the game mode of this level, either .single or .multiple
 *      -   backgroundImageName : The background image filename of this level
 *      -   themeName           : The name of the theme that the assets of this level belong to.
 *
 *  The representation invariants - As we allow the level designer to init and modify 
 *      the game level during runtime, we will only do the checkRep for encode and decode methods:
 *      -   The number of players in the players array must be one if the game mode is single
 *      -   The number of players in the players array must be two if the game mode is multiple
 */
class GameLevel: NSObject, NSCoding {
    // index of the level in level list (index from 0)
    var id: Int = 0
    var obstacles = [Obstacle]()
    var players = [Player]()
    var gameMode: GameMode
    var backgroundImageName: String
    var themeName: String
    
    init(id: Int = 0, gameMode: GameMode = .single) {
        self.gameMode = gameMode
        self.id = id
        self.backgroundImageName = ""
        self.themeName = Constants.defaultThemeName
    }

    var obstacleCount: Int {
        return obstacles.count
    }

    func addObstacle(_ obs: Obstacle) {
        obstacles.append(obs)
    }

    func removeObstacle(at index: Int) {
        guard 0 <= index && index < obstacles.count else {
            return
        }
        obstacles.remove(at: index)
    }
    
    func removeAllObstacle() {
        obstacles.removeAll()
    }

    // MARK: NSCoding
    required convenience init?(coder decoder: NSCoder) {
        guard let obstacles = decoder.decodeObject(forKey: Constants.obstaclesKey) as? [Obstacle],
            let players = decoder.decodeObject(forKey: Constants.playersKey) as? [Player],
            let themeName = decoder.decodeObject(forKey: Constants.themeNameKey) as? String,
            let backgroundImageName = decoder.decodeObject(forKey: Constants.backgroundImageNameKey) as? String else {
                return nil
        }
        let id = decoder.decodeInteger(forKey: Constants.gameIdKey)
        let gameMode = GameMode(rawValue: decoder.decodeInteger(forKey: Constants.gameModekey)) ?? .single
        self.init(id: id, gameMode: gameMode)
        self.obstacles = obstacles
        self.players = players
        self.themeName = themeName
        self.backgroundImageName = backgroundImageName
        _checkRep()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: Constants.gameIdKey)
        aCoder.encode(obstacles, forKey: Constants.obstaclesKey)
        aCoder.encode(gameMode.rawValue, forKey: Constants.gameModekey)
        aCoder.encode(players, forKey: Constants.playersKey)
        aCoder.encode(themeName, forKey: Constants.themeNameKey)
        aCoder.encode(backgroundImageName, forKey: Constants.backgroundImageNameKey)
        _checkRep()
    }

    private func _checkRep() {
        if gameMode == .single {
            assert(players.count == 1, "Number of players in single mode must be 1")
        } else {
            assert(players.count == 2, "Number of players in multiple mode must be 2")
        }
    }
}

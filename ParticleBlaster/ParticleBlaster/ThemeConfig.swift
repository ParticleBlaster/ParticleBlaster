//
//  ThemeConfig.swift
//  ParticleBlaster
//
//  Created by Richthofen on 09/04/2017.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

import Foundation

struct ThemeConfig {
    static var themes = [String: Theme]()
    
    
    static let themeNames = ["StarWars",
                             "StarTrek",
                             "DoctorWho",
                             "EVA",
                             "Pixel",
                             "Monster"]
    static let themeObstacleNames = ["StarWars":obstacleFileNamesStarWars,
                                     "StarTrek":obstacleFileNamesStarTrek,
                                     "DoctorWho":obstacleFileNamesDoctorWho,
                                     "EVA":obstacleFileNamesEVA,
                                     "Pixel":obstacleFileNamesPixel,
                                     "Monster":obstacleFileNamesMonster]
    static let themeSpaceshipNames = ["StarWars":obstacleFileNamesStarWars,
                                     "StarTrek":obstacleFileNamesStarTrek,
                                     "DoctorWho":obstacleFileNamesDoctorWho,
                                     "EVA":obstacleFileNamesEVA,
                                     "Pixel":obstacleFileNamesPixel,
                                     "Monster":obstacleFileNamesMonster]
    static func setThemes() {
        for name in themeNames {
            setTheme(name: name,
                     logoName: "theme-\(name)",
                     obstacleNames: themeObstacleNames[name]!,
                     spaceshipNames: themeSpaceshipNames[name]!)
        }
    }
    
    static func setTheme(name: String, logoName: String, obstacleNames: [String], spaceshipNames: [String]) {
        let themeName = name
        let theme = Theme(themeName)
        theme.backgroundName = "deathStar"
        theme.iconName = logoName
        theme.obstaclesNames = obstacleNames
        theme.spaceshipsNames = spaceshipNames
        
        themes[themeName] = theme
    }
    
    static let obstacleFileNamesStarWars = ["starwars-bb8",
                                            "starwars-bountyhunter",
                                            "starwars-c3po",
                                            "starwars-darthvadar",
                                            "starwars-princess",
                                            "starwars-r2d2",
                                            "starwars-sith",
                                            "starwars-thundertrooper"]
    static let obstacleFileNamesStarTrek = ["startrek-blue-1",
                                            "startrek-blue-2",
                                            "startrek-red-1",
                                            "startrek-red-2",
                                            "startrek-yellow-1",
                                            "startrek-yellow-2",
                                            "startrek-spock",
                                            "startrek-logo",
                                            "startrek-llap"]
    static let obstacleFileNamesEVA = ["starwars-bb8",
                                            "starwars-bountyhunter",
                                            "starwars-c3po",
                                            "starwars-darthvadar",
                                            "starwars-princess",
                                            "starwars-r2d2",
                                            "starwars-sith",
                                            "starwars-thundertrooper"]
    static let obstacleFileNamesDoctorWho = ["starwars-bb8",
                                            "starwars-bountyhunter",
                                            "starwars-c3po",
                                            "starwars-darthvadar",
                                            "starwars-princess",
                                            "starwars-r2d2",
                                            "starwars-sith",
                                            "starwars-thundertrooper"]
    static let obstacleFileNamesPixel = ["obs",
                                         "obs-1",
                                         "obs-2",
                                         "obs-3",
                                         "obs-4",
                                         "obs-5"]
    
    static let obstacleFileNamesMonster = ["monster-1",
                                           "monster-2",
                                           "monster-3",
                                           "monster-4",
                                           "monster-5"]
}

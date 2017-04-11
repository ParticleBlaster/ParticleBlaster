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
    
    
    static let themeNames = ["default",
                             "StarWars",
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
                     logoName: "logo-\(name)",
                     obsNames: themeObstacleNames[name]!,
                     planeNames: themeSpaceshipNames[name]!)
        }
    }
    
    static func setTheme(name: String, logoName: String, obsNames: [String], planeNames: [String]) {
        let themeName = "StarWars"
        let starWars = Theme(themeName)
        starWars.backgroundName = "deathStar"
        
        themes[themeName] = starWars
    }
    
    static let obstacleFileNamesStarWars = ["starwars-bb8",
                                            "starwars-bountyhunter",
                                            "starwars-c3po",
                                            "starwars-darthvadar",
                                            "starwars-princess",
                                            "starwars-r2d2",
                                            "starwars-sith",
                                            "starwars-thundertrooper"]
    static let obstacleFileNamesStarTrek = ["starwars-bb8",
                                            "starwars-bountyhunter",
                                            "starwars-c3po",
                                            "starwars-darthvadar",
                                            "starwars-princess",
                                            "starwars-r2d2",
                                            "starwars-sith",
                                            "starwars-thundertrooper"]
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

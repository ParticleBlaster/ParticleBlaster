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


    static let themeNames = ["Planets",
                             "StarWars",
                             "StarTrek",
//                             "DoctorWho",
//                             "EVA",
                             "Monster"]

    static let themeObstacleNames = ["Planets":obstacleFileNamesPlanets,
                                     "StarWars":obstacleFileNamesStarWars,
                                     "StarTrek":obstacleFileNamesStarTrek,
                                     "DoctorWho":obstacleFileNamesDoctorWho,
                                     "EVA":obstacleFileNamesEVA,
                                     "Monster":obstacleFileNamesMonster]
    static let themeSpaceshipNames = ["Planets":spaceshipFileNamesPlanets,
                                      "StarWars":spaceshipFileNamesStarWars,
                                      "StarTrek":spaceshipFileNamesStarTrek,
                                      "DoctorWho":spaceshipFileNamesDoctorWho,
                                      "EVA":spaceshipFileNamesEVA,
                                      "Monster":spaceshipFileNamesMonster]
    static func setThemes() {
        for name in themeNames {
            setTheme(name: name,
                     logoName: "theme-\(name)",
                     backgroundName: "background-\(name)",
                     obstacleNames: themeObstacleNames[name]!,
                     spaceshipNames: themeSpaceshipNames[name]!)
        }
    }

    static func setTheme(name: String,
                         logoName: String,
                         backgroundName: String,
                         obstacleNames: [String],
                         spaceshipNames: [String]) {
        let themeName = name
        let theme = Theme(themeName)
        theme.backgroundName = backgroundName
        theme.iconName = logoName
        theme.obstaclesNames = obstacleNames
        theme.spaceshipsNames = spaceshipNames

        themes[themeName] = theme
    }


    // MARK: Default Theme
    // Theme Planet
    static let obstacleFileNamesPlanets = ["planet-1",
                                           "planet-2",
                                           "planet-3",
                                           "planet-4",
                                           "planet-5",
                                           "planet-6"]
    static let spaceshipFileNamesPlanets = ["planet-spaceship-1",
                                            "planet-spaceship-2"]

    // Theme StarWars
    static let obstacleFileNamesStarWars = ["starwars-bb8",
                                            "starwars-bountyhunter",
                                            "starwars-c3po",
                                            "starwars-darthvadar",
                                            "starwars-princess",
                                            "starwars-r2d2",
                                            "starwars-sith",
                                            "starwars-thundertrooper"]
    static let spaceshipFileNamesStarWars = ["starwars-spaceship-1",
                                             "starwars-spaceship-2"]

    // Theme StarWars
    static let obstacleFileNamesStarTrek = ["startrek-blue-1",
                                            "startrek-blue-2",
                                            "startrek-red-1",
                                            "startrek-red-2",
                                            "startrek-yellow-1",
                                            "startrek-yellow-2",
                                            "startrek-spock",
                                            "startrek-logo",
                                            "startrek-llap"]
    static let spaceshipFileNamesStarTrek = ["startrek-spaceship-1",
                                             "startrek-spaceship-2"]

    // Theme EVA
    static let obstacleFileNamesEVA = ["starwars-bb8",
                                        "starwars-bountyhunter",
                                        "starwars-c3po",
                                        "starwars-darthvadar",
                                        "starwars-princess",
                                        "starwars-r2d2",
                                        "starwars-sith",
                                        "starwars-thundertrooper"]
    static let spaceshipFileNamesEVA = ["eva-spaceship-1",
                                        "eva-spaceship-2"]

    // Theme Doctor Who
    static let obstacleFileNamesDoctorWho = ["starwars-bb8",
                                            "starwars-bountyhunter",
                                            "starwars-c3po",
                                            "starwars-darthvadar",
                                            "starwars-princess",
                                            "starwars-r2d2",
                                            "starwars-sith",
                                            "starwars-thundertrooper"]
    static let spaceshipFileNamesDoctorWho = ["doctorwho-spaceship-1",
                                             "doctorwho-spaceship-2"]

    // Theme Monster
    static let obstacleFileNamesMonster = ["monster-1",
                                           "monster-2",
                                           "monster-3",
                                           "monster-4",
                                           "monster-5",
                                           "monster-6"]
    static let spaceshipFileNamesMonster = ["monster-spaceship-1",
                                            "monster-spaceship-2"]
}

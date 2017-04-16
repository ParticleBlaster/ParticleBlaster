//
//  ThemeConfig.swift
//  ParticleBlaster
//
//  Created by Richthofen on 09/04/2017.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

/*
 *  The `Theme` class is the model for the Themes for GameLevel and LevelDesignerScene
 *  It contains the identifier attributes and
 *      - It defines the background image.
 *      - It defines a list of obstacles associated with this theme.
 *      - It defines a list of spaceships associated with this theme.
 */

struct ThemeConfig {
    /* Start of class attributes definition */
    static var themes = [String: Theme]()
    static let themeNames = ["Planets",
                             "StarWars"
                            ]
    static let themeObstacleNames = ["Planets":obstacleFileNamesPlanets,
                                     "StarWars":obstacleFileNamesStarWars]
    static let themeSpaceshipNames = ["Planets":spaceshipFileNamesPlanets,
                                      "StarWars":spaceshipFileNamesStarWars]
    /* End of class attributes definition */
    
    /* Start of theme setting functions */
    // This function sets up all the themes in the themes array
    static func setThemes() {
        for name in themeNames {
            setTheme(name: name,
                     logoName: "theme-\(name)",
                     backgroundName: "background-\(name)",
                     obstacleNames: themeObstacleNames[name]!,
                     spaceshipNames: themeSpaceshipNames[name]!)
        }
    }
    
    // This function initializes individual theme
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
    /* End of theme setting functions */

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
}

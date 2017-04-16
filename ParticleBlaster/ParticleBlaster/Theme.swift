//
//  Theme.swift
//  ParticleBlaster
//
//  Created by Richthofen on 09/04/2017.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

/*
 *  The `Theme` class is the model for the Themes for GameLevel and LevelDesignerScene
 *  It contains the identifier attributes and
 *      - It defines teh background image.
 *      - It defines a list of obstacles associated with this theme.
 *      - It defines a list of spaceships associated with this theme.
 */

class Theme {
    var name: String
    var iconName: String = ""
    var backgroundName: String = ""
    var obstaclesNames = [String]()
    var spaceshipsNames = [String]()
    
    /* Start of initializors */
    init(_ name: String) {
        self.name = name
    }
    /* End of initializors */
}

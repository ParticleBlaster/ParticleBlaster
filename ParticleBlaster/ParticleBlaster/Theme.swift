//
//  Theme.swift
//  ParticleBlaster
//
//  Created by Richthofen on 09/04/2017.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

import Foundation

class Theme {
    var name: String
    var logoName: String? = nil
    var backgroundName: String? = nil
    var obstacles = [Obstacle]()
    var players = [Player]()
    
    init(_ name: String) {
        self.name = name
    }
}

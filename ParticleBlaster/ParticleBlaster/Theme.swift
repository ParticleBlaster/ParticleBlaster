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
    var iconName: String = ""
    var backgroundName: String = ""
    var obstaclesNames = [String]()
    var spaceshipsNames = [String]()
    
    init(_ name: String) {
        self.name = name
    }
}

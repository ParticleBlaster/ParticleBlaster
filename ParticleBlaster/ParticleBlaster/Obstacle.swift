//
//  Obstacle.swift
//  ParticleBlaster
//
//  Created by Richard Jiang on 22/03/17.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

import SpriteKit

class Obstacle : GameObject {
    var initialPosition: CGPoint
    
    init(image: String) {
        self.initialPosition = CGPoint(x: Constants.obstacle1CenterX, y: Constants.obstacle1CenterY)
        super.init(imageName: image)
    }
    
    init() {
        self.initialPosition = CGPoint(x: Constants.obstacle1CenterX, y: Constants.obstacle1CenterY)
        super.init(imageName: "obs")
    }
    
    init(userSetInitialPosition: CGPoint) {
        self.initialPosition = userSetInitialPosition
        super.init(imageName: "obs")
    }
    
}

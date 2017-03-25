//
//  Bullet.swift
//  ParticleBlaster
//
//  Created by Richard Jiang on 23/03/17.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

import SpriteKit

class Bullet : GameObject {
    init(image: String) {
        super.init(imageName: image)
    }
    
    init() {
        super.init(imageName: "bullet-blue")
    }
    
}

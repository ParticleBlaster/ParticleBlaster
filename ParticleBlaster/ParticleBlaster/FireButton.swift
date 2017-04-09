//
//  FireButton.swift
//  ParticleBlaster
//
//  Created by Richard Jiang on 22/03/17.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

import SpriteKit

class FireButton : GameObject {
    init(image: String) {
        super.init(imageName: image)
    }
    
    override init() {
        super.init(imageName: "fire")
    }
    
    required convenience init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

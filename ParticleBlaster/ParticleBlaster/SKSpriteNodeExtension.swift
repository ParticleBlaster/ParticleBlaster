//
//  SKSpriteNodeExtension.swift
//  ParticleBlaster
//
//  Created by Richard Jiang on 09/04/17.
//  Copyright © 2017年 ParticleBlaster. All rights reserved.
//

import SpriteKit

class SKSpriteNodeWithMothership : SKSpriteNode {
    var mothership: SKSpriteNode
    var weaponType: WeaponCategory
    
    init(image: String, mothership: SKSpriteNode, weaponType: WeaponCategory) {
        //super.init(imageNamed: image)
        let texture = SKTexture(imageNamed: image)
        self.mothership = mothership
        self.weaponType = weaponType
        super.init(texture: texture, color: UIColor.init(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.0), size: texture.size())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

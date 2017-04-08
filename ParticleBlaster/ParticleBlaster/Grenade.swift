//
//  Grenade.swift
//  ParticleBlaster
//
//  Created by Richard Jiang on 06/04/17.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

import UIKit
import SpriteKit

class Grenade : GameObject {
    var exploded: Bool = false
    var grenadeAnimationList = [SKTexture]()
    
    init(image: String) {
        super.init(imageName: image)
        setupPhysicsProperty()
        self.grenadeAnimationList = SpriteUtils.obtainSpriteNodeList(textureName: "explosion", rows: 4, cols: 4)
    }
    
    init() {
        super.init(imageName: "bullet-orange")
        setupPhysicsProperty()
        self.grenadeAnimationList = SpriteUtils.obtainSpriteNodeList(textureName: "explosion", rows: 4, cols: 4)
    }
    
    private func setupPhysicsProperty() {
        let currGrenadeRadius = self.exploded ? (Constants.grenadeRadius * 4) : Constants.grenadeRadius
        self.shape.size = CGSize(width: currGrenadeRadius * 2, height: currGrenadeRadius * 2)
        self.shape.physicsBody = SKPhysicsBody(circleOfRadius: currGrenadeRadius)
        self.shape.physicsBody?.isDynamic = true
        self.shape.physicsBody?.categoryBitMask = PhysicsCategory.Grenade
        self.shape.physicsBody?.contactTestBitMask = PhysicsCategory.Obstacle //| PhysicsCategory.Player
        self.shape.physicsBody?.collisionBitMask = PhysicsCategory.None //PhysicsCategory.Obstacle
        //self.shape.physicsBody?.usesPreciseCollisionDetection = true
    }
    
    func explode() {
        if !self.exploded {
            self.exploded = true
            //self.shape.physicsBody?.velocity = CGVector.zero
            //let currCenter = self.shape.position
            //self.shape = SKSpriteNode(imageNamed: "bullet-red") // TODO: should be named as explodedGrenade
            self.shape.size = CGSize(width: Constants.grenadeRadius * 4, height: Constants.grenadeRadius * 4)
            self.shape.physicsBody = SKPhysicsBody(circleOfRadius: Constants.grenadeRadius * 2)
            self.shape.physicsBody?.isDynamic = false
            self.shape.physicsBody?.categoryBitMask = PhysicsCategory.Grenade
            self.shape.physicsBody?.contactTestBitMask = PhysicsCategory.Obstacle //| PhysicsCategory.Player
            self.shape.physicsBody?.collisionBitMask = PhysicsCategory.None
            //self.shape.position = currCenter
            
            let explosionAnimation = SKAction.animate(with: self.grenadeAnimationList, timePerFrame: 0.05)
            self.shape.run(explosionAnimation, completion: {
                
            })
            
        }
    }
}

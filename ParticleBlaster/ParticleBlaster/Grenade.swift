//
//  Grenade.swift
//  ParticleBlaster
//
//  Created by Richard Jiang on 06/04/17.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

import UIKit
import SpriteKit

class Grenade : Weapon {
    var exploded: Bool = false
    private var grenadeAnimationList = [SKTexture]()
    var explosionAdvertiser: ((SKSpriteNode) -> ())!
    
    static let explosionMusicName = Constants.grenadeExplodeSoundFilename
    
    // Standard initialisor for Game Play
    init(shootLocation: CGPoint, shootDirection: CGVector, rotation: CGFloat) {
        super.init(shootLocation: shootLocation, shootDirection: shootDirection, rotation: rotation, weaponType: WeaponCategory.Grenade)
        self.setupPhysicsProperty()
        self.grenadeAnimationList = SpriteUtils.obtainSpriteNodeList(textureName: "explosion", rows: 4, cols: 4)
    }
    
    override func launch() {
        let grenadeDistance = CGVector(dx: self.shootDirection.dx * Constants.grenadeThrowingDistance, dy: self.shootDirection.dy * Constants.grenadeThrowingDistance)
        
        self.shape.position = self.shootLocation
        self.shape.zRotation = self.rotation
        self.shape.zPosition = Constants.defaultWeaponZPosition
        
        let throwingAction = SKAction.move(by: grenadeDistance, duration: TimeInterval(Constants.grenadeThrowingTime))
        
        self.shape.run(throwingAction, completion: {
            self.explode()
        })
    }
    
    required convenience init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupPhysicsProperty() {
        self.shape.size = CGSize(width: Constants.grenadeRadius * 2, height: Constants.grenadeRadius * 2)
        //self.shape.physicsBody = SKPhysicsBody(circleOfRadius: Constants.grenadeRadius * 2)
        self.shape.physicsBody = SKPhysicsBody(texture: self.shape.texture!, size: (self.shape.texture?.size())!)
        self.shape.physicsBody?.isDynamic = true
        self.shape.physicsBody?.categoryBitMask = PhysicsCategory.Grenade
        self.shape.physicsBody?.contactTestBitMask = PhysicsCategory.Obstacle //| PhysicsCategory.Player
        self.shape.physicsBody?.collisionBitMask = PhysicsCategory.Obstacle //PhysicsCategory.Obstacle
    }
    
    func explode() {
        if !self.exploded {
            self.exploded = true
            self.shape.size = CGSize(width: Constants.grenadeRadius * 8, height: Constants.grenadeRadius * 8)
            self.shape.zPosition = Constants.grenadeExplosionAnimationZPosition
            //self.shape.physicsBody = SKPhysicsBody(circleOfRadius: Constants.grenadeRadius * 2)
            self.shape.physicsBody?.isDynamic = false
            self.shape.physicsBody?.velocity = CGVector.zero
            self.shape.physicsBody?.categoryBitMask = PhysicsCategory.None
            self.shape.physicsBody?.contactTestBitMask = PhysicsCategory.None
            self.shape.physicsBody?.collisionBitMask = PhysicsCategory.None
            
            let explosionAnimation = SKAction.animate(with: self.grenadeAnimationList, timePerFrame: 0.05)
            self.shape.run(explosionAnimation)
            if let grenadeDidExplodeHandler = self.explosionAdvertiser {
                grenadeDidExplodeHandler(self.shape)
            }
            
        }
    }
}

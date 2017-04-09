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
    
    // Standard initialisor for Game Play
    init(shootLocation: CGPoint, shootDirection: CGVector, rotation: CGFloat) {
        super.init(shootLocation: shootLocation, shootDirection: shootDirection, rotation: rotation, weaponType: WeaponCategory.Grenade)
        self.setupPhysicsProperty()
        self.grenadeAnimationList = SpriteUtils.obtainSpriteNodeList(textureName: "explosion", rows: 4, cols: 4)
        
        //        self.shootLocation = shootLocation
        //        self.shootDirection = shootDirection.normalized()
        //        self.rotation = rotation
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
    
    private func setupPhysicsProperty() {
//        let currGrenadeRadius = self.exploded ? (Constants.grenadeRadius * 4) : Constants.grenadeRadius
//        self.shape.size = CGSize(width: currGrenadeRadius * 2, height: currGrenadeRadius * 2)
//        self.shape.physicsBody = SKPhysicsBody(circleOfRadius: currGrenadeRadius * 2)
        
        self.shape.size = CGSize(width: Constants.grenadeRadius * 2, height: Constants.grenadeRadius * 2)
        self.shape.physicsBody = SKPhysicsBody(circleOfRadius: Constants.grenadeRadius * 2)
        self.shape.physicsBody?.isDynamic = true
        self.shape.physicsBody?.categoryBitMask = PhysicsCategory.Grenade
        self.shape.physicsBody?.contactTestBitMask = PhysicsCategory.Obstacle //| PhysicsCategory.Player
        self.shape.physicsBody?.collisionBitMask = PhysicsCategory.Obstacle //PhysicsCategory.Obstacle
        //self.shape.physicsBody?.usesPreciseCollisionDetection = true
    }
    
    func explode() {
        if !self.exploded {
            self.exploded = true
            self.shape.size = CGSize(width: Constants.grenadeRadius * 4, height: Constants.grenadeRadius * 4)
            self.shape.zPosition = Constants.grenadeExplosionAnimationZPosition
            //self.shape.physicsBody = SKPhysicsBody(circleOfRadius: Constants.grenadeRadius * 2)
            self.shape.physicsBody?.isDynamic = false
            self.shape.physicsBody?.velocity = CGVector.zero
            self.shape.physicsBody?.categoryBitMask = PhysicsCategory.None
            self.shape.physicsBody?.contactTestBitMask = PhysicsCategory.None
            self.shape.physicsBody?.collisionBitMask = PhysicsCategory.None
            //self.shape.position = currCenter
            
            let explosionAnimation = SKAction.animate(with: self.grenadeAnimationList, timePerFrame: 0.05)
            self.shape.run(explosionAnimation)
            
        }
    }
}

//
//  Bullet.swift
//  ParticleBlaster
//
//  Created by Richard Jiang on 23/03/17.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

import SpriteKit

class Bullet : Weapon {
    
    // Standard initialisor for Game Play
    init(shootLocation: CGPoint, shootDirection: CGVector, rotation: CGFloat) {
        super.init(shootLocation: shootLocation, shootDirection: shootDirection, rotation: rotation, weaponType: WeaponCategory.Bullet)
        self.setupPhysicsProperty()
    }

    
    required convenience init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupPhysicsProperty() {
        self.shape.size = CGSize(width: Constants.defaultBulletRadius * 2, height: Constants.defaultBulletRadius * 2)
        //self.shape.physicsBody = SKPhysicsBody(circleOfRadius: Constants.defaultBulletRadius)
        self.shape.physicsBody = SKPhysicsBody(texture: self.shape.texture!, size: (self.shape.texture?.size())!)
        self.shape.physicsBody?.isDynamic = true
        self.shape.physicsBody?.categoryBitMask = PhysicsCategory.Bullet
        self.shape.physicsBody?.contactTestBitMask = PhysicsCategory.Obstacle | PhysicsCategory.Player
        self.shape.physicsBody?.collisionBitMask = PhysicsCategory.None //PhysicsCategory.Obstacle
        self.shape.physicsBody?.usesPreciseCollisionDetection = true
    }
    
    override func launch() {
        let bulletVelocity = CGVector(dx: self.shootDirection.dx * Constants.bulletVelocity, dy: self.shootDirection.dy * Constants.bulletVelocity)
        
        self.updateVelocity(newVelocity: bulletVelocity)
        self.shape.position = self.shootLocation
        self.shape.zRotation = self.rotation
        self.shape.zPosition = Constants.defaultWeaponZPosition
        
    }
}

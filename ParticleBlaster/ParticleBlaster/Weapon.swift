//
//  Weapon.swift
//  ParticleBlaster
//
//  Created by Richard Jiang on 09/04/17.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

import UIKit
import SpriteKit

class Weapon : GameObject {
    
    var weaponType: WeaponCategory
    
    var shootLocation: CGPoint!
    var shootDirection: CGVector!
    var rotation: CGFloat!
    
    init(image: String) {
        self.weaponType = WeaponCategory.Bullet
        super.init(imageName: image)
        setupPhysicsProperty()
    }
    
    init() {
        self.weaponType = WeaponCategory.Bullet
        super.init(imageName: "bullet-blue")
        setupPhysicsProperty()
    }
    
    init(shootLocation: CGPoint, shootDirection: CGVector, rotation: CGFloat, weaponType: WeaponCategory) {
        self.weaponType = weaponType
        switch weaponType {
        case .Bullet:
            super.init(imageName: "bullet-blue")
        case .Grenade:
            super.init(imageName: "bullet-orange")
        case .Missile:
            super.init(imageName: "missile")
        }
        //super.init(imageName: "bullet-blue")
        self.setupPhysicsProperty()
        
        self.shootLocation = shootLocation
        self.shootDirection = shootDirection.normalized()
        self.rotation = rotation
        
    }
    
    private func setupPhysicsProperty() {
        self.shape.size = CGSize(width: Constants.defaultBulletRadius * 2, height: Constants.defaultBulletRadius * 2)
        self.shape.physicsBody = SKPhysicsBody(circleOfRadius: Constants.defaultBulletRadius)
        self.shape.physicsBody?.isDynamic = true
        self.shape.physicsBody?.categoryBitMask = PhysicsCategory.Bullet
        self.shape.physicsBody?.contactTestBitMask = PhysicsCategory.Obstacle | PhysicsCategory.Player
        self.shape.physicsBody?.collisionBitMask = PhysicsCategory.None //PhysicsCategory.Obstacle
        self.shape.physicsBody?.usesPreciseCollisionDetection = true
    }
    
    func launch() {
        
    }
}

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
    
    var lauchMusicName: String
    
    var shootLocation: CGPoint!
    var shootDirection: CGVector!
    var rotation: CGFloat!
    
    init(image: String) {
        self.weaponType = WeaponCategory.Bullet
        self.lauchMusicName = Constants.shootingSoundFilename
        super.init(imageName: image)
        setupPhysicsProperty()
    }
    
    init(shootLocation: CGPoint, shootDirection: CGVector, rotation: CGFloat, weaponType: WeaponCategory) {
        self.weaponType = weaponType
        switch weaponType {
        case .Bullet:
            self.lauchMusicName = Constants.shootingSoundFilename
            super.init(imageName: "bullet-blue")
        case .Grenade:
            self.lauchMusicName = Constants.throwGrenadeSoundFilename
            super.init(imageName: "bullet-orange")
        case .Missile:
            self.lauchMusicName = Constants.launchMissileSoundFilename
            super.init(imageName: "missile")
        }
        self.setupPhysicsProperty()
        
        self.shootLocation = shootLocation
        self.shootDirection = shootDirection.normalized()
        self.rotation = rotation
        
    }
    
    required convenience init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    func resetSpriteNodePhysicsProperties() {
        self.shape.physicsBody?.categoryBitMask = PhysicsCategory.None
        self.shape.physicsBody?.contactTestBitMask = PhysicsCategory.None
        self.shape.physicsBody?.collisionBitMask = PhysicsCategory.None
    }
}

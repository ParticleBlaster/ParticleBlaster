//
//  Weapon.swift
//  ParticleBlaster
//
//  Created by Richard Jiang on 09/04/17.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

/*
 * The `Weapon` class is the model for all available weapons to use in game play
 * It subclassed the basic GameObject class, and added extra functions for the unique attributes of weapon
 *      - It defines its basic weapon type and the launch msic associated with it
 *      - It defines the basic physics environment information when launching, including location, 
 *          direction, and rotation
 *      - Without explicit definition, the weapon will be initialized to a Bullet type
 *      - It provides the declaration for the launch method
 *      - It provides the API for resetting all physics properties to None type
 */


import UIKit
import SpriteKit

class Weapon : GameObject {
    
    /* Start of class attributes definition */
    var weaponType: WeaponCategory
    var lauchMusicName: String
    
    // The following attributes define the physics behaviors of the weapon when launching
    var shootLocation: CGPoint!
    var shootDirection: CGVector!
    var rotation: CGFloat!
    /* End of class attributes definition */
    
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
            super.init(imageName: Constants.defaultBulletSpriteFilename)
        case .Grenade:
            self.lauchMusicName = Constants.throwGrenadeSoundFilename
            super.init(imageName: Constants.defaultGrenadeSpriteFilename)
        case .Missile:
            self.lauchMusicName = Constants.launchMissileSoundFilename
            super.init(imageName: Constants.defaultMissileSpriteFilename)
        }
        self.setupPhysicsProperty()
        
        self.shootLocation = shootLocation
        self.shootDirection = shootDirection.normalized()
        self.rotation = rotation
        
    }
    
    required convenience init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /* Start of physics properties definition and update functions */
    // This function sets up the physics properties of the weapon, initialized to Bullet type
    private func setupPhysicsProperty() {
        self.shape.size = CGSize(width: Constants.defaultBulletRadius * 2, height: Constants.defaultBulletRadius * 2)
        self.shape.physicsBody = SKPhysicsBody(circleOfRadius: Constants.defaultBulletRadius)
        //self.shape.physicsBody = SKPhysicsBody(texture: self.shape.texture!, size: self.shape.size)
        self.shape.physicsBody?.isDynamic = true
        self.shape.physicsBody?.categoryBitMask = PhysicsCategory.Bullet
        self.shape.physicsBody?.contactTestBitMask = PhysicsCategory.Obstacle | PhysicsCategory.Player
        self.shape.physicsBody?.collisionBitMask = PhysicsCategory.None //PhysicsCategory.Obstacle
        self.shape.physicsBody?.usesPreciseCollisionDetection = true
    }
    
    // This function resets the physics properties to None to avoid duplicate collision
    func resetSpriteNodePhysicsProperties() {
        self.shape.physicsBody?.categoryBitMask = PhysicsCategory.None
        self.shape.physicsBody?.contactTestBitMask = PhysicsCategory.None
        self.shape.physicsBody?.collisionBitMask = PhysicsCategory.None
    }
    /* End of physics properties definition and update functions */
    
    // Function declaration for the launch handler; to be defined in subclasses
    func launch() {
    }
}

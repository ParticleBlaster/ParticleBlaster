//
//  Missile.swift
//  ParticleBlaster
//
//  Created by Richard Jiang on 03/04/17.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

import SpriteKit

class Missile : Weapon {
    
    var target: Obstacle!
    var isReady: Bool = false
    var scene: SKScene!
    
    init(targetObs: Obstacle) {
        self.target = targetObs
        super.init(image: "missile")
        self.setupPhysicsProperty()
    }
    
    // Standard initialisor for Game Play
    init(shootLocation: CGPoint, shootDirection: CGVector, rotation: CGFloat, targetObs: Obstacle, scene: SKScene) {
        super.init(shootLocation: shootLocation, shootDirection: shootDirection, rotation: rotation, weaponType: WeaponCategory.Missile)
        self.target = targetObs
        self.scene = scene
        self.setupPhysicsProperty()
    }
    
    override func launch() {
        self.shape.position = self.shootLocation
        self.shape.zRotation = self.rotation
        self.shape.zPosition = Constants.defaultWeaponZPosition
        
        let preparationDirection = self.shootDirection.orthonormalVector()
        let preparationOffset = CGVector(dx: preparationDirection.dx * Constants.missileLaunchOffset, dy: preparationDirection.dy * Constants.missileLaunchOffset)
        
        let missileFadeInAction = SKAction.fadeIn(withDuration: Constants.missileLaunchTime)
        let missileLaunchAction = SKAction.move(by: preparationOffset, duration: Constants.missileLaunchTime)
        let initialForce = CGVector(dx: shootDirection.dx * Constants.missileInitialForceValue, dy: shootDirection.dy * Constants.missileInitialForceValue)
        
        let missileReleaseAction = SKAction.group([missileFadeInAction, missileLaunchAction])
        self.shape.run(missileReleaseAction, completion: {
            let forceCenter = self.scene.convert(CGPoint(x: 0.5, y: 1), from: self.shape)
            let direction = CGVector(dx: self.target.shape.position.x - self.shape.position.x, dy: self.target.shape.position.y - self.shape.position.y).normalized()
            let rotationAngle = direction.eulerRotation()
            let missileInitalAccelerationAction = SKAction.applyForce(initialForce, at: forceCenter, duration: Constants.missileInitialAccelerationTime)
            
            let missileInitialRotateAction = SKAction.rotate(toAngle: rotationAngle, duration: Constants.missileInitialAccelerationTime)
            let missileFlyAction = SKAction.group([missileInitalAccelerationAction, missileInitialRotateAction])
            self.shape.run(missileFlyAction, completion: {
                self.isReadyToFly()
            })
        })
    }
    
    required convenience init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func isReadyToFly() {
        self.isReady = true
    }
    
    func updateRotation(newAngle: CGFloat) {
        self.shape.zRotation = newAngle
    }
    
    func updateFlyingVelocity() {
        let currPosition = self.shape.position
        let direction = CGVector(dx: self.target.shape.position.x - currPosition.x, dy: self.target.shape.position.y - currPosition.y).normalized()
        let nextAngle = direction.eulerRotation()
        let rotateAction = SKAction.rotate(toAngle: nextAngle, duration: 1)
        self.shape.run(rotateAction)
        
        let appliedForce = CGVector(dx: direction.dx * Constants.missileInitialForceValue, dy: direction.dy * Constants.missileInitialForceValue)
        let forceCenter = self.scene.convert(CGPoint(x: 0.5, y: 1), from: self.shape)
        self.pushedByForceWithPoint(appliedForce: appliedForce, point: forceCenter)
    }
    
    private func setupPhysicsProperty() {
        self.shape.size = CGSize(width: Constants.defaultBulletWidth, height: Constants.defaultBulletHeight)
        self.shape.physicsBody = SKPhysicsBody(rectangleOf: self.shape.size)
        self.shape.physicsBody?.isDynamic = true
        self.shape.physicsBody?.categoryBitMask = PhysicsCategory.Bullet
        self.shape.physicsBody?.contactTestBitMask = PhysicsCategory.Obstacle | PhysicsCategory.Player
        self.shape.physicsBody?.collisionBitMask = PhysicsCategory.None //PhysicsCategory.Obstacle
        self.shape.physicsBody?.usesPreciseCollisionDetection = true
    }
}

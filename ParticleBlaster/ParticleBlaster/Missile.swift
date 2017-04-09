//
//  Missile.swift
//  ParticleBlaster
//
//  Created by Richard Jiang on 03/04/17.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

import SpriteKit

class Missile : GameObject {
    
    var target: Obstacle!
    var isReady: Bool = false
    
//    override init() {
//        super.init(image: "missile")
//        self.setupPhysicsProperty()
//    }
    
    init(targetObs: Obstacle) {
        self.target = targetObs
        super.init(imageName: "missile")
        self.setupPhysicsProperty()
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

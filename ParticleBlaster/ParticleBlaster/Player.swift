//
//  Player.swift
//  ParticleBlaster
//
//  Created by Richard Jiang on 21/03/17.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

import SpriteKit

class Player : GameObject {
    var imageName: String
    var ratioPosition: CGPoint = .zero
    init(image: String = Constants.spaceshipFilename, timeToLive: Int = Constants.playerTimeToLive) {
        self.imageName = image
        super.init(imageName: image)
        self.timeToLive = timeToLive
        setupPhysicsProperty()
    }
    
    func updateRotation(newAngle: CGFloat) {
        self.shape.zRotation = newAngle
    }
    
    func hitByObstacle() {
        self.timeToLive -= 1
    }
    
    func checkDead() -> Bool {
        if self.timeToLive == 0 {
            return true
        } else {
            return false
        }
    }
    
    // Initializor supporting the storing of Obstacle objects using Object Archive
    required convenience init?(coder decoder: NSCoder) {
        guard let imageName = decoder.decodeObject(forKey: Constants.imageNameKey) as? String else {
            return nil
        }
        let ratioPosition = decoder.decodeCGPoint(forKey: Constants.ratioPositionKey)
        self.init(image: imageName)
        self.ratioPosition = ratioPosition
    }
    
    // Encoding function for supporting Object Archive
    override func encode(with aCoder: NSCoder) {
        aCoder.encode(imageName, forKey: Constants.imageNameKey)
        aCoder.encode(ratioPosition, forKey: Constants.ratioPositionKey)
    }
    
    // This function returns a copy of itself without physicsBody properties, except the position
    override func copy() -> Any {
        let copy = Player(image: self.imageName, timeToLive: self.timeToLive)
        copy.ratioPosition = self.ratioPosition
        // copy.shape.position = self.shape.position
        return copy
    }

    func setupPhysicsProperty() {
        self.shape.size = CGSize(width: Constants.playerWidth, height: Constants.playerHeight)
        //self.shape.physicsBody = SKPhysicsBody(texture: self.shape.texture!, size: self.shape.size)
        self.shape.physicsBody = SKPhysicsBody(texture: self.shape.texture!, size: self.shape.size)
        self.shape.physicsBody?.isDynamic = true
        self.shape.physicsBody?.categoryBitMask = PhysicsCategory.Player
        self.shape.physicsBody?.contactTestBitMask = PhysicsCategory.Obstacle | PhysicsCategory.Map
        self.shape.physicsBody?.collisionBitMask = PhysicsCategory.Map | PhysicsCategory.Obstacle | PhysicsCategory.Player
        self.shape.physicsBody?.mass = 0
    }
}

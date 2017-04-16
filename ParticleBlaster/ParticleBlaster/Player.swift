//
//  Player.swift
//  ParticleBlaster
//
//  Created by Richard Jiang on 21/03/17.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

/**
 *  The `Player` class defines the spaceship players controls
 *
 *  The representation invariants:
 *      - It should be a non static game object
 *      - The timeToLive value is non-negative
 */

import SpriteKit

class Player : GameObject {
    var imageName: String
    var ratioPosition: CGPoint = .zero
    
    init(image: String = Constants.spaceshipFilename, timeToLive: Int = Constants.playerTimeToLive) {
        self.imageName = image
        super.init(imageName: image, timeToLive: timeToLive)
        _checkRep()
        setupPhysicsProperty()
    }
    
    // Update the rotation of the player
    func updateRotation(newAngle: CGFloat) {
        _checkRep()
        self.shape.zRotation = newAngle
        _checkRep()
    }
    
    // Decrease the time to live value upon hit by obstalce
    func hitByObstacle() {
        _checkRep()
        self.timeToLive -= 1
        _checkRep()
    }
    
    // Check if player had been destroyed
    func checkDead() -> Bool {
        _checkRep()
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
        _checkRep()
    }
    
    // Encoding function for supporting Object Archive
    override func encode(with aCoder: NSCoder) {
        _checkRep()
        aCoder.encode(imageName, forKey: Constants.imageNameKey)
        aCoder.encode(ratioPosition, forKey: Constants.ratioPositionKey)
        _checkRep()
    }
    
    // This function returns a copy of itself without physicsBody properties, except the position
    override func copy() -> Any {
        _checkRep()
        let copy = Player(image: self.imageName, timeToLive: self.timeToLive)
        copy.ratioPosition = self.ratioPosition
        _checkRep()
        return copy
    }

    // This function set up the physics property of the player
    private func setupPhysicsProperty() {
        _checkRep()
        self.shape.size = CGSize(width: Constants.playerWidth,
                                 height: Constants.getHeightWithSameRatio(withWidth: Constants.playerWidth, forShape: self.shape))
        self.shape.physicsBody = SKPhysicsBody(circleOfRadius: Constants.playerRadius)
        self.shape.physicsBody?.isDynamic = true
        self.shape.physicsBody?.categoryBitMask = PhysicsCategory.Player
        self.shape.physicsBody?.contactTestBitMask = PhysicsCategory.Obstacle | PhysicsCategory.Map
        self.shape.physicsBody?.collisionBitMask = PhysicsCategory.Map | PhysicsCategory.Obstacle
        self.shape.physicsBody?.mass = 0
        _checkRep()
    }
    
    // A valid Player should be a non-static game object with timeToLive value >= 0
    private func _checkRep() {
        assert(self.isStatic == false, "Should be a non-static game object.")
        assert(self.timeToLive >= 0, "Invalid time to live value.")
    }
}

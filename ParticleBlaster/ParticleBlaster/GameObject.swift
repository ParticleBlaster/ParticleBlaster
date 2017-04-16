//
//  GameObject.swift
//  ParticleBlaster
//
//  Created by Richthofen on 16/03/2017.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

/*
 *  The `GameObject` class is the base model for all UI elements appearing in the game area
 *  It contains the fundamental SKSpriteNode for displaying purposes, a default timeToLive ('lives'), and a isStatic property
 *      - It defines the basic initialization of any object in the game area from images
 *      - It defines the basic APIs for modifying the physics properties of the object
 *
 *  The representation invariants:
 *      - The timeToLive value is non-negative
 */

import UIKit
import SpriteKit

class GameObject: NSObject, NSCoding {
    
    /* Start of class attributes definition */
    var shape: SKSpriteNode
    var timeToLive: Int
    var isStatic: Bool
    /* End of class attributes definition */
    
    
    /* Start of initializors and supporting functions */
    override init() {
        shape = SKSpriteNode()
        timeToLive = 0
        isStatic = true
        super.init()
    }
    
    init(shape: SKSpriteNode, timeToLive: Int, isStatic: Bool) {
        self.timeToLive = timeToLive
        self.shape = shape
        self.isStatic = isStatic
        super.init()
        _checkRep()
    }
    
    init(imageName: String, timeToLive: Int, isStatic: Bool) {
        let shapeNode = SKSpriteNode(imageNamed: imageName)
        self.shape = shapeNode
        self.timeToLive = timeToLive
        self.isStatic = isStatic
        super.init()
        _checkRep()
    }
    
    init(imageName: String, timeToLive: Int) {
        self.shape = SKSpriteNode(imageNamed: imageName)
        self.timeToLive = timeToLive
        self.isStatic = false
        super.init()
        _checkRep()
    }
    
    init(imageName: String) {
        self.shape = SKSpriteNode(imageNamed: imageName)
        self.timeToLive = Int.max
        self.isStatic = true
        super.init()
        _checkRep()
    }
    
    required convenience init?(coder decoder: NSCoder) {
        self.init()
    }
    
    func encode(with aCoder: NSCoder) {
    }
    /* End of initializors and supporting functions */
    
    /* Start of basic physics properties modification and update functions */
    // This function updates the position of the GameObject
    public func updatePosition(newLoation: CGPoint) {
        _checkRep()
        self.shape.position = newLoation
        _checkRep()
    }

    // This function updates the velocity of the GameObject from PhysicsBody level
    public func updateVelocity(newVelocity: CGVector) {
        _checkRep()
        self.shape.physicsBody?.velocity = newVelocity
        _checkRep()
    }

    // This function moves the GameObject based on a force applied to the central point of its physics body
    public func pushedByForce(appliedForce: CGVector) {
        _checkRep()
        self.shape.physicsBody?.applyForce(appliedForce)
        _checkRep()
    }
    
    // This function moves the GameObject based on a force aplied on the chosen point on the GameObject
    public func pushedByForceWithPoint(appliedForce: CGVector, point: CGPoint) {
        _checkRep()
        self.shape.physicsBody?.applyForce(appliedForce, at: point)
        _checkRep()
    }
    
    // This function moves the GameObject based on an instantaneous impulse applied on the physics body
    public func pushedByImpulse(appliedImpulse: CGVector) {
        _checkRep()
        self.shape.physicsBody?.applyImpulse(appliedImpulse)
        _checkRep()
    }
    /* End of basic physics properties modification and update functions */
    
    /* Start of private functions */
    // This function checks the representation of the GameObject class
    // A valid GameObject should have timeToLive value >= 0
    private func _checkRep() {
        assert(self.timeToLive >= 0, "Invalid time to live value.")
    }
    
    /* End of private functions */
}

//
//  GameObject.swift
//  ParticleBlaster
//
//  Created by Richthofen on 16/03/2017.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

/*
 * The `GameObject` class is the base model for all UI elements appearing in the game area
 * It contains the fundamental SKSpriteNode for displaying purposes, a default timeToLive ('lives'), and a isStatic property
 *      - It defines the basic initialization of any object in the game area from images
 *      - It defines the basic APIs for modifying the physics properties of the object
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
    }
    
    init(imageName: String, timeToLive: Int, isStatic: Bool) {
        let shapeNode = SKSpriteNode(imageNamed: imageName)
        self.shape = shapeNode
        self.timeToLive = timeToLive
        self.isStatic = isStatic
    }
    
    init(imageName: String, timeToLive: Int = Constants.defaultTimeToLive) {
        self.shape = SKSpriteNode(imageNamed: imageName)
        self.timeToLive = timeToLive
        self.isStatic = false
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
        self.shape.position = newLoation
    }

    // This function updates the velocity of the GameObject from PhysicsBody level
    public func updateVelocity(newVelocity: CGVector) {
        self.shape.physicsBody?.velocity = newVelocity
    }

    // This function moves the GameObject based on a force applied to the central point of its physics body
    public func pushedByForce(appliedForce: CGVector) {
        self.shape.physicsBody?.applyForce(appliedForce)
    }
    
    // This function moves the GameObject based on a force aplied on the chosen point on the GameObject
    public func pushedByForceWithPoint(appliedForce: CGVector, point: CGPoint) {
        self.shape.physicsBody?.applyForce(appliedForce, at: point)
    }
    
    // This function moves the GameObject based on an instantaneous impulse applied on the physics body
    public func pushedByImpulse(appliedImpulse: CGVector) {
        self.shape.physicsBody?.applyImpulse(appliedImpulse)
    }
    /* End of basic physics properties modification and update functions */

}

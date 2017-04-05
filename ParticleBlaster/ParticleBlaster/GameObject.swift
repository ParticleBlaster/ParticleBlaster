//
//  GameObject.swift
//  ParticleBlaster
//
//  Created by Richthofen on 16/03/2017.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

import UIKit
import SpriteKit

class GameObject: NSObject {
    var shape: SKSpriteNode
    var timeToLive: Int
    var isStatic: Bool

    init(shape: SKSpriteNode, timeToLive: Int, isStatic: Bool) {
        self.timeToLive = timeToLive
        self.shape = shape
        self.isStatic = isStatic
    }

    init(imageName: String) {
        self.shape = SKSpriteNode(imageNamed: imageName)
        self.shape.name = imageName
        // FIX: should this part be inside Player and other game object class itselt?
        if imageName == "player" || imageName == "Spaceship" {
            self.timeToLive = Constants.playerTimeToLive
        } else {
            self.timeToLive = Constants.defaultTimeToLive // by default set to 10 times of hit
        }
        self.isStatic = false
    }

    init(imageName: String, timeToLive: Int, isStatic: Bool) {
        let shapeNode = SKSpriteNode(imageNamed: imageName)
        self.shape = shapeNode
        self.timeToLive = timeToLive
        self.isStatic = isStatic
    }

    init(imageName: String, isStatic: Bool) {
        self.shape = SKSpriteNode(imageNamed: imageName)
        self.shape.name = imageName
        if imageName == "player" || imageName == "Spaceship" {
            self.timeToLive = Constants.playerTimeToLive
        } else {
            self.timeToLive = Constants.defaultTimeToLive // by default set to 10 times of hit
        }
        self.isStatic = isStatic
    }
    
    public func updatePosition(newLoation: CGPoint) {
        self.shape.position = newLoation
    }

    public func updateVelocity(newVelocity: CGVector) {
        self.shape.physicsBody?.velocity = newVelocity
    }

    public func pushedByForce(force: CGVector) {
        self.shape.physicsBody?.applyForce(force)
    }
}

//
//  GameObject.swift
//  ParticleBlaster
//
//  Created by Richthofen on 16/03/2017.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

import UIKit
import SpriteKit

class GameObject {
    //var position: CGPoint
    var shape: SKSpriteNode
    //var velocity: CGVector
    var timeToLive: Int
    var isStatic: Bool
    
//    init(position: CGPoint, shape: SKNode, velocity: CGVector) {
//        self.position = position
//        self.shape = shape
//        self.velocity = velocity
//    }
    
    init(shape: SKSpriteNode, timeToLive: Int, isStatic: Bool) {
        self.timeToLive = timeToLive
        self.shape = shape
        self.isStatic = isStatic
    }
    
    init(imageName: String) {
        let shapeNode = SKSpriteNode(imageNamed: imageName)
//        guard let shapeNode = SKSpriteNode(imageNamed: imageName) else {
//            return nil
//        }
        //self.position = CGPoint(x: 0, y: 0)
        self.shape = shapeNode
        //self.velocity = CGVector(dx: 0, dy: 0)
        self.timeToLive = 10 // by default set to 10 times of hit
        self.isStatic = false // by default the object should be moving
    }
    
//    init(shapePath: CGPath) {
//        let shapeNode = SKShapeNode(path: shapePath)
//        //self.position = CGPoint(x: 0, y: 0)
//        self.shape = shapeNode
//        //self.velocity = CGVector(dx: 0, dy: 0)
//        self.timeToLive = 10 // by default set to 10 times of hit
//        self.isStatic = false // by default the object should be moving
//    }
    
    init(imageName: String, timeToLive: Int, isStatic: Bool) {
        let shapeNode = SKSpriteNode(imageNamed: imageName)
        self.shape = shapeNode
        self.timeToLive = timeToLive
        self.isStatic = isStatic
    }
    
    public func updatePosition(newLoation: CGPoint) {
//        position.x += velocity.dx
//        position.y += velocity.dy
        self.shape.position = newLoation
    }
    
    public func updateVelocity(newVelocity: CGVector) {
        self.shape.physicsBody?.velocity = newVelocity
    }
    
}

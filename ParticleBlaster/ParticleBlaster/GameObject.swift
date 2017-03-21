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
    var position: CGPoint
    var shape: SKNode
    var velocity: CGVector
    
    init(position: CGPoint, shape: SKNode, velocity: CGVector) {
        self.position = position
        self.shape = shape
        self.velocity = velocity
    }
    
    init(imageName: String) {
        let shapeNode = SKSpriteNode(imageNamed: imageName)
//        guard let shapeNode = SKSpriteNode(imageNamed: imageName) else {
//            return nil
//        }
        self.position = CGPoint(x: 0, y: 0)
        self.shape = shapeNode
        self.velocity = CGVector(dx: 0, dy: 0)
    }
    
    init(shapePath: CGPath) {
        let shapeNode = SKShapeNode(path: shapePath)
        self.position = CGPoint(x: 0, y: 0)
        self.shape = shapeNode
        self.velocity = CGVector(dx: 0, dy: 0)
    }
    
    public func updatePosition() {
        position.x += velocity.dx
        position.y += velocity.dy
    }
    
}

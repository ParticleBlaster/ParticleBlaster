//
//  MapObject.swift
//  ParticleBlaster
//
//  Created by Bohan Huang on 25/3/17.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

import UIKit
import SpriteKit

// TODO: consider to replace this by Boundary class
class MapObject {
    var boundaries: [SKShapeNode]
    
    init(view: UIView) {
        boundaries = [SKShapeNode]()
        
        let bottomLeft = CGPoint(x: view.bounds.minX, y: view.bounds.minY)
        let bottomRight = CGPoint(x: view.bounds.maxX, y: view.bounds.minY)
        let topLeft = CGPoint(x: view.bounds.minX, y: view.bounds.maxY)
        let topRight = CGPoint(x: view.bounds.maxX, y: view.bounds.maxY)
        
        let leftPath = CGMutablePath()
        leftPath.move(to: bottomLeft)
        leftPath.addLine(to: topLeft)
        let leftBoundary = SKShapeNode(path: leftPath)
        leftBoundary.physicsBody = SKPhysicsBody(edgeFrom: bottomLeft, to: topLeft)
        boundaries.append(leftBoundary)
        
        let rightPath = CGMutablePath()
        rightPath.move(to: bottomRight)
        rightPath.addLine(to: topRight)
        let rightBoundary = SKShapeNode(path: rightPath)
        rightBoundary.physicsBody = SKPhysicsBody(edgeFrom: bottomRight, to: topRight)
        boundaries.append(rightBoundary)
        
        let topPath = CGMutablePath()
        topPath.move(to: topLeft)
        topPath.addLine(to: topRight)
        let topBoundary = SKShapeNode(path: topPath)
        topBoundary.physicsBody = SKPhysicsBody(edgeFrom: topLeft, to: topRight)
        boundaries.append(topBoundary)
        
        let bottomPath = CGMutablePath()
        bottomPath.move(to: bottomLeft)
        bottomPath.addLine(to: bottomRight)
        let bottomBoundary = SKShapeNode(path: bottomPath)
        bottomBoundary.physicsBody = SKPhysicsBody(edgeFrom: bottomLeft, to: bottomRight)
        boundaries.append(bottomBoundary)
        
        for boundary in boundaries {
            boundary.physicsBody?.isDynamic = false
            boundary.physicsBody?.categoryBitMask = PhysicsCategory.Map
            boundary.physicsBody?.contactTestBitMask = PhysicsCategory.All
            boundary.physicsBody?.collisionBitMask = PhysicsCategory.None
        }
    }
}

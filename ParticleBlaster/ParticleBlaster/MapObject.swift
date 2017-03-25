//
//  MapObject.swift
//  ParticleBlaster
//
//  Created by Bohan Huang on 25/3/17.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

import UIKit
import SpriteKit

class MapObject {
    var boundaries: [SKShapeNode]
    
    init(view: UIView) {
        boundaries = [SKShapeNode]()
        
        let originX = view.bounds.origin.x
        let originY = view.bounds.origin.y
        let limitX = view.bounds.origin.x + view.bounds.width
        let limitY = view.bounds.origin.y + view.bounds.height
        
        let leftPath = CGMutablePath()
        leftPath.move(to: CGPoint(x: originX, y: originY))
        leftPath.addLine(to: CGPoint(x: originX, y: limitY))
        let leftBoundary = SKShapeNode(path: leftPath)
        leftBoundary.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: originX, y: originY), to: CGPoint(x: originX, y: limitY))
        boundaries.append(leftBoundary)
        
        let rightPath = CGMutablePath()
        rightPath.move(to: CGPoint(x: limitX, y: originY))
        rightPath.addLine(to: CGPoint(x: limitX, y: limitY))
        let rightBoundary = SKShapeNode(path: rightPath)
        rightBoundary.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: limitX, y: originY), to: CGPoint(x: limitX, y: limitY))
        boundaries.append(rightBoundary)
        
        let topPath = CGMutablePath()
        topPath.move(to: CGPoint(x: originX, y: originY))
        topPath.addLine(to: CGPoint(x: limitX, y: originY))
        let topBoundary = SKShapeNode(path: topPath)
        topBoundary.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: originX, y: originY), to: CGPoint(x: limitX, y: originY))
        boundaries.append(topBoundary)
        
        let bottomPath = CGMutablePath()
        bottomPath.move(to: CGPoint(x: originX, y: limitY))
        bottomPath.addLine(to: CGPoint(x: limitX, y: limitY))
        let bottomBoundary = SKShapeNode(path: bottomPath)
        bottomBoundary.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: originX, y: limitY), to: CGPoint(x: limitX, y: limitY))
        boundaries.append(bottomBoundary)
        
        for boundary in boundaries {
            boundary.physicsBody?.isDynamic = false
            boundary.physicsBody?.categoryBitMask = PhysicsCategory.Map
            boundary.physicsBody?.contactTestBitMask = PhysicsCategory.All
            boundary.physicsBody?.collisionBitMask = PhysicsCategory.None
        }
    }
}
